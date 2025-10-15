; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dllimport i32 @printf(i8*, ...)
declare dllimport i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @insertion_sort(i32* %arr, i64 %n) {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp slt i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %i.gep = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %i.gep, align 4
  %j.init = add i64 %i, -1
  br label %while.cond

while.cond:                                       ; preds = %while.body, %for.body
  %j.cur = phi i64 [ %j.init, %for.body ], [ %j.dec, %while.body ]
  %j.nonneg = icmp sge i64 %j.cur, 0
  br i1 %j.nonneg, label %check, label %while.end

check:                                            ; preds = %while.cond
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %j.val = load i32, i32* %j.ptr, align 4
  %gt = icmp sgt i32 %j.val, %key
  br i1 %gt, label %while.body, label %while.end

while.body:                                       ; preds = %check
  %jp1 = add i64 %j.cur, 1
  %jp1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jp1
  store i32 %j.val, i32* %jp1.ptr, align 4
  %j.dec = add i64 %j.cur, -1
  br label %while.cond

while.end:                                        ; preds = %check, %while.cond
  %j.final = phi i64 [ %j.cur, %while.cond ], [ %j.cur, %check ]
  %j1 = add i64 %j.final, 1
  %dest = getelementptr inbounds i32, i32* %arr, i64 %j1
  store i32 %key, i32* %dest, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %arr0, i64 0
  store i32 9, i32* %p0, align 4
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
  %n = alloca i64, align 8
  store i64 10, i64* %n, align 8
  %n.val = load i64, i64* %n, align 8
  call void @insertion_sort(i32* %arr0, i64 %n.val)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %lt = icmp ult i64 %i.cur, %n.cur
  br i1 %lt, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i.cur
  %elem = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmtptr, i32 %elem)
  %inc = add i64 %i.cur, 1
  store i64 %inc, i64* %i, align 8
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %pc = call i32 @putchar(i32 10)
  ret i32 0
}