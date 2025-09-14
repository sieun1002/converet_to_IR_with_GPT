; ModuleID = 'dijkstra.ll'
source_filename = "dijkstra"

declare i32 @min_index(i32*, i32*, i32)

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dijkstra(i32* nocapture %graph, i32 %n, i32 %src, i32* nocapture %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s.i8, i8 0, i64 400, i1 false)

  %n64 = sext i32 %n to i64
  br label %init.loop

init.loop:                                            ; preds = %init.body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %init.body ]
  %cont.init = icmp slt i64 %i, %n64
  br i1 %cont.init, label %init.body, label %init.end

init.body:                                            ; preds = %init.loop
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 2147483647, i32* %dist.i, align 4
  %i.next = add nuw nsw i64 %i, 1
  br label %init.loop

init.end:                                             ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer.loop

outer.loop:                                           ; preds = %outer.latch, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.latch ]
  %nminus1 = add i32 %n, -1
  %cont.outer = icmp slt i32 %count, %nminus1
  br i1 %cont.outer, label %outer.body, label %ret

outer.body:                                           ; preds = %outer.loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %ret, label %mark.visited

mark.visited:                                         ; preds = %outer.body
  %u64 = sext i32 %u to i64
  %s.u = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u, align 4
  br label %inner.loop

inner.loop:                                           ; preds = %inner.latch, %mark.visited
  %v = phi i32 [ 0, %mark.visited ], [ %v.next, %inner.latch ]
  %cont.inner = icmp slt i32 %v, %n
  br i1 %cont.inner, label %inner.body, label %outer.latch

inner.body:                                           ; preds = %inner.loop
  %v64 = sext i32 %v to i64
  %u100 = mul nsw i64 %u64, 100
  %idx = add nsw i64 %u100, %v64
  %w.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %w.ptr, align 4
  %hasEdge = icmp ne i32 %w, 0
  br i1 %hasEdge, label %check.visited, label %inner.latch

check.visited:                                        ; preds = %inner.body
  %s.v = getelementptr inbounds i32, i32* %s.base, i64 %v64
  %vis = load i32, i32* %s.v, align 4
  %isUnvisited = icmp eq i32 %vis, 0
  br i1 %isUnvisited, label %check.inf, label %inner.latch

check.inf:                                            ; preds = %check.visited
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %du = load i32, i32* %dist.u.ptr, align 4
  %isInf = icmp eq i32 %du, 2147483647
  br i1 %isInf, label %inner.latch, label %relax

relax:                                                ; preds = %check.inf
  %tmp = add nsw i32 %du, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dist.v.ptr, align 4
  %lt = icmp slt i32 %tmp, %dv
  br i1 %lt, label %store, label %inner.latch

store:                                                ; preds = %relax
  store i32 %tmp, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:                                          ; preds = %store, %relax, %check.inf, %check.visited, %inner.body
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.latch:                                          ; preds = %inner.loop
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

ret:                                                  ; preds = %outer.body, %outer.loop
  ret void
}