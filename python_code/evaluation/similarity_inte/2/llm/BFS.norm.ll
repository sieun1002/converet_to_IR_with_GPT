; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/2/BFS.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.header = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str.pzs = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str.space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str.empty = private unnamed_addr constant [1 x i8] zeroinitializer, align 1
@.str.dist = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

define i32 @main() {
entry:
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %order_len = alloca i64, align 8
  %adj.i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(196) %adj.i8, i8 0, i64 196, i1 false)
  %p1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %p2, align 8
  %p7 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %p7, align 4
  %p10 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %p10, align 8
  %p11 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %p11, align 4
  %p14 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %p14, align 8
  %p19 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %p19, align 4
  %p22 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %p22, align 8
  %p29 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %p29, align 4
  %p33 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %p33, align 4
  %p37 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %p37, align 4
  %p39 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %p39, align 4
  %p41 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %p41, align 4
  %p47 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %p47, align 4
  store i64 0, i64* %order_len, align 8
  %adj.elem = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.elem = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.elem = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  call void @bfs(i32* nonnull %adj.elem, i64 7, i64 0, i32* nonnull %dist.elem, i64* nonnull %order.elem, i64* nonnull %order_len)
  %print1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([21 x i8], [21 x i8]* @.str.header, i64 0, i64 0), i64 0)
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %next, %loop1.body ]
  %len.val = load i64, i64* %order_len, align 8
  %cmp1 = icmp ult i64 %i.0, %len.val
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %next = add i64 %i.0, 1
  %cond.space = icmp ult i64 %next, %len.val
  %sep = select i1 %cond.space, i8* getelementptr inbounds ([2 x i8], [2 x i8]* @.str.space, i64 0, i64 0), i8* getelementptr inbounds ([1 x i8], [1 x i8]* @.str.empty, i64 0, i64 0)
  %order.idx.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.0
  %order.val = load i64, i64* %order.idx.ptr, align 8
  %print2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([6 x i8], [6 x i8]* @.str.pzs, i64 0, i64 0), i64 %order.val, i8* %sep)
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %nl = call i32 @putchar(i32 10)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.body, %loop1.end
  %j.0 = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.body ]
  %cmp2 = icmp ult i64 %j.0, 7
  br i1 %cmp2, label %loop2.body, label %ret

loop2.body:                                       ; preds = %loop2.cond
  %dist.idx.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %j.0
  %dist.val = load i32, i32* %dist.idx.ptr, align 4
  %print3 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([23 x i8], [23 x i8]* @.str.dist, i64 0, i64 0), i64 0, i64 %j.0, i32 %dist.val)
  %j.next = add i64 %j.0, 1
  br label %loop2.cond

ret:                                              ; preds = %loop2.cond
  ret i32 0
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @bfs(i32* %adj, i64 %n, i64 %start, i32* %dist, i64* %out_order, i64* %out_count) {
entry:
  %cmp_start_ge_n.not = icmp ult i64 %start, %n
  br i1 %cmp_start_ge_n.not, label %ldist.cond, label %early_out

common.ret:                                       ; preds = %bfs.end, %early_out_after_alloc, %early_out
  ret void

early_out:                                        ; preds = %entry
  store i64 0, i64* %out_count, align 8
  br label %common.ret

ldist.cond:                                       ; preds = %entry, %ldist.body
  %i = phi i64 [ %i.next, %ldist.body ], [ 0, %entry ]
  %i_lt_n = icmp ult i64 %i, %n
  br i1 %i_lt_n, label %ldist.body, label %post_init

ldist.body:                                       ; preds = %ldist.cond
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i
  store i32 -1, i32* %dist.gep, align 4
  %i.next = add i64 %i, 1
  br label %ldist.cond

post_init:                                        ; preds = %ldist.cond
  %malloc_size = shl i64 %n, 3
  %malloc_ptr = call i8* @malloc(i64 %malloc_size)
  %isnull = icmp eq i8* %malloc_ptr, null
  br i1 %isnull, label %early_out_after_alloc, label %after_alloc

early_out_after_alloc:                            ; preds = %post_init
  store i64 0, i64* %out_count, align 8
  br label %common.ret

after_alloc:                                      ; preds = %post_init
  %queue = bitcast i8* %malloc_ptr to i64*
  %dist_start_ptr = getelementptr inbounds i32, i32* %dist, i64 %start
  store i32 0, i32* %dist_start_ptr, align 4
  store i64 %start, i64* %queue, align 8
  store i64 0, i64* %out_count, align 8
  br label %bfs.cond

bfs.cond:                                         ; preds = %inner.cond, %after_alloc
  %head = phi i64 [ 0, %after_alloc ], [ %head.next, %inner.cond ]
  %tail = phi i64 [ 1, %after_alloc ], [ %tail.cur, %inner.cond ]
  %has_items = icmp ult i64 %head, %tail
  br i1 %has_items, label %bfs.iter, label %bfs.end

bfs.iter:                                         ; preds = %bfs.cond
  %qpop.ptr = getelementptr inbounds i64, i64* %queue, i64 %head
  %u = load i64, i64* %qpop.ptr, align 8
  %head.next = add i64 %head, 1
  %count.old = load i64, i64* %out_count, align 8
  %count.next = add i64 %count.old, 1
  store i64 %count.next, i64* %out_count, align 8
  %ord.slot = getelementptr inbounds i64, i64* %out_order, i64 %count.old
  store i64 %u, i64* %ord.slot, align 8
  br label %inner.cond

inner.cond:                                       ; preds = %inner.inc_end, %bfs.iter
  %v = phi i64 [ 0, %bfs.iter ], [ %v.next, %inner.inc_end ]
  %tail.cur = phi i64 [ %tail, %bfs.iter ], [ %tail.updated, %inner.inc_end ]
  %v_lt_n = icmp ult i64 %v, %n
  br i1 %v_lt_n, label %inner.body, label %bfs.cond

inner.body:                                       ; preds = %inner.cond
  %mul = mul i64 %u, %n
  %idx = add i64 %mul, %v
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.elem.ptr, align 4
  %hasEdge.not = icmp eq i32 %adj.val, 0
  br i1 %hasEdge.not, label %inner.inc_end, label %check.unseen

check.unseen:                                     ; preds = %inner.body
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %isUnseen = icmp eq i32 %dist.v, -1
  br i1 %isUnseen, label %visit.enqueue, label %inner.inc_end

visit.enqueue:                                    ; preds = %check.unseen
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.plus1 = add i32 %dist.u, 1
  store i32 %dist.u.plus1, i32* %dist.v.ptr, align 4
  %qtail.ptr = getelementptr inbounds i64, i64* %queue, i64 %tail.cur
  store i64 %v, i64* %qtail.ptr, align 8
  %tail.after = add i64 %tail.cur, 1
  br label %inner.inc_end

inner.inc_end:                                    ; preds = %inner.body, %check.unseen, %visit.enqueue
  %tail.updated = phi i64 [ %tail.after, %visit.enqueue ], [ %tail.cur, %check.unseen ], [ %tail.cur, %inner.body ]
  %v.next = add i64 %v, 1
  br label %inner.cond

bfs.end:                                          ; preds = %bfs.cond
  call void @free(i8* %malloc_ptr)
  br label %common.ret
}

declare i8* @malloc(i64)

declare void @free(i8*)

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
