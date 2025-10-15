; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @__main() {
entry:
  ret void
}

define void @bubble_sort(i32* %arr, i64 %len) {
entry:
  %cmp_len = icmp sgt i64 %len, 1
  br i1 %cmp_len, label %outer_init, label %ret

outer_init:
  %i = phi i64 [ 0, %entry ], [ %i_next, %outer_latch ]
  %tmp1 = sub i64 %len, 1
  %last = sub i64 %tmp1, %i
  %has_inner = icmp sgt i64 %last, 0
  br i1 %has_inner, label %inner, label %outer_latch

inner:
  %j = phi i64 [ 0, %outer_init ], [ %j_next, %after ]
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j
  %vj = load i32, i32* %pj, align 4
  %j1 = add i64 %j, 1
  %pj1 = getelementptr inbounds i32, i32* %arr, i64 %j1
  %vj1 = load i32, i32* %pj1, align 4
  %cmp = icmp sgt i32 %vj, %vj1
  br i1 %cmp, label %swap, label %noswap

swap:
  store i32 %vj, i32* %pj1, align 4
  store i32 %vj1, i32* %pj, align 4
  br label %after

noswap:
  br label %after

after:
  %j_next = add i64 %j, 1
  %cont = icmp slt i64 %j_next, %last
  br i1 %cont, label %inner, label %outer_latch

outer_latch:
  %i_next = add i64 %i, 1
  %conti = icmp slt i64 %i_next, %len
  br i1 %conti, label %outer_init, label %ret

ret:
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %arr = alloca [10 x i32], align 16
  %i = alloca i64, align 8
  %len = alloca i64, align 8
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %idx0 = getelementptr inbounds i32, i32* %base, i64 0
  store i32 9, i32* %idx0, align 4
  %idx1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 5, i32* %idx2, align 4
  %idx3 = getelementptr inbounds i32, i32* %base, i64 3
  store i32 3, i32* %idx3, align 4
  %idx4 = getelementptr inbounds i32, i32* %base, i64 4
  store i32 7, i32* %idx4, align 4
  %idx5 = getelementptr inbounds i32, i32* %base, i64 5
  store i32 2, i32* %idx5, align 4
  %idx6 = getelementptr inbounds i32, i32* %base, i64 6
  store i32 8, i32* %idx6, align 4
  %idx7 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 6, i32* %idx7, align 4
  %idx8 = getelementptr inbounds i32, i32* %base, i64 8
  store i32 4, i32* %idx8, align 4
  %idx9 = getelementptr inbounds i32, i32* %base, i64 9
  store i32 0, i32* %idx9, align 4
  store i64 10, i64* %len, align 8
  %lenv = load i64, i64* %len, align 8
  call void @bubble_sort(i32* %base, i64 %lenv)
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %iv = load i64, i64* %i, align 8
  %lenv2 = load i64, i64* %len, align 8
  %cond = icmp ult i64 %iv, %lenv2
  br i1 %cond, label %body, label %afterloop

body:
  %elem_ptr = getelementptr inbounds i32, i32* %base, i64 %iv
  %elem = load i32, i32* %elem_ptr, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i8*, ...) @printf(i8* %fmt, i32 %elem)
  %iv_next = add i64 %iv, 1
  store i64 %iv_next, i64* %i, align 8
  br label %loop

afterloop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}