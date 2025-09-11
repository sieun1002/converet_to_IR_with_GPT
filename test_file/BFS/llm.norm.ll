; ModuleID = 'cases/BFS/llm.ll'
source_filename = "cases/BFS/llm.ll"
target triple = "x86_64-unknown-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zus = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare noalias i8* @malloc(i64)

declare void @free(i8*)

declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %adj = alloca [7 x [7 x i32]], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %.fca.0.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 0
  store i32 0, i32* %.fca.0.0.gep, align 16
  %.fca.0.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 1
  store i32 0, i32* %.fca.0.1.gep, align 4
  %.fca.0.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 2
  store i32 0, i32* %.fca.0.2.gep, align 8
  %.fca.0.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 3
  store i32 0, i32* %.fca.0.3.gep, align 4
  %.fca.0.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 4
  store i32 0, i32* %.fca.0.4.gep, align 16
  %.fca.0.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 5
  store i32 0, i32* %.fca.0.5.gep, align 4
  %.fca.0.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 0, i64 6
  store i32 0, i32* %.fca.0.6.gep, align 8
  %.fca.1.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 0
  store i32 0, i32* %.fca.1.0.gep, align 4
  %.fca.1.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 1
  store i32 0, i32* %.fca.1.1.gep, align 16
  %.fca.1.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 2
  store i32 0, i32* %.fca.1.2.gep, align 4
  %.fca.1.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 3
  store i32 0, i32* %.fca.1.3.gep, align 8
  %.fca.1.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 4
  store i32 0, i32* %.fca.1.4.gep, align 4
  %.fca.1.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 5
  store i32 0, i32* %.fca.1.5.gep, align 16
  %.fca.1.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 1, i64 6
  store i32 0, i32* %.fca.1.6.gep, align 4
  %.fca.2.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 0
  store i32 0, i32* %.fca.2.0.gep, align 8
  %.fca.2.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 1
  store i32 0, i32* %.fca.2.1.gep, align 4
  %.fca.2.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 2
  store i32 0, i32* %.fca.2.2.gep, align 16
  %.fca.2.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 3
  store i32 0, i32* %.fca.2.3.gep, align 4
  %.fca.2.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 4
  store i32 0, i32* %.fca.2.4.gep, align 8
  %.fca.2.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 5
  store i32 0, i32* %.fca.2.5.gep, align 4
  %.fca.2.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 2, i64 6
  store i32 0, i32* %.fca.2.6.gep, align 16
  %.fca.3.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 0
  store i32 0, i32* %.fca.3.0.gep, align 4
  %.fca.3.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 1
  store i32 0, i32* %.fca.3.1.gep, align 8
  %.fca.3.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 2
  store i32 0, i32* %.fca.3.2.gep, align 4
  %.fca.3.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 3
  store i32 0, i32* %.fca.3.3.gep, align 16
  %.fca.3.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 4
  store i32 0, i32* %.fca.3.4.gep, align 4
  %.fca.3.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 5
  store i32 0, i32* %.fca.3.5.gep, align 8
  %.fca.3.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 3, i64 6
  store i32 0, i32* %.fca.3.6.gep, align 4
  %.fca.4.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 0
  store i32 0, i32* %.fca.4.0.gep, align 16
  %.fca.4.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 1
  store i32 0, i32* %.fca.4.1.gep, align 4
  %.fca.4.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 2
  store i32 0, i32* %.fca.4.2.gep, align 8
  %.fca.4.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 3
  store i32 0, i32* %.fca.4.3.gep, align 4
  %.fca.4.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 4
  store i32 0, i32* %.fca.4.4.gep, align 16
  %.fca.4.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 5
  store i32 0, i32* %.fca.4.5.gep, align 4
  %.fca.4.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 4, i64 6
  store i32 0, i32* %.fca.4.6.gep, align 8
  %.fca.5.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 0
  store i32 0, i32* %.fca.5.0.gep, align 4
  %.fca.5.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 1
  store i32 0, i32* %.fca.5.1.gep, align 16
  %.fca.5.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 2
  store i32 0, i32* %.fca.5.2.gep, align 4
  %.fca.5.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 3
  store i32 0, i32* %.fca.5.3.gep, align 8
  %.fca.5.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 4
  store i32 0, i32* %.fca.5.4.gep, align 4
  %.fca.5.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 5
  store i32 0, i32* %.fca.5.5.gep, align 16
  %.fca.5.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 5, i64 6
  store i32 0, i32* %.fca.5.6.gep, align 4
  %.fca.6.0.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 0
  store i32 0, i32* %.fca.6.0.gep, align 8
  %.fca.6.1.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 1
  store i32 0, i32* %.fca.6.1.gep, align 4
  %.fca.6.2.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 2
  store i32 0, i32* %.fca.6.2.gep, align 16
  %.fca.6.3.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 3
  store i32 0, i32* %.fca.6.3.gep, align 4
  %.fca.6.4.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 4
  store i32 0, i32* %.fca.6.4.gep, align 8
  %.fca.6.5.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 5
  store i32 0, i32* %.fca.6.5.gep, align 4
  %.fca.6.6.gep = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 6, i64 6
  store i32 0, i32* %.fca.6.6.gep, align 16
  store i32 1, i32* %.fca.0.1.gep, align 4
  store i32 1, i32* %.fca.0.2.gep, align 8
  store i32 1, i32* %.fca.0.6.gep, align 8
  store i32 1, i32* %.fca.1.0.gep, align 4
  store i32 1, i32* %.fca.1.1.gep, align 16
  store i32 1, i32* %.fca.1.6.gep, align 4
  store i32 1, i32* %.fca.2.5.gep, align 4
  store i32 1, i32* %.fca.3.1.gep, align 8
  store i32 1, i32* %.fca.4.1.gep, align 4
  store i32 1, i32* %.fca.4.5.gep, align 4
  store i32 1, i32* %.fca.5.2.gep, align 4
  store i32 1, i32* %.fca.5.4.gep, align 4
  store i32 1, i32* %.fca.5.6.gep, align 4
  store i32 1, i32* %.fca.6.5.gep, align 4
  br label %init_dist

init_dist:                                        ; preds = %init_dist.body, %entry
  %i0 = phi i64 [ 0, %entry ], [ %i1, %init_dist.body ]
  %done_init = icmp eq i64 %i0, 7
  br i1 %done_init, label %after_init_dist, label %init_dist.body

init_dist.body:                                   ; preds = %init_dist
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i0
  store i32 -1, i32* %dptr, align 4
  %i1 = add i64 %i0, 1
  br label %init_dist

after_init_dist:                                  ; preds = %init_dist
  %qraw = call noalias dereferenceable_or_null(56) i8* @malloc(i64 56)
  %isnull = icmp eq i8* %qraw, null
  br i1 %isnull, label %malloc_fail, label %malloc_ok

malloc_ok:                                        ; preds = %after_init_dist
  %queue = bitcast i8* %qraw to i64*
  store i64 0, i64* %queue, align 8
  %dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0, align 16
  br label %bfs.cond

bfs.cond:                                         ; preds = %v.loop, %malloc_ok
  %ordcnt.0 = phi i64 [ 0, %malloc_ok ], [ %oc.next, %v.loop ]
  %tail.0 = phi i64 [ 1, %malloc_ok ], [ %tail.1, %v.loop ]
  %head.0 = phi i64 [ 0, %malloc_ok ], [ %h.next, %v.loop ]
  %has = icmp ult i64 %head.0, %tail.0
  br i1 %has, label %bfs.pop, label %bfs.done

bfs.pop:                                          ; preds = %bfs.cond
  %qhe = getelementptr inbounds i64, i64* %queue, i64 %head.0
  %u = load i64, i64* %qhe, align 8
  %h.next = add i64 %head.0, 1
  %du.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u
  %du = load i32, i32* %du.ptr, align 4
  %ord.el = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %ordcnt.0
  store i64 %u, i64* %ord.el, align 8
  %oc.next = add i64 %ordcnt.0, 1
  br label %v.loop

v.loop:                                           ; preds = %v.nextbb, %bfs.pop
  %tail.1 = phi i64 [ %tail.0, %bfs.pop ], [ %tail.2, %v.nextbb ]
  %v = phi i64 [ 0, %bfs.pop ], [ %v.next, %v.nextbb ]
  %v.cont = icmp slt i64 %v, 7
  br i1 %v.cont, label %v.body, label %bfs.cond

v.body:                                           ; preds = %v.loop
  %cell = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* %adj, i64 0, i64 %u, i64 %v
  %aval = load i32, i32* %cell, align 4
  %nz.not = icmp eq i32 %aval, 0
  br i1 %nz.not, label %v.nextbb, label %check.unvis

check.unvis:                                      ; preds = %v.body
  %d.v.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v
  %d.v = load i32, i32* %d.v.ptr, align 4
  %is.unvis = icmp eq i32 %d.v, -1
  br i1 %is.unvis, label %enqueue, label %v.nextbb

enqueue:                                          ; preds = %check.unvis
  %q.dest = getelementptr inbounds i64, i64* %queue, i64 %tail.1
  store i64 %v, i64* %q.dest, align 8
  %t.new = add i64 %tail.1, 1
  %du.plus = add i32 %du, 1
  store i32 %du.plus, i32* %d.v.ptr, align 4
  br label %v.nextbb

v.nextbb:                                         ; preds = %enqueue, %check.unvis, %v.body
  %tail.2 = phi i64 [ %t.new, %enqueue ], [ %tail.1, %check.unvis ], [ %tail.1, %v.body ]
  %v.next = add i64 %v, 1
  br label %v.loop

bfs.done:                                         ; preds = %bfs.cond
  call void @free(i8* %qraw)
  %0 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0), i64 0)
  br label %print.order

print.order:                                      ; preds = %print.order.body, %bfs.done
  %pi = phi i64 [ 0, %bfs.done ], [ %pi1, %print.order.body ]
  %more = icmp ult i64 %pi, %ordcnt.0
  br i1 %more, label %print.order.body, label %after.order

print.order.body:                                 ; preds = %print.order
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %pi
  %oval = load i64, i64* %ord.ptr, align 8
  %pi1 = add i64 %pi, 1
  %islast = icmp eq i64 %pi1, %ordcnt.0
  %suf = select i1 %islast, i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0), i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0)
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str_zus, i64 0, i64 0), i64 %oval, i8* %suf)
  br label %print.order

after.order:                                      ; preds = %print.order
  %1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0))
  br label %dist.start

malloc_fail:                                      ; preds = %after_init_dist
  %2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0), i64 0)
  %3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0))
  br label %dist.start

dist.start:                                       ; preds = %malloc_fail, %after.order
  br label %dist.loop

dist.loop:                                        ; preds = %dist.body, %dist.start
  %j = phi i64 [ 0, %dist.start ], [ %j.next, %dist.body ]
  %j.done = icmp eq i64 %j, 7
  br i1 %j.done, label %ret, label %dist.body

dist.body:                                        ; preds = %dist.loop
  %dj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %dj = load i32, i32* %dj.ptr, align 4
  %4 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* getelementptr inbounds ([23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0), i64 0, i64 %j, i32 %dj)
  %j.next = add i64 %j, 1
  br label %dist.loop

ret:                                              ; preds = %dist.loop
  ret i32 0
}
