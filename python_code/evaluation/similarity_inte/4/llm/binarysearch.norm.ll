; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/binarysearch.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 16
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 8
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 16
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 8
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 16
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 16
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 8
  br label %loop

loop:                                             ; preds = %incr, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %incr ]
  %cmp = icmp ult i64 %i.0, 3
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.0
  %key = load i32, i32* %keyptr, align 4
  %idx = call i64 @binary_search(i32* noundef nonnull %arr0, i64 noundef 9, i32 noundef %key)
  %nonneg = icmp sgt i64 %idx, -1
  br i1 %nonneg, label %found, label %notfound

found:                                            ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str, i64 0, i64 0), i32 noundef %key, i64 noundef %idx)
  br label %incr

notfound:                                         ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.1, i64 0, i64 0), i32 noundef %key)
  br label %incr

incr:                                             ; preds = %notfound, %found
  %i.next = add i64 %i.0, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

define dso_local i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.body ]
  %cmp.loop = icmp ugt i64 %high, %low
  br i1 %cmp.loop, label %loop.body, label %postloop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elt = load i32, i32* %elt.ptr, align 4
  %cmp.sle.not = icmp slt i32 %elt, %key
  %mid.plus1 = add i64 %mid, 1
  %high.next = select i1 %cmp.sle.not, i64 %high, i64 %mid
  %low.next = select i1 %cmp.sle.not, i64 %mid.plus1, i64 %low
  br label %loop.cond

postloop:                                         ; preds = %loop.cond
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %checkval, label %ret.neg1

checkval:                                         ; preds = %postloop
  %elt.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %elt2 = load i32, i32* %elt.ptr2, align 4
  %eq = icmp eq i32 %elt2, %key
  br i1 %eq, label %common.ret, label %ret.neg1

common.ret:                                       ; preds = %checkval, %ret.neg1
  %common.ret.op = phi i64 [ -1, %ret.neg1 ], [ %low, %checkval ]
  ret i64 %common.ret.op

ret.neg1:                                         ; preds = %checkval, %postloop
  br label %common.ret
}
