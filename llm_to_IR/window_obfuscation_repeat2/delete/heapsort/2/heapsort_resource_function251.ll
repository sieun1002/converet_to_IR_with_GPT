; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global i8* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare void @sub_140002240()
declare void @sub_1400024E0()
declare void @free(i8* noundef)
declare void @InitializeCriticalSection(i8* noundef)
declare void @DeleteCriticalSection(i8* noundef)

define dso_local i32 @sub_1400023D0(i64 %rcx, i32 %edx) {
entry:
  %cmp_edx_2 = icmp eq i32 %edx, 2
  br i1 %cmp_edx_2, label %case2, label %check_ja

case2:                                            ; edx == 2
  call void @sub_1400024E0()
  ret i32 1

check_ja:
  %edx_gt_2 = icmp ugt i32 %edx, 2
  br i1 %edx_gt_2, label %loc_140002408, label %loc_1400023DF

loc_1400023DF:                                    ; edx is 0 or 1
  %is_zero = icmp eq i32 %edx, 0
  br i1 %is_zero, label %loc_140002420, label %loc_1400023E3

loc_1400023E3:                                    ; edx == 1
  %valE8_1 = load i32, i32* @dword_1400070E8, align 4
  %isZero1 = icmp eq i32 %valE8_1, 0
  br i1 %isZero1, label %loc_1400024C0, label %loc_1400023F1

loc_1400024C0:                                    ; InitializeCriticalSection
  %critptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @InitializeCriticalSection(i8* %critptr)
  br label %loc_1400023F1

loc_1400023F1:
  store i32 1, i32* @dword_1400070E8, align 4
  br label %ret1

loc_140002408:
  %cmp_edx_3 = icmp eq i32 %edx, 3
  br i1 %cmp_edx_3, label %loc_14000240D, label %ret1

loc_14000240D:
  %valE8_2 = load i32, i32* @dword_1400070E8, align 4
  %isZero2 = icmp eq i32 %valE8_2, 0
  br i1 %isZero2, label %ret1, label %loc_140002417

loc_140002417:
  call void @sub_140002240()
  br label %ret1

loc_140002420:
  %valE8_3 = load i32, i32* @dword_1400070E8, align 4
  %isZero3 = icmp eq i32 %valE8_3, 0
  br i1 %isZero3, label %loc_14000242E, label %loc_1400024B0

loc_1400024B0:
  call void @sub_140002240()
  br label %loc_14000242E

loc_14000242E:
  %valE8_4 = load i32, i32* @dword_1400070E8, align 4
  %isOne = icmp eq i32 %valE8_4, 1
  br i1 %isOne, label %loc_140002439, label %ret1

loc_140002439:
  %block0 = load i8*, i8** @Block, align 8
  %hasBlock = icmp ne i8* %block0, null
  br i1 %hasBlock, label %loop, label %afterFree

loop:
  %curr = phi i8* [ %block0, %loc_140002439 ], [ %next, %loopcont ]
  %gep16 = getelementptr i8, i8* %curr, i64 16
  %nextptrptr = bitcast i8* %gep16 to i8**
  %next = load i8*, i8** %nextptrptr, align 8
  call void @free(i8* %curr)
  %hasNext = icmp ne i8* %next, null
  br i1 %hasNext, label %loopcont, label %afterFree

loopcont:
  br label %loop

afterFree:
  %critptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  store i8* null, i8** @Block, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  call void @DeleteCriticalSection(i8* %critptr2)
  br label %ret1

ret1:
  ret i32 1
}