; ModuleID = 'sub_140001010'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_140002670(i32)
declare void @sub_1400027A0(i32)
declare void @sub_140002750()
declare void @sub_1400018D0()
declare void @sub_140002790()
declare void @sub_140002120()
declare i8** @sub_140002660()
declare void @sub_140002880(i32, i8**, i8*)
declare void @sub_140002778(i32)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare void @sub_1400027B8(i8*, i8*, i8*)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027D0(i32)
declare void @sub_140001CA0(void ()*)
declare void @sub_140001520()
declare void @nullsub_3()
declare void @sub_140001CB0()
declare void @sub_140001600()
declare void @sub_140002780(i8*, i8*)

@off_140004470 = external global i64*
@qword_140008280 = external global void (i32)*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8**
@dword_140007008 = external global i32
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@off_1400044F0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400043A0 = external global i32*
@off_140004400 = external global i32*
@off_1400044C0 = external global i8*
@off_1400044B0 = external global i8*
@off_140004520 = external global i32*
@off_1400044E0 = external global i32*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*
@off_140004460 = external global i8**
@qword_140008278 = external global i8*

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %retv = alloca i32, align 4
  store i32 0, i32* %retv, align 4
  %var_4C = alloca i32, align 4
  %lockpp.addr = load i64*, i64** @off_140004470, align 8
  %sleepfp.load = load void (i32)*, void (i32)** @qword_140008280, align 8
  %gsval = call i64 asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r,~{dirflag},~{fpsr},~{flags}"()
  %gsval.ptr = inttoptr i64 %gsval to i8*
  %peb.plus8 = getelementptr i8, i8* %gsval.ptr, i64 8
  %peb.plus8.i64p = bitcast i8* %peb.plus8 to i64*
  %rsi_val = load i64, i64* %peb.plus8.i64p, align 8
  br label %spin

spin:
  %cmpx = cmpxchg i64* %lockpp.addr, i64 0, i64 %rsi_val seq_cst seq_cst
  %loaded = extractvalue { i64, i1 } %cmpx, 0
  %ok = extractvalue { i64, i1 } %cmpx, 1
  br i1 %ok, label %acquired, label %fail

fail:
  %eqown = icmp eq i64 %loaded, %rsi_val
  br i1 %eqown, label %owned, label %do_sleep

do_sleep:
  call void %sleepfp.load(i32 1000)
  br label %spin

owned:
  br label %post_lock

acquired:
  br label %post_lock

post_lock:
  %ownedflag = phi i32 [ 1, %owned ], [ 0, %acquired ]
  %statepp = load i32*, i32** @off_140004480, align 8
  %state0 = load i32, i32* %statepp, align 4
  %is_one = icmp eq i32 %state0, 1
  br i1 %is_one, label %state_is1, label %state_chk0

state_is1:
  %r1 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %r1)
  %rv1 = load i32, i32* %retv, align 4
  ret i32 %rv1

state_chk0:
  %state1 = load i32, i32* %statepp, align 4
  %is_zero = icmp eq i32 %state1, 0
  br i1 %is_zero, label %init_path, label %after_state_nonzero

init_path:
  store i32 1, i32* %statepp, align 4
  call void @sub_1400018D0()
  %fp_loader = load i8*, i8** @qword_140008278, align 8
  %fp_typed = bitcast i8* %fp_loader to i8* (void ()*)*
  %cb_result = call i8* %fp_typed(void ()* @sub_140001CB0)
  %destpp = load i8**, i8*** @off_140004460, align 8
  store i8* %cb_result, i8** %destpp, align 8
  call void @sub_140002790()
  call void @sub_140002120()
  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p450, align 4
  %imagebase = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %imagebase to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %after_mz, label %pe_store0

after_mz:
  %e_lfanew.ptr = getelementptr i8, i8* %imagebase, i64 60
  %e_lfanew.i32p = bitcast i8* %e_lfanew.ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew.i32p, align 4
  %e_lfanew.z = zext i32 %e_lfanew to i64
  %nt.ptr = getelementptr i8, i8* %imagebase, i64 %e_lfanew.z
  %sig.p = bitcast i8* %nt.ptr to i32*
  %sig = load i32, i32* %sig.p, align 4
  %pe_ok = icmp eq i32 %sig, 17744
  br i1 %pe_ok, label %opt_magic, label %pe_store0

opt_magic:
  %magic.ptr = getelementptr i8, i8* %nt.ptr, i64 24
  %magic.p16 = bitcast i8* %magic.ptr to i16*
  %magic = load i16, i16* %magic.p16, align 2
  %is_pe32 = icmp eq i16 %magic, 267
  br i1 %is_pe32, label %pe32_case, label %chk_pe32plus

chk_pe32plus:
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %pe32plus_case, label %pe_store0

pe32plus_case:
  %sizecfg.ptr = getelementptr i8, i8* %nt.ptr, i64 132
  %sizecfg.p32 = bitcast i8* %sizecfg.ptr to i32*
  %sizecfg = load i32, i32* %sizecfg.p32, align 4
  %gt_e = icmp ugt i32 %sizecfg, 14
  br i1 %gt_e, label %pe32plus_read, label %pe_store0

