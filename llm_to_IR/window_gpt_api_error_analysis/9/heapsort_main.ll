; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@.str.header1 = private unnamed_addr constant [11 x i8] c"Original: \00"
@.str.header2 = private unnamed_addr constant [9 x i8] c"Sorted: \00"
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__main()

define internal void @heapify(i32* %arr, i64 %n, i64 %i) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %swap, %entry
  %i.cur = phi i64 [ %i, %entry ], [ %largest.final, %swap ]
  %l.mul = mul i64 %i.cur, 2
  %l = add i64 %l.mul, 1
  %r = add i64 %l, 1
  %largest.init = %i.cur
  %cmpL = icmp slt i64 %l, %n
  br i1 %cmpL, label %checkL, label %afterL

checkL:                                           ; preds = %loop.header
  %ptrL = getelementptr inbounds i32, i32* %arr, i64 %l
  %valL = load i32, i32* %ptrL, align 4
  %ptrI = getelementptr inbounds i32, i32* %arr, i64 %largest.init
  %valI = load i32, i32* %ptrI, align 4
  %cmpLV = icmp sgt i32 %valL, %valI
  br i1 %cmpLV, label %setLargestL, label %afterL

setLargestL:                                      ; preds = %checkL
  br label %afterL

afterL:                                           ; preds = %loop.header, %checkL, %setLargestL
  %largest.afterL = phi i64 [ %l, %setLargestL ], [ %largest.init, %checkL ], [ %largest.init, %loop.header ]
  %cmpR = icmp slt i64 %r, %n
  br i1 %cmpR, label %checkR, label %afterR

checkR:                                           ; preds = %afterL
  %ptrR = getelementptr inbounds i32, i32* %arr, i64 %r
  %valR = load i32, i32* %ptrR, align 4
  %ptrLargest2 = getelementptr inbounds i32, i32* %arr, i64 %largest.afterL
  %valLargest2 = load i32, i32* %ptrLargest2, align 4
  %cmpRV = icmp sgt i32 %valR, %valLargest2
  br i1 %cmpRV, label %setLargestR, label %afterR

setLargestR:                                      ; preds = %checkR
  br label %afterR

afterR:                                           ; preds = %afterL, %checkR, %setLargestR
  %largest.final = phi i64 [ %r, %setLargestR ], [ %largest.afterL, %checkR ], [ %largest.afterL, %afterL ]
  %needSwap = icmp ne i64 %largest.final, %i.cur
  br i1 %needSwap, label %swap, label %done

swap:                                             ; preds = %afterR
  %ptrI2 = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ptrL2 = getelementptr inbounds i32, i32* %arr, i64 %largest.final
  %valI2 = load i32, i32* %ptrI2, align 4
  %valL2 = load i32, i32* %ptrL2, align 4
  store i32 %valL2, i32* %ptrI2, align 4
  store i32 %valI2, i32* %ptrL2, align 4
  br label %loop.header

done:                                             ; preds = %afterR
  ret void
}

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %isZero = icmp eq i64 %n, 0
  br i1 %isZero, label %build.end, label %build.header

build.header:                                     ; preds = %entry, %build.body
  %half = udiv i64 %n, 2
  %start0 = sub i64 %half, 1
  %i.phi = phi i64 [ %start0, %entry ], [ %i.next, %build.body ]
  %cond = icmp sge i64 %i.phi, 0
  br i1 %cond, label %build.body, label %build.end

build.body:                                       ; preds = %build.header
  call void @heapify(i32* %arr, i64 %n, i64 %i.phi)
  %i.next = add i64 %i.phi, -1
  br label %build.header

build.end:                                        ; preds = %build.header, %entry
  %nminus1 = add i64 %n, -1
  br label %sort.header

sort.header:                                      ; preds = %sort.latch, %build.end
  %i2 = phi i64 [ %nminus1, %build.end ], [ %i2.next, %sort.latch ]
  %cond2 = icmp sgt i64 %i2, 0
  br i1 %cond2, label %sort.body, label %sort.end

sort.body:                                        ; preds = %sort.header
  %ptr0 = getelementptr inbounds i32, i32* %arr, i64 0
  %ptrI = getelementptr inbounds i32, i32* %arr, i64 %i2
  %v0 = load i32, i32* %ptr0, align 4
  %vi = load i32, i32* %ptrI, align 4
  store i32 %vi, i32* %ptr0, align 4
  store i32 %v0, i32* %ptrI, align 4
  call void @heapify(i32* %arr, i64 %i2, i64 0)
  %i2.next = add i64 %i2, -1
  br label %sort.latch

sort.latch:                                       ; preds = %sort.body
  br label %sort.header

sort.end:                                         ; preds = %sort.header
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [9 x i32], align 16
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %len = alloca i64, align 8
  store i64 9, i64* %len, align 8
  %arr0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %arr0, align 4
  %arr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %arr1, align 4
  %arr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %arr2, align 4
  %arr3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %arr3, align 4
  %arr4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %arr4, align 4
  %arr5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %arr5, align 4
  %arr6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %arr6, align 4
  %arr7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr7, align 4
  %arr8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %arr8, align 4
  %fmt1.ptr = getelementptr inbounds [11 x i8], [11 x i8]* @.str.header1, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr)
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.val = load i64, i64* %i, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp1 = icmp ult i64 %i.val, %len.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elem.val = load i32, i32* %elem.ptr, align 4
  %fmtd.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elem.val)
  %i.next1 = add i64 %i.val, 1
  store i64 %i.next1, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %nl1 = call i32 @putchar(i32 10)
  %arr.decay = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  %len2 = load i64, i64* %len, align 8
  call void @heap_sort(i32* %arr.decay, i64 %len2)
  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.header2, i64 0, i64 0
  %call.printf3 = call i32 (i8*, ...) @printf(i8* %fmt2.ptr)
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %j.val = load i64, i64* %j, align 8
  %len.val2 = load i64, i64* %len, align 8
  %cmp2 = icmp ult i64 %j.val, %len.val2
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.cond
  %elem2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elem2.val = load i32, i32* %elem2.ptr, align 4
  %call.printf4 = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elem2.val)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                        ; preds = %loop2.cond
  %nl2 = call i32 @putchar(i32 10)
  ret i32 0
}