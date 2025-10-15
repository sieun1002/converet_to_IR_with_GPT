; ModuleID = 'bfs_main'
target triple = "x86_64-unknown-linux-gnu"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_fmt = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

; A fixed 7-node adjacency matrix (0/1 integers)
@G = private constant [7 x [7 x i32]] [
  [7 x i32] [i32 0, i32 1, i32 1, i32 0, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 1, i32 0, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 1, i32 1, i32 0, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 0],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 1, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 1],
  [7 x i32] [i32 0, i32 0, i32 0, i32 0, i32 0, i32 0, i32 0]
], align 4

declare i32 @__printf_chk(i32, i8*, ...)
declare i8* @malloc(i64)
declare void @free(i8*)

define i32 @main() {
entry:
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %i.init = alloca i32, align 4
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %qptr = alloca i8*, align 8
  %j.loop = alloca i32, align 4

  ; initialize distances to -1
  %idx0 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  store i32 -1, i32* %idx0, align 4
  %idx1 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 1
  store i32 -1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 2
  store i32 -1, i32* %idx2, align 4
  %idx3 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 3
  store i32 -1, i32* %idx3, align 4
  %idx4 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 4
  store i32 -1, i32* %idx4, align 4
  %idx5 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 5
  store i32 -1, i32* %idx5, align 4
  %idx6 = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 6
  store i32 -1, i32* %idx6, align 4

  ; start from 0
  store i32 0, i32* %idx0, align 4

  ; allocate queue for up to 7 elements (7 * 8 bytes)
  %m = call i8* @malloc(i64 56)
  store i8* %m, i8** %qptr, align 8
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %malloc_null, label %bfs_init

bfs_init:
  ; queue[0] = 0 (as i64)
  %q64 = bitcast i8* %m to i64*
  store i64 0, i64* %q64, align 8
  ; head = 0, tail = 1
  store i64 0, i64* %head, align 8
  store i64 1, i64* %tail, align 8
  ; order[0] not yet filled; we'll fill when popping
  br label %bfs_cond

bfs_cond:
  %h.cur = load i64, i64* %head, align 8
  %t.cur = load i64, i64* %tail, align 8
  %more = icmp slt i64 %h.cur, %t.cur
  br i1 %more, label %bfs_pop, label %bfs_done

bfs_pop:
  ; node = queue[head]
  %q.base = load i8*, i8** %qptr, align 8
  %q.as64 = bitcast i8* %q.base to i64*
  %q.elem.ptr = getelementptr inbounds i64, i64* %q.as64, i64 %h.cur
  %node64 = load i64, i64* %q.elem.ptr, align 8
  %node32 = trunc i64 %node64 to i32

  ; record in order[head] = node
  %ord.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %h.cur
  store i64 %node64, i64* %ord.ptr, align 8

  ; head++
  %h.next = add i64 %h.cur, 1
  store i64 %h.next, i64* %head, align 8

  ; for j = 0..6
  store i32 0, i32* %j.loop, align 4
  br label %forj.cond

forj.cond:
  %j.cur = load i32, i32* %j.loop, align 4
  %j.lt = icmp slt i32 %j.cur, 7
  br i1 %j.lt, label %forj.body, label %forj.end

forj.body:
  ; if G[node][j] != 0 and dist[j] == -1
  %node64a = zext i32 %node32 to i64
  %j64 = zext i32 %j.cur to i64
  %row.ptr = getelementptr inbounds [7 x [7 x i32]], [7 x [7 x i32]]* @G, i64 0, i64 %node64a
  %cell.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %row.ptr, i64 0, i64 %j64
  %adj = load i32, i32* %cell.ptr, align 4
  %adj.ne0 = icmp ne i32 %adj, 0

  %dist.j.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j64
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %is.unvis = icmp eq i32 %dist.j, -1

  %should.enqueue = and i1 %adj.ne0, %is.unvis
  br i1 %should.enqueue, label %enqueue, label %forj.inc

enqueue:
  ; queue[tail] = j
  %t.cur2 = load i64, i64* %tail, align 8
  %q.base2 = load i8*, i8** %qptr, align 8
  %q.as64.2 = bitcast i8* %q.base2 to i64*
  %q.tail.ptr = getelementptr inbounds i64, i64* %q.as64.2, i64 %t.cur2
  %j.as64 = zext i32 %j.cur to i64
  store i64 %j.as64, i64* %q.tail.ptr, align 8
  ; tail++
  %t.next = add i64 %t.cur2, 1
  store i64 %t.next, i64* %tail, align 8
  ; dist[j] = dist[node] + 1
  %dist.node.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %node64a
  %dist.node = load i32, i32* %dist.node.ptr, align 4
  %dist.next = add i32 %dist.node, 1
  store i32 %dist.next, i32* %dist.j.ptr, align 4
  br label %forj.inc

forj.inc:
  %j.next = add i32 %j.cur, 1
  store i32 %j.next, i32* %j.loop, align 4
  br label %forj.cond

forj.end:
  br label %bfs_cond

bfs_done:
  ; free queue
  %q.free = load i8*, i8** %qptr, align 8
  call void @free(i8* %q.free)
  br label %print_header

malloc_null:
  br label %print_header

print_header:
  ; print "BFS order from %zu: " with start=0
  %fmt.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call.phdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt.ptr, i64 0)
  ; compute count = tail (if malloc failed, tail is uninitialized; set to 1 in that case to print only start)
  %m.chk = load i8*, i8** %qptr, align 8
  %was.null = icmp eq i8* %m.chk, null
  br i1 %was.null, label %set_count_null, label %use_tail

