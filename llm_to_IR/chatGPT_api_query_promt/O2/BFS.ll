; ModuleID = 'BFS.ll'
source_filename = "BFS.c"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_dist  = private unnamed_addr constant [24 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1
@.str_pair  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_sp    = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_emp   = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_nl    = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; 7x7 adjacency matrix (row-major), 1 means edge
; Edges: 0-1,0-2, 1-3,1-4, 2-5, 4-5, 5-6 (undirected)
@adj = internal constant [49 x i32] [
  ; row 0: 0..6
  i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0,
  ; row 1: 7..13
  i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0,
  ; row 2: 14..20
  i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0,
  ; row 3: 21..27
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0,
  ; row 4: 28..34
  i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0,
  ; row 5: 35..41
  i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1,
  ; row 6: 42..48
  i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0
], align 16

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind

define i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  ; locals
  %dist      = alloca [7 x i32], align 16
  %order     = alloca [7 x i64], align 16
  %head      = alloca i32, align 4
  %tail      = alloca i32, align 4
  %ocnt      = alloca i32, align 4
  %queue     = alloca i64*, align 8

  ; dist[i] = -1
  br label %init_loop

init_loop:
  %i0 = phi i32 [ 0, %entry ], [ %i0.next, %init_body ]
  %cmp0 = icmp slt i32 %i0, 7
  br i1 %cmp0, label %init_body, label %init_done

init_body:
  %dist.gep0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dist.ptr0 = getelementptr inbounds i32, i32* %dist.gep0, i64 (0)
  %dist.elem = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dist.gep.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dist.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  ; store -1 into dist[i0]
  %dist.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dist.elem.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i0
  store i32 -1, i32* %dist.ptr, align 4
  %i0.next = add nsw i32 %i0, 1
  br label %init_loop

init_done:
  ; queue = malloc(7 * 8)
  %qraw = call i8* @malloc(i64 56)
  %qptr = bitcast i8* %qraw to i64*
  store i64* %qptr, i64** %queue, align 8

  ; head = 0; tail = 0; ocnt = 0
  store i32 0, i32* %head, align 4
  store i32 0, i32* %tail, align 4
  store i32 0, i32* %ocnt, align 4

  ; if (!queue) goto no_bfs
  %qnull = icmp eq i64* %qptr, null
  br i1 %qnull, label %no_bfs, label %do_bfs

do_bfs:
  ; dist[0] = 0
  %d0ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0ptr, align 4

  ; enqueue 0
  %tail0 = load i32, i32* %tail, align 4
  %tail0.z = sext i32 %tail0 to i64
  %qslot0.ptr = getelementptr inbounds i64, i64* %qptr, i64 %tail0.z
  store i64 0, i64* %qslot0.ptr, align 8
  %tail1 = add nsw i32 %tail0, 1
  store i32 %tail1, i32* %tail, align 4

  br label %bfs_while

bfs_while:
  %h = load i32, i32* %head, align 4
  %t = load i32, i32* %tail, align 4
  %cond = icmp slt i32 %h, %t
  br i1 %cond, label %bfs_body, label %bfs_done

bfs_body:
  ; u = queue[head++]
  %h.z = sext i32 %h to i64
  %qslot.ptr = getelementptr inbounds i64, i64* %qptr, i64 %h.z
  %u64 = load i64, i64* %qslot.ptr, align 8
  %u = trunc i64 %u64 to i32
  %h.next = add nsw i32 %h, 1
  store i32 %h.next, i32* %head, align 4

  ; order[ocnt++] = u
  %oc = load i32, i32* %ocnt, align 4
  %oc.z = sext i32 %oc to i64
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oc.z
  store i64 %u64, i64* %ord.ptr, align 8
  %oc.next = add nsw i32 %oc, 1
  store i32 %oc.next, i32* %ocnt, align 4

  ; for v in 0..6
  br label %nbr_loop

nbr_loop:
  %v = phi i32 [ 0, %bfs_body ], [ %v.next, %nbr_cont ]
  %v.cmp = icmp slt i32 %v, 7
  br i1 %v.cmp, label %nbr_check, label %nbr_done

nbr_check:
  ; adj[u*7 + v]
  %u.mul7 = mul nsw i32 %u, 7
  %idx = add nsw i32 %u.mul7, %v
  %idx.z = sext i32 %idx to i64
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* @adj, i64 0, i64 %idx.z
  %adj.val = load i32, i32* %adj.ptr, align 4
  %has = icmp ne i32 %adj.val, 0
  br i1 %has, label %maybe_enqueue, label %nbr_cont

maybe_enqueue:
  ; if dist[v] == -1
  %dv.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 (0)
  %dv.ptr2 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
  %dv = load i32, i32* %dv.ptr2, align 4
  %unvis = icmp eq i32 %dv, -1
  br i1 %unvis, label %do_enqueue, label %nbr_cont

do_enqueue:
  ; dist[v] = dist[u] + 1
  %du.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u64
  ; Note: %u is i32, need to index with sext
  %u.z = sext i32 %u to i64
  %du.real = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u.z
  %du = load i32, i32* %du.real, align 4
  %du1 = add nsw i32 %du, 1
  store i32 %du1, i32* %dv.ptr2, align 4

  ; enqueue v
  %t.cur = load i32, i32* %tail, align 4
  %t.cur.z = sext i32 %t.cur to i64
  %qslot.v = getelementptr inbounds i64, i64* %qptr, i64 %t.cur.z
  %v64 = sext i32 %v to i64
  store i64 %v64, i64* %qslot.v, align 8
  %t.next = add nsw i32 %t.cur, 1
  store i32 %t.next, i32* %tail, align 4
  br label %nbr_cont

nbr_cont:
  %v.next = add nsw i32 %v, 1
  br label %nbr_loop

nbr_done:
  br label %bfs_while

bfs_done:
  ; free(queue)
  %qraw2 = bitcast i64* %qptr to i8*
  call void @free(i8* %qraw2)
  br label %print_header

no_bfs:
  ; no BFS; just print header and newline, distances remain -1
  br label %print_header

print_header:
  ; print "BFS order from %zu: " with start=0
  %fmt_bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_bfs, i64 0)

  ; print BFS order elements
  %oc.final = load i32, i32* %ocnt, align 4
  %have_order = icmp sgt i32 %oc.final, 0
  br i1 %have_order, label %ord_loop, label %after_order

