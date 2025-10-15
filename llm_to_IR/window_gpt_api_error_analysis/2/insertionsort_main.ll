; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__main()

define void @insertion_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cond0 = icmp sgt i64 %n, 1
  br i1 %cond0, label %for.cond, label %ret

for.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmpi = icmp slt i64 %i, %n
  br i1 %cmpi, label %for.body, label %ret

for.body:
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  %j.init = add nsw i64 %i, -1
  br label %while.cond

while.cond:
  %j = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %cmpj = icmp sge i64 %j, 0
  br i1 %cmpj, label %while.cmp, label %while.end

while.cmp:
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %gt = icmp sgt i32 %j.val, %key
  br i1 %gt, label %while.body, label %while.end

while.body:
  %jp1 = add nsw i64 %j, 1
  %jp1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1
  store i32 %j.val, i32* %jp1.ptr, align 4
  %j.dec = add nsw i64 %j, -1
  br label %while.cond

while.end:
  %j.final = phi i64 [ %j, %while.cond ], [ %j, %while.cmp ]
  %ins.pos = add nsw i64 %j.final, 1
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %ins.pos
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = add nuw nsw i64 %i, 1
  br label %for.cond

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 9
  store i32 0, i32* %p9, align 4
  call void @insertion_sort(i32* %p0, i64 10)
  br label %loop.cond

loop.cond:
  %i.loop = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %cmp.loop = icmp ult i64 %i.loop, 10
  br i1 %cmp.loop, label %loop.body, label %after.loop

loop.body:
  %elem.ptr = getelementptr inbounds i32, i32* %p0, i64 %i.loop
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i32 0, i32 0
  %callp = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  br label %loop.inc

loop.inc:
  %i.next = add nuw nsw i64 %i.loop, 1
  br label %loop.cond

after.loop:
  %callpc = call i32 @putchar(i32 10)
  ret i32 0
}