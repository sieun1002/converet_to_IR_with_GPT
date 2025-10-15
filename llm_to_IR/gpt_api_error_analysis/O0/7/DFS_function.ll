; ModuleID = 'dfs_preorder'
target triple = "x86_64-pc-linux-gnu"

@.str.format = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str.item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dfs_visit(i32* %A, i64 %n, i64 %u, i1* %visited, i64* %out, i64* %len) local_unnamed_addr {
entry:
  %visited_ptr = getelementptr inbounds i1, i1* %visited, i64 %u
  %visited_val = load i1, i1* %visited_ptr, align 1
  %is_visited = icmp ne i1 %visited_val, 0
  br i1 %is_visited, label %ret, label %mark

mark:
  store i1 1, i1* %visited_ptr, align 1
  %len_cur = load i64, i64* %len, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %len_cur
  store i64 %u, i64* %out_slot, align 8
  %len_next = add i64 %len_cur, 1
  store i64 %len_next, i64* %len, align 8
  %v = alloca i64, align 8
  store i64 0, i64* %v, align 8
  br label %loop.cond

loop.cond:
  %v_cur = load i64, i64* %v, align 8
  %cmp_end = icmp ult i64 %v_cur, %n
  br i1 %cmp_end, label %loop.body, label %ret

loop.body:
  %un = mul i64 %u, %n
  %idx_flat = add i64 %un, %v_cur
  %a_ptr = getelementptr inbounds i32, i32* %A, i64 %idx_flat
  %a_val = load i32, i32* %a_ptr, align 4
  %has_edge = icmp ne i32 %a_val, 0
  br i1 %has_edge, label %recurse, label %inc

recurse:
  call void @dfs_visit(i32* %A, i64 %n, i64 %v_cur, i1* %visited, i64* %out, i64* %len)
  br label %inc

inc:
  %v_next = add i64 %v_cur, 1
  store i64 %v_next, i64* %v, align 8
  br label %loop.cond

ret:
  ret void
}

define void @dfs(i32* %A, i64 %n, i64 %start, i64* %out, i64* %len) local_unnamed_addr {
entry:
  %visited = alloca i1, i64 %n, align 1
  %visited.i8 = bitcast i1* %visited to i8*
  %n_bytes = trunc i64 %n to i64
  call void @llvm.memset.p0i8.i64(i8* %visited.i8, i8 0, i64 %n_bytes, i1 false)
  call void @dfs_visit(i32* %A, i64 %n, i64 %start, i1* %visited, i64* %out, i64* %len)
  ret void
}

define i32 @main() local_unnamed_addr {
entry:
  %A = alloca [49 x i32], align 16
  %order = alloca [49 x i64], align 16
  %len = alloca i64, align 8
  %i = alloca i64, align 8
  %A.base = getelementptr inbounds [49 x i32], [49 x i32]* %A, i64 0, i64 0
  %order.base = getelementptr inbounds [49 x i64], [49 x i64]* %order, i64 0, i64 0
  %A.i8 = bitcast i32* %A.base to i8*
  call void @llvm.memset.p0i8.i64(i8* %A.i8, i8 0, i64 196, i1 false)
  %idx7 = getelementptr inbounds i32, i32* %A.base, i64 7
  store i32 1, i32* %idx7, align 4
  %idx14 = getelementptr inbounds i32, i32* %A.base, i64 14
  store i32 1, i32* %idx14, align 4
  %idx10 = getelementptr inbounds i32, i32* %A.base, i64 10
  store i32 1, i32* %idx10, align 4
  %idx22 = getelementptr inbounds i32, i32* %A.base, i64 22
  store i32 1, i32* %idx22, align 4
  %idx11 = getelementptr inbounds i32, i32* %A.base, i64 11
  store i32 1, i32* %idx11, align 4
  %idx29 = getelementptr inbounds i32, i32* %A.base, i64 29
  store i32 1, i32* %idx29, align 4
  %idx19 = getelementptr inbounds i32, i32* %A.base, i64 19
  store i32 1, i32* %idx19, align 4
  %idx37 = getelementptr inbounds i32, i32* %A.base, i64 37
  store i32 1, i32* %idx37, align 4
  %idx33 = getelementptr inbounds i32, i32* %A.base, i64 33
  store i32 1, i32* %idx33, align 4
  %idx39 = getelementptr inbounds i32, i32* %A.base, i64 39
  store i32 1, i32* %idx39, align 4
  %idx41 = getelementptr inbounds i32, i32* %A.base, i64 41
  store i32 1, i32* %idx41, align 4
  %idx47 = getelementptr inbounds i32, i32* %A.base, i64 47
  store i32 1, i32* %idx47, align 4
  store i64 0, i64* %len, align 8
  %n.const = add i64 0, 7
  %start.const = add i64 0, 0
  call void @dfs(i32* %A.base, i64 %n.const, i64 %start.const, i64* %order.base, i64* %len)
  %fmt.ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str.format, i64 0, i64 0
  %pr0 = call i32 (i8*, ...) @printf(i8* %fmt.ptr, i64 %start.const)
  store i64 0, i64* %i, align 8
  br label %loop.check

loop.check:
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %lt = icmp ult i64 %i.cur, %len.cur
  br i1 %lt, label %loop.body, label %after.loop

loop.body:
  %ip1 = add i64 %i.cur, 1
  %lt2 = icmp ult i64 %ip1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep = select i1 %lt2, i8* %space.ptr, i8* %empty.ptr
  %val.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur
  %val = load i64, i64* %val.ptr, align 8
  %item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.item, i64 0, i64 0
  %pr1 = call i32 (i8*, ...) @printf(i8* %item.ptr, i64 %val, i8* %sep)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.check

after.loop:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}