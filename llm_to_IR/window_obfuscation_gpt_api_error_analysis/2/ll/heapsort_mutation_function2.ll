; Target: Windows x64 (MSVC)
; NOTE: Link with the MSVCRT and kernel32
target triple = "x86_64-pc-windows-msvc"

; External globals (import address pointers, configuration blocks, etc.)
@off_140004450 = external global i64*                  ; pointer to a 64-bit spinlock location
@off_140004460 = external global i32*                  ; pointer to state dword
@dword_140007004 = external global i32                 ; misc flag (used to decide _cexit)
@off_1400043D0 = external global i8**                  ; pointer to a function pointer
@qword_140007010 = external global i8*                 ; arg vector context (opaque ptr)
@dword_140007020 = external global i32                 ; argc
@qword_140007018 = external global i8**                ; argv (array of char*)
@dword_140007008 = external global i32                 ; flag deciding exit() vs return

@off_140004440 = external global i8**                  ; storage for previous exception filter

@off_140004410 = external global i32*                  ; various init flags
@off_140004420 = external global i32*
@off_140004430 = external global i32*

@off_1400043A0 = external global i8*                   ; module base (PE header)

@off_140004400 = external global i32*                  ; app type indicator
@off_1400044D0 = external global i32*                  ; initial fmode value
@off_1400044B0 = external global i32*                  ; initial commode value
@off_140004380 = external global i32*                  ; flag for additional init
@off_1400043E0 = external global i32*                  ; thread locale config flag

@First          = external global i8**                 ; _initterm_e first
@Last           = external global i8**                 ; _initterm_e last
@off_140004470  = external global i8**                 ; _initterm first
@off_140004480  = external global i8**                 ; _initterm last

@off_140004500 = external global i32*                  ; extra config dword for sub_140002A60
@off_1400044C0 = external global i32*                  ; another config dword for sub_140002A60

; Handlers and callbacks
declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler()                                ; invalid parameter handler
declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32  @sub_140001910()
declare void @sub_1400018F0()
declare i32  @sub_140002070(i8*)
declare i8** @sub_140002A20()
declare i32  @sub_14000171D(i32, i8**, i8*)
declare i32  @sub_140002A30(i32)
declare i32  @sub_140002A60(i32*, i8***, i8**, i32, i32*)

; CRT / Win32
declare dllimport void @Sleep(i32)
declare dllimport i8* @SetUnhandledExceptionFilter(i8*)
declare dllimport i8* @_set_invalid_parameter_handler(i8*)
declare dllimport i32 @_set_app_type(i32)
declare dllimport i32* @__p__fmode()
declare dllimport i32* @__p__commode()
declare dllimport i32 @_configthreadlocale(i32)
declare dllimport void @_cexit()
declare dllimport void @exit(i32)

; libc
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i64 @strlen(i8*)
declare i8* @memcpy(i8* nocapture writeonly, i8* nocapture readonly, i64)

