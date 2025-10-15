; ModuleID = 'dfs_module'
source_filename = "dfs_module"
target triple = "x86_64-pc-windows-msvc"

@.str_fmt = private unnamed_addr constant [24 x i8] c"DFS preorder from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1

declare dso_local i32 @__main()
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local void @dfs_visit(i64 %n, i64 %u, i64* %out, i64* %outCount, i32* %adj, i8* %visited) {
entry:
  %vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %u
  %vis_val = load i8, i8* %vis_ptr, align 1
  %already = icmp ne i8 %vis_val, 0
  br i1 %already, label %ret, label %mark

mark:
  store i8 1, i8* %vis_ptr, align 1
  %cnt_cur = load i64, i64* %outCount, align 8
  %out_slot = getelementptr inbounds i64, i64* %out, i64 %cnt_cur
  store i64 %u, i64* %out_slot, align 8
  %cnt_next = add i64 %cnt_cur, 1
  store i64 %cnt_next, i64* %outCount, align 8
  br label %loop

loop:
  %v = phi i64 [ 0, %mark ], [ %v_next, %loop_cont ]
  %cmp = icmp ult i64 %v, %n
  br i1 %cmp, label %loop_body, label %ret

loop_body:
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %edge_ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge_val = load i32, i32* %edge_ptr, align 4
  %has_edge = icmp ne i32 %edge_val, 0
  br i1 %has_edge, label %recurse, label %loop_cont

recurse:
  call void @dfs_visit(i64 %n, i64 %v, i64* %out, i64* %outCount, i32* %adj, i8* %visited)
  br label %loop_cont

loop_cont:
  %v_next = add i64 %v, 1
  br label %loop

ret:
  ret void
}

define dso_local void @dfs(i64 %n, i64 %start, i64* %out, i64* %outCount, i32* %adj) {
entry:
  %visited = alloca i8, i64 %n, align 1
  %visited_i8 = bitcast i8* %visited to i8*
  call void @llvm.memset.p0i8.i64(i8* %visited_i8, i8 0, i64 %n, i1 false)
  call void @dfs_visit(i64 %n, i64 %start, i64* %out, i64* %outCount, i32* %adj, i8* %visited)
  ret void
}

define dso_local i32 @main() {
entry:
  %call_main = call i32 @__main()
  %adj = alloca [49 x i32], align 16
  %out = alloca [7 x i64], align 16
  %outCount = alloca i64, align 8
  store i64 0, i64* %outCount, align 8
  %adj_base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %adj_bytes = bitcast i32* %adj_base to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_bytes, i8 0, i64 196, i1 false)

  ; Set edges according to the disassembly-derived indices
  %p7 = getelementptr inbounds i32, i32* %adj_base, i64 7
  store i32 1, i32* %p7, align 4
  %p14 = getelementptr inbounds i32, i32* %adj_base, i64 14
  store i32 1, i32* %p14, align 4
  %p10 = getelementptr inbounds i32, i32* %adj_base, i64 10
  store i32 1, i32* %p10, align 4
  %p22 = getelementptr inbounds i32, i32* %adj_base, i64 22
  store i32 1, i32* %p22, align 4
  %p11 = getelementptr inbounds i32, i32* %adj_base, i64 11
  store i32 1, i32* %p11, align 4
  %p29 = getelementptr inbounds i32, i32* %adj_base, i64 29
  store i32 1, i32* %p29, align 4
  %p19 = getelementptr inbounds i32, i32* %adj_base, i64 19
  store i32 1, i32* %p19, align 4
  %p37 = getelementptr inbounds i32, i32* %adj_base, i64 37
  store i32 1, i32* %p37, align 4
  %p33 = getelementptr inbounds i32, i32* %adj_base, i64 33
  store i32 1, i32* %p33, align 4
  %p39 = getelementptr inbounds i32, i32* %adj_base, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %adj_base, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %adj_base, i64 47
  store i32 1, i32* %p47, align 4

  %out_base = getelementptr inbounds [7 x i64], [7 x i64]* %out, i64 0, i64 0

  %fmt1 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_fmt, i64 0, i64 0
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %spc = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %emp = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0

  %n = add i64 0, 7
  %start = add i64 0, 0

  call void @dfs(i64 %n, i64 %start, i64* %out_base, i64* %outCount, i32* %adj_base)

  %print1 = call i32 (i8*, ...) @printf(i8* %fmt1, i64 %start)

  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %loop

loop:
  %i_val = load i64, i64* %i, align 8
  %cnt = load i64, i64* %outCount, align 8
  %cmp_loop = icmp ult i64 %i_val, %cnt
  br i1 %cmp_loop, label %body, label %after

body:
  %i_next1 = add i64 %i_val, 1
  %more = icmp ult i64 %i_next1, %cnt
  %sep = select i1 %more, i8* %spc, i8* %emp
  %out_elem_ptr = getelementptr inbounds i64, i64* %out_base, i64 %i_val
  %out_elem = load i64, i64* %out_elem_ptr, align 8
  %print2 = call i32 (i8*, ...) @printf(i8* %fmt2, i64 %out_elem, i8* %sep)
  %i_inc = add i64 %i_val, 1
  store i64 %i_inc, i64* %i, align 8
  br label %loop

after:
  %nl = call i32 @putchar(i32 10)
  ret i32 0
}