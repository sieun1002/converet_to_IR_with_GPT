; ModuleID = 'bfs_main'
source_filename = "bfs_main.c"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str.printpair = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %out_len = alloca i64, align 8
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8
  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %out_len, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  %n.val = load i64, i64* %n, align 8
  %t2n = shl i64 %n.val, 1
  %t4n = shl i64 %n.val, 2
  %t3n = add i64 %t2n, %n.val
  %t5n = add i64 %t4n, %n.val
  %t6n = add i64 %t3n, %t3n
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %p.idx1 = getelementptr inbounds i32, i32* %adj.base, i64 %n.val
  store i32 1, i32* %p.idx1, align 4
  %p.idx2 = getelementptr inbounds i32, i32* %adj.base, i64 %t2n
  store i32 1, i32* %p.idx2, align 4
  %idx3 = add i64 %n.val, 3
  %p.idx3 = getelementptr inbounds i32, i32* %adj.base, i64 %idx3
  store i32 1, i32* %p.idx3, align 4
  %idx4 = add i64 %t3n, 1
  %p.idx4 = getelementptr inbounds i32, i32* %adj.base, i64 %idx4
  store i32 1, i32* %p.idx4, align 4
  %idx5 = add i64 %n.val, 4
  %p.idx5 = getelementptr inbounds i32, i32* %adj.base, i64 %idx5
  store i32 1, i32* %p.idx5, align 4
  %idx6 = add i64 %t4n, 1
  %p.idx6 = getelementptr inbounds i32, i32* %adj.base, i64 %idx6
  store i32 1, i32* %p.idx6, align 4
  %idx7 = add i64 %t2n, 5
  %p.idx7 = getelementptr inbounds i32, i32* %adj.base, i64 %idx7
  store i32 1, i32* %p.idx7, align 4
  %idx8 = add i64 %t5n, 2
  %p.idx8 = getelementptr inbounds i32, i32* %adj.base, i64 %idx8
  store i32 1, i32* %p.idx8, align 4
  %idx9 = add i64 %t4n, 5
  %p.idx9 = getelementptr inbounds i32, i32* %adj.base, i64 %idx9
  store i32 1, i32* %p.idx9, align 4
  %idx10 = add i64 %t5n, 4
  %p.idx10 = getelementptr inbounds i32, i32* %adj.base, i64 %idx10
  store i32 1, i32* %p.idx10, align 4
  %idx11 = add i64 %t5n, 6
  %p.idx11 = getelementptr inbounds i32, i32* %adj.base, i64 %idx11
  store i32 1, i32* %p.idx11, align 4
  %idx12 = add i64 %t6n, 5
  %p.idx12 = getelementptr inbounds i32, i32* %adj.base, i64 %idx12
  store i32 1, i32* %p.idx12, align 4
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %n.call = load i64, i64* %n, align 8
  %start.call = load i64, i64* %start, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.call, i64 %start.call, i32* %dist.base, i64* %order.base, i64* %out_len)
  %fmt1.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str.bfs, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call.print1 = call i32 (i8*, ...) @printf(i8* %fmt1.ptr, i64 %start.print)
  store i64 0, i64* %i, align 8
  br label %loop.cond

loop.cond:
  %i.val = load i64, i64* %i, align 8
  %olen.val = load i64, i64* %out_len, align 8
  %cmp = icmp ult i64 %i.val, %olen.val
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:
  %i.plus1 = add i64 %i.val, 1
  %cmp2 = icmp ult i64 %i.plus1, %olen.val
  br i1 %cmp2, label %space.true, label %space.false

space.true:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str.space, i64 0, i64 0
  br label %space.join

space.false:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0
  br label %space.join

space.join:
  %sp.sel = phi i8* [ %space.ptr, %space.true ], [ %empty.ptr, %space.false ]
  %ord.elem.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.val
  %ord.elem = load i64, i64* %ord.elem.ptr, align 8
  %fmtpair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.printpair, i64 0, i64 0
  %call.printpair = call i32 (i8*, ...) @printf(i8* %fmtpair.ptr, i64 %ord.elem, i8* %sp.sel)
  %i.inc = add i64 %i.val, 1
  store i64 %i.inc, i64* %i, align 8
  br label %loop.cond

loop.end:
  %nl = call i32 @putchar(i32 10)
  store i64 0, i64* %v, align 8
  br label %loop2.cond

loop2.cond:
  %v.val = load i64, i64* %v, align 8
  %n.val2 = load i64, i64* %n, align 8
  %cmp.v = icmp ult i64 %v.val, %n.val2
  br i1 %cmp.v, label %loop2.body, label %exit

loop2.body:
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %v.val
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmtdist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %start.re = load i64, i64* %start, align 8
  %call.dist = call i32 (i8*, ...) @printf(i8* %fmtdist.ptr, i64 %start.re, i64 %v.val, i32 %dist.elem)
  %v.inc = add i64 %v.val, 1
  store i64 %v.inc, i64* %v, align 8
  br label %loop2.cond

exit:
  ret i32 0
}