define i32 @sub_140001010() local_unnamed_addr {
entry:
  ; locals
  %retv        = alloca i32, align 4
  %opt_arg     = alloca i32, align 4      ; corresponds to [rsp+var_4C]
  %reentrant   = alloca i1,  align 1

  ; obtain per-thread token similar to rsi = gs:[0x30]->[+8]
  %teb = call i8* asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r"()
  %teb_plus8_ptr = getelementptr i8, i8* %teb, i64 8
  %token_ptr     = bitcast i8* %teb_plus8_ptr to i8**
  %token         = load i8*, i8** %token_ptr, align 8
  %token_bits    = ptrtoint i8* %token to i64

  ; load lock pointer
  %lock_loc_ptr  = load i64*, i64** @off_140004450, align 8

  br label %lock_try

lock_try:                                            ; lock acquisition via cmpxchg
  %expected0     = phi i64 [ 0, %entry ], [ 0, %sleep ], [ 0, %again ]
  %cmpx          = cmpxchg i64* %lock_loc_ptr, i64 %expected0, i64 %token_bits seq_cst seq_cst
  %old           = extractvalue { i64, i1 } %cmpx, 0
  %success       = extractvalue { i64, i1 } %cmpx, 1
  br i1 %success, label %locked_fresh, label %lock_fail

lock_fail:
  %same_owner    = icmp eq i64 %old, %token_bits
  br i1 %same_owner, label %locked_reentrant, label %sleep

sleep:
  call void @Sleep(i32 1000)
  br label %again

again:
  br label %lock_try

locked_fresh:
  store i1 false, i1* %reentrant, align 1
  br label %post_lock

locked_reentrant:
  store i1 true, i1* %reentrant, align 1
  br label %post_lock

post_lock:
  ; rbp = *off_140004460
  %state_ptr_ptr = load i32*, i32** @off_140004460, align 8
  %state0        = load i32, i32* %state_ptr_ptr, align 4
  %is_one        = icmp eq i32 %state0, 1
  br i1 %is_one, label %state_is_one, label %check_state_zero

state_is_one:
  ; sub_140002A30(31) then decide exit/return as per dword_140007008
  %code_31   = call i32 @sub_140002A30(i32 31)
  %flag_exitp1 = load i32, i32* @dword_140007008, align 4
  %z_exitp1    = icmp eq i32 %flag_exitp1, 0
  br i1 %z_exitp1, label %do_exit_now31, label %do_return31

do_exit_now31:
  call void @exit(i32 %code_31)
  unreachable

do_return31:
  store i32 %code_31, i32* %retv, align 4
  call void @_cexit()
  %rv31 = load i32, i32* %retv, align 4
  ret i32 %rv31

check_state_zero:
  %is_zero      = icmp eq i32 %state0, 0
  br i1 %is_zero, label %uninitialized, label %already_initialized

uninitialized:
  ; [rbp] = 1
  store i32 1, i32* %state_ptr_ptr, align 4
  call void @sub_140001CA0()

  ; SetUnhandledExceptionFilter(TopLevelExceptionFilter)
  %tlfp     = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prevflt  = call i8* @SetUnhandledExceptionFilter(i8* %tlfp)

  ; *off_140004440 = prev filter
  %prevstorepp = load i8**, i8*** @off_140004440, align 8
  store i8* %prevflt, i8** %prevstorepp, align 8

  ; _set_invalid_parameter_handler(Handler)
  %iph = bitcast void ()* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %iph)

  call void @sub_1400024E0()

  ; set several init flags to 1
  %p4110 = load i32*, i32** @off_140004410, align 8
  store i32 1, i32* %p4110, align 4
  %p4420 = load i32*, i32** @off_140004420, align 8
  store i32 1, i32* %p4420, align 4
  %p4430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p4430, align 4

  ; compute dword_140007008 (ecx) based on PE headers (best-effort)
  %base_mod      = load i8*, i8** @off_1400043A0, align 8
  %is_null_base  = icmp eq i8* %base_mod, null
  br i1 %is_null_base, label %pe_set0, label %pe_chk_mz

pe_chk_mz:
  %mz_ptr  = bitcast i8* %base_mod to i16*
  %mz      = load i16, i16* %mz_ptr, align 2
  %is_mz   = icmp eq i16 %mz, 23117        ; 0x5A4D
  br i1 %is_mz, label %pe_lfanew, label %pe_set0

pe_lfanew:
  %e_lfanew_ptr = getelementptr i8, i8* %base_mod, i64 60
  %e_lfanew_i32p= bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew     = load i32, i32* %e_lfanew_i32p, align 4
  %nt_hdr_ptr   = getelementptr i8, i8* %base_mod, i64 (0)
  %e_lfanew64   = zext i32 %e_lfanew to i64
  %nt           = getelementptr i8, i8* %nt_hdr_ptr, i64 %e_lfanew64
  %sig_ptr      = bitcast i8* %nt to i32*
  %sig          = load i32, i32* %sig_ptr, align 4
  %is_pe        = icmp eq i32 %sig, 17744  ; 0x00004550
  br i1 %is_pe, label %pe_magic, label %pe_set0

