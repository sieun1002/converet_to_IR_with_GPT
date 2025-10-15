; ModuleID: fixed_module
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)

define dso_local void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %outer_init

outer_init:
  br label %outer

outer:
  %i = phi i64 [ 0, %outer_init ], [ %i_next, %outer_after ]
  %cmp_outer = icmp ult i64 %i, %n
  br i1 %cmp_outer, label %inner_init, label %ret

inner_init:
  %j0 = add i64 %i, 1
  br label %inner

inner:
  %j = phi i64 [ %j0, %inner_init ], [ %j_next, %inner_after ]
  %cmp_inner = icmp ult i64 %j, %n
  br i1 %cmp_inner, label %inner_body, label %outer_after

inner_body:
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j
  %vi = load i32, i32* %pi, align 4
  %vj = load i32, i32* %pj, align 4
  %gt = icmp sgt i32 %vi, %vj
  br i1 %gt, label %do_swap, label %inner_after

do_swap:
  store i32 %vj, i32* %pi, align 4
  store i32 %vi, i32* %pj, align 4
  br label %inner_after

inner_after:
  %j_next = add i64 %j, 1
  br label %inner

outer_after:
  %i_next = add i64 %i, 1
  br label %outer

ret:
  ret void
}

define dso_local i32 @main() {
entry:
  %arr = alloca [10 x i32], align 16
  %len = alloca i64, align 8
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
  store i64 10, i64* %len, align 8
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i32 0, i32 0
  %nval = load i64, i64* %len, align 8
  call void @merge_sort(i32* %arr_base, i64 %nval)
  br label %loop

loop:
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %ncur = phi i64 [ %nval, %entry ], [ %nval, %body ]
  %cond = icmp ult i64 %i, %ncur
  br i1 %cond, label %body, label %after

body:
  %eptr = getelementptr inbounds i32, i32* %arr_base, i64 %i
  %eval = load i32, i32* %eptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i32 0, i32 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %eval)
  %inc = add i64 %i, 1
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}