; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/10/dijkstra_modular_function5.ll"

declare i8* @memset(i8* noundef, i32 noundef, i64 noundef)

declare i32 @min_index(i32* noundef, i32* noundef, i32 noundef)

define void @dijkstra(i32* noundef %adj, i32 noundef %n, i32 noundef %src, i32* noundef %dist) local_unnamed_addr {
entry:
  %s.allo = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s.allo to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 noundef 0, i64 noundef 400, i1 false)
  br label %init.loop

init.loop:                                        ; preds = %init.body, %entry
  %i.ph = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %init.cmp = icmp slt i32 %i.ph, %n
  br i1 %init.cmp, label %init.body, label %init.done

init.body:                                        ; preds = %init.loop
  %i64 = sext i32 %i.ph to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add i32 %i.ph, 1
  br label %init.loop

init.done:                                        ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.cont, %init.done
  %iter.ph = phi i32 [ 0, %init.done ], [ %iter.next, %outer.cont ]
  %n.minus1 = add i32 %n, -1
  %outer.cmp = icmp slt i32 %iter.ph, %n.minus1
  br i1 %outer.cmp, label %choose.u, label %end

choose.u:                                         ; preds = %outer.loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s.allo, i64 0, i64 0
  %u.call = call i32 @min_index(i32* noundef %dist, i32* noundef nonnull %s.base, i32 noundef %n)
  %u.neg1 = icmp eq i32 %u.call, -1
  br i1 %u.neg1, label %end, label %mark.u

mark.u:                                           ; preds = %choose.u
  %u64 = sext i32 %u.call to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s.allo, i64 0, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; preds = %inner.cont, %mark.u
  %v.ph = phi i32 [ 0, %mark.u ], [ %v.next, %inner.cont ]
  %inner.cmp = icmp slt i32 %v.ph, %n
  br i1 %inner.cmp, label %edge.check, label %outer.cont

edge.check:                                       ; preds = %inner.loop
  %v64.a = sext i32 %v.ph to i64
  %u.times.100 = mul nsw i64 %u64, 100
  %uv.index = add nsw i64 %u.times.100, %v64.a
  %w.ptr = getelementptr inbounds i32, i32* %adj, i64 %uv.index
  %w.val = load i32, i32* %w.ptr, align 4
  %w.is.zero = icmp eq i32 %w.val, 0
  br i1 %w.is.zero, label %inner.cont, label %check.sv

check.sv:                                         ; preds = %edge.check
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s.allo, i64 0, i64 %v64.a
  %s.v.val = load i32, i32* %s.v.ptr, align 4
  %v.visited.not = icmp eq i32 %s.v.val, 0
  br i1 %v.visited.not, label %check.du.inf, label %inner.cont

check.du.inf:                                     ; preds = %check.sv
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist.u.val = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u.val, 2147483647
  br i1 %u.is.inf, label %inner.cont, label %relax

relax:                                            ; preds = %check.du.inf
  %alt = add i32 %dist.u.val, %w.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64.a
  %dist.v.val = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v.val
  br i1 %alt.lt, label %update, label %inner.cont

update:                                           ; preds = %relax
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.cont

inner.cont:                                       ; preds = %update, %relax, %check.du.inf, %check.sv, %edge.check
  %v.next = add i32 %v.ph, 1
  br label %inner.loop

outer.cont:                                       ; preds = %inner.loop
  %iter.next = add i32 %iter.ph, 1
  br label %outer.loop

end:                                              ; preds = %choose.u, %outer.loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