pe_magic:
  %magic_ptr    = getelementptr i8, i8* %nt, i64 24
  %magic_p16    = bitcast i8* %magic_ptr to i16*
  %magic        = load i16, i16* %magic_p16, align 2
  %is_pe32      = icmp eq i16 %magic, 267   ; 0x10B
  %is_pe32p     = icmp eq i16 %magic, 523   ; 0x20B
  br i1 %is_pe32, label %chk_pe32, label %chk_pe32p

chk_pe32:
  ; if OptionalHeader.SizeOfOptionalHeader > 0xE then read [nt+0xE8]
  %soh_ptr      = getelementptr i8, i8* %nt, i64 116  ; 0x74
  %soh_p32      = bitcast i8* %soh_ptr to i32*
  %soh          = load i32, i32* %soh_p32, align 4
  %soh_gt       = icmp ugt i32 %soh, 14
  br i1 %soh_gt, label %read_pe32_flag, label %pe_set0

read_pe32_flag:
  %val_ptr      = getelementptr i8, i8* %nt, i64 232  ; 0xE8
  %val_p32      = bitcast i8* %val_ptr to i32*
  %val          = load i32, i32* %val_p32, align 4
  %nz           = icmp ne i32 %val, 0
  %ecx_pe32     = select i1 %nz, i32 1, i32 0
  store i32 %ecx_pe32, i32* @dword_140007008, align 4
  br label %after_pe

chk_pe32p:
  %soh2_ptr     = getelementptr i8, i8* %nt, i64 132  ; 0x84
  %soh2_p32     = bitcast i8* %soh2_ptr to i32*
  %soh2         = load i32, i32* %soh2_p32, align 4
  %soh2_gt      = icmp ugt i32 %soh2, 14
  br i1 %soh2_gt, label %read_pe32p_flag, label %pe_set0

read_pe32p_flag:
  %val2_ptr     = getelementptr i8, i8* %nt, i64 248  ; 0xF8
  %val2_p32     = bitcast i8* %val2_ptr to i32*
  %val2         = load i32, i32* %val2_p32, align 4
  %nz2          = icmp ne i32 %val2, 0
  %ecx_pe32p    = select i1 %nz2, i32 1, i32 0
  store i32 %ecx_pe32p, i32* @dword_140007008, align 4
  br label %after_pe

pe_set0:
  store i32 0, i32* @dword_140007008, align 4
  br label %after_pe

after_pe:
  ; app type
  %apptypep = load i32*, i32** @off_140004400, align 8
  %apptype  = load i32, i32* %apptypep, align 4
  %is_gui   = icmp ne i32 %apptype, 0
  br i1 %is_gui, label %set_app_gui, label %set_app_cui

set_app_gui:
  call i32 @_set_app_type(i32 2)
  br label %after_app_type

set_app_cui:
  call i32 @_set_app_type(i32 1)
  br label %after_app_type

after_app_type:
  ; propagate fmode/commode
  %pfmode = call i32* @__p__fmode()
  %src_fm_ptr = load i32*, i32** @off_1400044D0, align 8
  %src_fm = load i32, i32* %src_fm_ptr, align 4
  store i32 %src_fm, i32* %pfmode, align 4

  %pcomm = call i32* @__p__commode()
  %src_cm_ptr = load i32*, i32** @off_1400044B0, align 8
  %src_cm = load i32, i32* %src_cm_ptr, align 4
  store i32 %src_cm, i32* %pcomm, align 4

  ; sub_140001910()
  %r1910 = call i32 @sub_140001910()
  %neg1910 = icmp slt i32 %r1910, 0
  br i1 %neg1910, label %error_8, label %post_1910

