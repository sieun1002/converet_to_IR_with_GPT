; ModuleID = 'sub_140001010.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @Sleep(i32)
declare i8* @SetUnhandledExceptionFilter(i8*)
declare i8* @_set_invalid_parameter_handler(i8*)
declare void @sub_140001CA0()
declare void @sub_1400024E0()
declare i32* @__p__fmode()
declare i32* @__p__commode()
declare i32 @_set_app_type(i32)
declare i32 @sub_140001910()
declare void @sub_140002070(void ()*)
declare i32 @_configthreadlocale(i32)
declare i32 @_initterm_e(i32 ()**, i32 ()**)
declare void @_initterm(void ()**, void ()**)
declare i8* @malloc(i64)
declare i8* @memcpy(i8*, i8*, i64)
declare i64 @strlen(i8*)
declare i32 @sub_140002A60(i32*, i8***, i8***, i32, i32*)
declare i8* @sub_140002A20()
declare void @sub_14000171D(i32, i8**, i8*)
declare i32 @sub_140002A30(i32)
declare void @_cexit()
declare void @exit(i32) noreturn
declare void @sub_1400018F0()
declare void @sub_1400019D0()
declare i32 @TopLevelExceptionFilter(i8*)
declare void @Handler()

@off_140004450 = external global i64**           ; -> pointer to qword lock
@off_140004460 = external global i32**           ; -> pointer to dword state
@dword_140007004 = external global i32
@off_1400043D0 = external global i8**            ; -> pointer to pointer-to-callback
@qword_140007010 = external global i8*           ; raw pointer
@dword_140007020 = external global i32           ; argc
@qword_140007018 = external global i8**          ; argv array
@dword_140007008 = external global i32
@off_140004440 = external global i8**            ; -> location to store prev filter
@off_140004410 = external global i32**           ; -> int flag
@off_140004420 = external global i32**           ; -> int flag
@off_140004430 = external global i32**           ; -> int flag
@off_1400043A0 = external global i8**            ; -> module base
@off_140004400 = external global i32**           ; -> app type flag
@off_1400044D0 = external global i32**           ; -> default fmode
@off_1400044B0 = external global i32**           ; -> default commode
@off_140004380 = external global i32**           ; -> feature flag
@off_1400043E0 = external global i32**           ; -> configthreadlocale flag addr
@First = external global i8**                    ; -> _PIFV* first
@Last  = external global i8**                    ; -> _PIFV* last
@off_140004470 = external global i8**            ; -> _PVFV* first
@off_140004480 = external global i8**            ; -> _PVFV* last
@off_140004500 = external global i32**           ; -> int
@off_1400044C0 = external global i32**           ; -> int

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %var_4C = alloca i32, align 4
  %teb = call i64 asm sideeffect inteldialect "mov $0, qword ptr gs:0x30", "=r"()
  %teb.ptr = inttoptr i64 %teb to i8*
  %owner.ptr = getelementptr i8, i8* %teb.ptr, i64 8
  %owner.qp = bitcast i8* %owner.ptr to i64*
  %owner = load i64, i64* %owner.qp, align 8
  %lock.ptr.ptr = load i64*, i64** @off_140004450
  br label %acquire

acquire:                                             ; cmpxchg loop
  %cmpres = cmpxchg i64* %lock.ptr.ptr, i64 0, i64 %owner seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpres, 0
  %success = extractvalue { i64, i1 } %cmpres, 1
  br i1 %success, label %after_lock, label %cmp_fail

cmp_fail:
  %same = icmp eq i64 %old, %owner
  br i1 %same, label %reentrant, label %sleep_then

sleep_then:
  call void @Sleep(i32 1000)
  br label %acquire

reentrant:
  br label %after_lock

after_lock:
  %reent.flag = phi i1 [ false, %acquire ], [ true, %reentrant ]
  %state.ptr = load i32*, i32** @off_140004460
  %state0 = load i32, i32* %state.ptr, align 4
  %is1 = icmp eq i32 %state0, 1
  br i1 %is1, label %state_is1, label %state_not1

state_is1:
  %ret31 = call i32 @sub_140002A30(i32 31)
  call void @exit(i32 %ret31)
  unreachable

state_not1:
  %state1 = load i32, i32* %state.ptr, align 4
  %is0 = icmp eq i32 %state1, 0
  br i1 %is0, label %do_init, label %set_flag_then

set_flag_then:
  store i32 1, i32* @dword_140007004, align 4
  br label %post_init_common

