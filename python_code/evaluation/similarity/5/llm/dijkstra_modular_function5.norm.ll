; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function5.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8*, i32, i64)

declare i32 @min_index(i32*, i32*, i32)

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 0, i64 400, i1 false)
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %i.cmp = icmp slt i32 %i, %n
  br i1 %i.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add i32 %i, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  %n.minus1 = add i32 %n, -1
  br label %outer.loop

outer.loop:                                       ; preds = %outer.inc, %init.end
  %count = phi i32 [ 0, %init.end ], [ %count.next, %outer.inc ]
  %outer.cmp = icmp slt i32 %count, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %exit

outer.body:                                       ; preds = %outer.loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %minidx = call i32 @min_index(i32* %dist, i32* nonnull %s.base, i32 %n)
  %min.is.neg1 = icmp eq i32 %minidx, -1
  br i1 %min.is.neg1, label %exit, label %got.min

got.min:                                          ; preds = %outer.body
  %minidx.sext = sext i32 %minidx to i64
  %s.min.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %minidx.sext
  store i32 1, i32* %s.min.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; preds = %inner.inc, %got.min
  %j = phi i32 [ 0, %got.min ], [ %j.next, %inner.inc ]
  %inner.cmp = icmp slt i32 %j, %n
  br i1 %inner.cmp, label %inner.body.checkEdge, label %outer.inc

inner.body.checkEdge:                             ; preds = %inner.loop
  %j.sext = sext i32 %j to i64
  %edge.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %minidx.sext, i64 %j.sext
  %edge.val = load i32, i32* %edge.ptr, align 4
  %edge.is.zero = icmp eq i32 %edge.val, 0
  br i1 %edge.is.zero, label %inner.inc, label %checkVisited

checkVisited:                                     ; preds = %inner.body.checkEdge
  %s.j.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %j.sext
  %s.j.val = load i32, i32* %s.j.ptr, align 4
  %visited.not = icmp eq i32 %s.j.val, 0
  br i1 %visited.not, label %checkInf, label %inner.inc

checkInf:                                         ; preds = %checkVisited
  %dist.min.ptr = getelementptr inbounds i32, i32* %dist, i64 %minidx.sext
  %dist.min = load i32, i32* %dist.min.ptr, align 4
  %is.inf = icmp eq i32 %dist.min, 2147483647
  br i1 %is.inf, label %inner.inc, label %relax

relax:                                            ; preds = %checkInf
  %cand = add i32 %dist.min, %edge.val
  %dist.j.ptr = getelementptr inbounds i32, i32* %dist, i64 %j.sext
  %dist.j = load i32, i32* %dist.j.ptr, align 4
  %cand.lt = icmp slt i32 %cand, %dist.j
  br i1 %cand.lt, label %storeNew, label %inner.inc

storeNew:                                         ; preds = %relax
  store i32 %cand, i32* %dist.j.ptr, align 4
  br label %inner.inc

inner.inc:                                        ; preds = %storeNew, %relax, %checkInf, %checkVisited, %inner.body.checkEdge
  %j.next = add i32 %j, 1
  br label %inner.loop

outer.inc:                                        ; preds = %inner.loop
  %count.next = add i32 %count, 1
  br label %outer.loop

exit:                                             ; preds = %outer.body, %outer.loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
