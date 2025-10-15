; target: Windows x64 MSVC
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @Sleep(i32)
declare dso_local i32 @GetCurrentThreadId()
declare dso_local i32 @_set_app_type(i32)
declare dso_local i32 @_configthreadlocale(i32)
declare dso_local i32 @_initterm_e(i8**, i8**)
declare dso_local void @_initterm(i8**, i8**)
declare dso_local i32* @__p__fmode()
declare dso_local i32* @__p__commode()
declare dso_local void @_cexit()
declare dso_local void @exit(i32)

declare dso_local void @sub_140001CA0()
declare dso_local void @sub_1400024E0()
declare dso_local i32 @sub_140001910()
declare dso_local void @sub_140002070(i8*)
declare dso_local i32 @sub_140002A30(i32)
declare dso_local i8** @sub_140002A20()
declare dso_local i32 @sub_140002A60(i32*, i8***, i8***, i32, i32*)
declare dso_local void @sub_14000171D(i32, i8**, i8*)
declare dso_local void @sub_1400018F0()

declare dso_local i8* @_set_invalid_parameter_handler(i8*)
declare dso_local i8* @SetUnhandledExceptionFilter(i8*)

declare dso_local i8* @malloc(i64)
declare dso_local i8* @memcpy(i8*, i8*, i64)
declare dso_local i64 @strlen(i8*)

; external globals (import pointers, config/data)
@off_140004450 = external global i8*           ; -> i64 lock storage
@off_140004460 = external global i8*           ; -> i32 stage var
@__imp_Sleep_dummy = external global i8*       ; not used (we call Sleep directly)
@off_1400043D0 = external global i8*           ; -> ptr to callback
@off_140004440 = external global i8*           ; -> storage for previous exception filter (i8*)
@off_140004410 = external global i8*           ; -> i32
@off_140004420 = external global i8*           ; -> i32
@off_140004430 = external global i8*           ; -> i32
@off_1400043A0 = external global i8*           ; PE image base
@off_140004400 = external global i8*           ; -> i32 app type flag
@off_1400044D0 = external global i8*           ; -> i32 fmode initial
@off_1400044B0 = external global i8*           ; -> i32 commode initial
@off_140004380 = external global i8*           ; -> i32 flag
@off_1400043E0 = external global i8*           ; -> i32 locale flag
@First = external global i8**                  ; _initterm_e begin
@Last = external global i8**                   ; _initterm_e end
@off_140004470 = external global i8**          ; _initterm begin
@off_140004480 = external global i8**          ; _initterm end
@off_140004500 = external global i8*           ; -> i32
@off_1400044C0 = external global i8*           ; -> i32
@TopLevelExceptionFilter = external global i8*
@Handler = external global i8*

@dword_140007004 = external global i32
@dword_140007008 = external global i32
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32

; forward decls of functions referenced as data
declare dso_local i32 @sub_1400019D0(...)

define dso_local i32 @sub_140001010() local_unnamed_addr {
entry:
  %var5C = alloca i32, align 4
  %var4C = alloca i32, align 4
  %reentrant.flag = alloca i1, align 1
  store i1 false, i1* %reentrant.flag, align 1

  ; get lock pointer
  %lockptr.raw = load i8*, i8** @off_140004450
  %lockptr = bitcast i8* %lockptr.raw to i64*

  ; token based on current thread id
  %tid = call i32 @GetCurrentThreadId()
  %token = zext i32 %tid to i64

spin_try:
  ; try to acquire lock: cmpxchg [lock], 0 -> token
  %cmpxchg = cmpxchg i64* %lockptr, i64 0, i64 %token monotonic monotonic
  %old = extractvalue { i64, i1 } %cmpxchg, 0
  %acq = extractvalue { i64, i1 } %cmpxchg, 1
  br i1 %acq, label %after_lock, label %spin_fail

spin_fail:
  ; if old == token -> reentrant
  %old_eq_token = icmp eq i64 %old, %token
  br i1 %old_eq_token, label %spin_equal, label %spin_sleep

spin_equal:
  store i1 true, i1* %reentrant.flag, align 1
  br label %after_lock

spin_sleep:
  call void @Sleep(i32 1000)
  br label %spin_try

after_lock:
  ; rbp points to stage i32
  %stageptr.raw = load i8*, i8** @off_140004460
  %stageptr = bitcast i8* %stageptr.raw to i32*
  %stage0 = load i32, i32* %stageptr, align 4
  %is_one = icmp eq i32 %stage0, 1
  br i1 %is_one, label %stage_is_one, label %stage_check_zero

stage_is_one:
  ; call sub_140002A30(0x1F) then exit with its return
  %rc_stage1 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %rc_stage1)
  unreachable

