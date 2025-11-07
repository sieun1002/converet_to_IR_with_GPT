; ModuleID = 'bfs_ir'
source_filename = "bfs_ir.ll"
target triple = "x86_64-pc-linux-gnu"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@graph = private unnamed_addr constant [7 x [7 x i8]] [
  [7 x i8] [i8 0, i8 1, i8 1, i8 1, i8 0, i8 0, i8 0],
  [7 x i8] [i8 1, i8 0, i8 0, i8 0, i8 1, i8 0, i8 0],
  [7 x i8] [i8 1, i8 0, i8 0, i8 0, i8 0, i8 1, i8 0],
  [7 x i8] [i8 1, i8 0, i8 0, i8 0, i8 0, i8 0, i8 1],
  [7 x i8] [i8 0, i8 1, i8 0, i8 0, i8 0, i8 0, i8 0],
  [7 x i8] [i8 0, i8 0, i8 1, i8 0, i8 0, i8 0, i8 0],
  [7 x i8] [i8 0, i8 0, i8 0, i8 1, i8 0, i8 0, i8 0]
], align 1

declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main() local_unnamed_addr {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %queue = alloca [7 x i64], align 16
  %i.addr = alloca i32, align 4
  store i32 0, i32* %i.addr, align 4
  br label %init.loop

init.loop:
  %i.val = load i32, i32* %i.addr, align 4
  %cmp.init = icmp slt i32 %i.val, 7
  br i1 %cmp.init, label %init.body, label %init.end

init.body:
  %idxprom = sext i32 %i.val to i64
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %idxprom
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i.addr, align 4
  br label %init.loop

init.end:
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %count = alloca i64, align 8
  store i64 0, i64* %head, align 8
  store i64 1, i64* %tail, align 8
  store i64 1, i64* %count, align 8
  %q0 = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 0
  store i64 0, i64* %q0, align 8
  %o0 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  store i64 0, i64* %o0, align 8
  %d0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 0, i32* %d0, align 4
  br label %bfs.while

bfs.while:
  %head.v = load i64, i64* %head, align 8
  %tail.v = load i64, i64* %tail, align 8
  %cmp.ht = icmp ult i64 %head.v, %tail.v
  br i1 %cmp.ht, label %bfs.iter, label %bfs.done

bfs.iter:
  %q.u.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %head.v
  %u = load i64, i64* %q.u.ptr, align 8
  %head.inc = add nuw i64 %head.v, 1
  store i64 %head.inc, i64* %head, align 8
  %v.addr = alloca i64, align 8
  store i64 0, i64* %v.addr, align 8
  br label %for.v

for.v:
  %v.val = load i64, i64* %v.addr, align 8
  %cmp.v = icmp ult i64 %v.val, 7
  br i1 %cmp.v, label %loop.body, label %after.v

loop.body:
  %u.trunc = trunc i64 %u to i32
  %u.zext = zext i32 %u.trunc to i64
  %adj.rowptr = getelementptr inbounds [7 x [7 x i8]], [7 x [7 x i8]]* @graph, i64 0, i64 %u.zext
  %adj.elem = getelementptr inbounds [7 x i8], [7 x i8]* %adj.rowptr, i64 0, i64 %v.val
  %adj.val = load i8, i8* %adj.elem, align 1
  %adj.ne = icmp ne i8 %adj.val, 0
  br i1 %adj.ne, label %check.dist, label %inc.v

check.dist:
  %dist.ptr.v = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.val
  %dist.v = load i32, i32* %dist.ptr.v, align 4
  %is.unvisited = icmp eq i32 %dist.v, -1
  br i1 %is.unvisited, label %visit, label %inc.v

visit:
  %dist.u.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %u.zext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus = add nsw i32 %dist.u, 1
  store i32 %dist.u.plus, i32* %dist.ptr.v, align 4
  %tail.cur = load i64, i64* %tail, align 8
  %q.tail.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %queue, i64 0, i64 %tail.cur
  store i64 %v.val, i64* %q.tail.ptr, align 8
  %tail.next = add nuw i64 %tail.cur, 1
  store i64 %tail.next, i64* %tail, align 8
  %count.cur = load i64, i64* %count, align 8
  %o.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %count.cur
  store i64 %v.val, i64* %o.ptr, align 8
  %count.next = add nuw i64 %count.cur, 1
  store i64 %count.next, i64* %count, align 8
  br label %inc.v

inc.v:
  %v.next = add nuw i64 %v.val, 1
  store i64 %v.next, i64* %v.addr, align 8
  br label %for.v

after.v:
  br label %bfs.while

bfs.done:
  %fmt_bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call.header = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs.ptr, i64 0)
  %i.print = alloca i64, align 8
  store i64 0, i64* %i.print, align 8
  br label %print.loop

print.loop:
  %i.pv = load i64, i64* %i.print, align 8
  %count.val = load i64, i64* %count, align 8
  %cmp.print = icmp ult i64 %i.pv, %count.val
  br i1 %cmp.print, label %print.body, label %print.after

print.body:
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.pv
  %ord.val = load i64, i64* %ord.ptr, align 8
  %i.plus1 = add nuw i64 %i.pv, 1
  %is.last = icmp eq i64 %i.plus1, %count.val
  br i1 %is.last, label %sel.empty, label %sel.space

sel.empty:
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  br label %do.print

sel.space:
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  br label %do.print

do.print:
  %phi.str = phi i8* [ %empty.ptr, %sel.empty ], [ %space.ptr, %sel.space ]
  %fmt.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %call.item = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 %ord.val, i8* %phi.str)
  %i.pnext = add nuw i64 %i.pv, 1
  store i64 %i.pnext, i64* %i.print, align 8
  br label %print.loop

print.after:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  %j.addr = alloca i64, align 8
  store i64 0, i64* %j.addr, align 8
  br label %dist.loop

dist.loop:
  %j.val = load i64, i64* %j.addr, align 8
  %cmp.j = icmp ult i64 %j.val, 7
  br i1 %cmp.j, label %dist.body, label %done

dist.body:
  %dist.ptr.j = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.val
  %dist.val = load i32, i32* %dist.ptr.j, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.dist, i64 0, i64 %j.val, i32 %dist.val)
  %j.next = add nuw i64 %j.val, 1
  store i64 %j.next, i64* %j.addr, align 8
  br label %dist.loop

done:
  ret i32 0
}