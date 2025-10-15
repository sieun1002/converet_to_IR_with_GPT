; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = dso_local global i32 0, align 4
@qword_1400070E0 = dso_local global i8* null, align 8
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

declare dso_local void @sub_1400024E0()
declare dso_local void @sub_140002240()
declare dso_local void @sub_140002BB0(i8*)
declare dso_local void @sub_1403DDA29(i8*)
declare dso_local i32 @sub_1400E06D5(i8*)

define dso_local i32 @sub_1400023D0(i8* %rcx, i32 %edx) {
entry:
  %cmp2 = icmp eq i32 %edx, 2
  br i1 %cmp2, label %case2, label %not2

case2:
  call void @sub_1400024E0()
  ret i32 1

not2:
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2block, label %le2block

gt2block:
  %is3 = icmp eq i32 %edx, 3
  br i1 %is3, label %case3, label %ret1

case3:
  %g3 = load i32, i32* @dword_1400070E8, align 4
  %g3is0 = icmp eq i32 %g3, 0
  br i1 %g3is0, label %ret1, label %call2240_then_L420

call2240_then_L420:
  call void @sub_140002240()
  br label %L420

le2block:
  %is0 = icmp eq i32 %edx, 0
  br i1 %is0, label %L420, label %case1

case1:
  %g1 = load i32, i32* @dword_1400070E8, align 4
  %g1zero = icmp eq i32 %g1, 0
  br i1 %g1zero, label %L4C0, label %set1_ret

set1_ret:
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

L420:
  %gA = load i32, i32* @dword_1400070E8, align 4
  %gAnz = icmp ne i32 %gA, 0
  br i1 %gAnz, label %fromL420_call2240, label %check1

fromL420_call2240:
  call void @sub_140002240()
  br label %L4C0

check1:
  %gB = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %gB, 1
  br i1 %is1, label %cleanup, label %ret1

cleanup:
  %cur0 = load i8*, i8** @qword_1400070E0, align 8
  br label %loop

loop:
  %cur = phi i8* [ %cur0, %cleanup ], [ %next, %process ]
  %isnull = icmp eq i8* %cur, null
  br i1 %isnull, label %afterloop, label %process

process:
  %nextaddr = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextaddr to i8**
  %next = load i8*, i8** %nextptr, align 8
  call void @sub_140002BB0(i8* %cur)
  br label %loop

afterloop:
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %p100 = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i32 0, i32 0
  call void @sub_1403DDA29(i8* %p100)
  ret i32 1

L4C0:
  %p100b = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i32 0, i32 0
  %call = call i32 @sub_1400E06D5(i8* %p100b)
  ret i32 1

ret1:
  ret i32 1
}