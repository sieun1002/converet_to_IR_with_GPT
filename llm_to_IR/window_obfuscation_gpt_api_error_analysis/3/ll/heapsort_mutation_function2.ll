; ModuleID = 'crt_init'
source_filename = "crt_init.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

; External functions
declare void @Sleep(i32)
declare i8* @SetUnhandledExceptionFilter(i8*)
declare void @_set_invalid_parameter_handler(i8*)
declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @sub_140001910()
declare void @sub_140002070(void ()*)
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i32 ()**, i32 ()**)
declare void @_initterm(void ()**, void ()**)
declare i32 @sub_140002A60(i32*, i8***, i8**, i32*, i32)
declare i8** @sub_140002A20()
declare i32 @sub_14000171D(i32, i8**, i8*)
declare i8* @malloc(i64)
declare i64 @strlen(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare void @_cexit()
declare void @exit(i32) noreturn
declare i32 @sub_140002A30(i32)
declare i32 @GetCurrentThreadId()
declare void @sub_1400018F0()
declare void @_set_app_type(i32)

; Externally defined functions used as pointers
declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler()
declare void @sub_1400019D0()

; External global variables (import-pointer style "off_" indirection)
@off_140004450 = external global i8***          ; -> i8** (lock cell)
@off_140004460 = external global i32**          ; -> i32* (guard/state)
@off_1400043D0 = external global void (i32, i32, i32)** ; -> callback ptr
@off_140004440 = external global i8**           ; -> i8* (prev unhandled filter storage)
@off_140004410 = external global i32**          ; -> i32*
@off_140004420 = external global i32**          ; -> i32*
@off_140004430 = external global i32**          ; -> i32*
@off_1400043A0 = external global i8**           ; -> image base
@off_140004400 = external global i32**          ; -> i32* (console/gui flag)
@off_1400044D0 = external global i32**          ; -> i32* (fmode src)
@off_1400044B0 = external global i32**          ; -> i32* (commode src)
@off_140004380 = external global i32**          ; -> i32*
@off_1400043E0 = external global i32**          ; -> i32*
@First         = external global i32 ()***       ; -> i32 ()** (initterm_e first)
@Last          = external global i32 ()***       ; -> i32 ()** (initterm_e last)
@off_140004500 = external global i32**          ; -> i32* (show window / startup info)
@off_1400044C0 = external global i32**          ; -> i32* (flags)
@off_140004470 = external global void ()***     ; -> void ()** (initterm first)
@off_140004480 = external global void ()***     ; -> void ()** (initterm last)

; Program globals
@dword_140007004 = external global i32
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
@dword_140007008 = external global i32

define dso_local i32 @sub_140001010() local_unnamed_addr {
entry:
  ; Acquire lock: try to set from null to "owner" (current thread id as pointer)
  %tid = call i32 @GetCurrentThreadId()
  %tid64 = zext i32 %tid to i64
  %owner = inttoptr i64 %tid64 to i8*
  %lock_pp = load i8***, i8**** @off_140004450, align 8
  %lock_p = load i8**, i8*** %lock_pp, align 8
  br label %acquire_loop

acquire_loop:
  %old_and_succ = cmpxchg i8*, i8** %lock_p, i8* null, i8* %owner seq_cst seq_cst
  %old = extractvalue { i8*, i1 } %old_and_succ, 0
  %succ = extractvalue { i8*, i1 } %old_and_succ, 1
  br i1 %succ, label %acquired, label %check_reentrant

check_reentrant:
  %is_reentrant = icmp eq i8* %old, %owner
  br i1 %is_reentrant, label %reentrant, label %sleep_and_retry

sleep_and_retry:
  call void @Sleep(i32 1000)
  br label %acquire_loop

reentrant:
  br label %after_lock

acquired:
  br label %after_lock

after_lock:
  ; r14d flag: 1 if reentrant, 0 if we acquired normally
  %reent_phi = phi i1 [ true, %reentrant ], [ false, %acquired ]
  ; Load guard/state pointer
  %guard_pp = load i32**, i32*** @off_140004460, align 8
  %guard_p = load i32*, i32** %guard_pp, align 8
  %guard_val0 = load i32, i32* %guard_p, align 4
  %is_guard_1 = icmp eq i32 %guard_val0, 1
  br i1 %is_guard_1, label %guard_is_one, label %check_guard_zero

guard_is_one:
  %code31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %code31)
  unreachable

check_guard_zero:
  %is_guard_0 = icmp eq i32 %guard_val0, 0
  br i1 %is_guard_0, label %do_init, label %set_flag_and_continue

set_flag_and_continue:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init_common

do_init:
  ; set guard to 1
  store i32 1, i32* %guard_p, align 4
  call void @sub_140001CA0()
  ; SetUnhandledExceptionFilter(TopLevelExceptionFilter), and store previous to off_140004440
  %filter_fn = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev_filter = call i8* @SetUnhandledExceptionFilter(i8* %filter_fn)
  %prev_store_pp = load i8**, i8*** @off_140004440, align 8
  store i8* %prev_filter, i8** %prev_store_pp, align 8
  ; _set_invalid_parameter_handler(Handler)
  %iph = bitcast void ()* @Handler to i8*
  call void @_set_invalid_parameter_handler(i8* %iph)
  ; additional CRT init
  call void @sub_1400024E0()
  ; set off_140004410/420/430 to 1
  %p410pp = load i32**, i32*** @off_140004410, align 8
  %p410 = load i32*, i32** %p410pp, align 8
  store i32 1, i32* %p410, align 4
  %p420pp = load i32**, i32*** @off_140004420, align 8
  %p420 = load i32*, i32** %p420pp, align 8
  store i32 1, i32* %p420, align 4
  %p430pp = load i32**, i32*** @off_140004430, align 8
  %p430 = load i32*, i32** %p430pp, align 8
  store i32 1, i32* %p430, align 4
  ; Inspect PE headers to set dword_140007008
  %base_p = load i8**, i8*** @off_1400043A0, align 8
  %base = load i8*, i8** %base_p, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117                ; 0x5A4D
  br i1 %is_mz, label %pe_nt, label %set_flag_from_pe

pe_nt:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew64
  %sig_ptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig_ptr, align 4
  %is_pe = icmp eq i32 %sig, 17744               ; 0x00004550
  br i1 %is_pe, label %pe_magic, label %set_flag_from_pe

pe_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_pe32 = icmp eq i16 %magic, 267             ; 0x10B
  %is_pe64 = icmp eq i16 %magic, 523             ; 0x20B
  br i1 %is_pe32, label %pe32_path, label %check_pe64

check_pe64:
  br i1 %is_pe64, label %pe64_path, label %set_flag_from_pe

pe32_path:
  ; if dword [nt+0x74] > 0xE then check [nt+0xE8]
  %sz_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 116      ; 0x74
  %sz_ptr = bitcast i8* %sz_ptr_i8 to i32*
  %sz = load i32, i32* %sz_ptr, align 4
  %gtE = icmp ugt i32 %sz, 14
  br i1 %gtE, label %pe32_have_dir, label %set_flag_from_pe

pe32_have_dir:
  %cfg_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 232     ; 0xE8
  %cfg_ptr = bitcast i8* %cfg_ptr_i8 to i32*
  %cfg = load i32, i32* %cfg_ptr, align 4
  %nonzero_cfg = icmp ne i32 %cfg, 0
  %flag32 = select i1 %nonzero_cfg, i32 1, i32 0
  br label %finalize_pe_flag

pe64_path:
  ; if dword [nt+0x84] > 0xE then check [nt+0xF8]
  %sz64_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 132    ; 0x84
  %sz64_ptr = bitcast i8* %sz64_ptr_i8 to i32*
  %sz64 = load i32, i32* %sz64_ptr, align 4
  %gtE64 = icmp ugt i32 %sz64, 14
  br i1 %gtE64, label %pe64_have_dir, label %set_flag_from_pe

pe64_have_dir:
  %cfg64_ptr_i8 = getelementptr inbounds i8, i8* %nt, i64 248   ; 0xF8
  %cfg64_ptr = bitcast i8* %cfg64_ptr_i8 to i32*
  %cfg64 = load i32, i32* %cfg64_ptr, align 4
  %nonzero_cfg64 = icmp ne i32 %cfg64, 0
  %flag64 = select i1 %nonzero_cfg64, i32 1, i32 0
  br label %finalize_pe_flag

set_flag_from_pe:
  %flag_default = phi i32 [ 0, %pe_nt ], [ 0, %pe_magic ], [ 0, %check_pe64 ], [ 0, %do_init ]
  store i32 %flag_default, i32* @dword_140007008, align 4
  br label %post_pe_checks

finalize_pe_flag:
  %flag_from_path = phi i32 [ %flag32, %pe32_have_dir ], [ %flag64, %pe64_have_dir ]
  store i32 %flag_from_path, i32* @dword_140007008, align 4
  br label %post_pe_checks

post_pe_checks:
  ; decide app type from off_140004400
  %apptype_pp = load i32**, i32*** @off_140004400, align 8
  %apptype_p = load i32*, i32** %apptype_pp, align 8
  %apptype = load i32, i32* %apptype_p, align 4
  %is_gui = icmp ne i32 %apptype, 0
  br i1 %is_gui, label %set_gui, label %set_console

set_console:
  call void @_set_app_type(i32 1)
  br label %pointers_modes

set_gui:
  call void @_set_app_type(i32 2)
  br label %pointers_modes

pointers_modes:
  ; __p__fmode
  %pfmode = call i32* @__p__fmode()
  %fmode_src_pp = load i32**, i32*** @off_1400044D0, align 8
  %fmode_src = load i32*, i32** %fmode_src_pp, align 8
  %fmode_val = load i32, i32* %fmode_src, align 4
  store i32 %fmode_val, i32* %pfmode, align 4
  ; __p__commode
  %pcommode = call i32* @__p__commode()
  %commode_src_pp = load i32**, i32*** @off_1400044B0, align 8
  %commode_src = load i32*, i32** %commode_src_pp, align 8
  %commode_val = load i32, i32* %commode_src, align 4
  store i32 %commode_val, i32* %pcommode, align 4
  ; sub_140001910
  %res1910 = call i32 @sub_140001910()
  %neg1910 = icmp slt i32 %res1910, 0
  br i1 %neg1910, label %early_error, label %check_4380

check_4380:
  %p380pp = load i32**, i32*** @off_140004380, align 8
  %p380 = load i32*, i32** %p380pp, align 8
  %v380 = load i32, i32* %p380, align 4
  %is_one_380 = icmp eq i32 %v380, 1
  br i1 %is_one_380, label %call_2070, label %after_2070

call_2070:
  call void @sub_140002070(void ()* @sub_1400019D0)
  br label %after_2070

after_2070:
  ; check _configthreadlocale
  %p3E0pp = load i32**, i32*** @off_1400043E0, align 8
  %p3E0 = load i32*, i32** %p3E0pp, align 8
  %v3E0 = load i32, i32* %p3E0, align 4
  %is_m1 = icmp eq i32 %v3E0, -1
  br i1 %is_m1, label %call_cfgthreadlocale, label %initterm_e

call_cfgthreadlocale:
  %cfgret = call i32 @_configthreadlocale(i32 -1)
  br label %initterm_e

initterm_e:
  %first_ppp = load i32 ()***, i32 ()**** @First, align 8
  %first_pp = load i32 ()**, i32 ()*** %first_ppp, align 8
  %last_ppp = load i32 ()***, i32 ()**** @Last, align 8
  %last_pp = load i32 ()**, i32 ()*** %last_ppp, align 8
  %ie = call i32 @_initterm_e(i32 ()** %first_pp, i32 ()** %last_pp)
  %ie_nonzero = icmp ne i32 %ie, 0
  br i1 %ie_nonzero, label %initterm_e_fail, label %prep_cmdline

initterm_e_fail:
  ret i32 255

early_error:
  %ecode = call i32 @sub_140002A30(i32 8)
  call void @_cexit()
  ret i32 %ecode

prep_cmdline:
  ; Prepare for sub_140002A60
  %tmp_storage = alloca i32, align 4
  %p500pp = load i32**, i32*** @off_140004500, align 8
  %p500 = load i32*, i32** %p500pp, align 8
  %v500 = load i32, i32* %p500, align 4
  store i32 %v500, i32* %tmp_storage, align 4
  %p4C0pp = load i32**, i32*** @off_1400044C0, align 8
  %p4C0 = load i32*, i32** %p4C0pp, align 8
  %v4C0 = load i32, i32* %p4C0, align 4
  %argc_p = @dword_140007020
  %argv_pp = @qword_140007018
  %env_p = @qword_140007010
  %resA60 = call i32 @sub_140002A60(i32* %argc_p, i8*** %argv_pp, i8** %env_p, i32* %tmp_storage, i32 %v4C0)
  %negA60 = icmp slt i32 %resA60, 0
  br i1 %negA60, label %early_error, label %alloc_argv_copy

alloc_argv_copy:
  %argc = load i32, i32* @dword_140007020, align 4
  %argc1 = add i32 %argc, 1
  %argc1_64 = sext i32 %argc1 to i64
  %bytes = shl i64 %argc1_64, 3
  %newarr_i8 = call i8* @malloc(i64 %bytes)
  %newarr = bitcast i8* %newarr_i8 to i8**
  %newarr_null = icmp eq i8** %newarr, null
  br i1 %newarr_null, label %early_error, label %copy_loop_setup

copy_loop_setup:
  %argc_le0 = icmp sle i32 %argc, 0
  br i1 %argc_le0, label %after_copy_loop, label %copy_loop

copy_loop:
  ; i ranges 1..argc; index = i-1
  %i = phi i32 [ 1, %copy_loop_setup ], [ %i_next, %copy_iter_done ]
  %idx = add i32 %i, -1
  %idx64 = sext i32 %idx to i64
  %argv_old_pp = load i8**, i8*** @qword_140007018, align 8
  %src_slot = getelementptr inbounds i8*, i8** %argv_old_pp, i64 %idx64
  %src = load i8*, i8** %src_slot, align 8
  %len = call i64 @strlen(i8* %src)
  %size = add i64 %len, 1
  %buf_i8 = call i8* @malloc(i64 %size)
  %dest_slot = getelementptr inbounds i8*, i8** %newarr, i64 %idx64
  store i8* %buf_i8, i8** %dest_slot, align 8
  %buf_is_null = icmp eq i8* %buf_i8, null
  br i1 %buf_is_null, label %early_error, label %do_memcpy

do_memcpy:
  %copy_res = call i8* @memcpy(i8* %buf_i8, i8* %src, i64 %size)
  %is_last = icmp eq i32 %i, %argc
  br i1 %is_last, label %set_terminator, label %copy_iter_done

copy_iter_done:
  %i_next = add nsw i32 %i, 1
  br label %copy_loop

set_terminator:
  %argc64 = sext i32 %argc to i64
  %term_slot = getelementptr inbounds i8*, i8** %newarr, i64 %argc64
  store i8* null, i8** %term_slot, align 8
  br label %after_copy_loop

after_copy_loop:
  ; publish new argv
  store i8** %newarr, i8*** @qword_140007018, align 8
  ; run C++ initializers
  %init_first_ppp = load void ()***, void ()**** @off_140004470, align 8
  %init_first_pp = load void ()**, void ()*** %init_first_ppp, align 8
  %init_last_ppp = load void ()***, void ()**** @off_140004480, align 8
  %init_last_pp = load void ()**, void ()*** %init_last_ppp, align 8
  call void @_initterm(void ()** %init_first_pp, void ()** %init_last_pp)
  call void @sub_1400018F0()
  ; set guard to 2
  store i32 2, i32* %guard_p, align 4
  br label %post_init_common

post_init_common:
  ; If not reentrant, release the lock now
  br i1 %reent_phi, label %no_unlock, label %unlock_lock

unlock_lock:
  %xchg = atomicrmw xchg i8** %lock_p, i8* null seq_cst
  br label %no_unlock

no_unlock:
  ; Optional pre-main callback
  %cb_pp = load void (i32, i32, i32)**, void (i32, i32, i32)*** @off_1400043D0, align 8
  %cb = load void (i32, i32, i32)*, void (i32, i32, i32)** %cb_pp, align 8
  %cb_is_null = icmp eq void (i32, i32, i32)* %cb, null
  br i1 %cb_is_null, label %after_cb, label %do_cb

do_cb:
  call void %cb(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  ; Prepare startup parameters and call sub_14000171D
  %dest_pp = call i8** @sub_140002A20()
  %env = load i8*, i8** @qword_140007010, align 8
  store i8* %env, i8** %dest_pp, align 8
  %argc_main = load i32, i32* @dword_140007020, align 4
  %argv_main_pp = load i8**, i8*** @qword_140007018, align 8
  %ret_main = call i32 @sub_14000171D(i32 %argc_main, i8** %argv_main_pp, i8* %env)
  ; Decide exit behavior
  %seh_flag = load i32, i32* @dword_140007008, align 4
  %seh_zero = icmp eq i32 %seh_flag, 0
  br i1 %seh_zero, label %call_exit_with_ret, label %check_dword_7004

call_exit_with_ret:
  call void @exit(i32 %ret_main)
  unreachable

check_dword_7004:
  %dw7004 = load i32, i32* @dword_140007004, align 4
  %dw7004_zero = icmp eq i32 %dw7004, 0
  br i1 %dw7004_zero, label %cexit_and_ret, label %just_ret

cexit_and_ret:
  call void @_cexit()
  ret i32 %ret_main

just_ret:
  ret i32 %ret_main
}