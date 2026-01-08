; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002790()
declare void @sub_140002120()
declare void @sub_1400018D0()
declare void @sub_140001520()
declare void @sub_140001CA0(void ()*)
declare void @sub_140002778(i32)
declare void @sub_1400027D0(i32)
declare void @sub_140002750()
declare void @sub_140002780(i8**, i8**)
declare void @sub_1400027B8(i8*, i8*, i64)
declare void @sub_1400027A0(i32) noreturn
declare i32 @sub_140001540()
declare i32 @sub_140002788(i32*, i32*)
declare i32 @sub_1400026A0(i32*, i8***, i8**, i32, i32*)
declare i32 @sub_140002670(i32)
declare i32 @sub_140002880(i32, i8*)
declare i64 @sub_140002700(i8*)
declare i8* @sub_1400027F8(i64)
declare i32* @sub_140002720()
declare i32* @sub_140002718()
declare i8** @sub_140002660()

declare void () @nullsub_3()
declare void () @sub_140001600()
declare void () @sub_140001CB0()

@off_140004470 = external global i64*
@qword_140008280 = external global void (i32)*
@qword_140008278 = external global i8* (i8*)*
@off_140004480 = external global i32*
@off_1400043F0 = external global i8**
@off_1400043C0 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_140004420 = external global i32*
@off_1400043A0 = external global i32*
@off_140004400 = external global i32*
@off_1400044C0 = external global i32*
@off_1400044B0 = external global i32*
@off_140004520 = external global i32*
@off_1400044E0 = external global i32*
@off_140004460 = external global i8**
@off_1400044F0 = external global i32*
@off_1400044D0 = external global i32*
@off_1400044A0 = external global i8**
@off_140004490 = external global i8**

@qword_140007010 = external global i8*
@qword_140007018 = external global i8**
@dword_140007020 = external global i32
@dword_140007008 = external global i32
@dword_140007004 = external global i32