pe32plus_read:
  %cfg.ptr = getelementptr i8, i8* %nt.ptr, i64 248
  %cfg.p32 = bitcast i8* %cfg.ptr to i32*
  %cfg.v = load i32, i32* %cfg.p32, align 4
  %nz1 = icmp ne i32 %cfg.v, 0
  %zext1 = zext i1 %nz1 to i32
  br label %pe_store

pe32_case:
  %sizecfg2.ptr = getelementptr i8, i8* %nt.ptr, i64 116
  %sizecfg2.p32 = bitcast i8* %sizecfg2.ptr to i32*
  %sizecfg2 = load i32, i32* %sizecfg2.p32, align 4
  %gt_e2 = icmp ugt i32 %sizecfg2, 14
  br i1 %gt_e2, label %pe32_read, label %pe_store0

pe32_read:
  %cfg2.ptr = getelementptr i8, i8* %nt.ptr, i64 232
  %cfg2.p32 = bitcast i8* %cfg2.ptr to i32*
  %cfg2.v = load i32, i32* %cfg2.p32, align 4
  %nz2 = icmp ne i32 %cfg2.v, 0
  %zext2 = zext i1 %nz2 to i32
  br label %pe_store

pe_store0:
  store i32 0, i32* @dword_140007008, align 4
  br label %post_pe

pe_store:
  %ecxflag.phi = phi i32 [ %zext1, %pe32plus_read ], [ %zext2, %pe32_read ]
  store i32 %ecxflag.phi, i32* @dword_140007008, align 4
  br label %post_pe

post_pe:
  %cfgp = load i32*, i32** @off_140004420, align 8
  %r8d = load i32, i32* %cfgp, align 4
  %r8d_nz = icmp ne i32 %r8d, 0
  br i1 %r8d_nz, label %call_2778_2, label %call_2778_1

call_2778_2:
  call void @sub_140002778(i32 2)
  br label %after_2778

call_2778_1:
  call void @sub_140002778(i32 1)
  br label %after_2778

after_2778:
  %p1 = call i32* @sub_140002720()
  %v1p = load i32*, i32** @off_1400044F0, align 8
  %v1 = load i32, i32* %v1p, align 4
  store i32 %v1, i32* %p1, align 4
  %p2 = call i32* @sub_140002718()
  %v2p = load i32*, i32** @off_1400044D0, align 8
  %v2 = load i32, i32* %v2p, align 4
  store i32 %v2, i32* %p2, align 4
  %chk = call i32 @sub_140001540()
  %neg = icmp slt i32 %chk, 0
  br i1 %neg, label %err_path, label %after_chk

after_chk:
  %g3a0p = load i32*, i32** @off_1400043A0, align 8
  %g3a0 = load i32, i32* %g3a0p, align 4
  %eq1 = icmp eq i32 %g3a0, 1
  br i1 %eq1, label %call_CA0, label %chk_m1

call_CA0:
  call void @sub_140001CA0(void ()* @sub_140001600)
  br label %after_CA0

after_CA0:
  br label %chk_m1

chk_m1:
  %g400p = load i32*, i32** @off_140004400, align 8
  %g400 = load i32, i32* %g400p, align 4
  %is_m1 = icmp eq i32 %g400, -1
  br i1 %is_m1, label %call_27D0, label %after_27D0

call_27D0:
  call void @sub_1400027D0(i32 -1)
  br label %after_27D0

after_27D0:
  %bptr = load i8*, i8** @off_1400044B0, align 8
  %cptr = load i8*, i8** @off_1400044C0, align 8
  %chk2 = call i32 @sub_140002788(i8* %bptr, i8* %cptr)
  %nz3 = icmp ne i32 %chk2, 0
  br i1 %nz3, label %ret_ff, label %cont_cfg

ret_ff:
  store i32 255, i32* %retv, align 4
  %rv_ff = load i32, i32* %retv, align 4
  ret i32 %rv_ff

cont_cfg:
  %p520 = load i32*, i32** @off_140004520, align 8
  %val520 = load i32, i32* %p520, align 4
  store i32 %val520, i32* %var_4C, align 4
  %p4E0 = load i32*, i32** @off_1400044E0, align 8
  %r9d = load i32, i32* %p4E0, align 4
  %arrcountp = load i32, i32* @dword_140007020, align 4
  %arrcount = load i32, i32* @dword_140007020, align 4
  %arrpp = load i8**, i8*** @qword_140007018, align 8
  %elem0 = load i8*, i8** @qword_140007010, align 8
  %call_6A0 = call i32 @sub_1400026A0(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %r9d, i32* %var_4C)
  %neg2 = icmp slt i32 %call_6A0, 0
  br i1 %neg2, label %err_path, label %alloc_list

