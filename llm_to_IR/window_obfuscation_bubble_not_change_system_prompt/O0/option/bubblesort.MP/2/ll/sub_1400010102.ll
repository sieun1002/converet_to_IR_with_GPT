; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002660()
declare void @sub_140002880(i64*, i64)
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare void @sub_140002778(i32)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i64*, i64*, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027B8(i8*, i8*, i64)
declare i32 @sub_140002670(i32)
declare void @sub_140002750()
declare void @sub_1400027D0(i32)
declare void @sub_140001CA0(i8*)
declare void @sub_1400018D0()
declare void @sub_140001520()
declare void @sub_140002780(i8*, i8*)
declare void @sub_1400027A0(i32)
declare void @sub_140001600()
declare void @sub_140001CB0()
declare void @nullsub_1()

@off_140004470 = external global i64*
@qword_140008280 = external global void (i32)*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8**
@qword_140007010 = external global i64
@qword_140007018 = external global i64
@dword_140007020 = external global i32
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
@qword_140008278 = external global i64 (i8*)*
@off_140004460 = external global i64*

define i32 @sub_140001010() {
entry:
  %var_5C = alloca i32, align 4
  %var_4C = alloca i32, align 4

  %teb = call i64 asm inteldialect "mov $0, qword ptr gs:[0x30]", "=r"()
  %teb.p = inttoptr i64 %teb to i8*
  %p8 = getelementptr i8, i8* %teb.p, i64 8
  %p8.q = bitcast i8* %p8 to i64*
  %rsi_val = load i64, i64* %p8.q, align 8

  %lock_ptr_ptr = load i64*, i64** @off_140004470, align 8
  %sleep_fp = load void (i32)*, void (i32)** @qword_140008280, align 8

  br label %lock_try

lock_try:
  %cmpx_old_succ = cmpxchg i64* %lock_ptr_ptr, i64 0, i64 %rsi_val seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx_old_succ, 0
  %succ = extractvalue { i64, i1 } %cmpx_old_succ, 1
  br i1 %succ, label %after_lock, label %lock_fail

lock_fail:
  %reent = icmp eq i64 %old, %rsi_val
  br i1 %reent, label %after_lock_reent, label %sleep_and_retry

sleep_and_retry:
  call void %sleep_fp(i32 1000)
  br label %lock_try

after_lock:
  br label %after_lock_with_flag

after_lock_reent:
  br label %after_lock_with_flag

after_lock_with_flag:
  %r14_is_one = phi i1 [ false, %after_lock ], [ true, %after_lock_reent ]

  %rbp_ptr = load i32*, i32** @off_140004480, align 8
  %state0 = load i32, i32* %rbp_ptr, align 4
  %state_is_1 = icmp eq i32 %state0, 1
  br i1 %state_is_1, label %loc_3C8, label %state_test_zero

loc_3C8:
  %ret_670_31 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %ret_670_31)
  unreachable

state_test_zero:
  %state1 = load i32, i32* %rbp_ptr, align 4
  %is_zero = icmp eq i32 %state1, 0
  br i1 %is_zero, label %loc_110, label %normal_path

normal_path:
  store i32 1, i32* @dword_140007004, align 4
  br label %test_r14

loc_110:
  store i32 1, i32* %rbp_ptr, align 4
  call void @sub_1400018D0()

  %regfp_ptr = load i64 (i8*)*, i64 (i8*)** @qword_140008278, align 8
  %cb = bitcast void ()* @sub_140001CB0 to i8*
  %regret = call i64 %regfp_ptr(i8* %cb)
  %dst64p = load i64*, i64** @off_140004460, align 8
  store i64 %regret, i64* %dst64p, align 8
  %nullfp = bitcast void ()* @nullsub_1 to i8*
  call void @sub_140002790(i8* %nullfp)

  call void @sub_140002120()

  %p430 = load i32*, i32** @off_140004430, align 8
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440, align 8
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450, align 8
  store i32 1, i32* %p450, align 4

  %base = load i8*, i8** @off_1400043C0, align 8
  %mz.ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz.ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %loc_1C0_pre0

check_pe:
  %e_lfanew.p = getelementptr i8, i8* %base, i64 60
  %e_lfanew.pi = bitcast i8* %e_lfanew.p to i32*
  %e_lfanew = load i32, i32* %e_lfanew.pi, align 4
  %e_lfanew.ext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base, i64 %e_lfanew.ext
  %pe.sig.p = bitcast i8* %pehdr to i32*
  %pe.sig = load i32, i32* %pe.sig.p, align 4
  %is_pe = icmp eq i32 %pe.sig, 17744
  br i1 %is_pe, label %check_optmagic, label %loc_1C0_pre0

check_optmagic:
  %opt.ptr = getelementptr i8, i8* %pehdr, i64 24
  %opt.pw = bitcast i8* %opt.ptr to i16*
  %opt.magic = load i16, i16* %opt.pw, align 2
  %is_pe32 = icmp eq i16 %opt.magic, 267
  br i1 %is_pe32, label %path_3AA, label %check_peplus

