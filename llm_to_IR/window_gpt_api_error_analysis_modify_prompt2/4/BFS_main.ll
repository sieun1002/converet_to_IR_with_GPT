; ModuleID = 'bfs_main_fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_hdr = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @bfs(i32*, i64, i64, i8*, i64*, i64*)
declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() {
entry:
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %count = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %adj = alloca [48 x i32], align 16
  %dist = alloca [64 x i32], align 16
  %order = alloca [64 x i64], align 16

  store i64 7, i64* %n, align 8

  %adj.i8 = bitcast [48 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 192, i1 false)

  ; set adj[0] = 0 (already zeroed, but keep as per assembly)
  %adj0.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  store i32 0, i32* %adj0.ptr, align 4

  ; set specific entries to 1
  %adj1.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj1.ptr, align 4
  %adj7.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj7.ptr, align 4
  %adj14.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj14.ptr, align 4
  %adj10.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj10.ptr, align 4
  %adj22.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj22.ptr, align 4
  %adj11.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj11.ptr, align 4
  %adj29.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj29.ptr, align 4
  %adj19.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj19.ptr, align 4
  %adj37.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj37.ptr, align 4
  %adj33.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj33.ptr, align 4
  %adj39.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj39.ptr, align 4
  %adj41.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj41.ptr, align 4
  %adj47.ptr = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj47.ptr, align 4

  ; initialize start and count
  store i64 0, i64* %start, align 8
  store i64 0, i64* %count, align 8

  ; call bfs(adj, n, start, context, &count, order)
  %adj.base = getelementptr inbounds [48 x i32], [48 x i32]* %adj, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8
  %dist.base = getelementptr inbounds [64 x i32], [64 x i32]* %dist, i64 0, i64 0
  %ctx = bitcast i32* %dist.base to i8*
  %order.base = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %start.val, i8* %ctx, i64* %count, i64* %order.base)

  ; printf("BFS order from %zu: ", start)
  %fmt_hdr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call_printf_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr, i64 %start.val2)

  ; i = 0
  store i64 0, i64* %i, align 8
  br label %loop1.cond

loop1.cond:                                         ; preds = %loop1.body, %entry
  %i.cur = load i64, i64* %i, align 8
  %count.cur = load i64, i64* %count, align 8
  %cmp1 = icmp ult i64 %i.cur, %count.cur
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                         ; preds = %loop1.cond
  ; determine separator
  %i.plus1 = add i64 %i.cur, 1
  %lt.next = icmp ult i64 %i.plus1, %count.cur
  %space.ptr = select i1 %lt.next, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0)
  ; value = order[i]
  %order.elem.ptr = getelementptr inbounds [64 x i64], [64 x i64]* %order, i64 0, i64 %i.cur
  %order.val = load i64, i64* %order.elem.ptr, align 8
  ; printf("%zu%s", value, sep)
  %fmt_zu_s = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call_printf_item = call i32 (i8*, ...) @printf(i8* %fmt_zu_s, i64 %order.val, i8* %space.ptr)
  ; i++
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop1.cond

loop1.end:                                          ; preds = %loop1.cond
  ; newline
  %call_nl = call i32 @putchar(i32 10)

  ; j = 0
  store i64 0, i64* %j, align 8
  br label %loop2.cond

loop2.cond:                                         ; preds = %loop2.body, %loop1.end
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp2 = icmp ult i64 %j.cur, %n.cur
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                         ; preds = %loop2.cond
  ; load dist[j] (i32)
  %dist.elem.ptr = getelementptr inbounds [64 x i32], [64 x i32]* %dist, i64 0, i64 %j.cur
  %dist.val = load i32, i32* %dist.elem.ptr, align 4
  ; printf("dist(%zu -> %zu) = %d\n", start, j, dist[j])
  %fmt_dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start.val3 = load i64, i64* %start, align 8
  %call_printf_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist, i64 %start.val3, i64 %j.cur, i32 %dist.val)
  ; j++
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop2.cond

loop2.end:                                          ; preds = %loop2.cond
  ret i32 0
}