alloc_list:
  %n = load i32, i32* @dword_140007020, align 4
  %n_sext = sext i32 %n to i64
  %n_plus1 = add i64 %n_sext, 1
  %bytes = shl i64 %n_plus1, 3
  %buf = call i8* @sub_1400027F8(i64 %bytes)
  %r13 = ptrtoint i8* %buf to i64
  %buf_isnull = icmp eq i8* %buf, null
  %newarr0 = inttoptr i64 %r13 to i8**
  br i1 %buf_isnull, label %err_path, label %maybe_loop

maybe_loop:
  %n0 = load i32, i32* @dword_140007020, align 4
  %n0_sext = sext i32 %n0 to i64
  %n0_le = icmp sle i64 %n0_sext, 0
  br i1 %n0_le, label %set_terminator, label %loop_prep

loop_prep:
  %oldarr = load i8**, i8*** @qword_140007018, align 8
  %i.init = add i64 0, 1
  br label %loop

loop:
  %i = phi i64 [ %i.init, %loop_prep ], [ %i.next, %after_copy ]
  %idxm1 = add i64 %i, -1
  %src.gep = getelementptr i8*, i8** %oldarr, i64 %idxm1
  %src = load i8*, i8** %src.gep, align 8
  %len = call i64 @sub_140002700(i8* %src)
  %len1 = add i64 %len, 1
  %dst = call i8* @sub_1400027F8(i64 %len1)
  %dst.slot = getelementptr i8*, i8** %newarr0, i64 %idxm1
  store i8* %dst, i8** %dst.slot, align 8
  %dst.isnull = icmp eq i8* %dst, null
  br i1 %dst.isnull, label %err_path, label %do_copy

do_copy:
  %dst.cast = bitcast i8* %dst to i8*
  %lenptr = inttoptr i64 %len1 to i8*
  call void @sub_1400027B8(i8* %dst.cast, i8* %src, i8* %lenptr)
  %ncur = load i32, i32* @dword_140007020, align 4
  %ncur.sext = sext i32 %ncur to i64
  %cmpend = icmp eq i64 %ncur.sext, %i
  br i1 %cmpend, label %last_slot, label %after_copy

after_copy:
  %i.next = add i64 %i, 1
  br label %loop

last_slot:
  %last.ptr = getelementptr i8*, i8** %newarr0, i64 %ncur.sext
  br label %set_terminator

set_terminator:
  %term.slot = phi i8** [ %last.ptr, %last_slot ], [ %newarr0, %maybe_loop ]
  store i8* null, i8** %term.slot, align 8
  %p4A0 = load i8*, i8** @off_1400044A0, align 8
  %p490 = load i8*, i8** @off_140004490, align 8
  store i8** %newarr0, i8*** @qword_140007018, align 8
  call void @sub_140002780(i8* %p490, i8* %p4A0)
  call void @sub_140001520()
  store i32 2, i32* %statepp, align 4
  br label %post1084

after_state_nonzero:
  store i32 1, i32* @dword_140007004, align 4
  br label %post1084

post1084:
  %owned_is_zero = icmp eq i32 %ownedflag, 0
  br i1 %owned_is_zero, label %unlock_then, label %goto_post108D

unlock_then:
  %oldx = atomicrmw xchg i64* %lockpp.addr, i64 0 seq_cst
  br label %goto_post108D

goto_post108D:
  %p3F0p = load i8**, i8*** @off_1400043F0, align 8
  %p3F0 = load i8*, i8** %p3F0p, align 8
  %p3F0_nz = icmp ne i8* %p3F0, null
  br i1 %p3F0_nz, label %call_p3F0, label %after_p3F0

call_p3F0:
  %callee3 = bitcast i8* %p3F0 to void (i32, i32, i32)*
  call void %callee3(i32 0, i32 2, i32 0)
  br label %after_p3F0

after_p3F0:
  %slot = call i8** @sub_140002660()
  %val_q = load i8*, i8** @qword_140007010, align 8
  store i8* %val_q, i8** %slot, align 8
  %arrp = load i8**, i8*** @qword_140007018, align 8
  %cnt = load i32, i32* @dword_140007020, align 4
  call void @sub_140002880(i32 %cnt, i8** %arrp, i8* %val_q)
  %flag = load i32, i32* @dword_140007008, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %call_27A0_from_eax, label %check_7004

call_27A0_from_eax:
  %eaxv = load i32, i32* %retv, align 4
  call void @sub_1400027A0(i32 %eaxv)
  %rv2 = load i32, i32* %retv, align 4
  ret i32 %rv2

check_7004:
  %v7004 = load i32, i32* @dword_140007004, align 4
  %is_zero_7004 = icmp eq i32 %v7004, 0
  br i1 %is_zero_7004, label %flush_then_ret, label %final_ret

flush_then_ret:
  %cur = load i32, i32* %retv, align 4
  store i32 %cur, i32* %retv, align 4
  call void @sub_140002750()
  %rv3 = load i32, i32* %retv, align 4
  ret i32 %rv3

final_ret:
  %rv4 = load i32, i32* %retv, align 4
  ret i32 %rv4

err_path:
  %e = call i32 @sub_140002670(i32 8)
  store i32 %e, i32* %retv, align 4
  call void @sub_140002750()
  %rv5 = load i32, i32* %retv, align 4
  ret i32 %rv5
}