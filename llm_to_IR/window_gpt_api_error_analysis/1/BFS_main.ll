; ModuleID = 'bfs_win_msvc'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00"
@.str_elem = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.str_space = private unnamed_addr constant [2 x i8] c" \00"
@.str_empty = private unnamed_addr constant [1 x i8] c"\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @__main()

define void @bfs(i32* nocapture %adj, i64 %n, i64 %start, i64* nocapture %order_out, i64* nocapture %order_len_out, i32* nocapture %dist_out) {
entry:
  %visited = alloca i8, i64 %n, align 1
  %queue = alloca i64, i64 %n, align 8
  %i0 = alloca i64, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %olen = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  store i64 0, i64* %olen, align 8
  store i64 0, i64* %i0, align 8
  br label %init_loop

init_loop:                                        ; i from 0 to n-1: visited[i]=0; dist[i]=-1
  %i0v = load i64, i64* %i0, align 8
  %cmp0 = icmp slt i64 %i0v, %n
  br i1 %cmp0, label %init_body, label %init_done

init_body:
  %vptr = getelementptr inbounds i8, i8* %visited, i64 %i0v
  store i8 0, i8* %vptr, align 1
  %diptr = getelementptr inbounds i32, i32* %dist_out, i64 %i0v
  store i32 -1, i32* %diptr, align 4
  %i0next = add i64 %i0v, 1
  store i64 %i0next, i64* %i0, align 8
  br label %init_loop

init_done:
  %start_vis_ptr = getelementptr inbounds i8, i8* %visited, i64 %start
  store i8 1, i8* %start_vis_ptr, align 1
  %dstart_ptr = getelementptr inbounds i32, i32* %dist_out, i64 %start
  store i32 0, i32* %dstart_ptr, align 4
  %q0ptr = getelementptr inbounds i64, i64* %queue, i64 0
  store i64 %start, i64* %q0ptr, align 8
  store i64 1, i64* %tail, align 8
  br label %bfs_cond

bfs_cond:
  %headv = load i64, i64* %head, align 8
  %tailv = load i64, i64* %tail, align 8
  %has = icmp slt i64 %headv, %tailv
  br i1 %has, label %bfs_body, label %bfs_done

bfs_body:
  %qptr = getelementptr inbounds i64, i64* %queue, i64 %headv
  %v = load i64, i64* %qptr, align 8
  %headn = add i64 %headv, 1
  store i64 %headn, i64* %head, align 8
  %olenv = load i64, i64* %olen, align 8
  %ooptr = getelementptr inbounds i64, i64* %order_out, i64 %olenv
  store i64 %v, i64* %ooptr, align 8
  %olenn = add i64 %olenv, 1
  store i64 %olenn, i64* %olen, align 8
  %j = alloca i64, align 8
  store i64 0, i64* %j, align 8
  br label %nbr_loop

nbr_loop:
  %jv = load i64, i64* %j, align 8
  %cmpj = icmp slt i64 %jv, %n
  br i1 %cmpj, label %nbr_body, label %bfs_cond

nbr_body:
  %mul = mul i64 %v, %n
  %idx = add i64 %mul, %jv
  %aptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %aptr, align 4
  %has_edge = icmp ne i32 %aval, 0
  br i1 %has_edge, label %check_vis, label %next_j

check_vis:
  %vjptr = getelementptr inbounds i8, i8* %visited, i64 %jv
  %vj = load i8, i8* %vjptr, align 1
  %notvis = icmp eq i8 %vj, 0
  br i1 %notvis, label %enqueue, label %next_j

enqueue:
  store i8 1, i8* %vjptr, align 1
  %dvptr = getelementptr inbounds i32, i32* %dist_out, i64 %v
  %dvv = load i32, i32* %dvptr, align 4
  %dnew = add i32 %dvv, 1
  %duptr = getelementptr inbounds i32, i32* %dist_out, i64 %jv
  store i32 %dnew, i32* %duptr, align 4
  %tailc = load i64, i64* %tail, align 8
  %qdst = getelementptr inbounds i64, i64* %queue, i64 %tailc
  store i64 %jv, i64* %qdst, align 8
  %tailnn = add i64 %tailc, 1
  store i64 %tailnn, i64* %tail, align 8
  br label %next_j

next_j:
  %jnext = add i64 %jv, 1
  store i64 %jnext, i64* %j, align 8
  br label %nbr_loop

bfs_done:
  %final_olen = load i64, i64* %olen, align 8
  store i64 %final_olen, i64* %order_len_out, align 8
  ret void
}

