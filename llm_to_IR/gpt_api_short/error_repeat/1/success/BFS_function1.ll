; ModuleID = 'bfs'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bfs ; Address: 0x11C9
; Intent: breadth-first search from src over an n×n i32 adjacency matrix, writing distances and visit order (confidence=0.92). Evidence: dist initialized to -1, queue via malloc, edge test adj[u*n+v], dist[v]=dist[u]+1, enqueue, record order/count.
; Preconditions: adj points to at least n*n i32 (row-major), dist to at least n i32, out to at least n i64, out_count non-null.
; Postconditions: If n==0, src>=n, or allocation fails: *out_count=0 and return (dist unchanged).

; Only the necessary external declarations:
declare noalias i8* @_malloc(i64)
declare void @_free(i8*)

define dso_local void @bfs(i32* nocapture readonly %adj, i64 %n, i64 %src, i32* nocapture %dist, i64* nocapture %out, i64* nocapture %out_count) local_unnamed_addr {
entry:
  %cmp_n0 = icmp eq i64 %n, 0
  br i1 %cmp_n0, label %early, label %chk_src

chk_src:                                          ; preds = %entry
  %src_ok = icmp ult i64 %src, %n
  br i1 %src_ok, label %init_dist, label %early

early:                                            ; preds = %chk_src, %entry, %allocq.null
  store i64 0, i64* %out_count, align 8
  ret void

init_dist:                                        ; preds = %chk_src
  br label %dist.loop

dist.loop:                                        ; preds = %dist.body, %init_dist
  %i = phi i64 [ 0, %init_dist ], [ %i.next, %dist.body ]
  %cont = icmp ult i64 %i, %n
  br i1 %cont, label %dist.body, label %allocq

dist.body:                                        ; preds = %dist.loop
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.i.ptr, align 4
  %i.next = add i64 %i, 1
  br label %dist.loop

allocq:                                           ; preds = %dist.loop
  %sizeb = shl i64 %n, 3
  %qraw = call noalias i8* @_malloc(i64 %sizeb)
  %q = bitcast i8* %qraw to i64*
  %alloc.null = icmp eq i64* %q, null
  br i1 %alloc.null, label %allocq.null, label %bfs.init

allocq.null:                                      ; preds = %allocq
  br label %early

bfs.init:                                         ; preds = %allocq
  ; head = 0, tail = 0
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  %q.tail.slot = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %src, i64* %q.tail.slot, align 8
  store i64 0, i64* %out_count, align 8
  br label %while

while:                                            ; preds = %end.for.v, %bfs.init
  %head = phi i64 [ 0, %bfs.init ], [ %head.next, %end.for.v ]
  %tail = phi i64 [ 1, %bfs.init ], [ %tail.out, %end.for.v ]
  %nonempty = icmp ult i64 %head, %tail
  br i1 %nonempty, label %deq, label %cleanup

deq:                                              ; preds = %while
  %q.head.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %q.head.ptr, align 8
  %head.next = add i64 %head, 1
  ; increment out_count then store u at previous index
  %k.old = load i64, i64* %out_count, align 8
  %k.new = add i64 %k.old, 1
  store i64 %k.new, i64* %out_count, align 8
  %out.ptr = getelementptr inbounds i64, i64* %out, i64 %k.old
  store i64 %u, i64* %out.ptr, align 8
  br label %for.v

for.v:                                            ; preds = %body.end, %deq
  %v = phi i64 [ 0, %deq ], [ %v.next, %body.end ]
  %tail.cur = phi i64 [ %tail, %deq ], [ %tail.next, %body.end ]
  %v.cont = icmp ult i64 %v, %n
  br i1 %v.cont, label %body, label %end.for.v

body:                                             ; preds = %for.v
  %un = mul i64 %u, %n
  %idx = add i64 %un, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %aval = load i32, i32* %adj.ptr, align 4
  %iszero = icmp eq i32 %aval, 0
  br i1 %iszero, label %body.end, label %chk.unvisited

chk.unvisited:                                    ; preds = %body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %unvisited = icmp eq i32 %dist.v, -1
  br i1 %unvisited, label %visit, label %body.end

visit:                                            ; preds = %chk.unvisited
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.v.new = add nsw i32 %dist.u, 1
  store i32 %dist.v.new, i32* %dist.v.ptr, align 4
  %q.enq.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.enq.ptr, align 8
  %tail.enq = add i64 %tail.cur, 1
  br label %body.end

body.end:                                         ; preds = %visit, %chk.unvisited, %body
  %tail.next = phi i64 [ %tail.enq, %visit ], [ %tail.cur, %chk.unvisited ], [ %tail.cur, %body ]
  %v.next = add i64 %v, 1
  br label %for.v

end.for.v:                                        ; preds = %for.v
  %tail.out = phi i64 [ %tail.cur, %for.v ]
  br label %while

cleanup:                                          ; preds = %while
  %qraw.free = bitcast i64* %q to i8*
  call void @_free(i8* %qraw.free)
  ret void
}