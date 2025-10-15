; ModuleID = 'insertion_sort.module'
source_filename = "insertion_sort.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define dso_local void @insertion_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp.n = icmp sgt i64 %n, 1
  br i1 %cmp.n, label %for.loop, label %exit

for.loop:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %i.ptr, align 4
  %i.minus1 = add nsw i64 %i, -1
  br label %while.cond

while.cond:
  %j = phi i64 [ %i.minus1, %for.loop ], [ %j.next, %while.body ]
  %j.ge0 = icmp sge i64 %j, 0
  br i1 %j.ge0, label %check.arr, label %while.end

check.arr:
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp = icmp sgt i32 %aj, %key
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %j.plus1 = add nsw i64 %j, 1
  %aj1.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  store i32 %aj, i32* %aj1.ptr, align 4
  %j.next = add nsw i64 %j, -1
  br label %while.cond

while.end:
  %j.end = phi i64 [ %j, %check.arr ], [ %j, %while.cond ]
  %j.end.plus1 = add nsw i64 %j.end, 1
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.end.plus1
  store i32 %key, i32* %dest.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = add nuw nsw i64 %i, 1
  %cmp2 = icmp slt i64 %i.next, %n
  br i1 %cmp2, label %for.loop, label %exit

exit:
  ret void
}

define dso_local i32 @main(i32 noundef %argc, i8** noundef %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %i.var = alloca i64, align 8
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %arr.base, align 4
  %gep1 = getelementptr inbounds i32, i32* %arr.base, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds i32, i32* %arr.base, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds i32, i32* %arr.base, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds i32, i32* %arr.base, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds i32, i32* %arr.base, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds i32, i32* %arr.base, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds i32, i32* %arr.base, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds i32, i32* %arr.base, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds i32, i32* %arr.base, i64 9
  store i32 0, i32* %gep9, align 4
  store i64 10, i64* %len, align 8
  %len.val = load i64, i64* %len, align 8
  call void @insertion_sort(i32* noundef %arr.base, i64 noundef %len.val)
  store i64 0, i64* %i.var, align 8
  br label %print.cond

print.cond:
  %i.load = load i64, i64* %i.var, align 8
  %len.cmp = load i64, i64* %len, align 8
  %lt = icmp ult i64 %i.load, %len.cmp
  br i1 %lt, label %print.body, label %print.end

print.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %i.load
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %i.next2 = add nuw nsw i64 %i.load, 1
  store i64 %i.next2, i64* %i.var, align 8
  br label %print.cond

print.end:
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}