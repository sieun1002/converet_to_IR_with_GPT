; target triple chosen for glibc-based x86_64 Linux
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.two   = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one   = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %src_ptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  store i32 0, i32* %m, align 4
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.two, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull %fmt2, i32* %n_ptr, i32* %m)
  %cmp_sc1 = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_sc1, label %after_first_scanf, label %error_ret

error_ret:
  store i32 -1, i32* %ret, align 4
  br label %return

after_first_scanf:
  %n_val1 = load i32, i32* %n_ptr, align 4
  %cmp_n_pos = icmp sgt i32 %n_val1, 0
  br i1 %cmp_n_pos, label %check_n_upper, label %error_ret2

check_n_upper:
  %n_val2 = load i32, i32* %n_ptr, align 4
  %cmp_n_le = icmp sle i32 %n_val2, 100
  br i1 %cmp_n_le, label %check_m_nonneg, label %error_ret2

error_ret2:
  store i32 -1, i32* %ret, align 4
  br label %return

check_m_nonneg:
  %m_val0 = load i32, i32* %m, align 4
  %cmp_m_ge0 = icmp sge i32 %m_val0, 0
  br i1 %cmp_m_ge0, label %init_and_loop, label %error_ret2

init_and_loop:
  %n_val3 = load i32, i32* %n_ptr, align 4
  call void @init_graph(%struct.graph* %g, i32 %n_val3)
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:
  %i_val = load i32, i32* %i, align 4
  %m_val1 = load i32, i32* %m, align 4
  %cmp_i_m = icmp sge i32 %i_val, %m_val1
  br i1 %cmp_i_m, label %after_edges, label %read_edge

read_edge:
  %fmt3 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.three, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull %fmt3, i32* %u, i32* %v, i32* %w)
  %cmp_sc2 = icmp eq i32 %call_scanf2, 3
  br i1 %cmp_sc2, label %validate_u, label %error_ret3

error_ret3:
  store i32 -1, i32* %ret, align 4
  br label %return

validate_u:
  %u_val0 = load i32, i32* %u, align 4
  %cmp_u_ge0 = icmp sge i32 %u_val0, 0
  br i1 %cmp_u_ge0, label %validate_u_upper, label %error_ret4

validate_u_upper:
  %u_val1 = load i32, i32* %u, align 4
  %n_val4 = load i32, i32* %n_ptr, align 4
  %cmp_u_lt_n = icmp slt i32 %u_val1, %n_val4
  br i1 %cmp_u_lt_n, label %validate_v, label %error_ret4

error_ret4:
  store i32 -1, i32* %ret, align 4
  br label %return

validate_v:
  %v_val0 = load i32, i32* %v, align 4
  %cmp_v_ge0 = icmp sge i32 %v_val0, 0
  br i1 %cmp_v_ge0, label %validate_v_upper, label %error_ret5

validate_v_upper:
  %v_val1 = load i32, i32* %v, align 4
  %n_val5 = load i32, i32* %n_ptr, align 4
  %cmp_v_lt_n = icmp slt i32 %v_val1, %n_val5
  br i1 %cmp_v_lt_n, label %add_edge_block, label %error_ret5

error_ret5:
  store i32 -1, i32* %ret, align 4
  br label %return

add_edge_block:
  %u_val2 = load i32, i32* %u, align 4
  %v_val2 = load i32, i32* %v, align 4
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u_val2, i32 %v_val2, i32 %w_val, i32 1)
  %i_val2 = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_val2, 1
  store i32 %i_inc, i32* %i, align 4
  br label %loop_cond

after_edges:
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.one, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull %fmt1, i32* %src_ptr)
  %cmp_sc3 = icmp eq i32 %call_scanf3, 1
  br i1 %cmp_sc3, label %check_src_range, label %error_ret6

error_ret6:
  store i32 -1, i32* %ret, align 4
  br label %return

check_src_range:
  %src_val0 = load i32, i32* %src_ptr, align 4
  %cmp_src_ge0 = icmp sge i32 %src_val0, 0
  br i1 %cmp_src_ge0, label %check_src_upper, label %error_ret7

check_src_upper:
  %src_val1 = load i32, i32* %src_ptr, align 4
  %n_val6 = load i32, i32* %n_ptr, align 4
  %cmp_src_lt_n = icmp slt i32 %src_val1, %n_val6
  br i1 %cmp_src_lt_n, label %ok_ret, label %error_ret7

error_ret7:
  store i32 -1, i32* %ret, align 4
  br label %return

ok_ret:
  store i32 0, i32* %ret, align 4
  br label %return

return:
  %ret_val = load i32, i32* %ret, align 4
  ret i32 %ret_val
}