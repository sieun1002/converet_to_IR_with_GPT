; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str.sorted = private unnamed_addr constant [15 x i8] c"Sorted array: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local void @__main()
declare dso_local i32 @printf(i8*, ...)

define dso_local void @selection_sort(i32* %arr, i32 %n) {
entry:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %min_idx = alloca i32, align 4
  %tmp = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.i.cond

for.i.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp1 = icmp slt i32 %i.val, %n
  br i1 %cmp1, label %for.i.body, label %for.i.end

for.i.body:
  store i32 %i.val, i32* %min_idx, align 4
  %i.plus1 = add i32 %i.val, 1
  store i32 %i.plus1, i32* %j, align 4
  br label %for.j.cond

for.j.cond:
  %j.val = load i32, i32* %j, align 4
  %cmpj = icmp slt i32 %j.val, %n
  br i1 %cmpj, label %for.j.body, label %for.j.end

for.j.body:
  %j.idx64 = sext i32 %j.val to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.elem = load i32, i32* %j.ptr, align 4
  %min.cur = load i32, i32* %min_idx, align 4
  %min.idx64 = sext i32 %min.cur to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx64
  %min.elem = load i32, i32* %min.ptr, align 4
  %lt = icmp slt i32 %j.elem, %min.elem
  br i1 %lt, label %update.min, label %no.update

update.min:
  store i32 %j.val, i32* %min_idx, align 4
  br label %no.update

no.update:
  %j.old = load i32, i32* %j, align 4
  %j.next = add i32 %j.old, 1
  store i32 %j.next, i32* %j, align 4
  br label %for.j.cond

for.j.end:
  %min.fin = load i32, i32* %min_idx, align 4
  %i.cur = load i32, i32* %i, align 4
  %need.swap = icmp ne i32 %min.fin, %i.cur
  br i1 %need.swap, label %do.swap, label %skip.swap

do.swap:
  %i.idx64 = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %min.idx64.2 = sext i32 %min.fin to i64
  %min.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %min.idx64.2
  %val.i = load i32, i32* %i.ptr, align 4
  %val.min = load i32, i32* %min.ptr2, align 4
  store i32 %val.i, i32* %tmp, align 4
  store i32 %val.min, i32* %i.ptr, align 4
  %tmpv = load i32, i32* %tmp, align 4
  store i32 %tmpv, i32* %min.ptr2, align 4
  br label %skip.swap

skip.swap:
  %i.old = load i32, i32* %i, align 4
  %i.next = add i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %for.i.cond

for.i.end:
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  call void @__main()
  %arr = alloca [5 x i32], align 16
  %len = alloca i32, align 4
  %i = alloca i32, align 4
  store i32 29, i32* getelementptr inbounds ([5 x i32], [5 x i32]* %arr, i32 0, i32 0), align 4
  store i32 10, i32* getelementptr inbounds ([5 x i32], [5 x i32]* %arr, i32 0, i32 1), align 4
  store i32 14, i32* getelementptr inbounds ([5 x i32], [5 x i32]* %arr, i32 0, i32 2), align 4
  store i32 37, i32* getelementptr inbounds ([5 x i32], [5 x i32]* %arr, i32 0, i32 3), align 4
  store i32 13, i32* getelementptr inbounds ([5 x i32], [5 x i32]* %arr, i32 0, i32 4), align 4
  store i32 5, i32* %len, align 4
  %arr.base = getelementptr inbounds [5 x i32], [5 x i32]* %arr, i32 0, i32 0
  %n.val = load i32, i32* %len, align 4
  call void @selection_sort(i32* %arr.base, i32 %n.val)
  %fmt.sorted.ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.sorted, i32 0, i32 0
  %call.printf.sorted = call i32 (i8*, ...) @printf(i8* %fmt.sorted.ptr)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %n.cur = load i32, i32* %len, align 4
  %cmp = icmp slt i32 %i.cur, %n.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %idx64 = sext i32 %i.cur to i64
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %idx64
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.d.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i32 0, i32 0
  %call.printf.elem = call i32 (i8*, ...) @printf(i8* %fmt.d.ptr, i32 %elem)
  %i.next = add i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

loop.end:
  ret i32 0
}