; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_140002670(i32)
declare void @exit(i32)
declare void @_cexit()
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare void @_set_app_type(i32)
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_initterm_e(i8*, i8*)
declare void @_initterm(i8*, i8*)
declare i32 @_configthreadlocale(i32)
declare void @sub_1400018D0()
declare void @sub_140002120()
declare i32 @sub_140001540()
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_140002660()
declare i32 @sub_140002880(i32, i8**)
declare void @sub_140001520()
declare void @sub_140001CA0(void ()*)
declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler(...)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @sub_140001600()

@__imp_Sleep = external dllimport global void (i32)*
@__imp_SetUnhandledExceptionFilter = external dllimport global i8* (i8*)*

@off_140004470 = external global i64*
@off_140004480 = external global i32*
@off_1400043F0 = external global i8*
@off_140004460 = external global i8**
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_1400044F0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400043A0 = external global i32*
@off_140004400 = external global i32*
@First = external global i8*
@Last  = external global i8*
@off_140004520 = external global i32*
@off_1400044E0 = external global i32*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@dword_140007004 = external global i32

define dso_local i32 @sub_140001010() local_unnamed_addr {
entry:
  %var_4C = alloca i32, align 4
  %var_5C = alloca i32, align 4

  %tid = call i64 asm sideeffect inteldialect "mov eax, 0x30; mov rax, qword ptr gs:[rax]; mov rax, qword ptr [rax+8]", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %lock_addr = load i64*, i64** @off_140004470, align 8
  %sleep_fp = load void (i32)*, void (i32)** @__imp_Sleep, align 8
  br label %try_lock

try_lock:
  %cmpx = cmpxchg i64* %lock_addr, i64 0, i64 %tid seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx, 0
  %acq = extractvalue { i64, i1 } %cmpx, 1
  br i1 %acq, label %locked, label %check_owner

check_owner:
  %own = icmp eq i64 %old, %tid
  br i1 %own, label %reentrant, label %sleep

sleep:
  call void %sleep_fp(i32 1000)
  br label %try_lock

locked:
  br label %after_lock

reentrant:
  br label %after_lock

after_lock:
  %reent = phi i1 [ false, %locked ], [ true, %reentrant ]
  %state_ptr = load i32*, i32** @off_140004480, align 8
  %state0 = load i32, i32* %state_ptr, align 4
  %is_one = icmp eq i32 %state0, 1
  br i1 %is_one, label %exit31, label %check_zero

exit31:
  %rc31 = call i32 @sub_140002670(i32 31)
  call void @exit(i32 %rc31)
  unreachable

check_zero:
  %state1 = load i32, i32* %state_ptr, align 4
  %is_zero = icmp eq i32 %state1, 0
  br i1 %is_zero, label %init_path, label %set_flag_then

set_flag_then:
  store i32 1, i32* @dword_140007004, align 4
  br i1 %reent, label %cont_after_lock, label %release_lock

release_lock:
  %xchgold = atomicrmw xchg i64* %lock_addr, i64 0 seq_cst
  br label %cont_after_lock

cont_after_lock:
  %fp_loc = load i8*, i8** @off_1400043F0, align 8
  %has_cb = icmp ne i8* %fp_loc, null
  br i1 %has_cb, label %call_cb, label %after_cb

call_cb:
  %cb = bitcast i8* %fp_loc to void (i32, i32, i32)*
  call void %cb(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  %bufptr = call i8* @sub_140002660()
  %envp_val = load i8*, i8** @qword_140007010, align 8
  %bufptr_cast = bitcast i8* %bufptr to i8**
  store i8* %envp_val, i8** %bufptr_cast, align 8
  %argv_arr = load i8**, i8*** @qword_140007018, align 8
  %argc_val = load i32, i32* @dword_140007020, align 4
  %ret_main = call i32 @sub_140002880(i32 %argc_val, i8** %argv_arr)
  %ucrt_flag = load i32, i32* @dword_140007008, align 4
  %ucrt_zero = icmp eq i32 %ucrt_flag, 0
  br i1 %ucrt_zero, label %call_exit, label %check_dword_7004

call_exit:
  call void @exit(i32 %ret_main)
  unreachable

check_dword_7004:
  %f7004 = load i32, i32* @dword_140007004, align 4
  %is_zero_7004 = icmp eq i32 %f7004, 0
  br i1 %is_zero_7004, label %do_cexit_ret, label %epilogue_return

do_cexit_ret:
  store i32 %ret_main, i32* %var_5C, align 4
  call void @_cexit()
  %ret_load = load i32, i32* %var_5C, align 4
  br label %epilogue_return_with_val

epilogue_return_with_val:
  ret i32 %ret_load

epilogue_return:
  ret i32 %ret_main

init_path:
  store i32 1, i32* %state_ptr, align 4
  call void @sub_1400018D0()
  %pSetUEF = load i8* (i8*)*, i8* (i8*)** @__imp_SetUnhandledExceptionFilter, align 8
  %tlfp = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev_filter = call i8* %pSetUEF(i8* %tlfp)
  %store_prev_loc = load i8**, i8*** @off_140004460, align 8
  store i8* %prev_filter, i8** %store_prev_loc, align 8
  %handler_ptr = bitcast void (...)* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %handler_ptr)
  call void @sub_140002120()
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p450, align 4

  %base = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %set_ecx_and_after

check_pe:
  %offs_e_lfanew_ptr = getelementptr i8, i8* %base, i64 60
  %offs_e_lfanew_iptr = bitcast i8* %offs_e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %offs_e_lfanew_iptr, align 4
  %base_i = ptrtoint i8* %base to i64
  %e_lfanew_i = sext i32 %e_lfanew to i64
  %nt_off = add i64 %base_i, %e_lfanew_i
  %nt = inttoptr i64 %nt_off to i8*
  %sigptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %set_ecx_and_after

check_opt:
  %opt_magic_ptr = getelementptr i8, i8* %nt, i64 24
  %opt_magic_ip = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_ip, align 2
  %is_pe32 = icmp eq i16 %opt_magic, 267
  br i1 %is_pe32, label %pe32_path, label %check_pe32plus

check_pe32plus:
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %pe32plus_path, label %set_ecx_and_after

pe32plus_path:
  %sizeptr64 = getelementptr i8, i8* %nt, i64 132
  %size64_ip = bitcast i8* %sizeptr64 to i32*
  %size64 = load i32, i32* %size64_ip, align 4
  %gt0e64 = icmp ugt i32 %size64, 14
  br i1 %gt0e64, label %read_guard64, label %set_ecx_and_after

read_guard64:
  %g64ptr = getelementptr i8, i8* %nt, i64 248
  %g64_ip = bitcast i8* %g64ptr to i32*
  %g64 = load i32, i32* %g64_ip, align 4
  %g64nz = icmp ne i32 %g64, 0
  %ecx_flag64 = zext i1 %g64nz to i32
  br label %store_ecx

pe32_path:
  %sizeptr32 = getelementptr i8, i8* %nt, i64 116
  %size32_ip = bitcast i8* %sizeptr32 to i32*
  %size32 = load i32, i32* %size32_ip, align 4
  %gt0e32 = icmp ugt i32 %size32, 14
  br i1 %gt0e32, label %read_guard32, label %set_ecx_and_after

read_guard32:
  %g32ptr = getelementptr i8, i8* %nt, i64 232
  %g32_ip = bitcast i8* %g32ptr to i32*
  %g32 = load i32, i32* %g32_ip, align 4
  %g32nz = icmp ne i32 %g32, 0
  %ecx_flag32 = zext i1 %g32nz to i32
  br label %store_ecx

set_ecx_and_after:
  %ecx_def = phi i32 [ 0, %init_path ], [ 0, %check_pe ], [ 0, %check_opt ], [ 0, %check_pe32plus ], [ 0, %pe32plus_path ], [ 0, %pe32_path ]
  br label %store_ecx

store_ecx:
  %ecx_fin = phi i32 [ %ecx_flag64, %read_guard64 ], [ %ecx_flag32, %read_guard32 ], [ %ecx_def, %set_ecx_and_after ]
  store i32 %ecx_fin, i32* @dword_140007008, align 4
  %apptype_ptr = load i32*, i32** @off_140004420, align 8
  %apptype_val = load i32, i32* %apptype_ptr, align 4
  %apptype_nz = icmp ne i32 %apptype_val, 0
  br i1 %apptype_nz, label %set_gui, label %set_console

set_console:
  call void @_set_app_type(i32 1)
  br label %after_set_app

set_gui:
  call void @_set_app_type(i32 2)
  br label %after_set_app

after_set_app:
  %pfmode = call i32* @__p__fmode()
  %fmode_srcp = load i32*, i32** @off_1400044F0, align 8
  %fmode_val = load i32, i32* %fmode_srcp, align 4
  store i32 %fmode_val, i32* %pfmode, align 4

  %pcommode = call i32* @__p__commode()
  %commode_srcp = load i32*, i32** @off_1400044D0, align 8
  %commode_val = load i32, i32* %commode_srcp, align 4
  store i32 %commode_val, i32* %pcommode, align 4

  %s1540 = call i32 @sub_140001540()
  %neg1540 = icmp slt i32 %s1540, 0
  br i1 %neg1540, label %err_1301, label %check_3A0

check_3A0:
  %p3a0 = load i32*, i32** @off_1400043A0, align 8
  %v3a0 = load i32, i32* %p3a0, align 4
  %is1_3a0 = icmp eq i32 %v3a0, 1
  br i1 %is1_3a0, label %call_ca0, label %check_400

check_400:
  %p400 = load i32*, i32** @off_140004400, align 8
  %v400 = load i32, i32* %p400, align 4
  %is_m1 = icmp eq i32 %v400, -1
  br i1 %is_m1, label %do_cfg_locale, label %call_initterm_e

do_cfg_locale:
  %cfg = call i32 @_configthreadlocale(i32 -1)
  br label %call_initterm_e

call_ca0:
  call void @sub_140001CA0(void ()* @sub_140001600)
  br label %check_400

call_initterm_e:
  %last = load i8*, i8** @Last, align 8
  %first = load i8*, i8** @First, align 8
  %e = call i32 @_initterm_e(i8* %first, i8* %last)
  %nonzero_e = icmp ne i32 %e, 0
  br i1 %nonzero_e, label %ret_255, label %setup_args

ret_255:
  ret i32 255

setup_args:
  %p520 = load i32*, i32** @off_140004520, align 8
  %v520 = load i32, i32* %p520, align 4
  store i32 %v520, i32* %var_4C, align 4
  %p4E0 = load i32*, i32** @off_1400044E0, align 8
  %v4E0 = load i32, i32* %p4E0, align 4
  %rcx_argc_ptr = bitcast i32* @dword_140007020 to i32*
  %rdx_argv_ptr = bitcast i8*** @qword_140007018 to i8***
  %r8_envp_ptr = bitcast i8** @qword_140007010 to i8**
  %call26a0 = call i32 @sub_1400026A0(i32* %rcx_argc_ptr, i8*** %rdx_argv_ptr, i8** %r8_envp_ptr, i32 %v4E0, i32* %var_4C)
  %neg26a0 = icmp slt i32 %call26a0, 0
  br i1 %neg26a0, label %err_1301, label %alloc_argv

alloc_argv:
  %argc_now = load i32, i32* @dword_140007020, align 4
  %argc_sx = sext i32 %argc_now to i64
  %argc_plus1 = add i64 %argc_sx, 1
  %sizeBytes = shl i64 %argc_plus1, 3
  %newvec = call i8* @malloc(i64 %sizeBytes)
  %newvec_cast = bitcast i8* %newvec to i8**
  %new_null = icmp eq i8* %newvec, null
  br i1 %new_null, label %err_1301, label %check_loop

check_loop:
  %has_items = icmp sgt i32 %argc_now, 0
  br i1 %has_items, label %loop_init, label %terminate_and_init

loop_init:
  %orig_argv = load i8**, i8*** @qword_140007018, align 8
  br label %loop

loop:
  %i = phi i64 [ 1, %loop_init ], [ %i.next, %after_copy ]
  %src_slot_ptr = getelementptr i8*, i8** %orig_argv, i64 %i
  %src_ptr_prev = getelementptr i8*, i8** %orig_argv, i64 %i
  %src_elem_ptr = getelementptr i8*, i8** %orig_argv, i64 %i
  %src_elem_addr = getelementptr i8*, i8** %orig_argv, i64 %i
  %src_idx = sub i64 %i, 1
  %src_elem = getelementptr i8*, i8** %orig_argv, i64 %src_idx
  %src_val = load i8*, i8** %src_elem, align 8
  %len = call i64 @strlen(i8* %src_val)
  %need = add i64 %len, 1
  %dst = call i8* @malloc(i64 %need)
  %dst_slot = getelementptr i8*, i8** %newvec_cast, i64 %src_idx
  store i8* %dst, i8** %dst_slot, align 8
  %dst_null = icmp eq i8* %dst, null
  br i1 %dst_null, label %err_1301, label %do_copy

do_copy:
  %copied = call i8* @memcpy(i8* %dst, i8* %src_val, i64 %need)
  %i_eq_argc = icmp eq i64 %argc_sx, %i
  br i1 %i_eq_argc, label %terminate, label %after_copy

after_copy:
  %i.next = add i64 %i, 1
  br label %loop

terminate:
  %end_slot = getelementptr i8*, i8** %newvec_cast, i64 %argc_sx
  store i8* null, i8** %end_slot, align 8
  br label %terminate_and_init

terminate_and_init:
  store i8** %newvec_cast, i8*** @qword_140007018, align 8
  %last2 = load i8*, i8** @off_1400044A0, align 8
  %first2 = load i8*, i8** @off_140004490, align 8
  call void @_initterm(i8* %first2, i8* %last2)
  call void @sub_140001520()
  store i32 2, i32* %state_ptr, align 4
  br label %set_flag_then

err_1301:
  %code8 = call i32 @sub_140002670(i32 8)
  store i32 %code8, i32* %var_5C, align 4
  call void @_cexit()
  %ret_err = load i32, i32* %var_5C, align 4
  ret i32 %ret_err
}