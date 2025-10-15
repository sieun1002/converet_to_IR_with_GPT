; target: x86_64 Linux with glibc
target triple = "x86_64-pc-linux-gnu"

@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.dd  = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.d   = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  %fmt_dd_gep = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd_gep, i32* %n_ptr, i32* %m)
  %cmp_scanf1_ok = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_scanf1_ok, label %check_bounds1, label %ret_minus1

check_bounds1:
  %n_val_ldr = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n_val_ldr, 0
  %n_le_100 = icmp sle i32 %n_val_ldr, 100
  %n_ok = and i1 %n_pos, %n_le_100
  %m_ldr = load i32, i32* %m, align 4
  %m_nonneg = icmp sge i32 %m_ldr, 0
  %bounds1_ok = and i1 %n_ok, %m_nonneg
  br i1 %bounds1_ok, label %init, label %ret_minus1

init:
  %n_for_init = load i32, i32* %n_ptr, align 4
  call void @init_graph(i8* %g, i32 %n_for_init)
  store i32 0, i32* %i, align 4
  br label %loop_hdr

loop_hdr:
  %i_cur = load i32, i32* %i, align 4
  %m_cur = load i32, i32* %m, align 4
  %i_ge_m = icmp sge i32 %i_cur, %m_cur
  br i1 %i_ge_m, label %after_loop, label %loop_body

loop_body:
  %fmt_ddd_gep = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call_scanf_edge = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd_gep, i32* %u, i32* %v, i32* %w)
  %scanf_edge_ok = icmp eq i32 %call_scanf_edge, 3
  br i1 %scanf_edge_ok, label %validate_uv, label %ret_minus1

validate_uv:
  %u_val = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %u_val, 0
  %n_val_for_u = load i32, i32* %n_ptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n_val_for_u
  %u_ok = and i1 %u_nonneg, %u_lt_n

  %v_val = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %v_val, 0
  %n_val_for_v = load i32, i32* %n_ptr, align 4
  %v_lt_n = icmp slt i32 %v_val, %n_val_for_v
  %v_ok = and i1 %v_nonneg, %v_lt_n

  %uv_ok = and i1 %u_ok, %v_ok
  br i1 %uv_ok, label %add_call, label %ret_minus1

add_call:
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next = add nsw i32 %i_cur, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_hdr

after_loop:
  %fmt_d_gep = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call_scanf_last = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d_gep, i32* %start_ptr)
  %scanf_last_ok = icmp eq i32 %call_scanf_last, 1
  br i1 %scanf_last_ok, label %check_start, label %ret_minus1

check_start:
  %start_val = load i32, i32* %start_ptr, align 4
  %start_nonneg = icmp sge i32 %start_val, 0
  %n_val_final = load i32, i32* %n_ptr, align 4
  %start_lt_n = icmp slt i32 %start_val, %n_val_final
  %start_ok = and i1 %start_nonneg, %start_lt_n
  br i1 %start_ok, label %ret_zero, label %ret_minus1

ret_minus1:
  ret i32 -1

ret_zero:
  ret i32 0
}