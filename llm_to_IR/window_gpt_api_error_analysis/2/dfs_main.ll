; ModuleID = 'dfs_module'
source_filename = "dfs_module.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@.str_format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

@adj7 = internal constant [49 x i8] [
  i8 0, i8 1, i8 1, i8 0, i8 0, i8 0, i8 0,
  i8 1, i8 0, i8 0, i8 1, i8 1, i8 0, i8 0,
  i8 1, i8 0, i8 0, i8 0, i8 0, i8 1, i8 0,
  i8 0, i8 1, i8 0, i8 0, i8 0, i8 0, i8 0,
  i8 0, i8 1, i8 0, i8 0, i8 0, i8 1, i8 0,
  i8 0, i8 0, i8 1, i8 0, i8 1, i8 0, i8 1,
  i8 0, i8 0, i8 0, i8 0, i8 0, i8 1, i8 0
], align 1

declare dso_local i32 @printf(i8* noundef, ...)
declare dso_local i32 @putchar(i32 noundef)

define internal void @dfs_visit(i64 %n, i8* %adj, i64 %v, i8* %visited, i64* %out, i64* %out_len) {
entry:
  %v_ptr = getelementptr inbounds i8, i8* %visited, i64 %v
  store i8 1, i8* %v_ptr, align 1
  %cur_len = load i64, i64* %out_len, align 8
  %out_pos_ptr = getelementptr inbounds i64, i64* %out, i64 %cur_len
  store i64 %v, i64* %out_pos_ptr, align 8
  %inc_len = add i64 %cur_len, 1
  store i64 %inc_len, i64* %out_len, align 8
  br label %for.cond

for.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp slt i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:
  %mul1 = mul i64 %v, %n
  %off = add i64 %mul1, %i
  %cell_ptr = getelementptr inbounds i8, i8* %adj, i64 %off
  %cell = load i8, i8* %cell_ptr, align 1
  %has_edge = icmp ne i8 %cell, 0
  br i1 %has_edge, label %check.vis, label %for.inc

check.vis:
  %vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %i
  %vis_val = load i8, i8* %vis_ptr, align 1
  %not_vis = icmp eq i8 %vis_val, 0
  br i1 %not_vis, label %recurse, label %for.inc

recurse:
  call void @dfs_visit(i64 %n, i8* %adj, i64 %i, i8* %visited, i64* %out, i64* %out_len)
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:
  ret void
}

define dso_local void @dfs(i64 %n, i8* %adj, i64 %start, i64* %out, i64* %out_len) {
entry:
  store i64 0, i64* %out_len, align 8
  %visited = alloca i8, i64 %n, align 1
  br label %z.cond

z.cond:
  %zi = phi i64 [ 0, %entry ], [ %zi.next, %z.inc ]
  %zcmp = icmp slt i64 %zi, %n
  br i1 %zcmp, label %z.body, label %z.end

z.body:
  %zptr = getelementptr inbounds i8, i8* %visited, i64 %zi
  store i8 0, i8* %zptr, align 1
  br label %z.inc

z.inc:
  %zi.next = add i64 %zi, 1
  br label %z.cond

z.end:
  call void @dfs_visit(i64 %n, i8* %adj, i64 %start, i8* %visited, i64* %out, i64* %out_len)
  ret void
}

define dso_local i32 @main() {
entry:
  %out.arr = alloca [7 x i64], align 16
  %out.len = alloca i64, align 8
  %out.base = getelementptr inbounds [7 x i64], [7 x i64]* %out.arr, i64 0, i64 0
  %adj.ptr = getelementptr inbounds [49 x i8], [49 x i8]* @adj7, i64 0, i64 0
  call void @dfs(i64 7, i8* %adj.ptr, i64 0, i64* %out.base, i64* %out.len)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_format, i64 0, i64 0
  %print1 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 0)
  store i64 0, i64* %out.len, align 8
  call void @dfs(i64 7, i8* %adj.ptr, i64 0, i64* %out.base, i64* %out.len)
  br label %loop.cond

loop.cond:
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop.inc ]
  %len = load i64, i64* %out.len, align 8
  %cond = icmp slt i64 %i, %len
  br i1 %cond, label %loop.body, label %loop.end

loop.body:
  %ip1 = add i64 %i, 1
  %len2 = load i64, i64* %out.len, align 8
  %has_more = icmp ult i64 %ip1, %len2
  br i1 %has_more, label %sep.space, label %sep.empty

sep.space:
  %sp = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %print.elem

sep.empty:
  %emp = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %print.elem

print.elem:
  %sep = phi i8* [ %sp, %sep.space ], [ %emp, %sep.empty ]
  %val.ptr = getelementptr inbounds i64, i64* %out.base, i64 %i
  %val = load i64, i64* %val.ptr, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %print2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %val, i8* %sep)
  br label %loop.inc

loop.inc:
  %i.next = add i64 %i, 1
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}