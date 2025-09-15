; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function5.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)

declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 0, i64 400, i1 false)
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.ext = zext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.latch, %init.end
  %iter = phi i32 [ 0, %init.end ], [ %iter.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %iter, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %done

outer.body:                                       ; preds = %outer.loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* nonnull %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %after.u

after.u:                                          ; preds = %outer.body
  %u.ext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u.ext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; preds = %inner.latch, %after.u
  %v = phi i32 [ 0, %after.u ], [ %v.next, %inner.latch ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner.loop
  %v.ext = zext i32 %v to i64
  %u.mul = mul nsw i32 %u, 100
  %u.mul.ext = sext i32 %u.mul to i64
  %idx = add nsw i64 %u.mul.ext, %v.ext
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.is.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.is.zero, label %inner.latch, label %check.sv

check.sv:                                         ; preds = %inner.body
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v.ext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.nonzero.not = icmp eq i32 %s.v, 0
  br i1 %s.v.nonzero.not, label %check.du, label %inner.latch

check.du:                                         ; preds = %check.sv
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.is.inf, label %inner.latch, label %compute.alt

compute.alt:                                      ; preds = %check.du
  %alt = add nsw i32 %dist.u, %adj.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.ext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %update, label %inner.latch

update:                                           ; preds = %compute.alt
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %update, %compute.alt, %check.du, %check.sv, %inner.body
  %v.next = add nuw nsw i32 %v, 1
  br label %inner.loop

outer.latch:                                      ; preds = %inner.loop
  %iter.next = add nuw nsw i32 %iter, 1
  br label %outer.loop

done:                                             ; preds = %outer.body, %outer.loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
