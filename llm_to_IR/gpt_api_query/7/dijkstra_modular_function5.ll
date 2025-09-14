; ModuleID = 'dijkstra'
source_filename = "dijkstra"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s.i8, i32 0, i64 400)

  br label %init.cond

init.cond:                                           ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                           ; preds = %init.cond
  %i64 = sext i32 %i to i64
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i, align 4
  %i.next = add nsw i32 %i, 1
  br label %init.cond

init.end:                                            ; preds = %init.cond
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer.cond

outer.cond:                                          ; preds = %outer.inc, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %count, %nminus1
  br i1 %outer.cmp, label %outer.body, label %ret

outer.body:                                          ; preds = %outer.cond
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %is.neg1 = icmp eq i32 %u, -1
  br i1 %is.neg1, label %ret, label %have.u

have.u:                                              ; preds = %outer.body
  %u64 = sext i32 %u to i64
  %s.u = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u, align 4
  br label %inner.cond

inner.cond:                                          ; preds = %inner.inc, %have.u
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.inc ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.body, label %outer.inc

inner.body:                                          ; preds = %inner.cond
  %v64 = sext i32 %v to i64
  %rowoff = mul nsw i64 %u64, 100
  %idx = add nsw i64 %rowoff, %v64
  %e.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %w = load i32, i32* %e.ptr, align 4
  %wzero = icmp eq i32 %w, 0
  br i1 %wzero, label %inner.inc, label %chk.s

chk.s:                                               ; preds = %inner.body
  %s.v = getelementptr inbounds i32, i32* %s.base, i64 %v64
  %s.v.val = load i32, i32* %s.v, align 4
  %s.v.set = icmp ne i32 %s.v.val, 0
  br i1 %s.v.set, label %inner.inc, label %chk.du

chk.du:                                              ; preds = %chk.s
  %dist.u = getelementptr inbounds i32, i32* %dist, i64 %u64
  %du = load i32, i32* %dist.u, align 4
  %du.is.max = icmp eq i32 %du, 2147483647
  br i1 %du.is.max, label %inner.inc, label %relax

relax:                                               ; preds = %chk.du
  %sum = add i32 %du, %w
  %dist.v = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dist.v, align 4
  %better = icmp slt i32 %sum, %dv
  br i1 %better, label %store, label %inner.inc

store:                                               ; preds = %relax
  store i32 %sum, i32* %dist.v, align 4
  br label %inner.inc

inner.inc:                                           ; preds = %store, %relax, %chk.du, %chk.s, %inner.body
  %v.next = add nsw i32 %v, 1
  br label %inner.cond

outer.inc:                                           ; preds = %inner.cond
  %count.next = add nsw i32 %count, 1
  br label %outer.cond

ret:                                                 ; preds = %outer.body, %outer.cond
  ret void
}