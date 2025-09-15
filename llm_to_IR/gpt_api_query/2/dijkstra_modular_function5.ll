; ModuleID = 'dijkstra.ll'

declare i32 @min_index(i32* %dist, i32* %s, i32 %n)
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s_i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* %s_i8, i8 0, i64 400, i1 false)

  %i = alloca i32, align 4
  store i32 0, i32* %i, align 4
  br label %for.init

for.init:                                         ; preds = %for.body, %entry
  %i.val = load i32, i32* %i, align 4
  %cmp_i = icmp slt i32 %i.val, %n
  br i1 %cmp_i, label %for.body, label %for.end

for.body:                                         ; preds = %for.init
  %i64 = sext i32 %i.val to i64
  %dist.gep = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.gep, align 4
  %inc = add i32 %i.val, 1
  store i32 %inc, i32* %i, align 4
  br label %for.init

for.end:                                          ; preds = %for.init
  %src64 = sext i32 %src to i64
  %dist_src = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist_src, align 4

  %t = alloca i32, align 4
  store i32 0, i32* %t, align 4
  br label %outer.cond

outer.cond:                                       ; preds = %after.inner, %for.end
  %t.val = load i32, i32* %t, align 4
  %n_minus1 = add i32 %n, -1
  %cond = icmp slt i32 %t.val, %n_minus1
  br i1 %cond, label %outer.body, label %ret

outer.body:                                       ; preds = %outer.cond
  %s.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.ptr, i32 %n)
  %u_is_neg1 = icmp eq i32 %u, -1
  br i1 %u_is_neg1, label %ret, label %have_u

have_u:                                           ; preds = %outer.body
  %u64 = sext i32 %u to i64
  %s_u = getelementptr inbounds i32, i32* %s.ptr, i64 %u64
  store i32 1, i32* %s_u, align 4

  %v = alloca i32, align 4
  store i32 0, i32* %v, align 4
  br label %inner.cond

inner.cond:                                       ; preds = %inner.next, %have_u
  %v.val = load i32, i32* %v, align 4
  %v_lt_n = icmp slt i32 %v.val, %n
  br i1 %v_lt_n, label %inner.body, label %after.inner

inner.body:                                       ; preds = %inner.cond
  %v64 = sext i32 %v.val to i64
  %rowIndex = mul i64 %u64, 100
  %flatIndex = add i64 %rowIndex, %v64
  %adj.elem.ptr = getelementptr inbounds i32, i32* %adj, i64 %flatIndex
  %w = load i32, i32* %adj.elem.ptr, align 4
  %w_is_zero = icmp eq i32 %w, 0
  br i1 %w_is_zero, label %inner.next, label %check_s

check_s:                                          ; preds = %inner.body
  %s_v = getelementptr inbounds i32, i32* %s.ptr, i64 %v64
  %s_v_val = load i32, i32* %s_v, align 4
  %s_v_is_zero = icmp eq i32 %s_v_val, 0
  br i1 %s_v_is_zero, label %check_distu, label %inner.next

check_distu:                                      ; preds = %check_s
  %dist_u_ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %dist_u_is_inf = icmp eq i32 %dist_u, 2147483647
  br i1 %dist_u_is_inf, label %inner.next, label %relax

relax:                                            ; preds = %check_distu
  %alt = add i32 %dist_u, %w
  %dist_v_ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %better = icmp slt i32 %alt, %dist_v
  br i1 %better, label %update, label %inner.next

update:                                           ; preds = %relax
  store i32 %alt, i32* %dist_v_ptr, align 4
  br label %inner.next

inner.next:                                       ; preds = %update, %relax, %check_distu, %check_s, %inner.body
  %v.next = add i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %inner.cond

after.inner:                                      ; preds = %inner.cond
  %t.next = add i32 %t.val, 1
  store i32 %t.next, i32* %t, align 4
  br label %outer.cond

ret:                                              ; preds = %outer.body, %outer.cond
  ret void
}