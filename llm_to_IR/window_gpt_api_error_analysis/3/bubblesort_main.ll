; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare dso_local void @bubble_sort(i32*, i64)

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i64, align 8
  call void @__main()
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.base, align 4
  %arr.1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %arr.1, align 4
  %arr.2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %arr.2, align 4
  %arr.3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %arr.3, align 4
  %arr.4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %arr.4, align 4
  %arr.5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %arr.5, align 4
  %arr.6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %arr.6, align 4
  %arr.7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %arr.7, align 4
  %arr.8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %arr.8, align 4
  %arr.9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %arr.9, align 4
  store i64 10, i64* %len, align 8
  %len.load0 = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %arr.base, i64 %len.load0)
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.body:
  %idx.load = load i64, i64* %idx, align 8
  %elt.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %idx.load
  %elt = load i32, i32* %elt.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %printf.call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elt)
  %idx.next = add i64 %idx.load, 1
  store i64 %idx.next, i64* %idx, align 8
  br label %loop.cond

loop.cond:
  %idx.cur = load i64, i64* %idx, align 8
  %len.load1 = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx.cur, %len.load1
  br i1 %cmp, label %loop.body, label %after

after:
  %putchar.call = call i32 @putchar(i32 10)
  ret i32 0
}