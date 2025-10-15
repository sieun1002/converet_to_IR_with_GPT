; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @quick_sort(i32* %a, i32 %l, i32 %r) {
entry:
  %cmp = icmp sge i32 %l, %r
  br i1 %cmp, label %ret, label %body

body:
  %i = alloca i32, align 4
  %j = alloca i32, align 4
  %key = alloca i32, align 4
  store i32 %l, i32* %i, align 4
  %li = load i32, i32* %i, align 4
  %li1 = add i32 %li, 1
  store i32 %li1, i32* %i, align 4
  br label %for.cond

for.cond:
  %i.val = load i32, i32* %i, align 4
  %cmp_i_r = icmp sle i32 %i.val, %r
  br i1 %cmp_i_r, label %for.body, label %ret

for.body:
  %idx_i_sext = sext i32 %i.val to i64
  %ptr_ai = getelementptr inbounds i32, i32* %a, i64 %idx_i_sext
  %val_ai = load i32, i32* %ptr_ai, align 4
  store i32 %val_ai, i32* %key, align 4
  %i_minus1 = add i32 %i.val, -1
  store i32 %i_minus1, i32* %j, align 4
  br label %while.cond

while.cond:
  %j.val = load i32, i32* %j, align 4
  %cmp_j_l = icmp sge i32 %j.val, %l
  br i1 %cmp_j_l, label %check.swap, label %insert

check.swap:
  %j.sext = sext i32 %j.val to i64
  %ptr_aj = getelementptr inbounds i32, i32* %a, i64 %j.sext
  %val_aj = load i32, i32* %ptr_aj, align 4
  %key.val = load i32, i32* %key, align 4
  %cmp_gt = icmp sgt i32 %val_aj, %key.val
  br i1 %cmp_gt, label %do.swap, label %insert

do.swap:
  %jplus1 = add i32 %j.val, 1
  %jplus1.sext = sext i32 %jplus1 to i64
  %ptr_aj1 = getelementptr inbounds i32, i32* %a, i64 %jplus1.sext
  store i32 %val_aj, i32* %ptr_aj1, align 4
  %j.dec = add i32 %j.val, -1
  store i32 %j.dec, i32* %j, align 4
  br label %while.cond

insert:
  %j2 = load i32, i32* %j, align 4
  %j2plus1 = add i32 %j2, 1
  %j2plus1.sext = sext i32 %j2plus1 to i64
  %ptr_aj1b = getelementptr inbounds i32, i32* %a, i64 %j2plus1.sext
  %key2 = load i32, i32* %key, align 4
  store i32 %key2, i32* %ptr_aj1b, align 4
  %i.val2 = load i32, i32* %i, align 4
  %i.inc = add i32 %i.val2, 1
  store i32 %i.inc, i32* %i, align 4
  br label %for.cond

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %n = alloca i64, align 8
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  store i64 10, i64* %n, align 8
  %n.val = load i64, i64* %n, align 8
  %cmp_n_le1 = icmp ule i64 %n.val, 1
  br i1 %cmp_n_le1, label %after.sort, label %do.sort

do.sort:
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %n.val2 = load i64, i64* %n, align 8
  %n.minus1 = add i64 %n.val2, -1
  %r32 = trunc i64 %n.minus1 to i32
  call void @quick_sort(i32* %arr.base, i32 0, i32 %r32)
  br label %after.sort

after.sort:
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %n.val3 = load i64, i64* %n, align 8
  %cmp_i_n = icmp ult i64 %i.val, %n.val3
  br i1 %cmp_i_n, label %loop.body, label %after.loop

loop.body:
  %arr.base2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %elem.ptr = getelementptr inbounds i32, i32* %arr.base2, i64 %i.val
  %elem = load i32, i32* %elem.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i32 %elem)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.cond

after.loop:
  %putc = call i32 @putchar(i32 10)
  ret i32 0
}