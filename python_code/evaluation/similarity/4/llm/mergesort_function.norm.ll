; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/mergesort_function.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/mergesort_function.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)

declare void @free(i8*)

declare i8* @memcpy(i8*, i8*, i64)

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

; Function Attrs: argmemonly nofree nounwind willreturn
declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn }
