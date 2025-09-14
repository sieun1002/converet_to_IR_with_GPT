; ModuleID = 'recovered_bfs_main'
target triple = "x86_64-pc-linux-gnu"

@.str_hdr   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %g = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8

  %g.base.i32 = getelementptr inbounds [49 x i32], [49 x i32]* %g, i64 0, i64 0
  %g.base.i8 = bitcast i32* %g.base.i32 to i8*
  call void @llvm.memset.p0i8.i64(i8* %g.base.i8, i8 0, i64 196, i1 false)

  %idx7.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 7
  store i32 1, i32* %idx7.ptr, align 4
  %idx14.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 14
  store i32 1, i32* %idx14.ptr, align 4
  %idx10.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 10
  store i32 1, i32* %idx10.ptr, align 4
  %idx22.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 22
  store i32 1, i32* %idx22.ptr, align 4
  %idx11.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 11
  store i32 1, i32* %idx11.ptr, align 4
  %idx29.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 29
  store i32 1, i32* %idx29.ptr, align 4
  %idx19.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 19
  store i32 1, i32* %idx19.ptr, align 4
  %idx37.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 37
  store i32 1, i32* %idx37.ptr, align 4
  %idx33.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 33
  store i32 1, i32* %idx33.ptr, align 4
  %idx39.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 39
  store i32 1, i32* %idx39.ptr, align 4
  %idx41.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 41
  store i32 1, i32* %idx41.ptr, align 4
  %idx47.ptr = getelementptr inbounds i32, i32* %g.base.i32, i64 47
  store i32 1, i32* %idx47.ptr, align 4

  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  store i64 0, i64* %order_len, align 8

  call void @bfs(i32* %g.base.i32, i64 7, i64 0, i32* %dist.base, i64* %order.base, i64* %order_len)

  %hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %hdr.call = call i32 (i8*, ...) @printf(i8* %hdr.ptr, i64 0)

  br label %order.loop.header

order.loop.header:
  %i.phi = phi i64 [ 0, %entry ], [ %i.next, %order.loop.latch ]
  %len.cur = load i64, i64* %order_len, align 8
  %cmp.cont = icmp ult i64 %i.phi, %len.cur
  br i1 %cmp.cont, label %order.loop.body, label %order.loop.exit

order.loop.body:
  %i.plus1 = add i64 %i.phi, 1
  %len.for.sep = load i64, i64* %order_len, align 8
  %has.space = icmp ult i64 %i.plus1, %len.for.sep
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.ptr = select i1 %has.space, i8* %space.ptr, i8* %empty.ptr

  %item.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.phi
  %item.val = load i64, i64* %item.ptr, align 8

  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %print.item = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %item.val, i8* %sep.ptr)

  br label %order.loop.latch

order.loop.latch:
  %i.next = add i64 %i.phi, 1
  br label %order.loop.header

order.loop.exit:
  %nl.call = call i32 @putchar(i32 10)
  br label %dist.loop.header

dist.loop.header:
  %v.phi = phi i64 [ 0, %order.loop.exit ], [ %v.next, %dist.loop.latch ]
  %cmp.v = icmp ult i64 %v.phi, 7
  br i1 %cmp.v, label %dist.loop.body, label %dist.loop.exit

dist.loop.body:
  %dist.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v.phi
  %dist.val = load i32, i32* %dist.ptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %print.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 0, i64 %v.phi, i32 %dist.val)
  br label %dist.loop.latch

dist.loop.latch:
  %v.next = add i64 %v.phi, 1
  br label %dist.loop.header

dist.loop.exit:
  ret i32 0
}