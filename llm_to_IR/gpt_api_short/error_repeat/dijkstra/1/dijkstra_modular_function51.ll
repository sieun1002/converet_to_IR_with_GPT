; ModuleID = 'dijkstra'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dijkstra ; Address: 0x401450
; Intent: compute single-source shortest paths (Dijkstra) (confidence=0.93). Evidence: initializes dist to INT_MAX and dist[src]=0; calls min_index(dist,s,n); relaxes edges from selected u over adjacency with 0x190 stride (100 ints).
; Preconditions: n <= 100; graph is an n x n int adjacency matrix with non-negative weights; dist has length >= n.
; Postconditions: dist[v] is the shortest-path distance from src to v, or INT_MAX if unreachable.

; Only the necessary external declarations:
declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define dso_local void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) local_unnamed_addr {
entry:
  %s = alloca [100 x i32], align 16
  %0 = bitcast [100 x i32]* %s to i8*
  ; memset(s, 0, 0x190)
  call i8* @memset(i8* %0, i32 0, i64 400)

  br label %init.loop

init.loop:                                          ; i from 0 to n-1: dist[i] = INT_MAX
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.inc ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i to i64
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i, align 4
  br label %init.inc

init.inc:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  ; dist[src] = 0
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4

  br label %outer.loop

outer.loop:                                         ; count from 0 to n-2
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %nminus1 = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %count, %nminus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:
  %s.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.ptr, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %exit, label %after.u

after.u:
  %u64 = sext i32 %u to i64
  %s.u = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u64
  store i32 1, i32* %s.u, align 4
  br label %inner.loop

inner.loop:                                         ; v from 0 to n-1
  %v = phi i32 [ 0, %after.u ], [ %v.next, %inner.inc ]
  %cond.v = icmp slt i32 %v, %n
  br i1 %cond.v, label %inner.body, label %outer.inc

inner.body:
  %v64 = sext i32 %v to i64
  ; w = graph[u][v]
  %g.uv = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u64, i64 %v64
  %w = load i32, i32* %g.uv, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.inc, label %check.sv

check.sv:
  %s.v = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v64
  %sv = load i32, i32* %s.v, align 4
  %sv.nz = icmp ne i32 %sv, 0
  br i1 %sv.nz, label %inner.inc, label %check.du

check.du:
  %dist.u = getelementptr inbounds i32, i32* %dist, i64 %u64
  %du = load i32, i32* %dist.u, align 4
  %du.inf = icmp eq i32 %du, 2147483647
  br i1 %du.inf, label %inner.inc, label %compute.tmp

compute.tmp:
  %tmp = add nsw i32 %du, %w
  %dist.v = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dv = load i32, i32* %dist.v, align 4
  %lt = icmp slt i32 %tmp, %dv
  br i1 %lt, label %update, label %inner.inc

update:
  store i32 %tmp, i32* %dist.v, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.inc:
  %count.next = add nsw i32 %count, 1
  br label %outer.loop

exit:
  ret void
}