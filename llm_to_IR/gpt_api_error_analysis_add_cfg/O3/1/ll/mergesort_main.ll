; ModuleID = 'mergesort_skeleton'
source_filename = "mergesort_skeleton.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define i32 @mergesort_main1() {
entry:
  br label %.L10c0

.L10c0:
  %acc0 = phi i32 [ 0, %entry ]
  %t1 = and i32 %acc0, 1
  %cond1 = icmp eq i32 %t1, 0
  br i1 %cond1, label %loc_1140, label %loc_1158

loc_1140:
  %acc1 = add nsw i32 %acc0, 1
  br label %loc_115C

loc_1158:
  %acc2 = add nsw i32 %acc0, 2
  br label %loc_115C

loc_115C:
  %acc3 = phi i32 [ %acc1, %loc_1140 ], [ %acc2, %loc_1158 ]
  %cond2 = icmp slt i32 %acc3, 5
  br i1 %cond2, label %loc_1280, label %loc_128A

loc_1280:
  %acc4 = add nsw i32 %acc3, 3
  br label %loc_12B8

loc_128A:
  %acc5 = add nsw i32 %acc3, 4
  br label %loc_12B8

loc_12B8:
  %acc6 = phi i32 [ %acc4, %loc_1280 ], [ %acc5, %loc_128A ]
  %t2 = and i32 %acc6, 2
  %cond3 = icmp ne i32 %t2, 0
  br i1 %cond3, label %loc_12D7, label %loc_12F0

loc_12D7:
  %acc7 = add nsw i32 %acc6, 5
  br label %loc_12F0

loc_12F0:
  %acc8 = phi i32 [ %acc6, %loc_12B8 ], [ %acc7, %loc_12D7 ]
  %cond4 = icmp sgt i32 %acc8, 3
  br i1 %cond4, label %loc_1313, label %loc_1380

loc_1313:
  %acc9 = sub nsw i32 %acc8, 1
  br label %loc_1380

loc_1380:
  %acc10 = phi i32 [ %acc8, %loc_12F0 ], [ %acc9, %loc_1313 ]
  %t3 = and i32 %acc10, 4
  %cond5 = icmp eq i32 %t3, 4
  br i1 %cond5, label %loc_13A0, label %loc_13AD

loc_13A0:
  %acc11 = add nsw i32 %acc10, 6
  br label %loc_13AD

loc_13AD:
  %acc12 = phi i32 [ %acc10, %loc_1380 ], [ %acc11, %loc_13A0 ]
  %cond6 = icmp sge i32 %acc12, 10
  br i1 %cond6, label %loc_13CE, label %loc_13E0

loc_13CE:
  %acc13 = add nsw i32 %acc12, 7
  br label %loc_13E0

loc_13E0:
  %acc14 = phi i32 [ %acc12, %loc_13AD ], [ %acc13, %loc_13CE ]
  %t4 = and i32 %acc14, 8
  %cond7 = icmp ne i32 %t4, 0
  br i1 %cond7, label %loc_1435, label %loc_142E

loc_1435:
  %acc15 = add nsw i32 %acc14, 8
  br label %loc_143A

loc_142E:
  %acc16 = sub nsw i32 %acc14, 2
  br label %loc_143A

loc_143A:
  %acc17 = phi i32 [ %acc15, %loc_1435 ], [ %acc16, %loc_142E ]
  br label %loc_11C4

loc_11C4:
  %acc18 = add nsw i32 %acc17, 0
  ret i32 %acc18
}

define i32 @main() {
entry:
  %res = call i32 @mergesort_main1()
  ret i32 %res
}