do_init:
  store i32 1, i32* %state.ptr, align 4
  call void @sub_140001CA0()
  %filter.fp = bitcast i32 (i8*)* @TopLevelExceptionFilter to i8*
  %prev = call i8* @SetUnhandledExceptionFilter(i8* %filter.fp)
  %prevloc.p = load i8*, i8** @off_140004440
  %prevloc.pp = bitcast i8* %prevloc.p to i8**
  store i8* %prev, i8** %prevloc.pp, align 8
  %iph = bitcast void ()* @Handler to i8*
  %oldiph = call i8* @_set_invalid_parameter_handler(i8* %iph)
  call void @sub_1400024E0()
  %p410 = load i32*, i32** @off_140004410
  store i32 1, i32* %p410, align 4
  %p420 = load i32*, i32** @off_140004420
  store i32 1, i32* %p420, align 4
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430, align 4
  %base.p = load i8*, i8** @off_1400043A0
  %mz.p = bitcast i8* %base.p to i16*
  %mz = load i16, i16* %mz.p, align 1
  %mzok = icmp eq i16 %mz, i16 23117            ; 0x5A4D
  br i1 %mzok, label %chk_nt, label %pe_flag_zero

chk_nt:
  %e_lfanew.p = getelementptr i8, i8* %base.p, i64 60
  %e_lfanew.pi = bitcast i8* %e_lfanew.p to i32*
  %e_lfanew = load i32, i32* %e_lfanew.pi, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base.p, i64 %e_lfanew64
  %sig.p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sig.p, align 1
  %isPE = icmp eq i32 %sig, 17744               ; 0x00004550
  br i1 %isPE, label %chk_opt, label %pe_flag_zero

chk_opt:
  %optmag.p0 = getelementptr i8, i8* %nt, i64 24
  %optmag.pi = bitcast i8* %optmag.p0 to i16*
  %optmag = load i16, i16* %optmag.pi, align 1
  %isPE32 = icmp eq i16 %optmag, i16 267        ; 0x10B
  %isPE64 = icmp eq i16 %optmag, i16 523        ; 0x20B
  br i1 %isPE32, label %pe32_path, label %chk_pe64

pe32_path:
  %szdir.p = getelementptr i8, i8* %nt, i64 116 ; +0x74
  %szdir.pi = bitcast i8* %szdir.p to i32*
  %szdir = load i32, i32* %szdir.pi, align 1
  %enough = icmp ugt i32 %szdir, 14
  br i1 %enough, label %pe32_dd, label %pe_flag_zero

pe32_dd:
  %dd14.p = getelementptr i8, i8* %nt, i64 232  ; +0xE8
  %dd14.pi = bitcast i8* %dd14.p to i32*
  %dd14 = load i32, i32* %dd14.pi, align 1
  %nz = icmp ne i32 %dd14, 0
  br label %set_pe_flag

chk_pe64:
  br i1 %isPE64, label %pe64_path, label %pe_flag_zero

pe64_path:
  %szdir64.p = getelementptr i8, i8* %nt, i64 132 ; +0x84
  %szdir64.pi = bitcast i8* %szdir64.p to i32*
  %szdir64 = load i32, i32* %szdir64.pi, align 1
  %enough64 = icmp ugt i32 %szdir64, 14
  br i1 %enough64, label %pe64_dd, label %pe_flag_zero

pe64_dd:
  %dd14_64.p = getelementptr i8, i8* %nt, i64 248 ; +0xF8
  %dd14_64.pi = bitcast i8* %dd14_64.p to i32*
  %dd14_64 = load i32, i32* %dd14_64.pi, align 1
  %nz64 = icmp ne i32 %dd14_64, 0
  br label %set_pe_flag

pe_flag_zero:
  %pef0 = phi i1 [ false, %do_init ], [ false, %chk_nt ], [ false, %chk_opt ], [ false, %pe32_path ], [ false, %chk_pe64 ]
  %pef0.ext = zext i1 %pef0 to i32
  store i32 %pef0.ext, i32* @dword_140007008, align 4
  br label %app_type_decide

set_pe_flag:
  %nz.any = phi i1 [ %nz, %pe32_dd ], [ %nz64, %pe64_dd ]
  %pef = zext i1 %nz.any to i32
  store i32 %pef, i32* @dword_140007008, align 4
  br label %app_type_decide

app_type_decide:
  %apptype.ptr = load i32*, i32** @off_140004400
  %apptype.val = load i32, i32* %apptype.ptr, align 4
  %apptype.nz = icmp ne i32 %apptype.val, 0
  br i1 %apptype.nz, label %app_gui, label %app_console

app_console:
  %set1 = call i32 @_set_app_type(i32 1)
  br label %crt_modes

app_gui:
  %set2 = call i32 @_set_app_type(i32 2)
  br label %crt_modes

