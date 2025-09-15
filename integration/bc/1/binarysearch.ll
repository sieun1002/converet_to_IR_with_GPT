; ModuleID = 'binarysearch.bc'
source_filename = "llvm-link"
target triple = "x86_64-unknown-linux-gnu"

@.str.found = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.not = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %arr.gep0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr.gep0, align 4
  %arr.gep1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr.gep1, align 4
  %arr.gep2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr.gep2, align 4
  %arr.gep3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr.gep3, align 4
  %arr.gep4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr.gep4, align 4
  %arr.gep5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr.gep5, align 4
  %arr.gep6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr.gep6, align 4
  %arr.gep7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr.gep7, align 4
  %arr.gep8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr.gep8, align 4
  %keys.gep0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys.gep0, align 4
  %keys.gep1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys.gep1, align 4
  %keys.gep2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys.gep2, align 4
  br label %loop

loop:                                             ; preds = %after_print, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %after_print ]
  %cmp = icmp ult i64 %i, 3
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %idx = call i64 @binary_search(i32* %arr.base, i64 9, i32 %key)
  %found.cmp = icmp slt i64 %idx, 0
  br i1 %found.cmp, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt.found = getelementptr inbounds [21 x i8], [21 x i8]* @.str.found, i64 0, i64 0
  %call.found = call i32 (i8*, ...) @printf(i8* %fmt.found, i32 %key, i64 %idx)
  br label %after_print

notfound:                                         ; preds = %loop.body
  %fmt.not = getelementptr inbounds [21 x i8], [21 x i8]* @.str.not, i64 0, i64 0
  %call.not = call i32 (i8*, ...) @printf(i8* %fmt.not, i32 %key)
  br label %after_print

after_print:                                      ; preds = %notfound, %found
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 0
}

declare i32 @printf(i8*, ...)

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.header
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmpk = icmp sle i32 %key, %val
  br i1 %cmpk, label %set.high, label %set.low

set.low:                                          ; preds = %loop.body
  %mid.plus1 = add i64 %mid, 1
  br label %loop.latch

set.high:                                         ; preds = %loop.body
  br label %loop.latch

loop.latch:                                       ; preds = %set.high, %set.low
  %low.next = phi i64 [ %mid.plus1, %set.low ], [ %low, %set.high ]
  %high.next = phi i64 [ %high, %set.low ], [ %mid, %set.high ]
  br label %loop.header

after.loop:                                       ; preds = %loop.header
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check.value, label %notfound

check.value:                                      ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:                                            ; preds = %check.value
  ret i64 %low

notfound:                                         ; preds = %check.value, %after.loop
  ret i64 -1
}
