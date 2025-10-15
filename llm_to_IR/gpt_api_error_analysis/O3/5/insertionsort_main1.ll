; ModuleID = 'insertion_sort_main'
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 16
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 8, i32* %p2, align 8
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 16
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 5, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 8
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 16
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4
  br label %outer.cond

outer.cond:
  %i = phi i32 [ 1, %entry ], [ %i.next, %outer.inc ]
  %cmp.i = icmp slt i32 %i, 10
  br i1 %cmp.i, label %outer.body, label %print.init

outer.body:
  %i64 = sext i32 %i to i64
  %pi = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
  %key = load i32, i32* %pi, align 4
  %j0 = add nsw i32 %i, -1
  br label %inner.cond

inner.cond:
  %j = phi i32 [ %j0, %outer.body ], [ %j.next, %inner.shift ]
  %j.nonneg = icmp sge i32 %j, 0
  br i1 %j.nonneg, label %inner.check, label %inner.exit

inner.check:
  %j64 = sext i32 %j to i64
  %pj = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j64
  %aj = load i32, i32* %pj, align 4
  %gt = icmp sgt i32 %aj, %key
  br i1 %gt, label %inner.shift, label %inner.exit

inner.shift:
  %j1 = add nsw i32 %j, 1
  %j1.64 = sext i32 %j1 to i64
  %pj1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %j1.64
  store i32 %aj, i32* %pj1, align 4
  %j.next = add nsw i32 %j, -1
  br label %inner.cond

inner.exit:
  %j.exit = phi i32 [ %j, %inner.cond ], [ %j, %inner.check ]
  %ins = add nsw i32 %j.exit, 1
  %ins64 = sext i32 %ins to i64
  %pins = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %ins64
  store i32 %key, i32* %pins, align 4
  br label %outer.inc

outer.inc:
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

print.init:
  br label %print.loop

print.loop:
  %k = phi i32 [ 0, %print.init ], [ %k.next, %print.body ]
  %k.cmp = icmp slt i32 %k, 10
  br i1 %k.cmp, label %print.body, label %ret

print.body:
  %k64 = sext i32 %k to i64
  %pk = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %k64
  %vk = load i32, i32* %pk, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %vk)
  %k.next = add nuw nsw i32 %k, 1
  br label %print.loop

ret:
  %fmtnl = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtnl)
  ret i32 0
}