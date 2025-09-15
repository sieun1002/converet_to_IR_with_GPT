; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function5.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)

declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 0, i64 400, i1 false)
  br label %init

init:                                             ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %after.init

init.body:                                        ; preds = %init
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add i32 %i, 1
  br label %init

after.init:                                       ; preds = %init
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer

outer:                                            ; preds = %outer.latch, %after.init
  %j = phi i32 [ 0, %after.init ], [ %j.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %j, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %done

outer.body:                                       ; preds = %outer
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* nonnull %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %have.u

have.u:                                           ; preds = %outer.body
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner

inner:                                            ; preds = %inner.latch, %have.u
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner
  %v.sext = sext i32 %v to i64
  %cell.ptr = getelementptr [100 x i32], [100 x i32]* %graph, i64 %u.sext, i64 %v.sext
  %w = load i32, i32* %cell.ptr, align 4
  %edge.nz = icmp ne i32 %w, 0
  %s.v.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %v.sext
  %s.v.val = load i32, i32* %s.v.ptr, align 4
  %s.v.zero = icmp eq i32 %s.v.val, 0
  %dist.u.ptr = getelementptr i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.notinf = icmp ne i32 %dist.u, 2147483647
  %c1 = and i1 %edge.nz, %s.v.zero
  %guard = and i1 %c1, %dist.u.notinf
  br i1 %guard, label %relax, label %inner.latch

relax:                                            ; preds = %inner.body
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.cmp = icmp slt i32 %sum, %dist.v
  br i1 %lt.cmp, label %update, label %inner.latch

update:                                           ; preds = %relax
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %update, %relax, %inner.body
  %v.next = add i32 %v, 1
  br label %inner

outer.latch:                                      ; preds = %inner
  %j.next = add i32 %j, 1
  br label %outer

done:                                             ; preds = %outer.body, %outer
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