stage_check_zero:
  %stage1 = load i32, i32* %stageptr, align 4
  %is_zero = icmp eq i32 %stage1, 0
  br i1 %is_zero, label %first_init, label %set_flag_and_maybe_release

first_init:
  store i32 1, i32* %stageptr, align 4
  call void @sub_140001CA0()
  ; SetUnhandledExceptionFilter(TopLevelExceptionFilter)
  %tlfp = load i8*, i8** @TopLevelExceptionFilter
  %prev.filter = call i8* @SetUnhandledExceptionFilter(i8* %tlfp)
  ; save previous filter to *off_140004440
  %prev.store.ptr.raw = load i8*, i8** @off_140004440
  %prev.store.ptr = bitcast i8* %prev.store.ptr.raw to i8**
  store i8* %prev.filter, i8** %prev.store.ptr, align 8
  ; set invalid parameter handler
  %handlerp = load i8*, i8** @Handler
  %old.iph = call i8* @_set_invalid_parameter_handler(i8* %handlerp)
  ; additional init
  call void @sub_1400024E0()
  ; set three flags to 1
  %p410.raw = load i8*, i8** @off_140004410
  %p410 = bitcast i8* %p410.raw to i32*
  store i32 1, i32* %p410, align 4
  %p420.raw = load i8*, i8** @off_140004420
  %p420 = bitcast i8* %p420.raw to i32*
  store i32 1, i32* %p420, align 4
  %p430.raw = load i8*, i8** @off_140004430
  %p430 = bitcast i8* %p430.raw to i32*
  store i32 1, i32* %p430, align 4

  ; PE header checks to compute ecx -> ecx_val
  %base = load i8*, i8** @off_1400043A0
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, i16 23117              ; 0x5A4D
  br i1 %is_mz, label %pe_check_pe, label %pe_set0

pe_check_pe:
  %e_lfanew.ptr = getelementptr i8, i8* %base, i64 60
  %e_lfanew.i32p = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32p, align 4
  %newhdr = getelementptr i8, i8* %base, i64 (0)
  %newhdr.off = sext i32 %e_lfanew to i64
  %newhdr.ptr = getelementptr i8, i8* %newhdr, i64 %newhdr.off
  %pesig.p = bitcast i8* %newhdr.ptr to i32*
  %pesig = load i32, i32* %pesig.p, align 4
  %is_pe = icmp eq i32 %pesig, 17744              ; 0x00004550
  br i1 %is_pe, label %pe_magic, label %pe_set0

pe_magic:
  %magic.ptr = getelementptr i8, i8* %newhdr.ptr, i64 24
  %magic.u16p = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.u16p, align 2
  %is_pe32 = icmp eq i16 %magic, i16 267          ; 0x10B
  %is_pe64 = icmp eq i16 %magic, i16 523          ; 0x20B
  br i1 %is_pe32, label %pe32_path, label %pe64_or0

pe64_or0:
  br i1 %is_pe64, label %pe64_path_check, label %pe_set0

