; ModuleID = 'fixed_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str_sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dllimport i32 @printf(i8*, ...)

define dso_local void @__main() {
entry:
  ret void
}

define dso_local void @selection_sort(i32* nocapture %0, i32 %1) {
entry:
  %2 = icmp sgt i32 %1, 1
  br i1 %2, label %outer.header, label %ret

outer.header:                                     ; preds = %outer.latch, %entry
  %3 = phi i32 [ 0, %entry ], [ %11, %outer.latch ]
  %4 = add i32 %1, -1
  %5 = icmp slt i32 %3, %4
  br i1 %5, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.header
  %6 = add i32 %3, 1
  br label %inner.header

inner.header:                                     ; preds = %inner.body, %outer.body
  %7 = phi i32 [ %3, %outer.body ], [ %10, %inner.body ]
  %8 = phi i32 [ %6, %outer.body ], [ %9, %inner.body ]
  %9 = add i32 %8, 0
  %10 = add i32 %7, 0
  %11_cond = icmp slt i32 %8, %1
  br i1 %11_cond, label %inner.body, label %inner.end

inner.body:                                       ; preds = %inner.header
  %12 = zext i32 %8 to i64
  %13 = getelementptr inbounds i32, i32* %0, i64 %12
  %14 = load i32, i32* %13, align 4
  %15 = zext i32 %7 to i64
  %16 = getelementptr inbounds i32, i32* %0, i64 %15
  %17 = load i32, i32* %16, align 4
  %18 = icmp slt i32 %14, %17
  %19 = select i1 %18, i32 %8, i32 %7
  %20 = add i32 %8, 1
  br label %inner.header

inner.end:                                        ; preds = %inner.header
  %21 = icmp ne i32 %7, %3
  br i1 %21, label %swap, label %outer.latch

swap:                                             ; preds = %inner.end
  %22 = zext i32 %3 to i64
  %23 = getelementptr inbounds i32, i32* %0, i64 %22
  %24 = zext i32 %7 to i64
  %25 = getelementptr inbounds i32, i32* %0, i64 %24
  %26 = load i32, i32* %23, align 4
  %27 = load i32, i32* %25, align 4
  store i32 %26, i32* %25, align 4
  store i32 %27, i32* %23, align 4
  br label %outer.latch

outer.latch:                                      ; preds = %swap, %inner.end
  %11 = add i32 %3, 1
  br label %outer.header

ret:                                              ; preds = %outer.header, %entry
  ret void
}

define dso_local i32 @main() {
entry:
  %0 = alloca [5 x i32], align 16
  call void @__main()
  %1 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 0
  store i32 29, i32* %1, align 4
  %2 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 1
  store i32 10, i32* %2, align 4
  %3 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 2
  store i32 14, i32* %3, align 4
  %4 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 3
  store i32 37, i32* %4, align 4
  %5 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 4
  store i32 13, i32* %5, align 4
  %6 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 0
  call void @selection_sort(i32* %6, i32 5)
  %7 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_sorted, i64 0, i64 0
  %8 = call i32 (i8*, ...) @printf(i8* %7)
  br label %loop.header

loop.header:                                      ; preds = %loop.latch, %entry
  %9 = phi i32 [ 0, %entry ], [ %13, %loop.latch ]
  %10 = icmp slt i32 %9, 5
  br i1 %10, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.header
  %11 = zext i32 %9 to i64
  %12 = getelementptr inbounds [5 x i32], [5 x i32]* %0, i64 0, i64 %11
  %13_val = load i32, i32* %12, align 4
  %14 = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %15 = call i32 (i8*, ...) @printf(i8* %14, i32 %13_val)
  br label %loop.latch

loop.latch:                                       ; preds = %loop.body
  %13 = add i32 %9, 1
  br label %loop.header

loop.end:                                         ; preds = %loop.header
  ret i32 0
}