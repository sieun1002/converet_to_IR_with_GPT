target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i64
@unk_140007100 = external global i8

declare void @sub_140001E80()
declare void @sub_140002120()
declare void @"loc_1400027ED+3"(i8*)
declare void @"loc_140015626"(i8*)
declare void @"loc_1405DBE11+2"(i8*)

define i32 @sub_140002010(i32 %ecx, i32 %edx) {
entry:
  %saved = alloca i8*, align 8
  %cmp_eq2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq2, label %bb_0D8, label %bb_after_cmp

bb_after_cmp:
  %cmp_ugt2 = icmp ugt i32 %edx, 2
  br i1 %cmp_ugt2, label %bb_048, label %bb_01f

bb_01f:
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %bb_060, label %bb_023

bb_023:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %t1 = icmp eq i32 %g1, 0
  br i1 %t1, label %bb_100, label %bb_031

bb_031:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %bb_03b

bb_03b:
  ret i32 1

bb_048:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %bb_04d, label %bb_03b

bb_04d:
  %g2 = load i32, i32* @dword_1400070E8, align 4
  %is_zero2 = icmp eq i32 %g2, 0
  br i1 %is_zero2, label %bb_03b, label %bb_057

bb_057:
  call void @sub_140001E80()
  br label %bb_060

bb_060:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %test_nz = icmp ne i32 %g3, 0
  br i1 %test_nz, label %bb_0F0, label %bb_06e

bb_0F0:
  call void @sub_140001E80()
  br label %bb_100

bb_06e:
  %g4 = load i32, i32* @dword_1400070E8, align 4
  %cmp1 = icmp eq i32 %g4, 1
  br i1 %cmp1, label %bb_079, label %bb_03b

bb_079:
  %p64 = load i64, i64* @qword_1400070E0, align 8
  %p_is_zero = icmp eq i64 %p64, 0
  br i1 %p_is_zero, label %bb_0ab, label %bb_090

bb_090:
  %cur0 = inttoptr i64 %p64 to i8*
  br label %bb_iter

bb_iter:
  %cur = phi i8* [ %cur0, %bb_090 ], [ %n1, %bb_iter ]
  %gep16 = getelementptr i8, i8* %cur, i64 16
  %next_ptr64_p = bitcast i8* %gep16 to i64*
  %next64 = load i64, i64* %next_ptr64_p, align 8
  %next = inttoptr i64 %next64 to i8*
  store i8* %next, i8** %saved, align 8
  call void @"loc_1400027ED+3"(i8* %cur)
  %n1 = load i8*, i8** %saved, align 8
  %cond = icmp ne i8* %n1, null
  br i1 %cond, label %bb_iter, label %bb_0ab

bb_0ab:
  store i64 0, i64* @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @"loc_1405DBE11+2"(i8* @unk_140007100)
  br label %bb_03b

bb_0D8:
  call void @sub_140002120()
  ret i32 1

bb_100:
  call void @"loc_140015626"(i8* @unk_140007100)
  br label %bb_031
}