check_peplus:
  %is_peplus = icmp eq i16 %opt.magic, 523
  br i1 %is_peplus, label %pe64_check, label %loc_1C0_pre0

pe64_check:
  %sz.ptr = getelementptr i8, i8* %pehdr, i64 132
  %sz.p = bitcast i8* %sz.ptr to i32*
  %sz = load i32, i32* %sz.p, align 4
  %szok = icmp ugt i32 %sz, 14
  br i1 %szok, label %pe64_read, label %loc_1C0_pre0

pe64_read:
  %fld.ptr = getelementptr i8, i8* %pehdr, i64 248
  %fld.p = bitcast i8* %fld.ptr to i32*
  %fld = load i32, i32* %fld.p, align 4
  %nz = icmp ne i32 %fld, 0
  %ecx_val64 = zext i1 %nz to i32
  br label %loc_1C0

path_3AA:
  %sz2.ptr = getelementptr i8, i8* %pehdr, i64 116
  %sz2.p = bitcast i8* %sz2.ptr to i32*
  %sz2 = load i32, i32* %sz2.p, align 4
  %sz2ok = icmp ugt i32 %sz2, 14
  br i1 %sz2ok, label %pe32_read, label %loc_1C0_pre0

pe32_read:
  %fld2.ptr = getelementptr i8, i8* %pehdr, i64 232
  %fld2.p = bitcast i8* %fld2.ptr to i32*
  %fld2 = load i32, i32* %fld2.p, align 4
  %nz2 = icmp ne i32 %fld2, 0
  %ecx_val32 = zext i1 %nz2 to i32
  br label %loc_1C0

loc_1C0_pre0:
  br label %loc_1C0

loc_1C0:
  %ecx_final = phi i32 [ 0, %loc_1C0_pre0 ], [ %ecx_val64, %pe64_read ], [ %ecx_val32, %pe32_read ]
  %p420 = load i32*, i32** @off_140004420, align 8
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %r8d_load = load i32, i32* %p420, align 4
  %r8d_nz = icmp ne i32 %r8d_load, 0
  br i1 %r8d_nz, label %loc_1338, label %loc_1D9

loc_1338:
  call void @sub_140002778(i32 2)
  br label %loc_1E3

loc_1D9:
  call void @sub_140002778(i32 1)
  br label %loc_1E3

loc_1E3:
  %ret720 = call i32* @sub_140002720()
  %p4F0 = load i32*, i32** @off_1400044F0, align 8
  %val4F0 = load i32, i32* %p4F0, align 4
  store i32 %val4F0, i32* %ret720, align 4

  %ret718 = call i32* @sub_140002718()
  %p4D0 = load i32*, i32** @off_1400044D0, align 8
  %val4D0 = load i32, i32* %p4D0, align 4
  store i32 %val4D0, i32* %ret718, align 4

  %st = call i32 @sub_140001540()
  %stneg = icmp slt i32 %st, 0
  br i1 %stneg, label %loc_301, label %loc_210

loc_210:
  %p3A0 = load i32*, i32** @off_1400043A0, align 8
  %val3A0 = load i32, i32* %p3A0, align 4
  %is1 = icmp eq i32 %val3A0, 1
  br i1 %is1, label %loc_399, label %loc_220

loc_399:
  %fp600 = bitcast void ()* @sub_140001600 to i8*
  call void @sub_140001CA0(i8* %fp600)
  br label %loc_220

loc_220:
  %p400 = load i32*, i32** @off_140004400, align 8
  %val400 = load i32, i32* %p400, align 4
  %is_m1 = icmp eq i32 %val400, -1
  br i1 %is_m1, label %loc_138A, label %loc_230

loc_138A:
  call void @sub_1400027D0(i32 -1)
  br label %loc_230

loc_230:
  %argRdx = load i8*, i8** @off_1400044C0, align 8
  %argRcx = load i8*, i8** @off_1400044B0, align 8
  %ret788 = call i32 @sub_140002788(i8* %argRcx, i8* %argRdx)
  %ret788_nz = icmp ne i32 %ret788, 0
  br i1 %ret788_nz, label %loc_1380, label %loc_24B

loc_1380:
  br label %ret_bb_ff

loc_24B:
  %p520 = load i32*, i32** @off_140004520, align 8
  %val520 = load i32, i32* %p520, align 4
  store i32 %val520, i32* %var_4C, align 4

  %p4E0 = load i32*, i32** @off_1400044E0, align 8
  %val4E0 = load i32, i32* %p4E0, align 4

  %addr_q7010 = getelementptr i64, i64* @qword_140007010, i64 0
  %addr_q7018 = getelementptr i64, i64* @qword_140007018, i64 0
  %addr_d7020 = getelementptr i32, i32* @dword_140007020, i64 0

  %ret6A0 = call i32 @sub_1400026A0(i32* %addr_d7020, i64* %addr_q7018, i64* %addr_q7010, i32 %val4E0, i32* %var_4C)
  %ret6A0_neg = icmp slt i32 %ret6A0, 0
  br i1 %ret6A0_neg, label %loc_301, label %loc_28A

