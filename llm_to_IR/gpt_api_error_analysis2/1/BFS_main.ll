; ModuleID = 'bfs_main'
source_filename = "bfs_main.c"
target triple = "x86_64-pc-linux-gnu"

@.str_title = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @bfs(i32*, i64, i64, i32*, i64*, i64*)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1)

define i32 @main() {
entry:
  %graph = alloca [49 x i32], align 16
  %order = alloca [7 x i64], align 16
  %dist = alloca [7 x i32], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8

  store i64 7, i64* %n, align 8
  store i64 0, i64* %start, align 8
  store i64 0, i64* %count, align 8

  %graph.i8 = bitcast [49 x i32]* %graph to i8*
  call void @llvm.memset.p0i8.i64(i8* %graph.i8, i8 0, i64 196, i1 false)

  %gbase = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0

  %p1 = getelementptr inbounds i32, i32* %gbase, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %gbase, i64 2
  store i32 1, i32* %p2, align 4
  %p7 = getelementptr inbounds i32, i32* %gbase, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds i32, i32* %gbase, i64 10
  store i32 1, i32* %p10, align 4
  %p11 = getelementptr inbounds i32, i32* %gbase, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds i32, i32* %gbase, i64 14
  store i32 1, i32* %p14, align 4
  %p19 = getelementptr inbounds i32, i32* %gbase, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds i32, i32* %gbase, i64 22
  store i32 1, i32* %p22, align 4
  %p29 = getelementptr inbounds i32, i32* %gbase, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds i32, i32* %gbase, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds i32, i32* %gbase, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds i32, i32* %gbase, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds i32, i32* %gbase, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds i32, i32* %gbase, i64 47
  store i32 1, i32* %p47, align 4

  %gptr = getelementptr inbounds [49 x i32], [49 x i32]* %graph, i64 0, i64 0
  %dptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %optr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0

  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  call void @bfs(i32* %gptr, i64 %n.val, i64 %start.val, i32* %dptr, i64* %optr, i64* %count)

  %fmt_title.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_title, i64 0, i64 0
  %start.print = load i64, i64* %start, align 8
  %call_title = call i32 (i8*, ...) @printf(i8* %fmt_title.ptr, i64 %start.print)

  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:
  %i.cur = load i64, i64* %i, align 8
  %cnt.cur = load i64, i64* %count, align 8
  %cmp1 = icmp ult i64 %i.cur, %cnt.cur
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:
  %i.plus1 = add i64 %i.cur, 1
  %cnt.cur2 = load i64, i64* %count, align 8
  %has_more = icmp ult i64 %i.plus1, %cnt.cur2
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.ptr = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr

  %ord.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %ord.elem.ptr = getelementptr inbounds i64, i64* %ord.base, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8

  %fmt_pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_pair = call i32 (i8*, ...) @printf(i8* %fmt_pair.ptr, i64 %ord.val, i8* %sep.ptr)
  br label %loop1.inc

loop1.inc:
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp2, label %loop2.body, label %end

loop2.body:
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %j.cur
  %dist.val = load i32, i32* %dist.elem.ptr, align 4

  %fmt_dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start.print2 = load i64, i64* %start, align 8
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist.ptr, i64 %start.print2, i64 %j.cur, i32 %dist.val)

  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

end:
  ret i32 0
}