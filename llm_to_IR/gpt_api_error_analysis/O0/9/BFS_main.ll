; ModuleID = 'bfs_main'
source_filename = "bfs_main.ll"
target triple = "x86_64-pc-linux-gnu"
; adjust datalayout if needed for your toolchain
; target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@__stack_chk_guard = external thread_local global i64
declare void @__stack_chk_fail() noreturn

declare void @bfs(i32* noundef, i64 noundef, i64 noundef, i32* noundef, i64* noundef, i64* noundef)
declare i32 @printf(i8* noundef, ...)
declare i32 @putchar(i32 noundef)

@.str_hdr   = private unnamed_addr constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_pair  = private unnamed_addr constant [6 x i8] c"%zu%s\00", align 1
@.str_space = private unnamed_addr constant [2 x i8] c" \00", align 1
@.str_empty = private unnamed_addr constant [1 x i8] c"\00", align 1
@.str_dist  = private unnamed_addr constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define i32 @main() local_unnamed_addr {
entry:
  %canary.slot = alloca i64, align 8
  %adj = alloca [49 x i32], align 16
  %dist = alloca [7 x i32], align 16
  %order = alloca [7 x i64], align 16
  %n = alloca i64, align 8
  %start = alloca i64, align 8
  %order_len = alloca i64, align 8
  %i = alloca i64, align 8
  %v = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary.slot, align 8

  store i64 7, i64* %n, align 8

  %adj.cast = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj.cast, i8 0, i64 196, i1 false)

  ; edges: 0-1, 0-2, 1-3, 1-4, 2-5, 4-5, 5-6 (undirected)
  ; adj[0][1] = 1
  %adj.idx1.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 1
  store i32 1, i32* %adj.idx1.ptr, align 4
  ; adj[1][0] = 1
  %adj.idx7.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 7
  store i32 1, i32* %adj.idx7.ptr, align 4
  ; adj[0][2] = 1
  %adj.idx2.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 2
  store i32 1, i32* %adj.idx2.ptr, align 4
  ; adj[2][0] = 1
  %adj.idx14.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 14
  store i32 1, i32* %adj.idx14.ptr, align 4
  ; adj[1][3] = 1
  %adj.idx10.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 10
  store i32 1, i32* %adj.idx10.ptr, align 4
  ; adj[3][1] = 1
  %adj.idx22.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 22
  store i32 1, i32* %adj.idx22.ptr, align 4
  ; adj[1][4] = 1
  %adj.idx11.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 11
  store i32 1, i32* %adj.idx11.ptr, align 4
  ; adj[4][1] = 1
  %adj.idx29.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 29
  store i32 1, i32* %adj.idx29.ptr, align 4
  ; adj[2][5] = 1
  %adj.idx19.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 19
  store i32 1, i32* %adj.idx19.ptr, align 4
  ; adj[5][2] = 1
  %adj.idx37.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 37
  store i32 1, i32* %adj.idx37.ptr, align 4
  ; adj[4][5] = 1
  %adj.idx33.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 33
  store i32 1, i32* %adj.idx33.ptr, align 4
  ; adj[5][4] = 1
  %adj.idx39.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 39
  store i32 1, i32* %adj.idx39.ptr, align 4
  ; adj[5][6] = 1
  %adj.idx41.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 41
  store i32 1, i32* %adj.idx41.ptr, align 4
  ; adj[6][5] = 1
  %adj.idx47.ptr = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 47
  store i32 1, i32* %adj.idx47.ptr, align 4

  store i64 0, i64* %start, align 8
  store i64 0, i64* %order_len, align 8

  %adj.base = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 0
  %dist.base = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 0
  %order.base = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 0
  %n.val = load i64, i64* %n, align 8
  %start.val = load i64, i64* %start, align 8

  call void @bfs(i32* %adj.base, i64 %n.val, i64 %start.val, i32* %dist.base, i64* %order.base, i64* %order_len)

  %fmt_hdr.ptr = getelementptr inbounds [21 x i8], [21 x i8]* @.str_hdr, i64 0, i64 0
  %start.val2 = load i64, i64* %start, align 8
  %call_hdr = call i32 (i8*, ...) @printf(i8* %fmt_hdr.ptr, i64 %start.val2)

  store i64 0, i64* %i, align 8
  br label %loop_order

loop_order:                                           ; preds = %loop_body, %entry
  %i.cur = phi i64 [ 0, %entry ], [ %i.next, %loop_body ]
  %len.cur = load i64, i64* %order_len, align 8
  %cond.cont = icmp ult i64 %i.cur, %len.cur
  br i1 %cond.cont, label %loop_body, label %after_order

loop_body:                                            ; preds = %loop_order
  %i.plus1 = add i64 %i.cur, 1
  %has_more = icmp ult i64 %i.plus1, %len.cur
  %space.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_space, i64 0, i64 0
  %empty.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @.str_empty, i64 0, i64 0
  %delim.ptr = select i1 %has_more, i8* %space.ptr, i8* %empty.ptr
  %ord.elem.ptr = getelementptr inbounds [7 x i64], [7 x i64]* %order, i64 0, i64 %i.cur
  %ord.val = load i64, i64* %ord.elem.ptr, align 8
  %fmt_pair.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_pair, i64 0, i64 0
  %call_pair = call i32 (i8*, ...) @printf(i8* %fmt_pair.ptr, i64 %ord.val, i8* %delim.ptr)
  %i.next = add i64 %i.cur, 1
  br label %loop_order

after_order:                                          ; preds = %loop_order
  %nl = call i32 @putchar(i32 10)

  store i64 0, i64* %v, align 8
  br label %loop_dist

loop_dist:                                            ; preds = %dist_body, %after_order
  %v.cur = phi i64 [ 0, %after_order ], [ %v.next, %dist_body ]
  %n.now = load i64, i64* %n, align 8
  %cont.dist = icmp ult i64 %v.cur, %n.now
  br i1 %cont.dist, label %dist_body, label %epilogue

dist_body:                                            ; preds = %loop_dist
  %dist.ptr = getelementptr inbounds [7 x i32], [7 x i32]* %dist, i64 0, i64 %v.cur
  %dval = load i32, i32* %dist.ptr, align 4
  %fmt_dist.ptr = getelementptr inbounds [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %start.for.dist = load i64, i64* %start, align 8
  %call_dist = call i32 (i8*, ...) @printf(i8* %fmt_dist.ptr, i64 %start.for.dist, i64 %v.cur, i32 %dval)
  %v.next = add i64 %v.cur, 1
  br label %loop_dist

epilogue:                                             ; preds = %loop_dist
  %guard.load = load i64, i64* %canary.slot, align 8
  %guard.now = load i64, i64* @__stack_chk_guard
  %guard.ok = icmp eq i64 %guard.load, %guard.now
  br i1 %guard.ok, label %ret, label %stack_fail

stack_fail:                                           ; preds = %epilogue
  call void @__stack_chk_fail()
  unreachable

ret:                                                  ; preds = %epilogue
  ret i32 0
}