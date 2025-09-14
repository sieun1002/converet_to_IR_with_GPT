; ModuleID = 'insertion_sort_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n = icmp ult i64 %n, 2
  br i1 %cmp_n, label %ret, label %for.header

for.header:
  %i.ph = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %i.cmp = icmp ult i64 %i.ph, %n
  br i1 %i.cmp, label %for.body, label %ret

for.body:
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.ph
  %key = load i32, i32* %i.ptr, align 4
  %j.init = add i64 %i.ph, -1
  br label %while.cond

while.cond:
  %j.ph = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %j.ge0 = icmp sge i64 %j.ph, 0
  br i1 %j.ge0, label %check, label %while.end

check:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp = icmp sgt i32 %j.val, %key
  br i1 %cmp, label %while.body, label %while.end

while.body:
  %src.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ph
  %src.val = load i32, i32* %src.ptr, align 4
  %dst.index = add i64 %j.ph, 1
  %dst.ptr = getelementptr inbounds i32, i32* %arr, i64 %dst.index
  store i32 %src.val, i32* %dst.ptr, align 4
  %j.dec = add i64 %j.ph, -1
  br label %while.cond

while.end:
  %j.fin = phi i64 [ %j.ph, %while.cond ], [ %j.ph, %check ]
  %ins.index = add i64 %j.fin, 1
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %ins.index
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i.ph, 1
  br label %for.header

ret:
  ret void
}

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %base, align 4
  %p1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* %base, i64 10)
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %base, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}