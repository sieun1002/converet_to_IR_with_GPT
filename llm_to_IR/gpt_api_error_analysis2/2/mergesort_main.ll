; ModuleID = 'merge_sort_print'
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare void @merge_sort(i32* nocapture, i64)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len.addr = alloca i64, align 8
  store i64 10, i64* %len.addr, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %arr.base, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %idx9, align 4
  %len = load i64, i64* %len.addr, align 8
  call void @merge_sort(i32* %arr.base, i64 %len)
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %inc, %for.inc ]
  %cmp = icmp ult i64 %i, %len
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %for.inc

for.inc:
  %inc = add i64 %i, 1
  br label %for.cond

for.end:
  %call.putchar = call i32 @putchar(i32 10)
  ret i32 0
}