ord_loop:
  %oi = phi i32 [ 0, %print_header ], [ %oi.next, %ord_body ]
  %oi.z = sext i32 %oi to i64
  %ord.ptr.i = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oi.z
  %oval = load i64, i64* %ord.ptr.i, align 8

  ; suffix = (oi+1 == oc.final) ? "" : " "
  %oi.next = add nsw i32 %oi, 1
  %last = icmp eq i32 %oi.next, %oc.final
  %sptr = select i1 %last,
            i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_emp, i64 0, i64 0),
            i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_sp,  i64 0, i64 0)

  %fmt_pair = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %__ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_pair, i64 %oval, i8* %sptr)

  %more = icmp slt i32 %oi.next, %oc.final
  br i1 %more, label %ord_body, label %after_order

ord_body:
  br label %ord_loop

after_order:
  ; newline
  %fmt_nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %___ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_nl)

  ; print distances
  br label %dist_loop

dist_loop:
  %di = phi i32 [ 0, %after_order ], [ %di.next, %dist_body ]
  %di.cmp = icmp slt i32 %di, 7
  br i1 %di.cmp, label %dist_body, label %done

dist_body:
  %di.z = sext i32 %di to i64
  %dptr.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %di.z
  %dval = load i32, i32* %dptr.i, align 4

  %fmt_dist = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dist, i64 0, i64 0
  %____ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt_dist, i64 0, i64 %di.z, i32 %dval)

  %di.next = add nsw i32 %di, 1
  br label %dist_loop

done:
  ret i32 0
}