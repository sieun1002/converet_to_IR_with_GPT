; ModuleID = 'dijkstra.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @memset(i8*, i32, i64)
declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call i8* @memset(i8* %s.i8, i32 0, i64 400)

  br label %init

init:                                             ; i = 0..n-1 set dist[i]=INT_MAX
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %after_init

init.body:
  %i64 = sext i32 %i to i64
  %dist.i = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i, align 4
  %i.next = add nsw i32 %i, 1
  br label %init

after_init:
  %src64 = sext i32 %src to i64
  %dist.src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src, align 4
  br label %outer

outer:                                            ; t = 0..n-2
  %t = phi i32 [ 0, %after_init ], [ %t.next, %outer.inc ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.outer = icmp slt i32 %t, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %ret

outer.body:
  %s.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %min = call i32 @min_index(i32* %dist, i32* %s.ptr, i32 %n)
  %is.neg1 = icmp eq i32 %min, -1
  br i1 %is.neg1, label %ret, label %gotmin

gotmin:
  %min64 = sext i32 %min to i64
  %s.min.ptr = getelementptr inbounds i32, i32* %s.ptr, i64 %min64
  store i32 1, i32* %s.min.ptr, align 4
  br label %inner

inner:                                            ; v = 0..n-1
  %v = phi i32 [ 0, %gotmin ], [ %v.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %v, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:
  %min.times.100 = mul nsw i32 %min, 100
  %idx.row = add nsw i32 %min.times.100, %v
  %idx.row64 = sext i32 %idx.row to i64
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx.row64
  %w = load i32, i32* %adj.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.inc, label %chkVis

chkVis:
  %v64 = sext i32 %v to i64
  %s.v.ptr = getelementptr inbounds i32, i32* %s.ptr, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %vis = icmp ne i32 %s.v, 0
  br i1 %vis, label %inner.inc, label %chkInf

chkInf:
  %dist.min.ptr = getelementptr inbounds i32, i32* %dist, i64 %min64
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %isInf = icmp eq i32 %dist.min, 2147483647
  br i1 %isInf, label %inner.inc, label %relax

relax:
  %alt = add nsw i32 %dist.min, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt = icmp slt i32 %alt, %dist.v
  br i1 %lt, label %update, label %inner.inc

update:
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v, 1
  br label %inner

outer.inc:
  %t.next = add nsw i32 %t, 1
  br label %outer

ret:
  ret void
}