post_1910:
  ; if *off_140004380 == 1 then sub_140002070(&sub_1400019D0)
  %p4380 = load i32*, i32** @off_140004380, align 8
  %v4380 = load i32, i32* %p4380, align 4
  %is_one_4380 = icmp eq i32 %v4380, 1
  br i1 %is_one_4380, label %call_2070, label %check_locale

call_2070:
  %cb = bitcast i32 (i8*)* @sub_1400019D0 to i8*
  %tmp2070 = call i32 @sub_140002070(i8* %cb)
  br label %check_locale

check_locale:
  ; if *off_1400043E0 == -1 then _configthreadlocale(-1)
  %p43E0 = load i32*, i32** @off_1400043E0, align 8
  %v43E0 = load i32, i32* %p43E0, align 4
  %is_m1  = icmp eq i32 %v43E0, -1
  br i1 %is_m1, label %do_ctl, label %after_ctl

do_ctl:
  call i32 @_configthreadlocale(i32 -1)
  br label %after_ctl

after_ctl:
  ; _initterm_e(First, Last)
  %first = load i8**, i8*** @First, align 8
  %last  = load i8**, i8*** @Last, align 8
  %ie    = call i32 @_initterm_e(i8** %first, i8** %last)
  %ie_nz = icmp ne i32 %ie, 0
  br i1 %ie_nz, label %error_ff, label %after_initterm_e

after_initterm_e:
  ; prepare and call sub_140002A60(&dword_140007020, &qword_140007018, &qword_140007010, r9d, &opt_arg)
  %opt_srcp   = load i32*, i32** @off_140004500, align 8
  %opt_src    = load i32, i32* %opt_srcp, align 4
  store i32 %opt_src, i32* %opt_arg, align 4
  %r9srcp     = load i32*, i32** @off_1400044C0, align 8
  %r9d        = load i32, i32* %r9srcp, align 4
  %argc_ptr   = bitcast i32* @dword_140007020 to i32*
  %argv_ptr   = bitcast i8*** @qword_140007018 to i8***
  %ctx_ptr    = bitcast i8* @qword_140007010 to i8* ; not used directly, we pass address of global value
  %ctx_val     = load i8*, i8** @qword_140007010, align 8
  %res_a60    = call i32 @sub_140002A60(i32* %argc_ptr, i8*** %argv_ptr, i8** @qword_140007010, i32 %r9d, i32* %opt_arg)
  %neg_a60    = icmp slt i32 %res_a60, 0
  br i1 %neg_a60, label %error_8, label %prepare_argv_copy

prepare_argv_copy:
  ; r12 = dword_140007020
  %argc = load i32, i32* @dword_140007020, align 4
  %argc64 = sext i32 %argc to i64
  %argc1  = add i64 %argc64, 1
  %bytes  = shl i64 %argc1, 3
  %newv   = call i8* @malloc(i64 %bytes)
  %argv_new = bitcast i8* %newv to i8**
  %alloc_ok = icmp ne i8* %newv, null
  br i1 %alloc_ok, label %maybe_copy, label %error_8

maybe_copy:
  ; if argc <= 0, just null-terminate
  %argc_pos = icmp sgt i32 %argc, 0
  br i1 %argc_pos, label %copy_loop_init, label %null_terminate

copy_loop_init:
  %argv_old = load i8**, i8*** @qword_140007018, align 8
  br label %copy_loop

copy_loop:
  ; i from 1 to argc
  %i      = phi i64 [ 1, %copy_loop_init ], [ %i_next, %after_copy_one ]
  %idxm1  = add i64 %i, -1
  %srcp   = getelementptr inbounds i8*, i8** %argv_old, i64 %idxm1
  %src    = load i8*, i8** %srcp, align 8
  %len    = call i64 @strlen(i8* %src)
  %size1  = add i64 %len, 1
  %dst    = call i8* @malloc(i64 %size1)
  %dstpp  = getelementptr inbounds i8*, i8** %argv_new, i64 %idxm1
  store i8* %dst, i8** %dstpp, align 8
  %dst_ok = icmp ne i8* %dst, null
  br i1 %dst_ok, label %do_copy, label %error_8

