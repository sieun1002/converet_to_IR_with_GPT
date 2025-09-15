; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/4/mergesort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.elem0.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.elem0.ptr, align 16
  %arr.elem1.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.elem1.ptr, align 4
  %arr.elem2.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.elem2.ptr, align 8
  %arr.elem3.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.elem3.ptr, align 4
  %arr.elem4.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.elem4.ptr, align 16
  %arr.elem5.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.elem5.ptr, align 4
  %arr.elem6.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.elem6.ptr, align 8
  %arr.elem7.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.elem7.ptr, align 4
  %arr.elem8.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.elem8.ptr, align 16
  %arr.elem9.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.elem9.ptr, align 4
  call void @merge_sort(i32* noundef nonnull %arr.elem0.ptr, i64 noundef 10)
  br label %loop.cond

loop.cond:                                        ; preds = %loop.body, %entry
  %i.0 = phi i64 [ 0, %entry ], [ %i.next, %loop.body ]
  %cmp = icmp ult i64 %i.0, 10
  br i1 %cmp, label %loop.body, label %loop.end

loop.body:                                        ; preds = %loop.cond
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i.0
  %elem = load i32, i32* %elem.ptr, align 4
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str, i64 0, i64 0), i32 noundef %elem)
  %i.next = add i64 %i.0, 1
  br label %loop.cond

loop.end:                                         ; preds = %loop.cond
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp.n.le1 = icmp ult i64 %n, 2
  br i1 %cmp.n.le1, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %bytes.alloc = shl i64 %n, 2
  %buf.i8 = call i8* @malloc(i64 %bytes.alloc)
  %buf.null = icmp eq i8* %buf.i8, null
  br i1 %buf.null, label %ret, label %init

init:                                             ; preds = %alloc
  %buf.i32 = bitcast i8* %buf.i8 to i32*
  br label %outer

outer:                                            ; preds = %swap, %init
  %run.phi = phi i64 [ 1, %init ], [ %run.next, %swap ]
  %src.phi = phi i32* [ %dest, %init ], [ %tmp.phi, %swap ]
  %tmp.phi = phi i32* [ %buf.i32, %init ], [ %src.phi, %swap ]
  %cmp.run.lt = icmp ult i64 %run.phi, %n
  br i1 %cmp.run.lt, label %inner.loop, label %finalize

inner.loop:                                       ; preds = %outer, %after.merge
  %base.phi = phi i64 [ %rend.raw, %after.merge ], [ 0, %outer ]
  %cmp.base.lt = icmp ult i64 %base.phi, %n
  br i1 %cmp.base.lt, label %merge.prelude, label %swap

merge.prelude:                                    ; preds = %inner.loop
  %mid.raw = add i64 %base.phi, %run.phi
  %mid.gt.n = icmp ugt i64 %mid.raw, %n
  %mid.clamp = select i1 %mid.gt.n, i64 %n, i64 %mid.raw
  %two.run = shl i64 %run.phi, 1
  %rend.raw = add i64 %base.phi, %two.run
  %rend.gt.n = icmp ugt i64 %rend.raw, %n
  %rend.clamp = select i1 %rend.gt.n, i64 %n, i64 %rend.raw
  br label %merge.loop

merge.loop:                                       ; preds = %take.right, %take.left, %merge.prelude
  %i.phi = phi i64 [ %base.phi, %merge.prelude ], [ %i.next.left, %take.left ], [ %i.phi, %take.right ]
  %j.phi = phi i64 [ %mid.clamp, %merge.prelude ], [ %j.phi, %take.left ], [ %j.next.right, %take.right ]
  %k.phi = phi i64 [ %base.phi, %merge.prelude ], [ %k.next.left, %take.left ], [ %k.next.right, %take.right ]
  %cmp.k.lt = icmp ult i64 %k.phi, %rend.clamp
  br i1 %cmp.k.lt, label %compare, label %after.merge

compare:                                          ; preds = %merge.loop
  %i.lt.mid = icmp ult i64 %i.phi, %mid.clamp
  br i1 %i.lt.mid, label %checkJ, label %compare.take.right_crit_edge

compare.take.right_crit_edge:                     ; preds = %compare
  %src.ptr.right.phi.trans.insert = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.right.pre = load i32, i32* %src.ptr.right.phi.trans.insert, align 4
  br label %take.right

checkJ:                                           ; preds = %compare
  %j.lt.rend = icmp ult i64 %j.phi, %rend.clamp
  br i1 %j.lt.rend, label %load.both, label %checkJ.take.left_crit_edge

checkJ.take.left_crit_edge:                       ; preds = %checkJ
  %src.ptr.left.phi.trans.insert = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.left.pre = load i32, i32* %src.ptr.left.phi.trans.insert, align 4
  br label %take.left

load.both:                                        ; preds = %checkJ
  %ptr.i = getelementptr inbounds i32, i32* %src.phi, i64 %i.phi
  %val.i = load i32, i32* %ptr.i, align 4
  %ptr.j = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %val.j = load i32, i32* %ptr.j, align 4
  %cmp.vi.gt = icmp sgt i32 %val.i, %val.j
  br i1 %cmp.vi.gt, label %take.right, label %take.left

take.left:                                        ; preds = %checkJ.take.left_crit_edge, %load.both
  %val.left = phi i32 [ %val.left.pre, %checkJ.take.left_crit_edge ], [ %val.i, %load.both ]
  %tmp.ptr.left = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.left, i32* %tmp.ptr.left, align 4
  %k.next.left = add i64 %k.phi, 1
  %i.next.left = add i64 %i.phi, 1
  br label %merge.loop

take.right:                                       ; preds = %compare.take.right_crit_edge, %load.both
  %val.right = phi i32 [ %val.right.pre, %compare.take.right_crit_edge ], [ %val.j, %load.both ]
  %tmp.ptr.right = getelementptr inbounds i32, i32* %tmp.phi, i64 %k.phi
  store i32 %val.right, i32* %tmp.ptr.right, align 4
  %k.next.right = add i64 %k.phi, 1
  %j.next.right = add i64 %j.phi, 1
  br label %merge.loop

after.merge:                                      ; preds = %merge.loop
  br label %inner.loop

swap:                                             ; preds = %inner.loop
  %run.next = shl i64 %run.phi, 1
  br label %outer

finalize:                                         ; preds = %outer
  %src.eq.dest = icmp eq i32* %src.phi, %dest
  br i1 %src.eq.dest, label %freebuf, label %docopy

docopy:                                           ; preds = %finalize
  %dest.i8.ptr = bitcast i32* %dest to i8*
  %src.i8.ptr = bitcast i32* %src.phi to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dest.i8.ptr, i8* align 1 %src.i8.ptr, i64 %bytes.alloc, i1 false)
  br label %freebuf

freebuf:                                          ; preds = %docopy, %finalize
  call void @free(i8* %buf.i8)
  br label %ret

ret:                                              ; preds = %freebuf, %alloc, %entry
  ret void
}

declare i8* @malloc(i64)

declare i8* @memcpy(i8*, i8*, i64)

declare void @free(i8*)

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn }
