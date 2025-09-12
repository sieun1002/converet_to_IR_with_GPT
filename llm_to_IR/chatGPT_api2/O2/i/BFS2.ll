; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print BFS order from node 0 and distances in a fixed 7-node graph (confidence=0.95). Evidence: queue-based traversal over 7x7 adjacency, distance -1 init and +1 propagation
; Preconditions: none
; Postconditions: prints BFS order and distances; returns 0

@adj = internal constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 1, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 1, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 1, i32 0, i32 1, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0]
]

@.str_bfs = private unnamed_addr constant [20 x i8] c"BFS order from %zu: \00"
@.fmt_order = private unnamed_addr constant [6 x i8] c"%zu%s\00"
@.space = private unnamed_addr constant [2 x i8] c" \00"
@.empty = private unnamed_addr constant [1 x i8] c"\00"
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00"

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  br label %init.cond

init.cond:                                        ; preds = %init.inc, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.inc ]
  %init.cmp = icmp ult i64 %i, 7
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.cond
  %dist.gep = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  br label %init.inc

init.inc:                                         ; preds = %init.body
  %i.next = add nuw nsw i64 %i, 1
  br label %init.cond

init.end:                                         ; preds = %init.cond
  %dist0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %dist0, align 4
  %qraw = call noalias i8* @malloc(i64 56)
  %isnull = icmp eq i8* %qraw, null
  br i1 %isnull, label %malloc_fail, label %malloc_ok

malloc_ok:                                        ; preds = %init.end
  %q = bitcast i8* %qraw to i64*
  store i64 0, i64* %q, align 8
  br label %bfs.loop

bfs.loop:                                         ; preds = %after_inner, %malloc_ok
  %p = phi i64 [ 0, %malloc_ok ], [ %p.next, %after_inner ]
  %s = phi i64 [ 1, %malloc_ok ], [ %s.out, %after_inner ]
  %cond = icmp ult i64 %p, %s
  br i1 %cond, label %process, label %bfs.done

process:                                          ; preds = %bfs.loop
  %qe = getelementptr inbounds i64, i64* %q, i64 %p
  %curr = load i64, i64* %qe, align 8
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %p
  store i64 %curr, i64* %order.ptr, align 8
  %dist.curr.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %curr
  %dist.curr = load i32, i32* %dist.curr.ptr, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.inc, %process
  %j = phi i64 [ 0, %process ], [ %j.next, %inner.inc ]
  %s.inner = phi i64 [ %s, %process ], [ %s.after, %inner.inc ]
  %j.cmp = icmp ult i64 %j, 7
  br i1 %j.cmp, label %inner.body, label %after_inner

inner.body:                                       ; preds = %inner.cond
  %rowptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @adj, i64 0, i64 %curr
  %cellptr = getelementptr inbounds [7 x i32], [7 x i32]* %rowptr, i64 0, i64 %j
  %adjval = load i32, i32* %cellptr, align 4
  %isEdge = icmp ne i32 %adjval, 0
  br i1 %isEdge, label %check.dist, label %inner.next_noedge

check.dist:                                       ; preds = %inner.body
  %distj.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j
  %distj = load i32, i32* %distj.ptr, align 4
  %unvisited = icmp eq i32 %distj, -1
  br i1 %unvisited, label %visit, label %inner.next_noenqueue

visit:                                            ; preds = %check.dist
  %nc = add nsw i32 %dist.curr, 1
  store i32 %nc, i32* %distj.ptr, align 4
  %qs.ptr = getelementptr inbounds i64, i64* %q, i64 %s.inner
  store i64 %j, i64* %qs.ptr, align 8
  %s.inc = add nuw nsw i64 %s.inner, 1
  br label %inner.inc

inner.next_noedge:                                ; preds = %inner.body
  br label %inner.inc

inner.next_noenqueue:                             ; preds = %check.dist
  br label %inner.inc

inner.inc:                                        ; preds = %inner.next_noenqueue, %inner.next_noedge, %visit
  %s.after = phi i64 [ %s.inner, %inner.next_noedge ], [ %s.inner, %inner.next_noenqueue ], [ %s.inc, %visit ]
  %j.next = add nuw nsw i64 %j, 1
  br label %inner.cond

after_inner:                                      ; preds = %inner.cond
  %p.next = add nuw nsw i64 %p, 1
  %s.out = phi i64 [ %s.inner, %inner.cond ]
  br label %bfs.loop

bfs.done:                                         ; preds = %bfs.loop
  %count = phi i64 [ %p, %bfs.loop ]
  %qraw2 = bitcast i64* %q to i8*
  call void @free(i8* %qraw2)
  br label %print_header

malloc_fail:                                      ; preds = %init.end
  br label %print_header

print_header:                                     ; preds = %malloc_fail, %bfs.done
  %count.phi = phi i64 [ %count, %bfs.done ], [ 0, %malloc_fail ]
  %fmt.ptr = getelementptr inbounds [20 x i8], [20 x i8]* @.str_bfs, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i64 0)
  br label %order.loop.cond

order.loop.cond:                                  ; preds = %order.loop.inc, %print_header
  %oi = phi i64 [ 0, %print_header ], [ %oi.next, %order.loop.inc ]
  %has = icmp ult i64 %oi, %count.phi
  br i1 %has, label %order.loop.body, label %order.after

order.loop.body:                                  ; preds = %order.loop.cond
  %optr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %oi
  %oval = load i64, i64* %optr, align 8
  %lastidx = add i64 %count.phi, -1
  %islast = icmp eq i64 %oi, %lastidx
  %spc.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.space, i64 0, i64 0
  %empt.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.empty, i64 0, i64 0
  %suffix = select i1 %islast, i8* %empt.ptr, i8* %spc.ptr
  %fmt2.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_order, i64 0, i64 0
  %__p1 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt2.ptr, i64 %oval, i8* %suffix)
  br label %order.loop.inc

order.loop.inc:                                   ; preds = %order.loop.body
  %oi.next = add nuw nsw i64 %oi, 1
  br label %order.loop.cond

order.after:                                      ; preds = %order.loop.cond
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %__p2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  br label %dist.loop.cond

dist.loop.cond:                                   ; preds = %dist.loop.inc, %order.after
  %k = phi i64 [ 0, %order.after ], [ %k.next, %dist.loop.inc ]
  %kcmp = icmp ult i64 %k, 7
  br i1 %kcmp, label %dist.loop.body, label %end

dist.loop.body:                                   ; preds = %dist.loop.cond
  %dk.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %k
  %dk = load i32, i32* %dk.ptr, align 4
  %fmt3.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %__p3 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt3.ptr, i64 0, i64 %k, i32 %dk)
  br label %dist.loop.inc

dist.loop.inc:                                    ; preds = %dist.loop.body
  %k.next = add nuw nsw i64 %k, 1
  br label %dist.loop.cond

end:                                              ; preds = %dist.loop.cond
  ret i32 0
}