; ModuleID = 'read_graph_module'
target triple = "x86_64-unknown-linux-gnu"

%struct.Graph = type opaque

@.str.dd = private constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.Graph*, i32)
declare void @add_edge(%struct.Graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.Graph* %g, i32* %nptr, i32* %startptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %fmt1ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %nptr, i32* %m)
  %cmp1 = icmp eq i32 %call1, 2
  br i1 %cmp1, label %check_nm, label %error

check_nm:
  %nload = load i32, i32* %nptr, align 4
  %n_gt0 = icmp sgt i32 %nload, 0
  %n_le100 = icmp sle i32 %nload, 100
  %n_ok = and i1 %n_gt0, %n_le100
  %mload = load i32, i32* %m, align 4
  %m_ge0 = icmp sge i32 %mload, 0
  %init_ok = and i1 %n_ok, %m_ge0
  br i1 %init_ok, label %do_init, label %error

do_init:
  call void @init_graph(%struct.Graph* %g, i32 %nload)
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:
  %i_cur = load i32, i32* %i, align 4
  %m_cur = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i_cur, %m_cur
  br i1 %i_lt_m, label %loop_body, label %after_edges

loop_body:
  %fmt3ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %u, i32* %v, i32* %w)
  %cmp3 = icmp eq i32 %call2, 3
  br i1 %cmp3, label %validate_u, label %error

validate_u:
  %u_val = load i32, i32* %u, align 4
  %u_ge0 = icmp sge i32 %u_val, 0
  %n_for_u = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n_for_u
  %u_ok = and i1 %u_ge0, %u_lt_n
  br i1 %u_ok, label %validate_v, label %error

validate_v:
  %v_val = load i32, i32* %v, align 4
  %v_ge0 = icmp sge i32 %v_val, 0
  %n_for_v = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %v_val, %n_for_v
  %v_ok = and i1 %v_ge0, %v_lt_n
  br i1 %v_ok, label %do_add, label %error

do_add:
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(%struct.Graph* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next_src = load i32, i32* %i, align 4
  %i_next = add nsw i32 %i_next_src, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_cond

after_edges:
  %fmt1dptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1dptr, i32* %startptr)
  %cmp_s = icmp eq i32 %call3, 1
  br i1 %cmp_s, label %validate_start, label %error

validate_start:
  %s_val = load i32, i32* %startptr, align 4
  %s_ge0 = icmp sge i32 %s_val, 0
  %n_for_s = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %s_val, %n_for_s
  %s_ok = and i1 %s_ge0, %s_lt_n
  br i1 %s_ok, label %success, label %error

success:
  store i32 0, i32* %ret, align 4
  br label %ret_block

error:
  store i32 -1, i32* %ret, align 4
  br label %ret_block

ret_block:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}