pe32_path:
  ; check OptionalHeader size > 0xE at offset +0x74 then read [ +0xE8 ]
  %opt32.size.ptr = getelementptr i8, i8* %newhdr.ptr, i64 116  ; 0x74
  %opt32.size = load i32, i32* bitcast (i8* %opt32.size.ptr to i32*), align 4
  %size_ok32 = icmp ugt i32 %opt32.size, 14
  br i1 %size_ok32, label %pe32_have_cfg, label %pe_set0

pe32_have_cfg:
  %cfg32.ptr = getelementptr i8, i8* %newhdr.ptr, i64 232    ; 0xE8
  %cfg32.val = load i32, i32* bitcast (i8* %cfg32.ptr to i32*), align 4
  %cfg32.nz = icmp ne i32 %cfg32.val, 0
  br label %pe_merge

pe64_path_check:
  ; check OptionalHeader size > 0xE at offset +0x84 then read [ +0xF8 ]
  %opt64.size.ptr = getelementptr i8, i8* %newhdr.ptr, i64 132  ; 0x84
  %opt64.size = load i32, i32* bitcast (i8* %opt64.size.ptr to i32*), align 4
  %size_ok64 = icmp ugt i32 %opt64.size, 14
  br i1 %size_ok64, label %pe64_have_cfg, label %pe_set0

pe64_have_cfg:
  %cfg64.ptr = getelementptr i8, i8* %newhdr.ptr, i64 248    ; 0xF8
  %cfg64.val = load i32, i32* bitcast (i8* %cfg64.ptr to i32*), align 4
  %cfg64.nz = icmp ne i32 %cfg64.val, 0
  br label %pe_merge

pe_merge:
  %phi_cfg = phi i1 [ %cfg32.nz, %pe32_have_cfg ], [ %cfg64.nz, %pe64_have_cfg ]
  %ecx_val = zext i1 %phi_cfg to i32
  br label %pe_done

pe_set0:
  br label %pe_done

pe_done:
  %ecx_final = phi i32 [ 0, %pe_set0 ], [ %ecx_val, %pe_merge ]
  ; dword_140007008 = ecx_final
  store i32 %ecx_final, i32* @dword_140007008, align 4
  ; app type
  %apptype.ptr.raw = load i8*, i8** @off_140004400
  %apptype.ptr = bitcast i8* %apptype.ptr.raw to i32*
  %apptype = load i32, i32* %apptype.ptr, align 4
  %apptype_nz = icmp ne i32 %apptype, 0
  br i1 %apptype_nz, label %set_app_gui, label %set_app_con

set_app_con:
  %oldtype1 = call i32 @_set_app_type(i32 1)
  br label %fmode_commode

set_app_gui:
  %oldtype2 = call i32 @_set_app_type(i32 2)
  br label %fmode_commode

fmode_commode:
  ; __p__fmode() = *off_1400044D0
  %pfmode = call i32* @__p__fmode()
  %fmode_src.raw = load i8*, i8** @off_1400044D0
  %fmode_src = bitcast i8* %fmode_src.raw to i32*
  %fmode_val = load i32, i32* %fmode_src, align 4
  store i32 %fmode_val, i32* %pfmode, align 4
  ; __p__commode() = *off_1400044B0
  %pcommode = call i32* @__p__commode()
  %comm_src.raw = load i8*, i8** @off_1400044B0
  %comm_src = bitcast i8* %comm_src.raw to i32*
  %comm_val = load i32, i32* %comm_src, align 4
  store i32 %comm_val, i32* %pcommode, align 4

  ; sub_140001910
  %initres = call i32 @sub_140001910()
  %initneg = icmp slt i32 %initres, 0
  br i1 %initneg, label %err_path, label %check_4380

check_4380:
  %p4380.raw = load i8*, i8** @off_140004380
  %p4380 = bitcast i8* %p4380.raw to i32*
  %v4380 = load i32, i32* %p4380, align 4
  %is1_4380 = icmp eq i32 %v4380, 1
  br i1 %is1_4380, label %call_2070, label %check_43E0