crt_modes:
  %pfmode = call i32* @__p__fmode()
  %defm.ptr.p = load i32*, i32** @off_1400044D0
  %defm = load i32, i32* %defm.ptr.p, align 4
  store i32 %defm, i32* %pfmode, align 4
  %pcommode = call i32* @__p__commode()
  %defc.ptr.p = load i32*, i32** @off_1400044B0
  %defc = load i32, i32* %defc.ptr.p, align 4
  store i32 %defc, i32* %pcommode, align 4
  %initres = call i32 @sub_140001910()
  %neg = icmp slt i32 %initres, 0
  br i1 %neg, label %error_cleanup, label %check_feat

check_feat:
  %feat.ptr = load i32*, i32** @off_140004380
  %feat = load i32, i32* %feat.ptr, align 4
  %feat_is1 = icmp eq i32 %feat, 1
  br i1 %feat_is1, label %do_reg, label %after_reg

do_reg:
  call void @sub_140002070(void ()* @sub_1400019D0)
  br label %after_reg

after_reg:
  %ctl.addr.p = load i32*, i32** @off_1400043E0
  %ctl.val = load i32, i32* %ctl.addr.p, align 4
  %ctl_is_m1 = icmp eq i32 %ctl.val, -1
  br i1 %ctl_is_m1, label %set_ctl, label %after_ctl

set_ctl:
  %ctls = call i32 @_configthreadlocale(i32 -1)
  br label %after_ctl

after_ctl:
  %first.p.raw = load i8*, i8** @First
  %last.p.raw  = load i8*, i8** @Last
  %first.p = bitcast i8* %first.p.raw to i32 ()**
  %last.p  = bitcast i8* %last.p.raw  to i32 ()**
  %e = call i32 @_initterm_e(i32 ()** %first.p, i32 ()** %last.p)
  %e_nz = icmp ne i32 %e, 0
  br i1 %e_nz, label %early_ret_ff, label %argv_setup

early_ret_ff:
  br label %return_ff

argv_setup:
  %p500 = load i32*, i32** @off_140004500
  %v500 = load i32, i32* %p500, align 4
  store i32 %v500, i32* %var_4C, align 4
  %p4c0 = load i32*, i32** @off_1400044C0
  %v4c0 = load i32, i32* %p4c0, align 4
  %argc.addr = bitcast i32* @dword_140007020 to i32*
  %argv.addr = bitcast i8** @qword_140007018 to i8***
  %env.addr  = bitcast i8* @qword_140007010 to i8*             ; pass by address for r8? r8 is env pointer target
  %env.addr.pp = bitcast i8* @qword_140007010 to i8***         ; for call signature
  %call.a60 = call i32 @sub_140002A60(i32* %argc.addr, i8*** %argv.addr, i8*** %env.addr.pp, i32 %v4c0, i32* %var_4C)
  %a60.neg = icmp slt i32 %call.a60, 0
  br i1 %a60.neg, label %error_cleanup, label %alloc_argv_copy

alloc_argv_copy:
  %argc.val = load i32, i32* @dword_140007020, align 4
  %argc64 = sext i32 %argc.val to i64
  %argc1 = add nsw i64 %argc64, 1
  %bytes = shl i64 %argc1, 3
  %newarr = call i8* @malloc(i64 %bytes)
  %newarr.cast = bitcast i8* %newarr to i8**
  %newarr.null = icmp eq i8* %newarr, null
  br i1 %newarr.null, label %error_cleanup, label %copy_loop_prep

copy_loop_prep:
  %cond = icmp sgt i32 %argc.val, 0
  br i1 %cond, label %copy_loop_head, label %terminate_array

copy_loop_head:
  %srcbase = load i8**, i8*** @qword_140007018, align 8
  br label %copy_loop

copy_loop:
  %i = phi i32 [ 1, %copy_loop_head ], [ %i.next, %copy_loop_body ]
  %idx64 = sext i32 %i to i64
  %src.ptr.slot = getelementptr i8*, i8** %srcbase, i64 (0)
  %src.elem.ptr = getelementptr i8*, i8** %srcbase, i64 (0)
  %src.elem = getelementptr i8*, i8** %srcbase, i64 (0)
  %src.at = getelementptr i8*, i8** %srcbase, i64 (add (sext (i32 %i) to i64), -1) ; place holder to keep SSA unique

  ; compute src = srcbase[i-1]
  %i_1 = add nsw i32 %i, -1
  %i_1_64 = sext i32 %i_1 to i64
  %src = getelementptr i8*, i8** %srcbase, i64 %i_1_64
  %src.val = load i8*, i8** %src, align 8

  %len = call i64 @strlen(i8* %src.val)
  %size = add i64 %len, 1
  %dst.mem = call i8* @malloc(i64 %size)
  %dstslot = getelementptr i8*, i8** %newarr.cast, i64 %i_1_64
  store i8* %dst.mem, i8** %dstslot, align 8
  %dst.null = icmp eq i8* %dst.mem, null
  br i1 %dst.null, label %error_cleanup, label %copy_loop_body

