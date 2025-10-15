; ModuleID = 'bfs_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@.str_bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_item = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare i32 @printf(i8*, ...)
declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %src, i64* %order_out, i64* %count_out, i32* %dist_out) {
entry:
  %i.init = alloca i64, align 8
  %head = alloca i64, align 8
  %tail = alloca i64, align 8
  %queue = alloca i64, i64 %n, align 8
  store i64 0, i64* %i.init, align 8
  br label %init.loop

init.loop:                                           ; preds = %init.body, %entry
  %i.cur = load i64, i64* %i.init, align 8
  %cmp.init = icmp ult i64 %i.cur, %n
  br i1 %cmp.init, label %init.body, label %init.done

init.body:                                           ; preds = %init.loop
  %dist.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %i.cur
  store i32 -1, i32* %dist.ptr, align 4
  %i.next = add i64 %i.cur, 1
  store i64 %i.next, i64* %i.init, align 8
  br label %init.loop

init.done:                                           ; preds = %init.loop
  store i64 0, i64* %head, align 8
  store i64 0, i64* %tail, align 8
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %src
  store i32 0, i32* %dist.src.ptr, align 4
  %tail0 = load i64, i64* %tail, align 8
  %q.enq.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail0
  store i64 %src, i64* %q.enq.ptr, align 8
  %tail1 = add i64 %tail0, 1
  store i64 %tail1, i64* %tail, align 8
  store i64 0, i64* %count_out, align 8
  br label %bfs.loop

bfs.loop:                                            ; preds = %bfs.after.neigh, %init.done
  %head.cur = load i64, i64* %head, align 8
  %tail.cur = load i64, i64* %tail, align 8
  %q.nonempty = icmp ult i64 %head.cur, %tail.cur
  br i1 %q.nonempty, label %bfs.pop, label %bfs.done

bfs.pop:                                             ; preds = %bfs.loop
  %q.deq.ptr = getelementptr inbounds i64, i64* %queue, i64 %head.cur
  %u = load i64, i64* %q.deq.ptr, align 8
  %head.next = add i64 %head.cur, 1
  store i64 %head.next, i64* %head, align 8
  %ord.count0 = load i64, i64* %count_out, align 8
  %ord.slot = getelementptr inbounds i64, i64* %order_out, i64 %ord.count0
  store i64 %u, i64* %ord.slot, align 8
  %ord.count1 = add i64 %ord.count0, 1
  store i64 %ord.count1, i64* %count_out, align 8
  %v.init = alloca i64, align 8
  store i64 0, i64* %v.init, align 8
  br label %neigh.loop

neigh.loop:                                          ; preds = %neigh.body, %bfs.pop
  %v.cur = load i64, i64* %v.init, align 8
  %cmp.v = icmp ult i64 %v.cur, %n
  br i1 %cmp.v, label %neigh.body, label %bfs.after.neigh

neigh.body:                                          ; preds = %neigh.loop
  %mul.un = mul i64 %u, %n
  %idx = add i64 %mul.un, %v.cur
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %edge.val = load i32, i32* %adj.ptr, align 4
  %has.edge = icmp ne i32 %edge.val, 0
  br i1 %has.edge, label %check.visit, label %skip.neigh

check.visit:                                         ; preds = %neigh.body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %v.cur
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %unvisited = icmp eq i32 %dist.v, -1
  br i1 %unvisited, label %visit.v, label %skip.neigh

visit.v:                                             ; preds = %check.visit
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist_out, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %tail.cur2 = load i64, i64* %tail, align 8
  %q.enq.ptr2 = getelementptr inbounds i64, i64* %queue, i64 %tail.cur2
  store i64 %v.cur, i64* %q.enq.ptr2, align 8
  %tail.next2 = add i64 %tail.cur2, 1
  store i64 %tail.next2, i64* %tail, align 8
  br label %skip.neigh

skip.neigh:                                          ; preds = %visit.v, %check.visit, %neigh.body
  %v.next = add i64 %v.cur, 1
  store i64 %v.next, i64* %v.init, align 8
  br label %neigh.loop

bfs.after.neigh:                                     ; preds = %neigh.loop
  br label %bfs.loop

bfs.done:                                            ; preds = %bfs.loop
  ret void
}

