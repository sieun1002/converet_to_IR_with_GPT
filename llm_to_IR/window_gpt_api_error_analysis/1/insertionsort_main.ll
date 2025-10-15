; ModuleID: insertion_sort_module
source_filename = "insertion_sort_module"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

define void @__main() {
entry:
  ret void
}

define void @insertion_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %entry, %for.inc
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp slt i64 %i, %n
  br i1 %cmp, label %for.body, label %ret

for.body:                                         ; preds = %for.cond
  %eltptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %eltptr, align 4
  %j.init = add i64 %i, -1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %cond1 = icmp sge i64 %j, 0
  br i1 %cond1, label %while.check, label %while.end

while.check:                                      ; preds = %while.cond
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %aj = load i32, i32* %jptr, align 4
  %cmp2 = icmp sgt i32 %aj, %key
  br i1 %cmp2, label %while.body, label %while.end

while.body:                                       ; preds = %while.check
  %j1 = add i64 %j, 1
  %dst = getelementptr inbounds i32, i32* %arr, i64 %j1
  store i32 %aj, i32* %dst, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                        ; preds = %while.check, %while.cond
  %j.end = phi i64 [ %j, %while.cond ], [ %j, %while.check ]
  %j1.final = add i64 %j.end, 1
  %pos = getelementptr inbounds i32, i32* %arr, i64 %j1.final
  store i32 %key, i32* %pos, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

ret:                                              ; preds = %for.cond
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %p0, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %p0, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %p0, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %p0, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %p0, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %p0, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %p0, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %p0, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %p0, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %p0, i64 9
  store i32 0, i32* %e9, align 4
  call void @insertion_sort(i32* noundef %p0, i64 noundef 10)
  br label %loop.cond

loop.cond:                                        ; preds = %entry, %loop.inc
  %i.idx = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i.idx, 10
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i.idx
  %val = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* noundef %fmt, i32 noundef %val)
  br label %loop.inc

loop.inc:                                         ; preds = %loop.body
  %i.next = add i64 %i.idx, 1
  br label %loop.cond

after.loop:                                       ; preds = %loop.cond
  %call2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}