loc_28A:
  %cnt = load i32, i32* @dword_140007020, align 4
  %cnt64 = sext i32 %cnt to i64
  %cntp1 = add i64 %cnt64, 1
  %bytes = shl i64 %cntp1, 3
  %arr_mem = call i8* @sub_1400027F8(i64 %bytes)
  %r13 = bitcast i8* %arr_mem to i8**
  %arr_is_null = icmp eq i8** %r13, null
  br i1 %arr_is_null, label %loc_301, label %loc_2AA

loc_2AA:
  %nonpos = icmp sle i32 %cnt, 0
  br i1 %nonpos, label %loc_34C, label %loc_2B3

loc_2B3:
  %src_arr_i64 = load i64, i64* @qword_140007018, align 8
  %src_arr = inttoptr i64 %src_arr_i64 to i8**
  br label %loop_copy

loop_copy:
  %i = phi i64 [ 1, %loc_2B3 ], [ %i.next, %loop_iter ]
  %idx0 = add i64 %i, -1
  %src.ptr.slot = getelementptr i8*, i8** %src_arr, i64 %idx0
  %src.ptr = load i8*, i8** %src.ptr.slot, align 8
  %len = call i64 @sub_140002700(i8* %src.ptr)
  %len1 = add i64 %len, 1
  %dest = call i8* @sub_1400027F8(i64 %len1)
  %dstslot = getelementptr i8*, i8** %r13, i64 %idx0
  store i8* %dest, i8** %dstslot, align 8
  %dest_is_null = icmp eq i8* %dest, null
  br i1 %dest_is_null, label %loc_301, label %loop_copy_cont

loop_copy_cont:
  call void @sub_1400027B8(i8* %dest, i8* %src.ptr, i64 %len1)
  %i.eq.cnt = icmp eq i64 %cnt64, %i
  br i1 %i.eq.cnt, label %loc_1347, label %loop_iter

loop_iter:
  %i.next = add i64 %i, 1
  br label %loop_copy

loc_1347:
  %end.slot = getelementptr i8*, i8** %r13, i64 %cnt64
  br label %loc_34C

loc_34C:
  %endptr = phi i8** [ %end.slot, %loc_1347 ], [ %r13, %loc_2AA ]
  store i8* null, i8** %endptr, align 8

  %argA = load i8*, i8** @off_1400044A0, align 8
  %arg9 = load i8*, i8** @off_140004490, align 8
  %r13_i64 = ptrtoint i8** %r13 to i64
  store i64 %r13_i64, i64* @qword_140007018, align 8

  call void @sub_140002780(i8* %arg9, i8* %argA)
  call void @sub_140001520()

  store i32 2, i32* %rbp_ptr, align 4
  br label %test_r14

loc_301:
  %tmp_err = call i32 @sub_140002670(i32 8)
  br label %loc_310

loc_310:
  %val_for_310 = phi i32 [ %tmp_err, %loc_301 ], [ %eax_after64, %loc_0DF_to_310 ]
  store i32 %val_for_310, i32* %var_5C, align 4
  call void @sub_140002750()
  %ret_from_310 = load i32, i32* %var_5C, align 4
  br label %ret_bb

test_r14:
  br i1 %r14_is_one, label %post_release, label %release_lock

release_lock:
  atomicrmw xchg i64* %lock_ptr_ptr, i64 0 seq_cst
  br label %post_release

post_release:
  %pfpp = load i8**, i8*** @off_1400043F0, align 8
  %pf = load i8*, i8** %pfpp, align 8
  %has_pf = icmp ne i8* %pf, null
  br i1 %has_pf, label %call_cb, label %after_cb

call_cb:
  %cbfp = bitcast i8* %pf to void (i64, i32, i64)*
  call void %cbfp(i64 0, i32 2, i64 0)
  br label %after_cb

after_cb:
  %p = call i64* @sub_140002660()
  %p_i = ptrtoint i64* %p to i64
  %eax_after64 = trunc i64 %p_i to i32
  %v7010 = load i64, i64* @qword_140007010, align 8
  store i64 %v7010, i64* %p, align 8
  %v7018 = load i64, i64* @qword_140007018, align 8
  call void @sub_140002880(i64* %p, i64 %v7018)

  %d7008 = load i32, i32* @dword_140007008, align 4
  %d7008_zero = icmp eq i32 %d7008, 0
  br i1 %d7008_zero, label %loc_3D2, label %loc_0D7

loc_3D2:
  call void @sub_1400027A0(i32 %eax_after64)
  unreachable

loc_0D7:
  %d7004 = load i32, i32* @dword_140007004, align 4
  %d7004_zero = icmp eq i32 %d7004, 0
  br i1 %d7004_zero, label %loc_0DF_to_310, label %ret_main

loc_0DF_to_310:
  br label %loc_310

ret_main:
  br label %ret_bb_with_eax_after

ret_bb_with_eax_after:
  br label %ret_bb

ret_bb_ff:
  br label %ret_bb

ret_bb:
  %retv = phi i32 [ %ret_from_310, %loc_310 ], [ %eax_after64, %ret_bb_with_eax_after ], [ 255, %ret_bb_ff ]
  ret i32 %retv
}