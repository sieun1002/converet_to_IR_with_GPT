; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@dword_1400070E8 = dso_local global i32 0, align 4
@qword_1400070E0 = dso_local global i8* null, align 8
@unk_140007100 = dso_local global [1 x i8] zeroinitializer, align 1

declare dso_local void @sub_140002240()
declare dso_local void @sub_1400024E0()
declare dso_local void @sub_140002BB0(i8*)
declare dso_local void @sub_1403DDA29(i8*)
declare dso_local i32 @sub_1400E06D5(i8*)

define dso_local i32 @sub_1400023D0(i8* %rcx, i32 %edx) local_unnamed_addr {
entry:
  %cmp_eq_2 = icmp eq i32 %edx, 2
  br i1 %cmp_eq_2, label %case2, label %not2

case2:                                            ; preds = %entry
  call void @sub_1400024E0()
  ret i32 1

not2:                                             ; preds = %entry
  %ugt2 = icmp ugt i32 %edx, 2
  br i1 %ugt2, label %gt2, label %le2

gt2:                                              ; preds = %not2
  %cmp_eq_3 = icmp eq i32 %edx, 3
  br i1 %cmp_eq_3, label %eq3, label %ret1

eq3:                                              ; preds = %gt2
  %flag3 = load i32, i32* @dword_1400070E8, align 4
  %flag3_zero = icmp eq i32 %flag3, 0
  br i1 %flag3_zero, label %ret1, label %call240_then_420

call240_then_420:                                 ; preds = %eq3
  call void @sub_140002240()
  br label %L420

le2:                                              ; preds = %not2
  %isZero = icmp eq i32 %edx, 0
  br i1 %isZero, label %L420, label %edx_is1

edx_is1:                                          ; preds = %le2
  %flag1 = load i32, i32* @dword_1400070E8, align 4
  %flag1_zero = icmp eq i32 %flag1, 0
  br i1 %flag1_zero, label %loc4C0, label %set1_ret1

set1_ret1:                                        ; preds = %edx_is1
  store i32 1, i32* @dword_1400070E8, align 4
  ret i32 1

L420:                                             ; preds = %le2, %call240_then_420
  %flagA = load i32, i32* @dword_1400070E8, align 4
  %flagA_nonzero = icmp ne i32 %flagA, 0
  br i1 %flagA_nonzero, label %afterCall240, label %check1

afterCall240:                                     ; preds = %L420
  call void @sub_140002240()
  br label %loc4C0

check1:                                           ; preds = %L420
  %flagB = load i32, i32* @dword_1400070E8, align 4
  %is1 = icmp eq i32 %flagB, 1
  br i1 %is1, label %traverse, label %ret1

traverse:                                         ; preds = %check1
  %head = load i8*, i8** @qword_1400070E0, align 8
  br label %loopTest

loopTest:                                         ; preds = %loopBodyEnd, %traverse
  %curr = phi i8* [ %head, %traverse ], [ %next, %loopBodyEnd ]
  %isNull = icmp eq i8* %curr, null
  br i1 %isNull, label %afterLoop, label %loopBody

loopBody:                                         ; preds = %loopTest
  %nextPtrAddr = getelementptr i8, i8* %curr, i64 16
  %nextPtrPtr = bitcast i8* %nextPtrAddr to i8**
  %next = load i8*, i8** %nextPtrPtr, align 8
  call void @sub_140002BB0(i8* %curr)
  br label %loopBodyEnd

loopBodyEnd:                                      ; preds = %loopBody
  br label %loopTest

afterLoop:                                        ; preds = %loopTest
  store i8* null, i8** @qword_1400070E0, align 8
  store i32 0, i32* @dword_1400070E8, align 4
  %p2 = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1403DDA29(i8* %p2)
  ret i32 1

loc4C0:                                           ; preds = %afterCall240, %edx_is1
  %p = getelementptr [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  %res = call i32 @sub_1400E06D5(i8* %p)
  ret i32 1

ret1:                                             ; preds = %eq3, %gt2, %check1
  ret i32 1
}