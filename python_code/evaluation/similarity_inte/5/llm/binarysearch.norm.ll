; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/5/binarysearch.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str_found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str_nf = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr0ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0ptr, align 16
  %arr1ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1ptr, align 4
  %arr2ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2ptr, align 8
  %arr3ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3ptr, align 4
  %arr4ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4ptr, align 16
  %arr5ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5ptr, align 4
  %arr6ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6ptr, align 8
  %arr7ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7ptr, align 4
  %arr8ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8ptr, align 16
  %k0ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %k0ptr, align 16
  %k1ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %k1ptr, align 4
  %k2ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %k2ptr, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp ult i64 %i.0, 3
  br i1 %cmp, label %loop.body, label %ret

loop.body:                                        ; preds = %loop.cond
  %keyptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.0
  %key = load i32, i32* %keyptr, align 4
  %idx.call = call i64 @binary_search(i32* nonnull %arr0ptr, i64 9, i32 %key)
  %foundcmp = icmp slt i64 %idx.call, 0
  br i1 %foundcmp, label %notfound, label %found

found:                                            ; preds = %loop.body
  %call.printf1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_found, i64 0, i64 0), i32 %key, i64 %idx.call)
  br label %inc

notfound:                                         ; preds = %loop.body
  %call.printf2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str_nf, i64 0, i64 0), i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.next = add i64 %i.0, 1
  br label %loop.cond

ret:                                              ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8*, ...)

define i64 @binary_search(i32* nocapture readonly %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:                                             ; preds = %body, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %body ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body ]
  %cmp = icmp ugt i64 %high, %low
  br i1 %cmp, label %body, label %after

body:                                             ; preds = %loop
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %le.not = icmp slt i32 %val, %key
  %mid.plus = add i64 %mid, 1
  %low.next = select i1 %le.not, i64 %mid.plus, i64 %low
  %high.next = select i1 %le.not, i64 %high, i64 %mid
  br label %loop

after:                                            ; preds = %loop
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check_eq, label %ret_neg

check_eq:                                         ; preds = %after
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %val2, %key
  br i1 %eq, label %common.ret, label %ret_neg

common.ret:                                       ; preds = %check_eq, %ret_neg
  %common.ret.op = phi i64 [ -1, %ret_neg ], [ %low, %check_eq ]
  ret i64 %common.ret.op

ret_neg:                                          ; preds = %check_eq, %after
  br label %common.ret
}