call_2070:
  %main.ptr = bitcast i32 (...) * @sub_1400019D0 to i8*
  call void @sub_140002070(i8* %main.ptr)
  br label %check_43E0

check_43E0:
  %p43E0.raw = load i8*, i8** @off_1400043E0
  %p43E0 = bitcast i8* %p43E0.raw to i32*
  %v43E0 = load i32, i32* %p43E0, align 4
  %is_m1 = icmp eq i32 %v43E0, -1
  br i1 %is_m1, label %cfg_locale, label %do_initterm_e

cfg_locale:
  %oldloc = call i32 @_configthreadlocale(i32 -1)
  br label %do_initterm_e

do_initterm_e:
  %first = load i8**, i8*** @First
  %last = load i8**, i8*** @Last
  %e_res = call i32 @_initterm_e(i8** %first, i8** %last)
  %e_fail = icmp ne i32 %e_res, 0
  br i1 %e_fail, label %fast_fail, label %collect_args

fast_fail:
  br label %ret_ff

ret_ff:
  ; return 0xFF
  ret i32 255

collect_args:
  ; load *off_140004500 into var4C
  %p4500.raw = load i8*, i8** @off_140004500
  %p4500 = bitcast i8* %p4500.raw to i32*
  %v4500 = load i32, i32* %p4500, align 4
  store i32 %v4500, i32* %var4C, align 4
  ; r9d from *off_1400044C0
  %p44C0.raw = load i8*, i8** @off_1400044C0
  %p44C0 = bitcast i8* %p44C0.raw to i32*
  %v44C0 = load i32, i32* %p44C0, align 4
  ; prepare pointers to argc/argv/envp globals
  %argc.p = bitcast i32* @dword_140007020 to i32*
  %argv.pp = bitcast i8*** @qword_140007018 to i8***
  %envp.pp = bitcast i8*** @qword_140007010 to i8***
  ; 5th arg: &var4C
  %var4C.ptr = bitcast i32* %var4C to i32*
  %a60 = call i32 @sub_140002A60(i32* %argc.p, i8*** %argv.pp, i8*** %envp.pp, i32 %v44C0, i32* %var4C.ptr)
  %a60neg = icmp slt i32 %a60, 0
  br i1 %a60neg, label %err_path, label %alloc_argv_copy

alloc_argv_copy:
  %argc = load i32, i32* @dword_140007020, align 4
  %argc1 = add i32 %argc, 1
  %argc1_64 = sext i32 %argc1 to i64
  %bytes = shl i64 %argc1_64, 3
  %r13 = call i8* @malloc(i64 %bytes)
  %r13_isnull = icmp eq i8* %r13, null
  br i1 %r13_isnull, label %err_path, label %maybe_loop

maybe_loop:
  %argc64 = sext i32 %argc to i64
  %has_args = icmp sgt i64 %argc64, 0
  br i1 %has_args, label %loop_setup, label %write_null_term

loop_setup:
  %r15 = load i8**, i8*** @qword_140007018
  br label %loop_head

loop_head:
  ; i from 1 to argc
  %i = phi i64 [ 1, %loop_setup ], [ %i.next, %loop_body_done ]
  %src.slot.ptr = getelementptr i8*, i8** %r15, i64 (0)
  %src.ptr = getelementptr i8*, i8** %src.slot.ptr, i64 %i
  %src.elem = getelementptr i8*, i8** %r15, i64 %i
  %src = load i8*, i8** %src.elem, align 8
  %len = call i64 @strlen(i8* %src)
  %cpylen = add i64 %len, 1
  %dst = call i8* @malloc(i64 %cpylen)
  %dst.slot = getelementptr i8*, i8** bitcast (i8* %r13 to i8**), i64 %i
  store i8* %dst, i8** %dst.slot, align 8
  %dst_isnull = icmp eq i8* %dst, null
  br i1 %dst_isnull, label %err_path, label %do_memcpy

