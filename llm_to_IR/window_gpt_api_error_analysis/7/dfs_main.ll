; ModuleID = 'dfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_pre = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @__main() {
entry:
  ret void
}

define void @dfs_visit(i32* %base, i64 %n, i64 %u, i8* %visited, i64* %out, i64* %out_len) {
entry:
  %vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %u
  %vis_val = load i8, i8* %vis_ptr, align 1
  %already = icmp ne i8 %vis_val, 0
  br i1 %already, label %ret, label %mark

mark:
  store i8 1, i8* %vis_ptr, align 1
  %len0 = load i64, i64* %out_len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len0
  store i64 %u, i64* %out_slot, align 8
  %len1 = add i64 %len0, 1
  store i64 %len1, i64* %out_len, align 8
  br label %loop

loop:
  %v = phi i64 [ 0, %mark ], [ %v.next, %loop_end ]
  %cond = icmp ult i64 %v, %n
  br i1 %cond, label %body, label %ret

body:
  %mul = mul i64 %u, %n
  %idx64 = add i64 %mul, %v
  %adj_ptr = getelementptr inbounds i32, i32* %base, i64 %idx64
  %adj_val = load i32, i32* %adj_ptr, align 4
  %has = icmp ne i32 %adj_val, 0
  br i1 %has, label %recurse, label %loop_end

recurse:
  call void @dfs_visit(i32* %base, i64 %n, i64 %v, i8* %visited, i64* %out, i64* %out_len)
  br label %loop_end

loop_end:
  %v.next = add i64 %v, 1
  br label %loop

ret:
  ret void
}

define void @dfs(i32* %base, i64 %n, i64 %start, i64* %out, i64* %out_len) {
entry:
  %visited = alloca i8, i64 %n, align 1
  br label %init

init:
  %i = phi i64 [ 0, %entry ], [ %i.next, %init_end ]
  %lt = icmp ult i64 %i, %n
  br i1 %lt, label %init_body, label %after_init

init_body:
  %p = getelementptr inbounds i8, i8* %visited, i64 %i
  store i8 0, i8* %p, align 1
  %i.next = add i64 %i, 1
  br label %init

after_init:
  call void @dfs_visit(i32* %base, i64 %n, i64 %start, i8* %visited, i64* %out, i64* %out_len)
  ret void

init_end:
  br label %init
}

define i32 @main() {
entry:
  call void @__main()
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %adj = alloca [49 x i32], align 16
  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)
  %base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %e1 = getelementptr inbounds i32, i32* %base, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %base, i64 2
  store i32 1, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %base, i64 7
  store i32 1, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %base, i64 10
  store i32 1, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %base, i64 11
  store i32 1, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %base, i64 14
  store i32 1, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %base, i64 19
  store i32 1, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %base, i64 22
  store i32 1, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %base, i64 29
  store i32 1, i32* %e9, align 4
  %e10 = getelementptr inbounds i32, i32* %base, i64 33
  store i32 1, i32* %e10, align 4
  %e11 = getelementptr inbounds i32, i32* %base, i64 37
  store i32 1, i32* %e11, align 4
  %e12 = getelementptr inbounds i32, i32* %base, i64 39
  store i32 1, i32* %e12, align 4
  %e13 = getelementptr inbounds i32, i32* %base, i64 41
  store i32 1, i32* %e13, align 4
  %e14 = getelementptr inbounds i32, i32* %base, i64 47
  store i32 1, i32* %e14, align 4
  %out = alloca [64 x i64], align 16
  %out_ptr = getelementptr inbounds [64 x i64], [64 x i64]* %out, i64 0, i64 0
  %out_len = alloca i64, align 8
  store i64 0, i64* %out_len, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  %nval = load i64, i64* %n, align 8
  %startval = load i64, i64* %start, align 8
  call void @dfs(i32* %base, i64 %nval, i64 %startval, i64* %out_ptr, i64* %out_len)
  %fmt = getelementptr inbounds [24 x i8], [24 x i8]* @.str_pre, i64 0, i64 0
  %startval2 = load i64, i64* %start, align 8
  %callhdr = call i32 (i8*, ...) @printf(i8* %fmt, i64 %startval2)
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i.cur = load i64, i64* %i, align 8
  %len = load i64, i64* %out_len, align 8
  %lt2 = icmp ult i64 %i.cur, %len
  br i1 %lt2, label %body, label %after

body:
  %i.next1 = add i64 %i.cur, 1
  %less = icmp ult i64 %i.next1, %len
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %less, i8* %space_ptr, i8* %empty_ptr
  %valptr = getelementptr inbounds i64, i64* %out_ptr, i64 %i.cur
  %val = load i64, i64* %valptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %callitem = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %suffix)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}