define i32 @sub_140001010() {
entry:
  %var5C = alloca i32, align 4
  %var4C = alloca i32, align 4
  %teb = call i64 asm sideeffect "mov $0, qword ptr gs:[0x30]", "=r"()
  %teb.ptr = inttoptr i64 %teb to i8*
  %teb.plus8 = getelementptr i8, i8* %teb.ptr, i64 8
  %thr.ptr = bitcast i8* %teb.plus8 to i64*
  %thr = load i64, i64* %thr.ptr, align 8
  %lock.addr.ptr = load i64*, i64** @off_140004470
  %sleepfp = load void (i32)*, void (i32)** @qword_140008280
  br label %try_lock

try_lock:                                         ; 0x140001050
  %cmpx = cmpxchg i64* %lock.addr.ptr, i64 0, i64 %thr seq_cst seq_cst
  %old = extractvalue { i64, i1 } %cmpx, 0
  %success = extractvalue { i64, i1 } %cmpx, 1
  br i1 %success, label %lock_acquired, label %lock_failed

lock_failed:                                      ; 0x140001040
  %own = icmp eq i64 %old, %thr
  br i1 %own, label %owned_reentrant, label %sleep_and_retry

sleep_and_retry:                                  ; 0x140001049
  call void %sleepfp(i32 1000)
  br label %try_lock

owned_reentrant:                                  ; 0x140001100
  br label %after_lock

lock_acquired:
  br label %after_lock

after_lock:                                       ; 0x14000105C
  %reentrant = phi i1 [ false, %lock_acquired ], [ true, %owned_reentrant ]
  %state.ptr.ptr = load i32*, i32** @off_140004480
  %state = load i32, i32* %state.ptr.ptr, align 4
  %is1 = icmp eq i32 %state, 1
  br i1 %is1, label %L13C8, label %chk_zero

L13C8:                                            ; 0x1400013C8
  %e31 = call i32 @sub_140002670(i32 31)
  call void @sub_1400027A0(i32 %e31)
  unreachable

chk_zero:
  %is0 = icmp eq i32 %state, 0
  br i1 %is0, label %L1110, label %L107A

L1110:                                            ; 0x140001110
  store i32 1, i32* %state.ptr.ptr, align 4
  call void @sub_1400018D0()
  %fp2 = load i8* (i8*)*, i8* (i8*)** @qword_140008278
  %cb = bitcast void ()* @sub_140001CB0 to i8*
  %retcb = call i8* %fp2(i8* %cb)
  %p460 = load i8**, i8*** @off_140004460
  store i8* %retcb, i8** %p460, align 8
  call void @sub_140002790()
  call void @sub_140002120()
  %p430 = load i32*, i32** @off_140004430
  store i32 1, i32* %p430, align 4
  %p440 = load i32*, i32** @off_140004440
  store i32 1, i32* %p440, align 4
  %p450 = load i32*, i32** @off_140004450
  store i32 1, i32* %p450, align 4
  %img = load i8*, i8** @off_1400043C0
  %mzptr = bitcast i8* %img to i16*
  %mz = load i16, i16* %mzptr, align 2
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %store_ecx

check_pe:                                         ; 0x14000117B
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %img, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %ofs = load i32, i32* %e_lfanew.ptr, align 4
  %ofs64 = sext i32 %ofs to i64
  %nthdr = getelementptr i8, i8* %img, i64 %ofs64
  %sigptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sigptr, align 4
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %check_magic, label %store_ecx

check_magic:                                      ; 0x14000118A
  %magicptr.i8 = getelementptr i8, i8* %nthdr, i64 24
  %magicptr = bitcast i8* %magicptr.i8 to i16*
  %magic = load i16, i16* %magicptr, align 2
  %isPE32 = icmp eq i16 %magic, 267
  br i1 %isPE32, label %pe32_path, label %check_pe32plus

pe32_path:                                        ; 0x1400013AA
  %chkptr.i8 = getelementptr i8, i8* %nthdr, i64 116
  %chkptr = bitcast i8* %chkptr.i8 to i32*
  %chkval = load i32, i32* %chkptr, align 4
  %leq = icmp ule i32 %chkval, 14
  br i1 %leq, label %store_ecx, label %pe32_set

pe32_set:
  %fieldptr.i8 = getelementptr i8, i8* %nthdr, i64 232
  %fieldptr = bitcast i8* %fieldptr.i8 to i32*
  %field = load i32, i32* %fieldptr, align 4
  %nz = icmp ne i32 %field, 0
  %ecx_val1 = zext i1 %nz to i32
  br label %store_ecx_with

check_pe32plus:                                   ; 0x140001199
  %isPE32Plus = icmp eq i16 %magic, 523
  br i1 %isPE32Plus, label %pe32plus_checkfield, label %store_ecx

pe32plus_checkfield:                              ; 0x1400011A0
  %chk2ptr.i8 = getelementptr i8, i8* %nthdr, i64 132
  %chk2ptr = bitcast i8* %chk2ptr.i8 to i32*
  %chk2val = load i32, i32* %chk2ptr, align 4
  %leq2 = icmp ule i32 %chk2val, 14
  br i1 %leq2, label %store_ecx, label %pe32plus_set

pe32plus_set:
  %field2ptr.i8 = getelementptr i8, i8* %nthdr, i64 248
  %field2ptr = bitcast i8* %field2ptr.i8 to i32*
  %field2 = load i32, i32* %field2ptr, align 4
  %nz2 = icmp ne i32 %field2, 0
  %ecx_val2 = zext i1 %nz2 to i32
  br label %store_ecx_with

store_ecx_with:
  %ecx_final_from_set = phi i32 [ %ecx_val1, %pe32_set ], [ %ecx_val2, %pe32plus_set ]
  br label %after_pe

store_ecx:                                        ; 0x1400011C0
  br label %after_pe

after_pe:
  %ecx_final = phi i32 [ 0, %store_ecx ], [ %ecx_final_from_set, %store_ecx_with ]
  store i32 %ecx_final, i32* @dword_140007008, align 4
  %p4420 = load i32*, i32** @off_140004420
  %r8d = load i32, i32* %p4420, align 4
  %r8nz = icmp ne i32 %r8d, 0
  br i1 %r8nz, label %L1338, label %L1D9

L1338:                                            ; 0x140001338
  call void @sub_140002778(i32 2)
  br label %L1E3

L1D9:                                             ; 0x1400011D9
  call void @sub_140002778(i32 1)
  br label %L1E3

L1E3:                                             ; 0x1400011E3
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
  br i1 %neg, label %L1301, label %L1210

L1301:                                            ; 0x140001301
  %e8 = call i32 @sub_140002670(i32 8)
  br label %L1310_pre

L1210:                                            ; 0x140001210
  %p3A0 = load i32*, i32** @off_1400043A0
  %v3A0 = load i32, i32* %p3A0, align 4
  %is_one = icmp eq i32 %v3A0, 1
  br i1 %is_one, label %L1399, label %L1220

L1399:                                            ; 0x140001399
  call void @sub_140001CA0(void ()* @sub_140001600)
  br label %L1220

L1220:                                            ; 0x140001220
  %p400 = load i32*, i32** @off_140004400
  %v400 = load i32, i32* %p400, align 4
  %is_m1 = icmp eq i32 %v400, -1
  br i1 %is_m1, label %L138A, label %L1230

L138A:                                            ; 0x14000138A
  call void @sub_1400027D0(i32 -1)
  br label %L1230

L1230:                                            ; 0x140001230
  %p4C0 = load i32*, i32** @off_1400044C0
  %p4B0 = load i32*, i32** @off_1400044B0
  %e = call i32 @sub_140002788(i32* %p4B0, i32* %p4C0)
  %ne0 = icmp ne i32 %e, 0
  br i1 %ne0, label %L1380, label %L124B

L1380:                                            ; 0x140001380
  ret i32 255

L124B:                                            ; 0x14000124B
  %p520 = load i32*, i32** @off_140004520
  %ax = load i32, i32* %p520, align 4
  store i32 %ax, i32* %var4C, align 4
  %p4E0 = load i32*, i32** @off_1400044E0
  %r9v = load i32, i32* %p4E0, align 4
  %ret6A0 = call i32 @sub_1400026A0(i32* @dword_140007020, i8*** @qword_140007018, i8** @qword_140007010, i32 %r9v, i32* %var4C)
  %neg6 = icmp slt i32 %ret6A0, 0
  br i1 %neg6, label %L1301, label %L28A

L28A:                                             ; 0x14000128A
  %cnt = load i32, i32* @dword_140007020, align 4
  %r12_64 = sext i32 %cnt to i64
  %plus1 = add i64 %r12_64, 1
  %allocsz = shl i64 %plus1, 3
  %arrmem = call i8* @sub_1400027F8(i64 %allocsz)
  %isnull = icmp eq i8* %arrmem, null
  br i1 %isnull, label %L1301, label %L2AA

L2AA:                                             ; 0x1400012AA
  %le = icmp sle i32 %cnt, 0
  br i1 %le, label %L134C, label %L2B3

L2B3:                                             ; 0x1400012B3
  %r15 = load i8**, i8*** @qword_140007018
  br label %L2E1

L2E1:                                             ; 0x1400012E1
  %i = phi i64 [ 1, %L2B3 ], [ %i.next, %L2C8 ]
  %idx = add i64 %i, -1
  %srcptrptr = getelementptr i8*, i8** %r15, i64 %idx
  %src = load i8*, i8** %srcptrptr, align 8
  %len = call i64 @sub_140002700(i8* %src)
  %rdi = add i64 %len, 1
  %dest = call i8* @sub_1400027F8(i64 %rdi)
  %arrptr = bitcast i8* %arrmem to i8**
  %dstslot = getelementptr i8*, i8** %arrptr, i64 %idx
  store i8* %dest, i8** %dstslot, align 8
  %notnull = icmp ne i8* %dest, null
  br i1 %notnull, label %L2C8, label %L1301

L2C8:                                             ; 0x1400012C8
  %src2ptr = getelementptr i8*, i8** %r15, i64 %idx
  %src2 = load i8*, i8** %src2ptr, align 8
  call void @sub_1400027B8(i8* %dest, i8* %src2, i64 %rdi)
  %done = icmp eq i64 %r12_64, %i
  br i1 %done, label %L1347, label %L2DD

L2DD:                                             ; 0x1400012DD
  %i.next = add i64 %i, 1
  br label %L2E1

L1347:                                            ; 0x140001347
  %arrptr2 = bitcast i8* %arrmem to i8**
  %slotend = getelementptr i8*, i8** %arrptr2, i64 %r12_64
  br label %L134C

L134C:                                            ; 0x14000134C
  %arrptr3 = bitcast i8* %arrmem to i8**
  %slotptr = phi i8** [ %slotend, %L1347 ], [ %arrptr3, %L2AA ]
  store i8* null, i8** %slotptr, align 8
  %p4A0 = load i8**, i8*** @off_1400044A0
  %p490 = load i8**, i8*** @off_140004490
  %arr_as_i8pp = bitcast i8* %arrmem to i8**
  store i8** %arr_as_i8pp, i8*** @qword_140007018, align 8
  call void @sub_140002780(i8** %p490, i8** %p4A0)
  call void @sub_140001520()
  store i32 2, i32* %state.ptr.ptr, align 4
  br label %L1084

L107A:                                            ; 0x14000107A
  store i32 1, i32* @dword_140007004, align 4
  br label %L1084

L1084:                                            ; 0x140001084
  br i1 %reentrant, label %L108D, label %L1328

L1328:                                            ; 0x140001328
  %lock.addr.ptr.rel = load i64*, i64** @off_140004470
  %oldxchg = atomicrmw xchg i64* %lock.addr.ptr.rel, i64 0 seq_cst
  br label %L108D

L108D:                                            ; 0x14000108D
  %p3F0 = load i8**, i8*** @off_1400043F0
  %cbf = load i8*, i8** %p3F0, align 8
  %hascb = icmp ne i8* %cbf, null
  br i1 %hascb, label %L109C, label %L10A8

L109C:                                            ; 0x14000109C
  %fp3 = bitcast i8* %cbf to void (i32, i32, i32)*
  call void %fp3(i32 0, i32 2, i32 0)
  br label %L10A8

L10A8:                                            ; 0x1400010A8
  %dstptr = call i8** @sub_140002660()
  %q7010 = load i8*, i8** @qword_140007010, align 8
  store i8* %q7010, i8** %dstptr, align 8
  %cnt2 = load i32, i32* @dword_140007020, align 4
  %arrcurr = load i8**, i8*** @qword_140007018
  %res2880 = call i32 @sub_140002880(i32 %cnt2, i8* bitcast (i8** %arrcurr to i8*))
  %flag = load i32, i32* @dword_140007008, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %L13D2, label %L10D7

L13D2:                                            ; 0x1400013D2
  call void @sub_1400027A0(i32 %res2880)
  unreachable

L10D7:                                            ; 0x1400010D7
  %f2 = load i32, i32* @dword_140007004, align 4
  %isZero = icmp eq i32 %f2, 0
  br i1 %isZero, label %L1310_pre, label %ret_epilogue

L1310_pre:                                        ; 0x140001310
  store i32 %res2880, i32* %var5C, align 4
  call void @sub_140002750()
  %restored = load i32, i32* %var5C, align 4
  ret i32 %restored

ret_epilogue:                                     ; 0x1400010E5 path
  ret i32 %res2880
}