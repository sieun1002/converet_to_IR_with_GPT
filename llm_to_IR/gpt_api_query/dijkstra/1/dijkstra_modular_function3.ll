%struct.graph = type opaque

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %nptr, i32* %sptr) {
entry:
  %ret = alloca i32, align 4
  %edges = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  %fmt1ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %nptr, i32* %edges)
  %ok2 = icmp eq i32 %call1, 2
  br i1 %ok2, label %chk_n, label %ret_err

ret_err:
  store i32 -1, i32* %ret, align 4
  br label %ret_bb

chk_n:
  %n = load i32, i32* %nptr, align 4
  %n_gt_0 = icmp sgt i32 %n, 0
  br i1 %n_gt_0, label %chk_n2, label %ret_err

chk_n2:
  %n_le_100 = icmp sle i32 %n, 100
  br i1 %n_le_100, label %chk_edges_nonneg, label %ret_err

chk_edges_nonneg:
  %m = load i32, i32* %edges, align 4
  %edges_ge_0 = icmp sge i32 %m, 0
  br i1 %edges_ge_0, label %init_g, label %ret_err

init_g:
  call void @init_graph(%struct.graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:
  %i_val = load i32, i32* %i, align 4
  %m2 = load i32, i32* %edges, align 4
  %cmp_i = icmp sge i32 %i_val, %m2
  br i1 %cmp_i, label %after_edges, label %read_edge

read_edge:
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %sc3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %sc3, 3
  br i1 %ok3, label %validate_edge, label %ret_err

validate_edge:
  %u_val = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %u_val, 0
  br i1 %u_nonneg, label %u_upper, label %ret_err

u_upper:
  %n3 = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n3
  br i1 %u_lt_n, label %v_lower, label %ret_err

v_lower:
  %v_val = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %v_val, 0
  br i1 %v_nonneg, label %v_upper, label %ret_err

v_upper:
  %n4 = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %v_val, %n4
  br i1 %v_lt_n, label %do_add, label %ret_err

do_add:
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_old = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_old, 1
  store i32 %i_inc, i32* %i, align 4
  br label %loop_cond

after_edges:
  %fmt_last = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %sc_last = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_last, i32* %sptr)
  %ok1 = icmp eq i32 %sc_last, 1
  br i1 %ok1, label %validate_start, label %ret_err

validate_start:
  %s = load i32, i32* %sptr, align 4
  %s_nonneg = icmp sge i32 %s, 0
  br i1 %s_nonneg, label %s_upper, label %ret_err

s_upper:
  %n5 = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %s, %n5
  br i1 %s_lt_n, label %success, label %ret_err

success:
  store i32 0, i32* %ret, align 4
  br label %ret_bb

ret_bb:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}