; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: breadth-first search on a fixed 7-node graph and print order/distances from source 0 (confidence=0.85). Evidence: stack-built 7x7 adjacency matrix, queue via malloc/free, distance array with -1 sentinel and __printf_chk outputs.
; Preconditions: none
; Postconditions: prints BFS order and dist(0 -> v) for v in [0,6]

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
; locals
%adj = alloca [7 x [7 x i32]], align 16
%dist = alloca [7 x i32], align 16
%order = alloca [7 x i64], align 16
%head = alloca i64, align 8
%tail = alloca i64, align 8
%ordcnt = alloca i64, align 8

; zero adjacency
store [7 x [7 x i32]] zeroinitializer, [7 x [7 x i32]]* %adj, align 16

; set specific edges (nonzero means edge)
%r0 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0
%r1 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1
%r2 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2
%r3 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3
%r4 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4
%r5 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5
%r6 = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6

; row 0: col 1,2,6 = 1
%r0c1 = getelementptr inbounds [7 x i32], [7 x i32]* %r0, i64 0, i64 1
%r0c2 = getelementptr inbounds [7 x i32], [7 x i32]* %r0, i64 0, i64 2
%r0c6 = getelementptr inbounds [7 x i32], [7 x i32]* %r0, i64 0, i64 6
store i32 1, i32* %r0c1, align 4
store i32 1, i32* %r0c2, align 4
store i32 1, i32* %r0c6, align 4

; row 1: col 0,1,6 = 1
%r1c0 = getelementptr inbounds [7 x i32], [7 x i32]* %r1, i64 0, i64 0
%r1c1 = getelementptr inbounds [7 x i32], [7 x i32]* %r1, i64 0, i64 1
%r1c6 = getelementptr inbounds [7 x i32], [7 x i32]* %r1, i64 0, i64 6
store i32 1, i32* %r1c0, align 4
store i32 1, i32* %r1c1, align 4
store i32 1, i32* %r1c6, align 4

; row 2: col 5 = 1
%r2c5 = getelementptr inbounds [7 x i32], [7 x i32]* %r2, i64 0, i64 5
store i32 1, i32* %r2c5, align 4

; row 3: col 1 = 1
%r3c1 = getelementptr inbounds [7 x i32], [7 x i32]* %r3, i64 0, i64 1
store i32 1, i32* %r3c1, align 4

; row 4: col 1,5 = 1
%r4c1 = getelementptr inbounds [7 x i32], [7 x i32]* %r4, i64 0, i64 1
%r4c5 = getelementptr inbounds [7 x i32], [7 x i32]* %r4, i64 0, i64 5
store i32 1, i32* %r4c1, align 4
store i32 1, i32* %r4c5, align 4

; row 5: col 2,4,6 = 1
%r5c2 = getelementptr inbounds [7 x i32], [7 x i32]* %r5, i64 0, i64 2
%r5c4 = getelementptr inbounds [7 x i32], [7 x i32]* %r5, i64 0, i64 4
%r5c6 = getelementptr inbounds [7 x i32], [7 x i32]* %r5, i64 0, i64 6
store i32 1, i32* %r5c2, align 4
store i32 1, i32* %r5c4, align 4
store i32 1, i32* %r5c6, align 4

; row 6: col 5 = 1
%r6c5 = getelementptr inbounds [7 x i32], [7 x i32]* %r6, i64 0, i64 5
store i32 1, i32* %r6c5, align 4

; initialize dist[] = -1
br label %init_dist

init_dist:
%i0 = phi i64 [ 0, %entry ], [ %i1, %init_dist.body ]
%done_init = icmp eq i64 %i0, 7
br i1 %done_init, label %after_init_dist, label %init_dist.body

init_dist.body:
%dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i0
store i32 -1, i32* %dptr, align 4
%i1 = add i64 %i0, 1
br label %init_dist

after_init_dist:
; allocate queue of 7 x i64
%qraw = call noalias i8* @malloc(i64 56)
%isnull = icmp eq i8* %qraw, null
br i1 %isnull, label %malloc_fail, label %malloc_ok

