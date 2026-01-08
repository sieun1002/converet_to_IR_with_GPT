; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8** @sub_140002660()
declare void @sub_140002880(i32, i8**, i8*)
declare i32 @sub_140002670(i32)
declare void @sub_140002750()
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i32 @sub_140001540()
declare i32 @sub_140002788(i8*, i8*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i8* @sub_1400027F8(i64)
declare i64 @sub_140002700(i8*)
declare void @sub_1400027B8(i8*, i64, i8*)
declare void @sub_140002780(i8*, i8*)
declare void @sub_140001520()
declare void @sub_140002778(i32)
declare void @sub_1400027D0(i32)
declare void @sub_140001CA0(i8*)
declare void @sub_1400018D0()
declare void @sub_140002790(i8*)
declare void @sub_140002120()
declare void @sub_1400027A0(i32)

declare void @sub_140001CB0()
declare void @nullsub_1()
declare void @sub_140001600()

@off_140004470 = external global i64*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140008278 = external global i8*
@off_140004460 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@off_140004420 = external global i32*
@dword_140007008 = external global i32
@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
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

define i32 @sub_140001010() local_unnamed_addr {
entry:
  %teb = call i8* asm sideeffect "mov $0, qword ptr gs:[0x30]", "={rax},~{dirflag},~{fpsr},~{flags}"()
  %thrIdPtr = getelementptr i8, i8* %teb, i64 8
  %thrId = load i64, i64* %thrIdPtr, align 8
  %lockptr.addr = load i64*, i64** @off_140004470
  %sleepfp = load i8*, i8** @qword_140008280
  br label %attempt

attempt:                                          ; 0x140001050
  %cmp = cmpxchg i64* %lockptr.addr, i64 0, i64 %thrId monotonic monotonic
  %old = extractvalue { i64, i1 } %cmp, 0
  %succ = extractvalue { i64, i1 } %cmp, 1
  br i1 %succ, label %acq, label %fail

fail:                                             ; 0x140001040
  %own = icmp eq i64 %thrId, %old
  br i1 %own, label %ownlock, label %sleepb

sleepb:
  %sleepcast = bitcast i8* %sleepfp to void (i32)*
  call void %sleepcast(i32 1000)
  br label %attempt

ownlock:                                          ; 0x140001100
  br label %acq

acq:                                              ; 0x14000105C
  %r14 = phi i1 [ false, %attempt ], [ true, %ownlock ]
  %rbpaddr = load i32*, i32** @off_140004480
  %rbpval = load i32, i32* %rbpaddr, align 4
  %is1 = icmp eq i32 %rbpval, 1
  br i1 %is1, label %loc_13C8, label %contA

loc_13C8:                                         ; 0x1400013C8
  %call_1f = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %call_1f)
  unreachable

contA:
  %rbpval2 = load i32, i32* %rbpaddr, align 4
  %is0 = icmp eq i32 %rbpval2, 0
  br i1 %is0, label %loc_1110, label %after_setflag

loc_1110:                                         ; 0x140001110
  store i32 1, i32* %rbpaddr, align 4
  call void @sub_1400018D0()
  %fpinit.mem = load i8*, i8** @qword_140008278
  %fpinit = bitcast i8* %fpinit.mem to i8* (i8*)*
  %cb = call i8* %fpinit(i8* bitcast (void ()* @sub_140001CB0 to i8*))
  %storeaddr.mem = load i8*, i8** @off_140004460
  %storeaddr = bitcast i8* %storeaddr.mem to i8**
  store i8* %cb, i8** %storeaddr, align 8
  call void @sub_140002790(i8* bitcast (void ()* @nullsub_1 to i8*))
  call void @sub_140002120()
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450
  store i32 1, i32* %p450, align 4
  %base = load i8*, i8** @off_1400043C0
  %dos = bitcast i8* %base to i16*
  %mz = load i16, i16* %dos, align 2
  %ismz = icmp eq i16 %mz, 23117
  br i1 %ismz, label %mz_ok, label %pe_store

mz_ok:                                            ; 0x14000117B
  %e_lfanew.p = getelementptr i8, i8* %base, i64 60
  %e_lfanew = load i32, i32* bitcast (i8* %e_lfanew.p to i32*), align 4
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew64
  %sig = load i32, i32* bitcast (i8* %nt to i32*), align 4
  %ispe = icmp eq i32 %sig, 17744
  br i1 %ispe, label %nt_ok, label %pe_store

nt_ok:                                            ; 0x14000118A
  %optmagic.p = getelementptr i8, i8* %nt, i64 24
  %optmagic = load i16, i16* bitcast (i8* %optmagic.p to i16*), align 2
  %is32 = icmp eq i16 %optmagic, 267
  br i1 %is32, label %opt32, label %check64

check64:
  %is64 = icmp eq i16 %optmagic, 523
  br i1 %is64, label %opt64, label %pe_store

opt64:                                            ; 0x1400011A0
  %sizecfg.p = getelementptr i8, i8* %nt, i64 132
  %sizecfg = load i32, i32* bitcast (i8* %sizecfg.p to i32*), align 4
  %gtE = icmp ugt i32 %sizecfg, 14
  br i1 %gtE, label %opt64_have, label %pe_store

opt64_have:                                       ; 0x1400011A9
  %guard.p = getelementptr i8, i8* %nt, i64 248
  %guard = load i32, i32* bitcast (i8* %guard.p to i32*), align 4
  %nz = icmp ne i32 %guard, 0
  %ecx64 = zext i1 %nz to i32
  br label %pe_store_set

opt32:                                            ; 0x1400013AA
  %sizecfg32.p = getelementptr i8, i8* %nt, i64 116
  %sizecfg32 = load i32, i32* bitcast (i8* %sizecfg32.p to i32*), align 4
  %gtE32 = icmp ugt i32 %sizecfg32, 14
  br i1 %gtE32, label %opt32_have, label %pe_store

opt32_have:
  %guard32.p = getelementptr i8, i8* %nt, i64 232
  %guard32 = load i32, i32* bitcast (i8* %guard32.p to i32*), align 4
  %nz32 = icmp ne i32 %guard32, 0
  %ecx32 = zext i1 %nz32 to i32
  br label %pe_store_set

pe_store_set:
  %ecx_set = phi i32 [ %ecx64, %opt64_have ], [ %ecx32, %opt32_have ]
  br label %pe_store

pe_store:                                         ; 0x1400011C0
  %ecx_final = phi i32 [ 0, %loc_1110 ], [ 0, %mz_ok ], [ 0, %nt_ok ], [ 0, %check64 ], [ %ecx_set, %pe_store_set ], [ 0, %opt64 ], [ 0, %opt32 ]
  store i32 %ecx_final, i32* @dword_140007008
  %cfgaddr = load i32*, i32** @off_140004420
  %cfg = load i32, i32* %cfgaddr, align 4
  %cfgnz = icmp ne i32 %cfg, 0
  br i1 %cfgnz, label %loc_1338, label %loc_11D9

loc_1338:                                         ; 0x140001338
  call void @sub_140002778(i32 2)
  br label %loc_11E3

loc_11D9:                                         ; 0x1400011D9
  call void @sub_140002778(i32 1)
  %pA = call i32* @sub_140002720()
  %p4F0 = load i32*, i32** @off_1400044F0
  %v4F0 = load i32, i32* %p4F0, align 4
  store i32 %v4F0, i32* %pA, align 4
  %pB = call i32* @sub_140002718()
  %p4D0 = load i32*, i32** @off_1400044D0
  %v4D0 = load i32, i32* %p4D0, align 4
  store i32 %v4D0, i32* %pB, align 4
  %r = call i32 @sub_140001540()
  %neg = icmp slt i32 %r, 0
  br i1 %neg, label %loc_1301, label %cont2

loc_11E3:
  %r2 = call i32 @sub_140001540()
  %neg2 = icmp slt i32 %r2, 0
  br i1 %neg2, label %loc_1301, label %cont2

cont2:                                            ; 0x140001210
  %p3A0 = load i32*, i32** @off_1400043A0
  %v3A0 = load i32, i32* %p3A0, align 4
  %isOne = icmp eq i32 %v3A0, 1
  br i1 %isOne, label %loc_1399, label %cont3

loc_1399:                                         ; 0x140001399
  call void @sub_140001CA0(i8* bitcast (void ()* @sub_140001600 to i8*))
  br label %loc_1220

cont3:                                            ; 0x140001220
  %p400 = load i32*, i32** @off_140004400
  %v400 = load i32, i32* %p400, align 4
  %isneg1 = icmp eq i32 %v400, -1
  br i1 %isneg1, label %loc_138A, label %loc_1230

loc_138A:                                         ; 0x14000138A
  call void @sub_1400027D0(i32 -1)
  br label %loc_1230

loc_1220:
  br label %loc_1230

loc_1230:                                         ; 0x140001230
  %p4C0 = load i8*, i8** @off_1400044C0
  %p4B0 = load i8*, i8** @off_1400044B0
  %res788 = call i32 @sub_140002788(i8* %p4B0, i8* %p4C0)
  %nz788 = icmp ne i32 %res788, 0
  br i1 %nz788, label %loc_1380, label %cont4

loc_1380:                                         ; 0x140001380
  ret i32 255

cont4:                                            ; 0x14000124B
  %p520 = load i32*, i32** @off_140004520
  %v520 = load i32, i32* %p520, align 4
  %var_4C = alloca i32, align 4
  store i32 %v520, i32* %var_4C, align 4
  %p4E0 = load i32*, i32** @off_1400044E0
  %v4E0 = load i32, i32* %p4E0, align 4
  %pCount = getelementptr i32, i32* @dword_140007020, i64 0
  %pArrVar = bitcast i8** @qword_140007018 to i8***
  %pItemVar = getelementptr i8*, i8** @qword_140007010, i64 0
  %res6A0 = call i32 @sub_1400026A0(i32* %pCount, i8*** %pArrVar, i8** %pItemVar, i32 %v4E0, i32* %var_4C)
  %neg6A0 = icmp slt i32 %res6A0, 0
  br i1 %neg6A0, label %loc_1301, label %cont5

cont5:                                            ; 0x14000128A
  %count = load i32, i32* @dword_140007020, align 4
  %r12 = sext i32 %count to i64
  %add1 = add i64 %r12, 1
  %bytes = shl i64 %add1, 3
  %new = call i8* @sub_1400027F8(i64 %bytes)
  %r13 = bitcast i8* %new to i8**
  %isnull = icmp eq i8* %new, null
  br i1 %isnull, label %loc_1301, label %cont6

cont6:
  %endptr0 = getelementptr i8*, i8** %r13, i64 %r12
  %le0 = icmp sle i32 %count, 0
  br i1 %le0, label %loc_134C_pre, label %prepLoop

prepLoop:                                         ; 0x1400012BF
  %i = phi i64 [ 1, %cont6 ], [ %i.next, %loop_end ]
  %r15 = load i8**, i8*** %pArrVar
  %idx = add i64 %i, -1
  %srcptr = getelementptr i8*, i8** %r15, i64 %idx
  %src = load i8*, i8** %srcptr, align 8
  %len = call i64 @sub_140002700(i8* %src)
  %allocsz = add i64 %len, 1
  %dest = call i8* @sub_1400027F8(i64 %allocsz)
  %dstptr = getelementptr i8*, i8** %r13, i64 %idx
  store i8* %dest, i8** %dstptr, align 8
  %nullDst = icmp eq i8* %dest, null
  br i1 %nullDst, label %loc_1301, label %copydo

copydo:
  call void @sub_1400027B8(i8* %dest, i64 %allocsz, i8* %src)
  %endcmp = icmp eq i64 %r12, %i
  br i1 %endcmp, label %loc_1347, label %loop_end

loop_end:
  %i.next = add i64 %i, 1
  br label %prepLoop

loc_1347:                                         ; 0x140001347
  %endptr1 = getelementptr i8*, i8** %r13, i64 %r12
  store i8* null, i8** %endptr1, align 8
  br label %post_array

loc_134C_pre:                                     ; 0x14000134C
  store i8* null, i8** %endptr0, align 8
  br label %post_array

post_array:
  %rcxA = load i8*, i8** @off_140004490
  %rdxA = load i8*, i8** @off_1400044A0
  store i8** %r13, i8*** %pArrVar, align 8
  call void @sub_140002780(i8* %rcxA, i8* %rdxA)
  call void @sub_140001520()
  store i32 2, i32* %rbpaddr, align 4
  br label %test_r14

after_setflag:                                    ; 0x14000107A
  store i32 1, i32* @dword_140007004, align 4
  br label %test_r14

test_r14:                                         ; 0x140001084
  br i1 %r14, label %loc_108D, label %loc_1328

loc_1328:                                         ; 0x140001328
  %_ = atomicrmw xchg i64* %lockptr.addr, i64 0 monotonic
  br label %loc_108D

loc_108D:                                         ; 0x14000108D
  %p3F0.mem = load i8*, i8** @off_1400043F0
  %p3F0 = bitcast i8* %p3F0.mem to i8**
  %fp = load i8*, i8** %p3F0, align 8
  %hasfp = icmp ne i8* %fp, null
  br i1 %hasfp, label %call_fp, label %after_fp

call_fp:
  %fp3 = bitcast i8* %fp to void (i32, i32, i32)*
  call void %fp3(i32 0, i32 2, i32 0)
  br label %after_fp

after_fp:
  %slot = call i8** @sub_140002660()
  %r8v = load i8*, i8** @qword_140007010
  store i8* %r8v, i8** %slot, align 8
  %arr = load i8**, i8*** %pArrVar
  %cnt = load i32, i32* @dword_140007020, align 4
  call void @sub_140002880(i32 %cnt, i8** %arr, i8* %r8v)
  %g = load i32, i32* @dword_140007008, align 4
  %gz = icmp eq i32 %g, 0
  br i1 %gz, label %loc_13D2, label %check_flag

loc_13D2:                                         ; 0x1400013D2
  call void @sub_1400027A0(i32 0)
  unreachable

check_flag:                                       ; 0x1400010D7
  %flag = load i32, i32* @dword_140007004, align 4
  %fz = icmp eq i32 %flag, 0
  br i1 %fz, label %loc_1310_from108D, label %ret_default

loc_1301:                                         ; 0x140001301
  %res8 = call i32 @sub_140002670(i32 8)
  br label %loc_1310

loc_1310:                                         ; 0x140001310
  %var_5C = alloca i32, align 4
  store i32 %res8, i32* %var_5C, align 4
  call void @sub_140002750()
  %retv = load i32, i32* %var_5C, align 4
  ret i32 %retv

loc_1310_from108D:
  %var_5C_b = alloca i32, align 4
  store i32 0, i32* %var_5C_b, align 4
  call void @sub_140002750()
  %retv_b = load i32, i32* %var_5C_b, align 4
  ret i32 %retv_b

ret_default:
  ret i32 0
}