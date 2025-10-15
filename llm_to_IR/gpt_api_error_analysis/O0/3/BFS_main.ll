; ModuleID = 'main_bfs.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32* %adj, i64 %V, i64 %src, i32* %dist, i64* %order, i64* %order_len)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %V = alloca i64, align 8
  %src = alloca i64, align 8
  %order_len = alloca i64, align 8
  %k = alloca i64, align 8
  %t = alloca i64, align 8

  store i64 7, i64* %V, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %order_len, align 8

  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)

  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 4
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4

  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %V.load = load i64, i64* %V, align 8
  %src.load = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %V.load, i64 %src.load, i32* %dist.ptr, i64* %order.ptr, i64* %order_len)

  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %call.printf.bfs = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.load)

  store i64 0, i64* %k, align 8
  br label %loop.bfs

loop.bfs:
  %k.cur = load i64, i64* %k, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %k.cur, %len.cur
  br i1 %cond, label %loop.bfs.body, label %loop.bfs.end

loop.bfs.body:
  %k.plus1 = add i64 %k.cur, 1
  %len.cur2 = load i64, i64* %order_len, align 8
  %sep.need.space = icmp ult i64 %k.plus1, %len.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  %sep.ptr = select i1 %sep.need.space, i8* %space.ptr, i8* %empty.ptr
  %order.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %k.cur
  %order.elem = load i64, i64* %order.elem.ptr, align 8
  %fmt.zu.s = getelementptr inbounds [6 x i8], [6 x i8]* @.str.zu_s, i64 0, i64 0
  %call.printf.seq = call i32 (i8*, ...) @printf(i8* %fmt.zu.s, i64 %order.elem, i8* %sep.ptr)
  %k.next = add i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  br label %loop.bfs

loop.bfs.end:
  %nl = call i32 @putchar(i32 10)
  store i64 0, i64* %t, align 8
  br label %loop.dist

loop.dist:
  %t.cur = load i64, i64* %t, align 8
  %V.cur = load i64, i64* %V, align 8
  %cond.dist = icmp ult i64 %t.cur, %V.cur
  br i1 %cond.dist, label %loop.dist.body, label %end

loop.dist.body:
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %t.cur
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src.again = load i64, i64* %src, align 8
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.again, i64 %t.cur, i32 %dist.elem)
  %t.next = add i64 %t.cur, 1
  store i64 %t.next, i64* %t, align 8
  br label %loop.dist

end:
  ret i32 0
}