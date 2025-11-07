; ModuleID = 'read_graph.ll'
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %ret = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %fmt_dd_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 3
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_ptr, i32* %n_ptr, i32* %m)
  %cmp_sc1 = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_sc1, label %check_nm, label %fail

check_nm:
  %n_val0 = load i32, i32* %n_ptr, align 4
  %cmp_n_gt0 = icmp sgt i32 %n_val0, 0
  br i1 %cmp_n_gt0, label %check_n_le, label %fail

check_n_le:
  %n_val1 = load i32, i32* %n_ptr, align 4
  %cmp_n_le100 = icmp sle i32 %n_val1, 100
  br i1 %cmp_n_le100, label %check_m_ge0, label %fail

check_m_ge0:
  %m_val0 = load i32, i32* %m, align 4
  %cmp_m_ge0 = icmp sge i32 %m_val0, 0
  br i1 %cmp_m_ge0, label %init_g, label %fail

init_g:
  %n_val2 = load i32, i32* %n_ptr, align 4
  call void @init_graph(%struct.graph* %g, i32 %n_val2)
  store i32 0, i32* %i, align 4
  br label %loop_hdr

loop_hdr:
  %i_val = load i32, i32* %i, align 4
  %m_val1 = load i32, i32* %m, align 4
  %cmp_i_lt_m = icmp slt i32 %i_val, %m_val1
  br i1 %cmp_i_lt_m, label %loop_body, label %after_edges

loop_body:
  %fmt_triple_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call_scanf_edge = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_triple_ptr, i32* %u, i32* %v, i32* %w)
  %cmp_sc3 = icmp eq i32 %call_scanf_edge, 3
  br i1 %cmp_sc3, label %check_u_ge0, label %fail

check_u_ge0:
  %u_val0 = load i32, i32* %u, align 4
  %cmp_u_ge0 = icmp sge i32 %u_val0, 0
  br i1 %cmp_u_ge0, label %check_u_lt_n, label %fail

check_u_lt_n:
  %u_val1 = load i32, i32* %u, align 4
  %n_val3 = load i32, i32* %n_ptr, align 4
  %cmp_u_lt_n = icmp slt i32 %u_val1, %n_val3
  br i1 %cmp_u_lt_n, label %check_v_ge0, label %fail

check_v_ge0:
  %v_val0 = load i32, i32* %v, align 4
  %cmp_v_ge0 = icmp sge i32 %v_val0, 0
  br i1 %cmp_v_ge0, label %check_v_lt_n, label %fail

check_v_lt_n:
  %v_val1 = load i32, i32* %v, align 4
  %n_val4 = load i32, i32* %n_ptr, align 4
  %cmp_v_lt_n = icmp slt i32 %v_val1, %n_val4
  br i1 %cmp_v_lt_n, label %add_edge_call, label %fail

add_edge_call:
  %u_val2 = load i32, i32* %u, align 4
  %v_val2 = load i32, i32* %v, align 4
  %w_val0 = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u_val2, i32 %v_val2, i32 %w_val0, i32 1)
  %i_val2 = load i32, i32* %i, align 4
  %i_inc = add nsw i32 %i_val2, 1
  store i32 %i_inc, i32* %i, align 4
  br label %loop_hdr

after_edges:
  %fmt_d_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str_d, i64 0, i64 0
  %call_scanf_start = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_ptr, i32* %start_ptr)
  %cmp_sc1b = icmp eq i32 %call_scanf_start, 1
  br i1 %cmp_sc1b, label %check_start_ge0, label %fail

check_start_ge0:
  %start_val0 = load i32, i32* %start_ptr, align 4
  %cmp_s_ge0 = icmp sge i32 %start_val0, 0
  br i1 %cmp_s_ge0, label %check_start_lt_n, label %fail

check_start_lt_n:
  %start_val1 = load i32, i32* %start_ptr, align 4
  %n_val5 = load i32, i32* %n_ptr, align 4
  %cmp_s_lt_n = icmp slt i32 %start_val1, %n_val5
  br i1 %cmp_s_lt_n, label %success, label %fail

success:
  store i32 0, i32* %ret, align 4
  br label %exit

fail:
  store i32 -1, i32* %ret, align 4
  br label %exit

exit:
  %ret_val = load i32, i32* %ret, align 4
  ret i32 %ret_val
}