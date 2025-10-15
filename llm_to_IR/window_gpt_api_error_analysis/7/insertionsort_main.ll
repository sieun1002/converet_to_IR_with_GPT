; ModuleID = 'sort_print'
source_filename = "sort_print.ll"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local dllimport i32 @printf(i8*, ...)
declare dso_local dllimport i32 @putchar(i32)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cond = icmp sgt i64 %n, 1
  br i1 %cond, label %for.header, label %ret

for.header:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp.i = icmp slt i64 %i, %n
  br i1 %cmp.i, label %for.body, label %ret

for.body:
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %j.start = add i64 %i, -1
  br label %while.cond

while.cond:
  %j = phi i64 [ %j.start, %for.body ], [ %j.next, %while.body ]
  %j.ge0 = icmp sge i64 %j, 0
  br i1 %j.ge0, label %check.gt, label %while.end

check.gt:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %gt = icmp sgt i32 %j.val, %key
  br i1 %gt, label %while.body, label %while.end.fromcheck

while.body:
  %jp1 = add i64 %j, 1
  %dst.ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1
  store i32 %j.val, i32* %dst.ptr, align 4
  %j.next = add i64 %j, -1
  br label %while.cond

while.end.fromcheck:
  br label %while.end

while.end:
  %j.final = phi i64 [ %j, %while.end.fromcheck ], [ %j, %while.cond ]
  %jp1.end = add i64 %j.final, 1
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1.end
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.header

ret:
  ret void
}

define dso_local i32 @main(i32 %argc, i8** %argv) {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* %arr0, i64 10)
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}