malloc_ok:
%queue = bitcast i8* %qraw to i64*
; queue[0] = 0, head=0, tail=1, ordcnt=0, dist[0]=0
store i64 0, i64* %queue, align 8
store i64 0, i64* %head, align 8
store i64 1, i64* %tail, align 8
store i64 0, i64* %ordcnt, align 8
%dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
store i32 0, i32* %dist0, align 4
br label %bfs.cond

bfs.cond:
%h = load i64, i64* %head, align 8
%t = load i64, i64* %tail, align 8
%has = icmp ult i64 %h, %t
br i1 %has, label %bfs.pop, label %bfs.done

bfs.pop:
%qhe = getelementptr inbounds i64, i64* %queue, i64 %h
%u = load i64, i64* %qhe, align 8
%h.next = add i64 %h, 1
store i64 %h.next, i64* %head, align 8
; du = dist[u]
%du.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u
%du = load i32, i32* %du.ptr, align 4
; order[ordcnt++] = u
%oc = load i64, i64* %ordcnt, align 8
%ord.el = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oc
store i64 %u, i64* %ord.el, align 8
%oc.next = add i64 %oc, 1
store i64 %oc.next, i64* %ordcnt, align 8
br label %v.loop

v.loop:
%v = phi i64 [ 0, %bfs.pop ], [ %v.next, %v.nextbb ]
%v.cont = icmp slt i64 %v, 7
br i1 %v.cont, label %v.body, label %bfs.cond

v.body:
; if adj[u][v] != 0
%row.u = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %u
%cell = getelementptr inbounds [7 x i32], [7 x i32]* %row.u, i64 0, i64 %v
%aval = load i32, i32* %cell, align 4
%nz = icmp ne i32 %aval, 0
br i1 %nz, label %check.unvis, label %v.nextbb

check.unvis:
%d.v.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
%d.v = load i32, i32* %d.v.ptr, align 4
%is.unvis = icmp eq i32 %d.v, -1
br i1 %is.unvis, label %enqueue, label %v.nextbb

enqueue:
%t.cur = load i64, i64* %tail, align 8
%q.dest = getelementptr inbounds i64, i64* %queue, i64 %t.cur
store i64 %v, i64* %q.dest, align 8
%t.new = add i64 %t.cur, 1
store i64 %t.new, i64* %tail, align 8
%du.plus = add i32 %du, 1
store i32 %du.plus, i32* %d.v.ptr, align 4
br label %v.nextbb

v.nextbb:
%v.next = add i64 %v, 1
br label %v.loop

bfs.done:
call void @free(i8* %qraw)
; print header
%bfsfmt = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %bfsfmt, i64 0)
; print order
br label %print.order

print.order:
%pi = phi i64 [ 0, %bfs.done ], [ %pi.next, %print.order.body ]
%oc.cur = load i64, i64* %ordcnt, align 8
%more = icmp ult i64 %pi, %oc.cur
br i1 %more, label %print.order.body, label %after.order

print.order.body:
%ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
%oval = load i64, i64* %ord.ptr, align 8
%pi1 = add i64 %pi, 1
%islast = icmp eq i64 %pi1, %oc.cur
%spacep = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
%emptyp = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
%suf = select i1 %islast, i8* %emptyp, i8* %spacep
%zusfmt = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0
%_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %zusfmt, i64 %oval, i8* %suf)
%pi.next = add i64 %pi, 1
br label %print.order

after.order:
%nl = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl)
br label %dist.start

malloc_fail:
; header + newline, then distances (no traversal)
%bfsfmt.fail = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %bfsfmt.fail, i64 0)
%nl2 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl2)
br label %dist.start

dist.start:
br label %dist.loop

dist.loop:
%j = phi i64 [ 0, %dist.start ], [ %j.next, %dist.body ]
%j.done = icmp eq i64 %j, 7
br i1 %j.done, label %ret, label %dist.body

dist.body:
%dj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
%dj = load i32, i32* %dj.ptr, align 4
%distfmt = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %distfmt, i64 0, i64 %j, i32 %dj)
%j.next = add i64 %j, 1
br label %dist.loop

ret:
ret i32 0
}