do_memcpy:
  %dst.gep = getelementptr i8*, i8** bitcast (i8* %r13 to i8**), i64 %i
  %dst.cur = load i8*, i8** %dst.gep, align 8
  %cpy = call i8* @memcpy(i8* %dst.cur, i8* %src, i64 %cpylen)
  %atend = icmp eq i64 %i, %argc64
  br i1 %atend, label %loop_last, label %loop_body_done

loop_last:
  ; compute rax = r13 + argc*8 (end pointer)
  %endptr = getelementptr i8, i8* %r13, i64 mul (i64 %argc64, i64 8)
  br label %write_null_term_with_end

loop_body_done:
  %i.next = add i64 %i, 1
  br label %loop_head

write_null_term_with_end:
  ; endptr as computed above
  %endp.cast = bitcast i8* %endptr to i8**
  store i8* null, i8** %endp.cast, align 8
  br label %post_copy

write_null_term:
  ; rax is r13 (start), write null at [r13]
  %start.cast = bitcast i8* %r13 to i8**
  store i8* null, i8** %start.cast, align 8
  br label %post_copy

post_copy:
  ; qword_140007018 = r13
  store i8** bitcast (i8* %r13 to i8**), i8*** @qword_140007018, align 8
  ; call _initterm(off_140004470, off_140004480)
  %beg = load i8**, i8*** @off_140004470
  %end = load i8**, i8*** @off_140004480
  call void @_initterm(i8** %beg, i8** %end)
  call void @sub_1400018F0()
  store i32 2, i32* %stageptr, align 4
  br label %set_flag_and_maybe_release

set_flag_and_maybe_release:
  store i32 1, i32* @dword_140007004, align 4
  %reent = load i1, i1* %reentrant.flag, align 1
  %is_reent_false = icmp eq i1 %reent, false
  br i1 %is_reent_false, label %release_lock_and_continue, label %continue_after_release

release_lock_and_continue:
  %_ = atomicrmw xchg i64* %lockptr, i64 0 monotonic
  br label %continue_after_release

continue_after_release:
  ; optional callback
  %p3D0.raw = load i8*, i8** @off_1400043D0
  %p3D0 = bitcast i8* %p3D0.raw to i8**
  %cb = load i8*, i8** %p3D0, align 8
  %cb_isnull = icmp eq i8* %cb, null
  br i1 %cb_isnull, label %call_A20, label %do_cb

do_cb:
  %cb_typed = bitcast i8* %cb to void (i32, i32, i32)* 
  call void %cb_typed(i32 0, i32 2, i32 0)
  br label %call_A20

call_A20:
  %pA20 = call i8** @sub_140002A20()
  %envp = load i8*, i8** @qword_140007010, align 8
  store i8* %envp, i8** %pA20, align 8
  %argv2 = load i8**, i8*** @qword_140007018, align 8
  %argc2 = load i32, i32* @dword_140007020, align 4
  call void @sub_14000171D(i32 %argc2, i8** %argv2, i8* %envp)
  ; main result is in EAX per asm, but our callee returns void; emulate 0
  ; store a default result 0
  store i32 0, i32* %var5C, align 4

  %ecxflag = load i32, i32* @dword_140007008, align 4
  %ecxflag_zero = icmp eq i32 %ecxflag, 0
  br i1 %ecxflag_zero, label %exit_with_code, label %check_postflag

exit_with_code:
  %code = load i32, i32* %var5C, align 4
  call void @exit(i32 %code)
  unreachable

check_postflag:
  %flag2 = load i32, i32* @dword_140007004, align 4
  %flag2_zero = icmp eq i32 %flag2, 0
  br i1 %flag2_zero, label %err_path, label %ret_norm

err_path:
  %rc8 = call i32 @sub_140002A30(i32 8)
  store i32 %rc8, i32* %var5C, align 4
  call void @_cexit()
  %rc8load = load i32, i32* %var5C, align 4
  ret i32 %rc8load

ret_norm:
  ; normal return 0
  ret i32 0
}