define i32 @main() {
entry:
  %n = alloca i64, align 8
  store i64 7, i64* %n, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %count = alloca i64, align 8
  %src = alloca i64, align 8
  store i64 0, i64* %src, align 8
  store i64 0, i64* %count, align 8
  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i32 0, i32 0
  %i.zero = alloca i64, align 8
  store i64 0, i64* %i.zero, align 8
  br label %zero.loop

zero.loop:                                           ; preds = %zero.body, %entry
  %i.cur0 = load i64, i64* %i.zero, align 8
  %cmp.zero = icmp ult i64 %i.cur0, 49
  br i1 %cmp.zero, label %zero.body, label %zero.done

zero.body:                                           ; preds = %zero.loop
  %z.ptr = getelementptr inbounds i32, i32* %adj.base, i64 %i.cur0
  store i32 0, i32* %z.ptr, align 4
  %i.next0 = add i64 %i.cur0, 1
  store i64 %i.next0, i64* %i.zero, align 8
  br label %zero.loop

zero.done:                                           ; preds = %zero.loop
  %idx1 = getelementptr inbounds i32, i32* %adj.base, i64 1
  store i32 1, i32* %idx1, align 4
  %idx2 = getelementptr inbounds i32, i32* %adj.base, i64 2
  store i32 1, i32* %idx2, align 4
  %idx10 = getelementptr inbounds i32, i32* %adj.base, i64 10
  store i32 1, i32* %idx10, align 4
  %idx22 = getelementptr inbounds i32, i32* %adj.base, i64 22
  store i32 1, i32* %idx22, align 4
  %idx11 = getelementptr inbounds i32, i32* %adj.base, i64 11
  store i32 1, i32* %idx11, align 4
  %idx29 = getelementptr inbounds i32, i32* %adj.base, i64 29
  store i32 1, i32* %idx29, align 4
  %idx19 = getelementptr inbounds i32, i32* %adj.base, i64 19
  store i32 1, i32* %idx19, align 4
  %idx37 = getelementptr inbounds i32, i32* %adj.base, i64 37
  store i32 1, i32* %idx37, align 4
  %idx33 = getelementptr inbounds i32, i32* %adj.base, i64 33
  store i32 1, i32* %idx33, align 4
  %idx39 = getelementptr inbounds i32, i32* %adj.base, i64 39
  store i32 1, i32* %idx39, align 4
  %idx41 = getelementptr inbounds i32, i32* %adj.base, i64 41
  store i32 1, i32* %idx41, align 4
  %idx47 = getelementptr inbounds i32, i32* %adj.base, i64 47
  store i32 1, i32* %idx47, align 4
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i32 0, i32 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i32 0, i32 0
  %n.val = load i64, i64* %n, align 8
  %src.val = load i64, i64* %src, align 8
  call void @bfs(i32* %adj.base, i64 %n.val, i64 %src.val, i64* %order.base, i64* %count, i32* %dist.base)
  %fmt.bfs.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_bfs, i32 0, i32 0
  %src.val2 = load i64, i64* %src, align 8
  %call.printf0 = call i32 (i8*, ...) @printf(i8* %fmt.bfs.ptr, i64 %src.val2)
  %i.out = alloca i64, align 8
  store i64 0, i64* %i.out, align 8
  br label %print.loop

print.loop:                                          ; preds = %print.body, %zero.done
  %i.cur1 = load i64, i64* %i.out, align 8
  %count.val = load i64, i64* %count, align 8
  %cmp.out = icmp ult i64 %i.cur1, %count.val
  br i1 %cmp.out, label %print.body, label %after.print

print.body:                                          ; preds = %print.loop
  %next.i = add i64 %i.cur1, 1
  %has.next = icmp ult i64 %next.i, %count.val
  %sep.ptr = select i1 %has.next, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str_space, i32 0, i32 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str_empty, i32 0, i32 0)
  %val.ptr = getelementptr inbounds i64, i64* %order.base, i64 %i.cur1
  %val = load i64, i64* %val.ptr, align 8
  %fmt.item.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_item, i32 0, i32 0
  %call.printf1 = call i32 (i8*, ...) @printf(i8* %fmt.item.ptr, i64 %val, i8* %sep.ptr)
  store i64 %next.i, i64* %i.out, align 8
  br label %print.loop

after.print:                                         ; preds = %print.loop
  %nl = call i32 @putchar(i32 10)
  %i.dist = alloca i64, align 8
  store i64 0, i64* %i.dist, align 8
  br label %dist.loop

dist.loop:                                           ; preds = %dist.body, %after.print
  %i.cur2 = load i64, i64* %i.dist, align 8
  %n.cur = load i64, i64* %n, align 8
  %cmp.dist = icmp ult i64 %i.cur2, %n.cur
  br i1 %cmp.dist, label %dist.body, label %done

dist.body:                                           ; preds = %dist.loop
  %d.ptr = getelementptr inbounds i32, i32* %dist.base, i64 %i.cur2
  %d.val = load i32, i32* %d.ptr, align 4
  %fmt.dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i32 0, i32 0
  %src.val3 = load i64, i64* %src, align 8
  %i.cur2.z = zext i64 %i.cur2 to i64
  %call.printf2 = call i32 (i8*, ...) @printf(i8* %fmt.dist.ptr, i64 %src.val3, i64 %i.cur2.z, i32 %d.val)
  %i.next2 = add i64 %i.cur2, 1
  store i64 %i.next2, i64* %i.dist, align 8
  br label %dist.loop

done:                                                ; preds = %dist.loop
  ret i32 0
}