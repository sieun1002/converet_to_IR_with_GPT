; ModuleID = 'BFS.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.bfs = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.zu_s = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

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

loop.bfs:                                         ; preds = %loop.bfs.body, %entry
  %k.cur = load i64, i64* %k, align 8
  %len.cur = load i64, i64* %order_len, align 8
  %cond = icmp ult i64 %k.cur, %len.cur
  br i1 %cond, label %loop.bfs.body, label %loop.bfs.end

loop.bfs.body:                                    ; preds = %loop.bfs
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

loop.bfs.end:                                     ; preds = %loop.bfs
  %nl = call i32 @putchar(i32 10)
  store i64 0, i64* %t, align 8
  br label %loop.dist

loop.dist:                                        ; preds = %loop.dist.body, %loop.bfs.end
  %t.cur = load i64, i64* %t, align 8
  %V.cur = load i64, i64* %V, align 8
  %cond.dist = icmp ult i64 %t.cur, %V.cur
  br i1 %cond.dist, label %loop.dist.body, label %end

loop.dist.body:                                   ; preds = %loop.dist
  %dist.elem.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %t.cur
  %dist.elem = load i32, i32* %dist.elem.ptr, align 4
  %fmt.dist = getelementptr inbounds [23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0
  %src.again = load i64, i64* %src, align 8
  %call.printf.dist = call i32 (i8*, ...) @printf(i8* %fmt.dist, i64 %src.again, i64 %t.cur, i32 %dist.elem)
  %t.next = add i64 %t.cur, 1
  store i64 %t.next, i64* %t, align 8
  br label %loop.dist

end:                                              ; preds = %loop.dist
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

; Function Attrs: nounwind
define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out, i64* %count) #1 {
entry:
  %n_is_zero = icmp eq i64 %n, 0
  br i1 %n_is_zero, label %early_ret0, label %check_start

early_ret0:                                       ; preds = %entry
  store i64 0, i64* %count, align 8
  ret void

check_start:                                      ; preds = %entry
  %start_ok = icmp ult i64 %start, %n
  br i1 %start_ok, label %init_loop.preheader, label %early_ret0_2

early_ret0_2:                                     ; preds = %check_start
  store i64 0, i64* %count, align 8
  ret void

init_loop.preheader:                              ; preds = %check_start
  br label %init_loop

init_loop:                                        ; preds = %init_body, %init_loop.preheader
  %i = phi i64 [ 0, %init_loop.preheader ], [ %i.next, %init_body ]
  %i_cond = icmp ult i64 %i, %n
  br i1 %i_cond, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %dist_i_ptr = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist_i_ptr, align 4
  %i.next = add i64 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  %size.bytes = shl i64 %n, 3
  %q.raw = call i8* @malloc(i64 %size.bytes)
  %q = bitcast i8* %q.raw to i64*
  %q.isnull = icmp eq i64* %q, null
  br i1 %q.isnull, label %malloc_fail, label %post_alloc

malloc_fail:                                      ; preds = %after_init
  store i64 0, i64* %count, align 8
  ret void

post_alloc:                                       ; preds = %after_init
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  %q_tail0 = getelementptr inbounds i64, i64* %q, i64 0
  store i64 %start, i64* %q_tail0, align 8
  store i64 0, i64* %count, align 8
  br label %bfs_loop

bfs_loop:                                         ; preds = %after_neighbors, %post_alloc
  %head = phi i64 [ 0, %post_alloc ], [ %head.next, %after_neighbors ]
  %tail = phi i64 [ 1, %post_alloc ], [ %tail.out, %after_neighbors ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %dequeue, label %done

dequeue:                                          ; preds = %bfs_loop
  %u.ptr = getelementptr inbounds i64, i64* %q, i64 %head
  %u = load i64, i64* %u.ptr, align 8
  %head.next0 = add i64 %head, 1
  %cnt.old = load i64, i64* %count, align 8
  %out.slot = getelementptr inbounds i64, i64* %out, i64 %cnt.old
  store i64 %u, i64* %out.slot, align 8
  %cnt.new = add i64 %cnt.old, 1
  store i64 %cnt.new, i64* %count, align 8
  br label %neighbors

neighbors:                                        ; preds = %neighbors_latch, %dequeue
  %v = phi i64 [ 0, %dequeue ], [ %v.next, %neighbors_latch ]
  %tail.cur = phi i64 [ %tail, %dequeue ], [ %tail.next, %neighbors_latch ]
  %more_v = icmp ult i64 %v, %n
  br i1 %more_v, label %neighbors_body, label %after_neighbors

neighbors_body:                                   ; preds = %neighbors
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.zero, label %skip_neighbor, label %check_unvis

check_unvis:                                      ; preds = %neighbors_body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %is_unvis = icmp eq i32 %dist.v, -1
  br i1 %is_unvis, label %visit_neighbor, label %skip_neighbor

visit_neighbor:                                   ; preds = %check_unvis
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add nsw i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %q.tail.ptr = getelementptr inbounds i64, i64* %q, i64 %tail.cur
  store i64 %v, i64* %q.tail.ptr, align 8
  %tail.inc = add i64 %tail.cur, 1
  br label %neighbors_latch

skip_neighbor:                                    ; preds = %check_unvis, %neighbors_body
  br label %neighbors_latch

neighbors_latch:                                  ; preds = %skip_neighbor, %visit_neighbor
  %tail.next = phi i64 [ %tail.inc, %visit_neighbor ], [ %tail.cur, %skip_neighbor ]
  %v.next = add i64 %v, 1
  br label %neighbors

after_neighbors:                                  ; preds = %neighbors
  %head.next = phi i64 [ %head.next0, %neighbors ]
  %tail.out = phi i64 [ %tail.cur, %neighbors ]
  br label %bfs_loop

done:                                             ; preds = %bfs_loop
  %q.bc = bitcast i64* %q to i8*
  call void @free(i8* %q.bc)
  ret void
}

; Function Attrs: nounwind
declare noalias i8* @malloc(i64) #1

; Function Attrs: nounwind
declare void @free(i8* nocapture) #1

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
attributes #1 = { nounwind }