copy_loop_body:
  %dstslot.forcpy = phi i8* [ %dst.mem, %copy_loop ]
  %src.forcpy = phi i8* [ %src.val, %copy_loop ]
  %size.forcpy = phi i64 [ %size, %copy_loop ]
  %copied = call i8* @memcpy(i8* %dstslot.forcpy, i8* %src.forcpy, i64 %size.forcpy)
  %i.cmp = icmp eq i64 %argc64, sext (i32 %i to i64)
  %is_last = icmp eq i32 %argc.val, %i
  br i1 %is_last, label %terminate_array, label %loop_incr

loop_incr:
  %i.next = add nsw i32 %i, 1
  br label %copy_loop

terminate_array:
  %end.ptr.index = sext i32 %argc.val to i64
  %end.ptr = getelementptr i8*, i8** %newarr.cast, i64 %end.ptr.index
  store i8* null, i8** %end.ptr, align 8
  %init.last.p = load i8*, i8** @off_140004480
  %init.first.p = load i8*, i8** @off_140004470
  %init.last = bitcast i8* %init.last.p to void ()**
  %init.first = bitcast i8* %init.first.p to void ()**
  store i8** %newarr.cast, i8*** @qword_140007018, align 8
  call void @_initterm(void ()** %init.first, void ()** %init.last)
  call void @sub_1400018F0()
  store i32 2, i32* %state.ptr, align 4
  br label %post_init_common

error_cleanup:
  %errcode = call i32 @sub_140002A30(i32 8)
  br label %cexit_then_return

post_init_common:
  %r14 = phi i1 [ true, %set_flag_then ], [ %reent.flag, %after_lock ], [ %reent.flag, %terminate_array ]
  br i1 %r14, label %pre_main, label %unlock_then_pre_main

unlock_then_pre_main:
  %_ = atomicrmw xchg i64* %lock.ptr.ptr, i64 0 seq_cst
  br label %pre_main

pre_main:
  %cb.loc.p = load i8*, i8** @off_1400043D0
  %cb.loc.pp = bitcast i8* %cb.loc.p to i8**
  %cb.fp.raw = load i8*, i8** %cb.loc.pp, align 8
  %cb.isnull = icmp eq i8* %cb.fp.raw, null
  br i1 %cb.isnull, label %after_cb, label %do_cb

do_cb:
  %cb.fp = bitcast i8* %cb.fp.raw to void (i32, i32, i32)*
  call void %cb.fp(i32 0, i32 2, i32 0)
  br label %after_cb

after_cb:
  %ctx = call i8* @sub_140002A20()
  %ctx.pp = bitcast i8* %ctx to i8**
  %envp = load i8*, i8** @qword_140007010, align 8
  store i8* %envp, i8** %ctx.pp, align 8
  %argc.forcall = load i32, i32* @dword_140007020, align 4
  %argv.forcall = load i8**, i8*** @qword_140007018, align 8
  %env.forcall  = load i8*, i8** @qword_140007010, align 8
  call void @sub_14000171D(i32 %argc.forcall, i8** %argv.forcall, i8* %env.forcall)
  %ret_from_main = call i32 @sub_140002A30(i32 0) ; placeholder if sub_14000171D sets eax; emulate by fetching code if needed

  %peflag = load i32, i32* @dword_140007008, align 4
  %peflag_zero = icmp eq i32 %peflag, 0
  br i1 %peflag_zero, label %force_exit, label %maybe_cexit

force_exit:
  call void @exit(i32 %ret_from_main)
  unreachable

maybe_cexit:
  %flag004 = load i32, i32* @dword_140007004, align 4
  %flag004_zero = icmp eq i32 %flag004, 0
  br i1 %flag004_zero, label %cexit_then_return_with_main, label %return_main

cexit_then_return_with_main:
  %save = phi i32 [ %ret_from_main, %maybe_cexit ]
  call void @_cexit()
  ret i32 %save

return_main:
  ret i32 %ret_from_main

cexit_then_return:
  %save2 = phi i32 [ %errcode, %error_cleanup ]
  call void @_cexit()
  ret i32 %save2

return_ff:
  ret i32 255
}