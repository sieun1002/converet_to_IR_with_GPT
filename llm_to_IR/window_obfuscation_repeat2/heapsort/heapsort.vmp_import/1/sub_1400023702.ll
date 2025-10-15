source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global [0 x i8]

declare void @sub_140002480()
declare void @sub_1400021E0()
declare void @sub_140002B40(i8*)
declare void @sub_14001553E(i8*)
declare void @sub_140310D2E(i8*)

define i32 @sub_140002370(i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %not2

case2:
  call void @sub_140002480()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2, label %le2

gt2:
  %cmp3 = icmp eq i32 %edx, 3
  br i1 %cmp3, label %eq3, label %ret1

eq3:
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %iszero1 = icmp eq i32 %flag1, 0
  br i1 %iszero1, label %ret1, label %call21E0_from3

call21E0_from3:
  call void @sub_1400021E0()
  br label %ret1

le2:
  %isZeroEdx = icmp eq i32 %edx, 0
  br i1 %isZeroEdx, label %case0, label %case1

case1:
  %flag2 = load i32, i32* @dword_1400070E8, align 4
  %iszero2 = icmp eq i32 %flag2, 0
  br i1 %iszero2, label %loc460, label %setflag_ret

loc460:
  %unkptr1 = getelementptr [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_140310D2E(i8* %unkptr1)
  br label %setflag_ret

setflag_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

case0:
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %nonzero3 = icmp ne i32 %flag3, 0
  br i1 %nonzero3, label %loc450, label %after3ce

loc450:
  call void @sub_1400021E0()
  br label %after3ce

after3ce:
  %flag4 = load i32, i32* @dword_1400070E8, align 4
  %isOne = icmp eq i32 %flag4, 1
  br i1 %isOne, label %do_list, label %ret1

do_list:
  %head = load i8*, i8** @qword_1400070E0, align 8
  %headNull = icmp eq i8* %head, null
  br i1 %headNull, label %loc40b, label %loop

loop:
  %p = phi i8* [ %head, %do_list ], [ %next, %loop ]
  %p_plus_16 = getelementptr i8, i8* %p, i64 16
  %p_plus_16_ptr = bitcast i8* %p_plus_16 to i8**
  %next = load i8*, i8** %p_plus_16_ptr, align 8
  call void @sub_140002B40(i8* %p)
  %notnull = icmp ne i8* %next, null
  br i1 %notnull, label %loop, label %loc40b

loc40b:
  %unkptr2 = getelementptr [0 x i8], [0 x i8]* @unk_140007100, i64 0, i64 0
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @sub_14001553E(i8* %unkptr2)
  br label %ret1

ret1:
  ret i32 1
}