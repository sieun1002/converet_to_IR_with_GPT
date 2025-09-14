; External declarations
declare i32 @min_index(i32*, i32*, i32)
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define void @dijkstra(i32* %adj, i32 %n, i32 %start, i32* %dist) local_unnamed_addr {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s.i8, i8 0, i64 400, i1 false)

  br label %init.loop

init.loop:                                        ; i from 0 to n-1: dist[i] = INF
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body.end ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %post.init

init.body:
  %i64 = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.body.end

init.body.end:
  %i.next = add nsw i32 %i, 1
  br label %init.loop

post.init:
  %start64 = sext i32 %start to i64
  %dist.start.ptr = getelementptr inbounds i32, i32* %dist, i64 %start64
  store i32 0, i32* %dist.start.ptr, align 4

  br label %outer.loop

outer.loop:                                       ; k from 0 to n-2
  %k = phi i32 [ 0, %post.init ], [ %k.next, %outer.inc ]
  %n.minus1 = sub nsw i32 %n, 1
  %k.cmp = icmp slt i32 %k, %n.minus1
  br i1 %k.cmp, label %outer.body, label %done

outer.body:
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %have.u

have.u:
  %u64 = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds i32, i32* %s.base, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; v from 0 to n-1
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.inc ]
  %v.cmp = icmp slt i32 %v, %n
  br i1 %v.cmp, label %inner.body, label %outer.inc

inner.body:
  %u.mul100 = mul nsw i32 %u, 100
  %uv = add nsw i32 %u.mul100, %v
  %uv64 = sext i32 %uv to i64
  %adj.uv.ptr = getelementptr inbounds i32, i32* %adj, i64 %uv64
  %w = load i32, i32* %adj.uv.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %inner.inc, label %check.visited

check.visited:
  %v64 = sext i32 %v to i64
  %s.v.ptr = getelementptr inbounds i32, i32* %s.base, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %v.visited = icmp ne i32 %s.v, 0
  br i1 %v.visited, label %inner.inc, label %check.inf

check.inf:
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %is.inf, label %inner.inc, label %compute.new

compute.new:
  %newd = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt = icmp slt i32 %newd, %dist.v
  br i1 %lt, label %update, label %inner.inc

update:
  store i32 %newd, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.inc:
  %k.next = add nsw i32 %k, 1
  br label %outer.loop

done:
  ret void
}