define i32 @main() {
entry:
  call void @__main()
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %start = alloca i64, align 8
  store i64 0, i64* %start, align 8
  %adj = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  store i64 0, i64* %order_len, align 8
  %dist = alloca [7 x i32], align 16
  %adj_base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %zero_loop

zero_loop:
  %iv = load i64, i64* %i, align 8
  %cmp = icmp slt i64 %iv, 49
  br i1 %cmp, label %zero_body, label %zero_done

zero_body:
  %ptr = getelementptr inbounds i32, i32* %adj_base, i64 %iv
  store i32 0, i32* %ptr, align 4
  %inext = add i64 %iv, 1
  store i64 %inext, i64* %i, align 8
  br label %zero_loop

zero_done:
  ; Set undirected edges for graph:
  ; 0-1
  %e01a = getelementptr inbounds i32, i32* %adj_base, i64 1
  store i32 1, i32* %e01a, align 4
  %e01b = getelementptr inbounds i32, i32* %adj_base, i64 7
  store i32 1, i32* %e01b, align 4
  ; 0-2
  %e02a = getelementptr inbounds i32, i32* %adj_base, i64 2
  store i32 1, i32* %e02a, align 4
  %e02b = getelementptr inbounds i32, i32* %adj_base, i64 14
  store i32 1, i32* %e02b, align 4
  ; 1-3
  %e13a = getelementptr inbounds i32, i32* %adj_base, i64 10
  store i32 1, i32* %e13a, align 4
  %e13b = getelementptr inbounds i32, i32* %adj_base, i64 22
  store i32 1, i32* %e13b, align 4
  ; 1-4
  %e14a = getelementptr inbounds i32, i32* %adj_base, i64 11
  store i32 1, i32* %e14a, align 4
  %e14b = getelementptr inbounds i32, i32* %adj_base, i64 29
  store i32 1, i32* %e14b, align 4
  ; 2-5
  %e25a = getelementptr inbounds i32, i32* %adj_base, i64 19
  store i32 1, i32* %e25a, align 4
  %e25b = getelementptr inbounds i32, i32* %adj_base, i64 37
  store i32 1, i32* %e25b, align 4
  ; 4-5
  %e45a = getelementptr inbounds i32, i32* %adj_base, i64 33
  store i32 1, i32* %e45a, align 4
  %e45b = getelementptr inbounds i32, i32* %adj_base, i64 39
  store i32 1, i32* %e45b, align 4
  ; 5-6
  %e56a = getelementptr inbounds i32, i32* %adj_base, i64 41
  store i32 1, i32* %e56a, align 4
  %e56b = getelementptr inbounds i32, i32* %adj_base, i64 47
  store i32 1, i32* %e56b, align 4

  %order_base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %dist_base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %nval = load i64, i64* %n, align 8
  %startv = load i64, i64* %start, align 8
  call void @bfs(i32* %adj_base, i64 %nval, i64 %startv, i64* %order_base, i64* %order_len, i32* %dist_base)

  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %fmt_bfs_i8 = bitcast i8* %fmt_bfs to i8*
  %call0 = call i32 (i8*, ...) @printf(i8* %fmt_bfs_i8, i64 %startv)

  %len = load i64, i64* %order_len, align 8
  %k = alloca i64, align 8
  store i64 0, i64* %k, align 8
  br label %print_loop

print_loop:
  %kv = load i64, i64* %k, align 8
  %cmpk = icmp slt i64 %kv, %len
  br i1 %cmpk, label %print_body, label %after_print

print_body:
  %kp1 = add i64 %kv, 1
  %spc_cond = icmp slt i64 %kp1, %len
  %space_ptr = select i1 %spc_cond, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  %oval_ptr = getelementptr inbounds i64, i64* %order_base, i64 %kv
  %oval = load i64, i64* %oval_ptr, align 8
  %fmt_elem = getelementptr inbounds [6 x i8], [6 x i8]* @.str_elem, i64 0, i64 0
  %fmt_elem_i8 = bitcast i8* %fmt_elem to i8*
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt_elem_i8, i64 %oval, i8* %space_ptr)
  %knext = add i64 %kv, 1
  store i64 %knext, i64* %k, align 8
  br label %print_loop

after_print:
  %nl = call i32 @putchar(i32 10)

  %m = alloca i64, align 8
  store i64 0, i64* %m, align 8
  br label %dist_loop

dist_loop:
  %mv = load i64, i64* %m, align 8
  %cmpm = icmp slt i64 %mv, %nval
  br i1 %cmpm, label %dist_body, label %ret

dist_body:
  %dptr = getelementptr inbounds i32, i32* %dist_base, i64 %mv
  %dval = load i32, i32* %dptr, align 4
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %fmt_dist_i8 = bitcast i8* %fmt_dist to i8*
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt_dist_i8, i64 %startv, i64 %mv, i32 %dval)
  %mnext = add i64 %mv, 1
  store i64 %mnext, i64* %m, align 8
  br label %dist_loop

ret:
  ret i32 0
}