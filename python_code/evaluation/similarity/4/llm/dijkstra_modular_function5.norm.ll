; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function5.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

declare i8* @memset(i8*, i32, i64)

declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.cast = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.cast, i8 0, i64 400, i1 false)
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %after.init

init.body:                                        ; preds = %init.loop
  %i.ext = sext i32 %i to i64
  %dist.elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.elem.ptr, align 4
  %i.next = add i32 %i, 1
  br label %init.loop

after.init:                                       ; preds = %init.loop
  %src.ext = sext i32 %src to i64
  %src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %after.init
  %t = phi i32 [ 0, %after.init ], [ %t.next, %outer.inc ]
  %nminus1 = add i32 %n, -1
  %cond.outer = icmp slt i32 %t, %nminus1
  br i1 %cond.outer, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.loop
  %s.i32ptr0 = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* nonnull %s.i32ptr0, i32 %n)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %ret, label %mark.u

mark.u:                                           ; preds = %outer.body
  %u.ext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u.ext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; preds = %inner.inc, %mark.u
  %v = phi i32 [ 0, %mark.u ], [ %v.next, %inner.inc ]
  %v.cond = icmp slt i32 %v, %n
  br i1 %v.cond, label %inner.body.entry, label %outer.inc

inner.body.entry:                                 ; preds = %inner.loop
  %v.sext = sext i32 %v to i64
  %u.mul100 = mul nsw i64 %u.ext, 100
  %idx = add nsw i64 %u.mul100, %v.sext
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx
  %g.val = load i32, i32* %g.ptr, align 4
  %g.iszero = icmp eq i32 %g.val, 0
  br i1 %g.iszero, label %inner.inc, label %check.visited

check.visited:                                    ; preds = %inner.body.entry
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v.sext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %visited.not = icmp eq i32 %s.v, 0
  br i1 %visited.not, label %check.distinf, label %inner.inc

check.distinf:                                    ; preds = %check.visited
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %isinf, label %inner.inc, label %relax

relax:                                            ; preds = %check.distinf
  %tmp = add i32 %dist.u, %g.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %cmpupd = icmp slt i32 %tmp, %dist.v
  br i1 %cmpupd, label %do.update, label %inner.inc

do.update:                                        ; preds = %relax
  store i32 %tmp, i32* %dist.v.ptr, align 4
  br label %inner.inc

inner.inc:                                        ; preds = %do.update, %relax, %check.distinf, %check.visited, %inner.body.entry
  %v.next = add i32 %v, 1
  br label %inner.loop

outer.inc:                                        ; preds = %inner.loop
  %t.next = add i32 %t, 1
  br label %outer.loop

ret:                                              ; preds = %outer.body, %outer.loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
