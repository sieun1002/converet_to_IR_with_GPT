; ModuleID = 'bfs_main.ll'
source_filename = "bfs_main.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare dso_local void @bfs(i32* nocapture, i64, i64, i32* nocapture, i64* nocapture, i64* nocapture)
declare dso_local i32 @printf(i8*, ...)
declare dso_local i32 @putchar(i32)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define dso_local i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %len = alloca i64, align 8
  %n = alloca i64, align 8
  %src = alloca i64, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.i8, i8 0, i64 196, i1 false)
  store i64 7, i64* %n, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %len, align 8
  %adj.idx1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1, align 4
  %adj.idx7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7, align 4
  %adj.idx2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2, align 4
  %adj.idx14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14, align 4
  %adj.idx10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10, align 4
  %adj.idx22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22, align 4
  %adj.idx11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11, align 4
  %adj.idx29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29, align 4
  %adj.idx19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19, align 4
  %adj.idx37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37, align 4
  %adj.idx33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33, align 4
  %adj.idx39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39, align 4
  %adj.idx41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41, align 4
  %adj.idx47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47, align 4
  %adj.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.ptr, i64 %n.val, i64 %src.val, i32* %dist.ptr, i64* %order.ptr, i64* %len)
  %fmt.bfs = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %src.print = load i64, i64* %src, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt.bfs, i64 %src.print)
  store i64 0, i64* %i, align 8
  br label %loop.items

loop.items:                                        ; preds = %body.items, %entry
  %i.cur = load i64, i64* %i, align 8
  %len.cur = load i64, i64* %len, align 8
  %cond.items = icmp ult i64 %i.cur, %len.cur
  br i1 %cond.items, label %body.items, label %after.items

body.items:                                        ; preds = %loop.items
  %i.plus1 = add i64 %i.cur, 1
  %len.again = load i64, i64* %len, align 8
  %is.last = icmp uge i64 %i.plus1, %len.again
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %sep.ptr = select i1 %is.last, i8* %empty.ptr, i8* %space.ptr
  %order.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %order.elem = load i64, i64* %order.elem.ptr, align 8
  %fmt.item = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i64 0, i64 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.item, i64 %order.elem, i8* %sep.ptr)
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i, align 8
  br label %loop.items

after.items:                                       ; preds = %loop.items
  %nl.call = call i32 @putchar(i32 10)
  store i64 0, i64* %j, align 8
  br label %loop.dist

loop.dist:                                         ; preds = %body.dist, %after.items
  %j.cur = load i64, i64* %j, align 8
  %n.cur = load i64, i64* %n, align 8
  %cond.dist = icmp ult i64 %j.cur, %n.cur
  br i1 %cond.dist, label %body.dist, label %ret.block

body.dist:                                         ; preds = %loop.dist
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.cur
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %src.print2 = load i64, i64* %src, align 8
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.print2, i64 %j.cur, i32 %dist.elem)
  %j.next = add i64 %j.cur, 1
  store i64 %j.next, i64* %j, align 8
  br label %loop.dist

ret.block:                                         ; preds = %loop.dist
  ret i32 0
}