; ModuleID = 'bubblesort.bc'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %n = alloca i64, align 8
  %i = alloca i64, align 8
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %9, align 4
  store i64 10, i64* %n, align 8
  %10 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %11 = load i64, i64* %n, align 8
  call void @bubble_sort(i32* %10, i64 %11)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %12 = load i64, i64* %i, align 8
  %13 = load i64, i64* %n, align 8
  %14 = icmp ult i64 %12, %13
  br i1 %14, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %15 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %12
  %16 = load i32, i32* %15, align 4
  %17 = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %18 = call i32 (i8*, ...) @printf(i8* %17, i32 %16)
  %19 = add i64 %12, 1
  store i64 %19, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %20 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %init

init:                                             ; preds = %entry
  br label %outer.check

outer.check:                                      ; preds = %setLast, %init
  %last = phi i64 [ %n, %init ], [ %last_swap, %setLast ]
  %cmpLast = icmp ugt i64 %last, 1
  br i1 %cmpLast, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.check
  br label %inner.cond

inner.cond:                                       ; preds = %inner.latch, %outer.body
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last_swap = phi i64 [ 0, %outer.body ], [ %ls.update, %inner.latch ]
  %cmpI = icmp ult i64 %i, %last
  br i1 %cmpI, label %inner.body, label %afterInner

inner.body:                                       ; preds = %inner.cond
  %im1 = add i64 %i, -1
  %ptrPrev = getelementptr inbounds i32, i32* %a, i64 %im1
  %ptrCurr = getelementptr inbounds i32, i32* %a, i64 %i
  %valPrev = load i32, i32* %ptrPrev, align 4
  %valCurr = load i32, i32* %ptrCurr, align 4
  %cmpSwap = icmp sgt i32 %valPrev, %valCurr
  br i1 %cmpSwap, label %do.swap, label %no.swap

do.swap:                                          ; preds = %inner.body
  store i32 %valCurr, i32* %ptrPrev, align 4
  store i32 %valPrev, i32* %ptrCurr, align 4
  br label %inner.latch

no.swap:                                          ; preds = %inner.body
  br label %inner.latch

inner.latch:                                      ; preds = %no.swap, %do.swap
  %ls.update = phi i64 [ %i, %do.swap ], [ %last_swap, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

afterInner:                                       ; preds = %inner.cond
  %isZero = icmp eq i64 %last_swap, 0
  br i1 %isZero, label %ret, label %setLast

setLast:                                          ; preds = %afterInner
  br label %outer.check

ret:                                              ; preds = %afterInner, %outer.check, %entry
  ret void
}
