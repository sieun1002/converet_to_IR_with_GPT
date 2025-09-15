; ModuleID = 'binarysearch.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [21 x i8] c"key %d -> index %ld\0A\00", align 1
@.str.1 = private unnamed_addr constant [21 x i8] c"key %d -> not found\0A\00", align 1

define i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %keys = alloca [3 x i32], align 16
  %N = alloca i64, align 8
  %K = alloca i64, align 8
  %i.addr = alloca i64, align 8
  %res = alloca i64, align 8
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 -5, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 -1, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 0, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 2, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 2, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 3, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 7, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 9, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 12, i32* %arr8, align 4
  %keys0 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 0
  store i32 2, i32* %keys0, align 4
  %keys1 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 1
  store i32 5, i32* %keys1, align 4
  %keys2 = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 2
  store i32 -5, i32* %keys2, align 4
  store i64 9, i64* %N, align 8
  store i64 3, i64* %K, align 8
  store i64 0, i64* %i.addr, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %inc, %entry
  %i.load = load i64, i64* %i.addr, align 8
  %K.load = load i64, i64* %K, align 8
  %cmp = icmp ult i64 %i.load, %K.load
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.cond
  %key.ptr = getelementptr inbounds [3 x i32], [3 x i32]* %keys, i64 0, i64 %i.load
  %key = load i32, i32* %key.ptr, align 4
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %N.load = load i64, i64* %N, align 8
  %bs.ret = call i64 @binary_search(i32* %arr.base, i64 %N.load, i32 %key)
  store i64 %bs.ret, i64* %res, align 8
  %neg = icmp slt i64 %bs.ret, 0
  br i1 %neg, label %notfound, label %found

found:                                            ; preds = %loop.body
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str, i64 0, i64 0
  %printf.ok = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %key, i64 %bs.ret)
  br label %inc

notfound:                                         ; preds = %loop.body
  %fmt2.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.1, i64 0, i64 0
  %printf.nf = call i32 (i8*, ...) @printf(i8* %fmt2.ptr, i32 %key)
  br label %inc

inc:                                              ; preds = %notfound, %found
  %i.prev = load i64, i64* %i.addr, align 8
  %i.next = add i64 %i.prev, 1
  store i64 %i.next, i64* %i.addr, align 8
  br label %loop.cond

exit:                                             ; preds = %loop.cond
  ret i32 0
}

declare i32 @printf(i8*, ...)

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop.cond

loop.cond:                                        ; preds = %loop.latch, %entry
  %low = phi i64 [ 0, %entry ], [ %low.next, %loop.latch ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %loop.latch ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %condLE = icmp sle i32 %key, %elem
  %mid.plus1 = add i64 %mid, 1
  %low.sel = select i1 %condLE, i64 %low, i64 %mid.plus1
  %high.sel = select i1 %condLE, i64 %mid, i64 %high
  br label %loop.latch

loop.latch:                                       ; preds = %loop.body
  %low.next = phi i64 [ %low.sel, %loop.body ]
  %high.next = phi i64 [ %high.sel, %loop.body ]
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check, label %ret.notfound

check:                                            ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.found, label %ret.notfound

ret.found:                                        ; preds = %check
  ret i64 %low

ret.notfound:                                     ; preds = %check, %after.loop
  ret i64 -1
}
