; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/2/mergesort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00"

define i32 @main() {
entry:
  %arr = alloca [10 x i32], align 4
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  call void @merge_sort(i32* noundef nonnull %gep0, i64 noundef 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %body ]
  %cmp = icmp ult i64 %i, 10
  br i1 %cmp, label %body, label %done

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
  %i.next = add nuw nsw i64 %i, 1
  br label %loop

done:                                             ; preds = %loop
  %nl = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %cmp_le1 = icmp ult i64 %n, 2
  br i1 %cmp_le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %size_bytes = shl i64 %n, 2
  %buf.i8 = call noalias i8* @malloc(i64 %size_bytes)
  %buf_is_null = icmp eq i8* %buf.i8, null
  br i1 %buf_is_null, label %ret, label %init

init:                                             ; preds = %alloc
  %tmp0 = bitcast i8* %buf.i8 to i32*
  br label %outer.cond

outer.cond:                                       ; preds = %outer.swap, %init
  %run = phi i64 [ 1, %init ], [ %run.next, %outer.swap ]
  %src.cur = phi i32* [ %dest, %init ], [ %tmp.cur, %outer.swap ]
  %tmp.cur = phi i32* [ %tmp0, %init ], [ %src.cur, %outer.swap ]
  %run_lt_n = icmp ult i64 %run, %n
  br i1 %run_lt_n, label %inner.cond, label %after.outer

inner.cond:                                       ; preds = %outer.cond, %after.chunk
  %start = phi i64 [ %twice.run, %after.chunk ], [ 0, %outer.cond ]
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %chunk.init, label %outer.swap

chunk.init:                                       ; preds = %inner.cond
  %mid.tmp = add i64 %start, %run
  %mid.gt.n = icmp ugt i64 %mid.tmp, %n
  %mid = select i1 %mid.gt.n, i64 %n, i64 %mid.tmp
  %reass.add = shl i64 %run, 1
  %twice.run = add i64 %start, %reass.add
  %right.gt.n = icmp ugt i64 %twice.run, %n
  %right = select i1 %right.gt.n, i64 %n, i64 %twice.run
  br label %chunk.loop.cond

chunk.loop.cond:                                  ; preds = %chunk.loop.latch, %chunk.init
  %i = phi i64 [ %start, %chunk.init ], [ %i.next, %chunk.loop.latch ]
  %j = phi i64 [ %mid, %chunk.init ], [ %j.next, %chunk.loop.latch ]
  %k = phi i64 [ %start, %chunk.init ], [ %k.next, %chunk.loop.latch ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %after.chunk

choose:                                           ; preds = %chunk.loop.cond
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %have_i, label %take_right_i_oob

have_i:                                           ; preds = %choose
  %j_lt_right = icmp ult i64 %j, %right
  br i1 %j_lt_right, label %both_valid, label %take_left_j_oob

both_valid:                                       ; preds = %have_i
  %src.i.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %val.i = load i32, i32* %src.i.ptr, align 4
  %src.j.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %val.j = load i32, i32* %src.j.ptr, align 4
  %i_gt_j = icmp sgt i32 %val.i, %val.j
  br i1 %i_gt_j, label %take_right_both, label %take_left_both

take_left_j_oob:                                  ; preds = %have_i
  %src.i.ptr.lo = getelementptr inbounds i32, i32* %src.cur, i64 %i
  %val.i.lo = load i32, i32* %src.i.ptr.lo, align 4
  %tmp.k.ptr.lo = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.i.lo, i32* %tmp.k.ptr.lo, align 4
  %i.next.lo = add i64 %i, 1
  br label %chunk.loop.latch

take_left_both:                                   ; preds = %both_valid
  %tmp.k.ptr.lb = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.i, i32* %tmp.k.ptr.lb, align 4
  %i.next.lb = add i64 %i, 1
  br label %chunk.loop.latch

take_right_i_oob:                                 ; preds = %choose
  %src.j.ptr.ro = getelementptr inbounds i32, i32* %src.cur, i64 %j
  %val.j.ro = load i32, i32* %src.j.ptr.ro, align 4
  %tmp.k.ptr.ro = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.j.ro, i32* %tmp.k.ptr.ro, align 4
  %j.next.ro = add i64 %j, 1
  br label %chunk.loop.latch

take_right_both:                                  ; preds = %both_valid
  %tmp.k.ptr.rb = getelementptr inbounds i32, i32* %tmp.cur, i64 %k
  store i32 %val.j, i32* %tmp.k.ptr.rb, align 4
  %j.next.rb = add i64 %j, 1
  br label %chunk.loop.latch

chunk.loop.latch:                                 ; preds = %take_right_both, %take_right_i_oob, %take_left_both, %take_left_j_oob
  %i.next = phi i64 [ %i.next.lo, %take_left_j_oob ], [ %i.next.lb, %take_left_both ], [ %i, %take_right_i_oob ], [ %i, %take_right_both ]
  %j.next = phi i64 [ %j, %take_left_j_oob ], [ %j, %take_left_both ], [ %j.next.ro, %take_right_i_oob ], [ %j.next.rb, %take_right_both ]
  %k.next = add i64 %k, 1
  br label %chunk.loop.cond

after.chunk:                                      ; preds = %chunk.loop.cond
  br label %inner.cond

outer.swap:                                       ; preds = %inner.cond
  %run.next = shl i64 %run, 1
  br label %outer.cond

after.outer:                                      ; preds = %outer.cond
  %src_eq_dest = icmp eq i32* %src.cur, %dest
  br i1 %src_eq_dest, label %free.buf, label %do.memcpy

do.memcpy:                                        ; preds = %after.outer
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dest.i8, i8* align 1 %src.i8, i64 %size_bytes, i1 false)
  br label %free.buf

free.buf:                                         ; preds = %do.memcpy, %after.outer
  call void @free(i8* %buf.i8)
  br label %ret

ret:                                              ; preds = %free.buf, %alloc, %entry
  ret void
}

declare i8* @malloc(i64)

declare i8* @memcpy(i8*, i8*, i64)

declare void @free(i8*)

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn }
