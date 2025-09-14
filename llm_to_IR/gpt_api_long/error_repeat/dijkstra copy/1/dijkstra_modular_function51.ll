; ModuleID = 'dijkstra'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: dijkstra  ; Address: 0x401450
; Intent: Single-source shortest paths via Dijkstra over up to 100-node adjacency matrix (confidence=0.95). Evidence: use of INF=0x7fffffff and min_index over visited set with 100-int row stride (0x190 bytes).
; Preconditions: 0 <= n <= 100; adj points to a 100-column row-major int matrix (at least n*100 elements); dist has at least n elements; 0 <= src < n.
; Postconditions: dist[v] contains the computed shortest path distance from src to v; unreachable vertices remain at 0x7fffffff.

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define dso_local void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) local_unnamed_addr {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s.i8, i32 0, i64 400)
  br label %init.loop

init.loop:                                         ; i = 0 .. n-1: dist[i] = INF
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.cont ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:
  %i64 = sext i32 %i to i64
  %dist.i.ptr = getelementptr i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.cont

init.cont:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                        ; t = 0 .. n-2
  %t = phi i32 [ 0, %init.end ], [ %t.next, %outer.inc ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %t, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:
  %s.base = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %exit, label %after.u

after.u:
  %u64 = sext i32 %u to i64
  %s.u.ptr = getelementptr i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                        ; v = 0 .. n-1
  %v = phi i32 [ 0, %after.u ], [ %v.next, %inner.inc ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.body, label %outer.inc

inner.body:
  %u.mul100 = mul nsw i32 %u, 100
  %idx = add nsw i32 %u.mul100, %v
  %idx64 = sext i32 %idx to i64
  %adj.elem.ptr = getelementptr i32, i32* %adj, i64 %idx64
  %w = load i32, i32* %adj.elem.ptr, align 4
  %w.zero = icmp eq i32 %w, 0
  br i1 %w.zero, label %inner.inc, label %check.sv

check.sv:
  %v64 = sext i32 %v to i64
  %s.v.ptr = getelementptr i32, i32* %s.base, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.nz = icmp ne i32 %s.v, 0
  br i1 %s.v.nz, label %inner.inc, label %check.distu

check.distu:
  %dist.u.ptr = getelementptr i32, i32* %dist, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %dist.u.inf, label %inner.inc, label %compute.alt

compute.alt:
  %alt = add i32 %dist.u, %w
  %dist.v.ptr = getelementptr i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %update, label %inner.inc

update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.inc:
  %t.next = add nsw i32 %t, 1
  br label %outer.loop

exit:
  ret void
}