set_count_null:
  store i64 1, i64* %tail, align 8
  br label %after_count

use_tail:
  br label %after_count

after_count:
  %cnt = load i64, i64* %tail, align 8
  %one = icmp eq i64 %cnt, 1
  br i1 %one, label %print_single, label %print_multi

print_multi:
  ; print elements 1..cnt-1 with space suffix
  %i.start = phi i64 [ 1, %after_count ], [ %i.next2, %print_multi.body ]
  %cond.more = icmp slt i64 %i.start, %cnt
  br i1 %cond.more, label %print_multi.body, label %print_first

print_multi.body:
  %ord.ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.start
  %val = load i64, i64* %ord.ptr2, align 8
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %space = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %call.print = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2, i64 %val, i8* %space)
  %i.next2 = add i64 %i.start, 1
  br label %print_multi

print_first:
  ; print first element with empty suffix
  %first.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %first = load i64, i64* %first.ptr, align 8
  %fmt3 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %empty = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call.first = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt3, i64 %first, i8* %empty)
  br label %print_newline

print_single:
  ; when only one element, print order[0] (or 0 if malloc failed)
  %m.chk2 = load i8*, i8** %qptr, align 8
  %was.null2 = icmp eq i8* %m.chk2, null
  br i1 %was.null2, label %single_if_null, label %single_if_notnull

single_if_null:
  %fmt4a = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %empty4a = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call.single.null = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt4a, i64 0, i8* %empty4a)
  br label %print_newline

single_if_notnull:
  %first.ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %first2 = load i64, i64* %first.ptr2, align 8
  %fmt4 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %empty4 = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %call.single = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt4, i64 %first2, i8* %empty4)
  br label %print_newline

print_newline:
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call.nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl.ptr)
  br label %print_dists.init

print_dists.init:
  store i32 0, i32* %i.init, align 4
  br label %print_dists.cond

print_dists.cond:
  %i.cur = load i32, i32* %i.init, align 4
  %i.lt7 = icmp slt i32 %i.cur, 7
  br i1 %i.lt7, label %print_dists.body, label %retblk

print_dists.body:
  %i64 = zext i32 %i.cur to i64
  %dist.ptr.i = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %i64
  %d.val = load i32, i32* %dist.ptr.i, align 4
  %fmtd = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %call.dist = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmtd, i64 0, i64 %i64, i32 %d.val)
  %i.next = add i32 %i.cur, 1
  store i32 %i.next, i32* %i.init, align 4
  br label %print_dists.cond

retblk:
  ret i32 0
}