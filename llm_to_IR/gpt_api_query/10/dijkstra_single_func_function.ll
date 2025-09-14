; ModuleID = 'dijkstra.ll'

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_num = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra([100 x i32]* %graph, i32 %V, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %spt = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %min_idx = alloca i32, align 4
  %min_dist = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4

  store i32 0, i32* %i, align 4
  br label %init.loop

init.loop:                                         ; preds = %init.body, %entry
  %it = load i32, i32* %i, align 4
  %cmp_init = icmp slt i32 %it, %V
  br i1 %cmp_init, label %init.body, label %init.end

init.body:                                         ; preds = %init.loop
  %idx64 = sext i32 %it to i64
  %dist_i_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %idx64
  store i32 2147483647, i32* %dist_i_ptr, align 4
  %spt_i_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %idx64
  store i32 0, i32* %spt_i_ptr, align 4
  %inc = add nsw i32 %it, 1
  store i32 %inc, i32* %i, align 4
  br label %init.loop

init.end:                                          ; preds = %init.loop
  %src64 = sext i32 %src to i64
  %dist_src_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist_src_ptr, align 4

  store i32 0, i32* %count, align 4
  br label %outer.cond

outer.cond:                                        ; preds = %vloop.end, %init.end
  %countv = load i32, i32* %count, align 4
  %Vm1 = add nsw i32 %V, -1
  %cond_outer = icmp slt i32 %countv, %Vm1
  br i1 %cond_outer, label %outer.body, label %print.start

outer.body:                                        ; preds = %outer.cond
  store i32 -1, i32* %min_idx, align 4
  store i32 2147483647, i32* %min_dist, align 4
  store i32 0, i32* %i, align 4
  br label %minloop.cond

minloop.cond:                                      ; preds = %minloop.inc, %outer.body
  %it2 = load i32, i32* %i, align 4
  %cond_min = icmp slt i32 %it2, %V
  br i1 %cond_min, label %minloop.body, label %minloop.end

minloop.body:                                      ; preds = %minloop.cond
  %idx64b = sext i32 %it2 to i64
  %spt_ptr_i = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %idx64b
  %spt_val = load i32, i32* %spt_ptr_i, align 4
  %is_unset = icmp eq i32 %spt_val, 0
  br i1 %is_unset, label %check.dist, label %minloop.inc

check.dist:                                        ; preds = %minloop.body
  %dist_ptr_i = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %idx64b
  %di = load i32, i32* %dist_ptr_i, align 4
  %minv = load i32, i32* %min_dist, align 4
  %lt = icmp slt i32 %di, %minv
  br i1 %lt, label %update.min, label %minloop.inc

update.min:                                        ; preds = %check.dist
  store i32 %di, i32* %min_dist, align 4
  store i32 %it2, i32* %min_idx, align 4
  br label %minloop.inc

minloop.inc:                                       ; preds = %update.min, %check.dist, %minloop.body
  %inc2 = add nsw i32 %it2, 1
  store i32 %inc2, i32* %i, align 4
  br label %minloop.cond

minloop.end:                                       ; preds = %minloop.cond
  %min_idx_v = load i32, i32* %min_idx, align 4
  %has_min = icmp ne i32 %min_idx_v, -1
  br i1 %has_min, label %after.mincheck, label %print.start

after.mincheck:                                    ; preds = %minloop.end
  store i32 %min_idx_v, i32* %u, align 4
  %u64 = sext i32 %min_idx_v to i64
  %spt_ptr_u = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %u64
  store i32 1, i32* %spt_ptr_u, align 4

  store i32 0, i32* %v, align 4
  br label %vloop.cond

vloop.cond:                                        ; preds = %vloop.inc, %after.mincheck
  %vv = load i32, i32* %v, align 4
  %vcond = icmp slt i32 %vv, %V
  br i1 %vcond, label %vloop.body, label %vloop.end

vloop.body:                                        ; preds = %vloop.cond
  %u.cur = load i32, i32* %u, align 4
  %u64b = sext i32 %u.cur to i64
  %v64 = sext i32 %vv to i64
  %w_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %graph, i64 %u64b, i64 %v64
  %w = load i32, i32* %w_ptr, align 4
  %is_zero = icmp eq i32 %w, 0
  br i1 %is_zero, label %vloop.inc, label %check.sptV

check.sptV:                                        ; preds = %vloop.body
  %spt_ptr_v = getelementptr inbounds [100 x i32], [100 x i32]* %spt, i64 0, i64 %v64
  %spt_v = load i32, i32* %spt_ptr_v, align 4
  %v_not_in_spt = icmp eq i32 %spt_v, 0
  br i1 %v_not_in_spt, label %check.distU, label %vloop.inc

check.distU:                                       ; preds = %check.sptV
  %dist_u_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64b
  %dist_u = load i32, i32* %dist_u_ptr, align 4
  %u_not_inf = icmp ne i32 %dist_u, 2147483647
  br i1 %u_not_inf, label %check.relax, label %vloop.inc

check.relax:                                       ; preds = %check.distU
  %dist_v_ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist_v = load i32, i32* %dist_v_ptr, align 4
  %sum = add nsw i32 %dist_u, %w
  %cmp_relax = icmp sgt i32 %dist_v, %sum
  br i1 %cmp_relax, label %do.relax, label %vloop.inc

do.relax:                                          ; preds = %check.relax
  store i32 %sum, i32* %dist_v_ptr, align 4
  br label %vloop.inc

vloop.inc:                                         ; preds = %do.relax, %check.relax, %check.distU, %check.sptV, %vloop.body
  %vnext = add nsw i32 %vv, 1
  store i32 %vnext, i32* %v, align 4
  br label %vloop.cond

vloop.end:                                         ; preds = %vloop.cond
  %countnext = add nsw i32 %countv, 1
  store i32 %countnext, i32* %count, align 4
  br label %outer.cond

print.start:                                       ; preds = %minloop.end, %outer.cond
  store i32 0, i32* %i, align 4
  br label %print.cond

print.cond:                                        ; preds = %print.inc, %print.start
  %ip = load i32, i32* %i, align 4
  %condp = icmp slt i32 %ip, %V
  br i1 %condp, label %print.body, label %exit

print.body:                                        ; preds = %print.cond
  %ip64 = sext i32 %ip to i64
  %dist_i_ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %ip64
  %di2 = load i32, i32* %dist_i_ptr2, align 4
  %is_inf = icmp eq i32 %di2, 2147483647
  br i1 %is_inf, label %print.inf, label %print.num

print.inf:                                         ; preds = %print.body
  %fmt1 = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @printf(i8* %fmt1, i32 %ip)
  br label %print.inc

print.num:                                         ; preds = %print.body
  %fmt2 = getelementptr inbounds [15 x i8], [15 x i8]* @.str_num, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @printf(i8* %fmt2, i32 %ip, i32 %di2)
  br label %print.inc

print.inc:                                         ; preds = %print.num, %print.inf
  %ipnext = add nsw i32 %ip, 1
  store i32 %ipnext, i32* %i, align 4
  br label %print.cond

exit:                                              ; preds = %print.cond
  ret void
}