do_copy:
  %cp = call i8* @memcpy(i8* %dst, i8* %src, i64 %size1)
  %i_next = add i64 %i, 1
  %i_end  = icmp eq i64 %i, %argc64
  br i1 %i_end, label %null_terminate, label %after_copy_one

after_copy_one:
  br label %copy_loop

null_terminate:
  %end_slot = getelementptr inbounds i8*, i8** %argv_new, i64 %argc64
  store i8* null, i8** %end_slot, align 8

  ; publish new argv and run _initterm range
  store i8** %argv_new, i8*** @qword_140007018, align 8
  %it_first = load i8**, i8*** @off_140004470, align 8
  %it_last  = load i8**, i8*** @off_140004480, align 8
  call void @_initterm(i8** %it_first, i8** %it_last)

  call void @sub_1400018F0()
  store i32 2, i32* %state_ptr_ptr, align 4
  br label %after_init

already_initialized:
  ; signal that we are not the primary initializer
  store i32 1, i32* @dword_140007004, align 4
  br label %after_init

after_init:
  ; release lock if not re-entrant (xor eax,eax; xchg [lock], rax)
  %is_reent = load i1, i1* %reentrant, align 1
  %need_release = icmp eq i1 %is_reent, false
  br i1 %need_release, label %release_lock, label %keep_lock

release_lock:
  %_ = atomicrmw xchg i64* %lock_loc_ptr, i64 0 seq_cst
  br label %keep_lock

keep_lock:
  ; optional callback at *(*off_1400043D0)
  %fpbox_ptr  = load i8**, i8*** @off_1400043D0, align 8
  %fp_any     = load i8*, i8** %fpbox_ptr, align 8
  %has_cb     = icmp ne i8* %fp_any, null
  br i1 %has_cb, label %call_cb, label %after_cb

call_cb:
  ; signature assumed: void cb(i32 rcx, i32 rdx, i32 r8)
  %cb_typed = bitcast i8* %fp_any to void (i32, i32, i32)*
  call void %cb_typed(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  ; p = sub_140002A20(); *p = qword_140007010
  %p_store  = call i8** @sub_140002A20()
  %ctxv2    = load i8*, i8** @qword_140007010, align 8
  store i8* %ctxv2, i8** %p_store, align 8

  ; ret = sub_14000171D(dword_140007020, qword_140007018, qword_140007010)
  %argc_now = load i32, i32* @dword_140007020, align 4
  %argv_now = load i8**, i8*** @qword_140007018, align 8
  %retcode  = call i32 @sub_14000171D(i32 %argc_now, i8** %argv_now, i8* %ctxv2)

  ; if dword_140007008 == 0 => exit(retcode)
  %flag_exit = load i32, i32* @dword_140007008, align 4
  %z_exit    = icmp eq i32 %flag_exit, 0
  br i1 %z_exit, label %do_exit_now, label %maybe_cexit

do_exit_now:
  call void @exit(i32 %retcode)
  unreachable

maybe_cexit:
  ; if dword_140007004 == 0 => _cexit(); return ret
  %flag_cex = load i32, i32* @dword_140007004, align 4
  %z_cex    = icmp eq i32 %flag_cex, 0
  br i1 %z_cex, label %do_cexit_and_return, label %return_direct

do_cexit_and_return:
  store i32 %retcode, i32* %retv, align 4
  call void @_cexit()
  %rv = load i32, i32* %retv, align 4
  ret i32 %rv

return_direct:
  ret i32 %retcode

error_8:
  ; sub_140002A30(8); _cexit; return that code
  %code8 = call i32 @sub_140002A30(i32 8)
  store i32 %code8, i32* %retv, align 4
  call void @_cexit()
  %r8 = load i32, i32* %retv, align 4
  ret i32 %r8

error_ff:
  ; return 0xFF (assembly jumps to epilogue)
  ret i32 255
}

; Extra external symbol needed by call site above
declare i32 @sub_1400019D0(i8*)