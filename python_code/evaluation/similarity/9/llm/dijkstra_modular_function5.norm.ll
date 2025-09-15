; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function5.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function5.ll"
target triple = "x86_64-pc-linux-gnu"

declare i8* @memset(i8* noundef, i32 noundef, i64 noundef)

declare i32 @min_index(i32* noundef, i32* noundef, i32 noundef)

define void @dijkstra(i32* noundef %graph, i32 noundef %n, i32 noundef %src, i32* noundef %dist) {
entry:
  %visited = alloca [100 x i32], align 16
  %visited_i8ptr = bitcast [100 x i32]* %visited to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %visited_i8ptr, i8 noundef 0, i64 noundef 400, i1 false)
  br label %init_loop

init_loop:                                        ; preds = %init_body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init_body ]
  %init_cmp = icmp slt i32 %i, %n
  br i1 %init_cmp, label %init_body, label %post_init

init_body:                                        ; preds = %init_loop
  %i.ext = zext i32 %i to i64
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.gep, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %init_loop

post_init:                                        ; preds = %init_loop
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer_loop

outer_loop:                                       ; preds = %outer_latch, %post_init
  %iter = phi i32 [ 0, %post_init ], [ %iter.next, %outer_latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer_cmp = icmp slt i32 %iter, %n.minus1
  br i1 %outer_cmp, label %outer_body, label %exit

outer_body:                                       ; preds = %outer_loop
  %visited.base = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 0
  %u = call i32 @min_index(i32* noundef %dist, i32* noundef nonnull %visited.base, i32 noundef %n)
  %u.neg1 = icmp eq i32 %u, -1
  br i1 %u.neg1, label %exit, label %mark_visited

mark_visited:                                     ; preds = %outer_body
  %u.ext = sext i32 %u to i64
  %visited.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u.ext
  store i32 1, i32* %visited.u.ptr, align 4
  br label %inner_loop

inner_loop:                                       ; preds = %inner_latch, %mark_visited
  %v = phi i32 [ 0, %mark_visited ], [ %v.next, %inner_latch ]
  %inner_cmp = icmp slt i32 %v, %n
  br i1 %inner_cmp, label %inner_body, label %outer_latch

inner_body:                                       ; preds = %inner_loop
  %row.off = mul nsw i64 %u.ext, 100
  %v.ext = zext i32 %v to i64
  %idx.flat = add nsw i64 %row.off, %v.ext
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %idx.flat
  %w = load i32, i32* %g.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %inner_latch, label %check_visited

check_visited:                                    ; preds = %inner_body
  %visited.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v.ext
  %visited.v = load i32, i32* %visited.v.ptr, align 4
  %v.already.not = icmp eq i32 %visited.v, 0
  br i1 %v.already.not, label %check_du, label %inner_latch

check_du:                                         ; preds = %check_visited
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext
  %du = load i32, i32* %dist.u.ptr, align 4
  %du.isinf = icmp eq i32 %du, 2147483647
  br i1 %du.isinf, label %inner_latch, label %relax_try

relax_try:                                        ; preds = %check_du
  %sum = add nsw i32 %du, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.ext
  %dv = load i32, i32* %dist.v.ptr, align 4
  %improve = icmp slt i32 %sum, %dv
  br i1 %improve, label %do_relax, label %inner_latch

do_relax:                                         ; preds = %relax_try
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %inner_latch

inner_latch:                                      ; preds = %do_relax, %relax_try, %check_du, %check_visited, %inner_body
  %v.next = add nuw nsw i32 %v, 1
  br label %inner_loop

outer_latch:                                      ; preds = %inner_loop
  %iter.next = add nuw nsw i32 %iter, 1
  br label %outer_loop

exit:                                             ; preds = %outer_body, %outer_loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
