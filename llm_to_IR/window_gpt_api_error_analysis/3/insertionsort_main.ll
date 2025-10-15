; ModuleID = 'insertion_sort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local dllimport i32 @printf(i8* noundef, ...)
declare dso_local dllimport i32 @putchar(i32 noundef)

define dso_local void @insertion_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %key = alloca i32, align 4
  store i64 1, i64* %i, align 8
  br label %for.cond

for.cond:                                         ; preds = %while.end, %entry
  %i.cur = load i64, i64* %i, align 8
  %cmp.i = icmp ult i64 %i.cur, %n
  br i1 %cmp.i, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %elt.val = load i32, i32* %elt.ptr, align 4
  store i32 %elt.val, i32* %key, align 4
  %im1 = add i64 %i.cur, -1
  store i64 %im1, i64* %j, align 8
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j.cur = load i64, i64* %j, align 8
  %j.ge0 = icmp sge i64 %j.cur, 0
  br i1 %j.ge0, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %kval = load i32, i32* %key, align 4
  %gt = icmp sgt i32 %aj, %kval
  br i1 %gt, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %j.plus1 = add i64 %j.cur, 1
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.plus1
  store i32 %aj, i32* %dest.ptr, align 4
  %j.new = add i64 %j.cur, -1
  store i64 %j.new, i64* %j, align 8
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.end = load i64, i64* %j, align 8
  %j.end.plus1 = add i64 %j.end, 1
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.end.plus1
  %kval.end = load i32, i32* %key, align 4
  store i32 %kval.end, i32* %ins.ptr, align 4
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
  %idx = alloca i64, align 8
  %arrdecay = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrdecay, align 4
  %p1 = getelementptr inbounds i32, i32* %arrdecay, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrdecay, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrdecay, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrdecay, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrdecay, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrdecay, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrdecay, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrdecay, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrdecay, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %len, align 8
  %len.val = load i64, i64* %len, align 8
  call void @insertion_sort(i32* noundef %arrdecay, i64 noundef %len.val)
  store i64 0, i64* %idx, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %idx.cur = load i64, i64* %idx, align 8
  %len.cur = load i64, i64* %len, align 8
  %cmp = icmp ult i64 %idx.cur, %len.cur
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arrdecay, i64 %idx.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt.ptr, i32 noundef %elem)
  %idx.next = add i64 %idx.cur, 1
  store i64 %idx.next, i64* %idx, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %put = call i32 @putchar(i32 noundef 10)
  ret i32 0
}