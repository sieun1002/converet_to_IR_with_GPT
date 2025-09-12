; ModuleID = 'bfs_from_ida.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  ; allocas
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue_ptr = alloca i64*, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %ordcnt = alloca i64, align 8

  ; zero adjacency
  %adj.i8 = bitcast [7 x [7 x i32]]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  ; set edges (undirected)
  ; 0-1, 0-2
  %a001 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  store i32 1, i32* %a001, align 4
  %a002 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 1, i32* %a002, align 4
  %a010 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  store i32 1, i32* %a010, align 4
  %a020 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 1, i32* %a020, align 4

  ; 1-3, 1-4
  %a013 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 3
  store i32 1, i32* %a013, align 4
  %a014 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 4
  store i32 1, i32* %a014, align 4
  %a031 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 1, i32* %a031, align 4
  %a041 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 1, i32* %a041, align 4

  ; 2-5
  %a025 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 1, i32* %a025, align 4
  %a052 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 1, i32* %a052, align 4

  ; 4-5
  %a045 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 1, i32* %a045, align 4
  %a054 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  store i32 1, i32* %a054, align 4

  ; 5-6
  %a056 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 1, i32* %a056, align 4
  %a065 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 1, i32* %a065, align 4

  ; dist = -1
  %dist.i8 = bitcast [7 x i32]* %dist to i8*
  call void @llvm.memset.p0i8.i64(i8* %dist.i8, i8 -1, i64 28, i1 false)

  ; order_count = 0; head = 0; tail = 0
  store i64 0, i64* %ordcnt, align 8
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8

  ; queue = malloc(56)
  %qraw = call i8* @malloc(i64 56)
  %q = bitcast i8* %qraw to i64*
  store i64* %q, i64** %queue_ptr, align 8
  %qnull = icmp eq i64* %q, null
  br i1 %qnull, label %after_bfs_fail, label %bfs_init

bfs_init:
  ; queue[0] = 0
  %q0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 0, i64* %q0, align 8
  ; tail = 1
  store i64 1, i64* %tail, align 8
  ; dist[0] = 0
  %d0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0, align 4

  br label %bfs_loop

bfs_loop:
  ; while (head < tail)
  %h = load i64, i64* %head, align 8
  %t = load i64, i64* %tail, align 8
  %cond = icmp ult i64 %h, %t
  br i1 %cond, label %bfs_pop, label %bfs_done

bfs_pop:
  ; u = queue[head]; head++
  %qptr = load i64*, i64** %queue_ptr, align 8
  %qu = getelementptr inbounds i64, i64* %qptr, i64 %h
  %u = load i64, i64* %qu, align 8
  %h1 = add i64 %h, 1
  store i64 %h1, i64* %head, align 8

  ; order[ordcnt++] = u
  %k = load i64, i64* %ordcnt, align 8
  %ordk = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %k
  store i64 %u, i64* %ordk, align 8
  %k1 = add i64 %k, 1
  store i64 %k1, i64* %ordcnt, align 8

  ; for v = 0..6
  %v = alloca i64, align 8
  store i64 0, i64* %v, align 8
  br label %for_v

for_v:
  %vc = load i64, i64* %v, align 8
  %vcond = icmp ult i64 %vc, 7
  br i1 %vcond, label %check_edge, label %bfs_loop

check_edge:
  ; if adj[u][v] && dist[v] == -1
  %au = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %u, i64 %vc
  %a_uv = load i32, i32* %au, align 4
  %has = icmp ne i32 %a_uv, 0
  br i1 %has, label %check_unseen, label %next_v

check_unseen:
  %dv = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %vc
  %dvv = load i32, i32* %dv, align 4
  %unseen = icmp eq i32 %dvv, -1
  br i1 %unseen, label %enqueue, label %next_v

enqueue:
  ; queue[tail] = v
  %tcur = load i64, i64* %tail, align 8
  %qptr2 = load i64*, i64** %queue_ptr, align 8
  %qdst = getelementptr inbounds i64, i64* %qptr2, i64 %tcur
  store i64 %vc, i64* %qdst, align 8
  ; tail++
  %tinc = add i64 %tcur, 1
  store i64 %tinc, i64* %tail, align 8
  ; dist[v] = dist[u] + 1
  %du = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u
  %duv = load i32, i32* %du, align 4
  %du1 = add nsw i32 %duv, 1
  store i32 %du1, i32* %dv, align 4
  br label %next_v

next_v:
  %vnext = add i64 %vc, 1
  store i64 %vnext, i64* %v, align 8
  br label %for_v

bfs_done:
  ; free(queue)
  %qfin = load i64*, i64** %queue_ptr, align 8
  %qfin8 = bitcast i64* %qfin to i8*
  call void @free(i8* %qfin8)
  br label %after_bfs

after_bfs_fail:
  ; malloc failed: no BFS, keep dist as all -1 (no dist[0]=0)
  br label %after_bfs

after_bfs:
  ; print "BFS order from 0: "
  %bfs_fmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %p1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %bfs_fmt, i64 0)

  ; print order elements (if any), separated by space, last without space
  %kfinal = load i64, i64* %ordcnt, align 8
  %i = alloca i64, align 8
  store i64 0, i64* %i, align 8
  br label %ord_loop

ord_loop:
  %ic = load i64, i64* %i, align 8
  %icond = icmp ult i64 %ic, %kfinal
  br i1 %icond, label %ord_print, label %ord_done

ord_print:
  %elem_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ic
  %elem = load i64, i64* %elem_ptr, align 8
  ; choose suffix
  %nexti = add i64 %ic, 1
  %is_last = icmp eq i64 %nexti, %kfinal
  %space_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %suffix = select i1 %is_last, i8* %empty_ptr, i8* %space_ptr
  %pair_fmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %p2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %pair_fmt, i64 %elem, i8* %suffix)
  store i64 %nexti, i64* %i, align 8
  br label %ord_loop

ord_done:
  ; newline
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %p3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)

  ; print distances
  %j = alloca i64, align 8
  store i64 0, i64* %j, align 8
  br label %dist_loop

dist_loop:
  %jc = load i64, i64* %j, align 8
  %jcond = icmp ult i64 %jc, 7
  br i1 %jcond, label %dist_print, label %ret

dist_print:
  %dj = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %jc
  %dval = load i32, i32* %dj, align 4
  %dist_fmt = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %p4 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %dist_fmt, i64 0, i64 %jc, i32 %dval)
  %jnext = add i64 %jc, 1
  store i64 %jnext, i64* %j, align 8
  br label %dist_loop

ret:
  ret i32 0
}