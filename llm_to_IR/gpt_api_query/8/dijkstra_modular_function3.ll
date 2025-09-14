; ModuleID = 'read_graph.ll'
target triple = "x86_64-pc-linux-gnu"

@.str_two_ints = private unnamed_addr constant [5 x i8] c"%d %d\00"
@.str_three_ints = private unnamed_addr constant [8 x i8] c"%d %d %d\00"
@.str_one_int = private unnamed_addr constant [3 x i8] c"%d\00"

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8* %g, i32 %n)
declare void @add_edge(i8* %g, i32 %u, i32 %v, i32 %w, i32 %flag)

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %s_ptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  ; scanf("%d %d", n_ptr, &m)
  %fmt2 = getelementptr inbounds [5 x i8], [5 x i8]* @.str_two_ints, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n_ptr, i32* %m)
  %ok2 = icmp eq i32 %scan2, 2
  br i1 %ok2, label %check_nm, label %fail

check_nm:
  %n_val0 = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n_val0, 0
  br i1 %n_pos, label %check_n_upper, label %fail

check_n_upper:
  %n_val1 = load i32, i32* %n_ptr, align 4
  %n_le_100 = icmp sle i32 %n_val1, 100
  br i1 %n_le_100, label %check_m_nonneg, label %fail

check_m_nonneg:
  %m_val0 = load i32, i32* %m, align 4
  %m_ge_0 = icmp sge i32 %m_val0, 0
  br i1 %m_ge_0, label %initg, label %fail

initg:
  %n_val2 = load i32, i32* %n_ptr, align 4
  call void @init_graph(i8* %g, i32 %n_val2)
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:
  %i_val = load i32, i32* %i, align 4
  %m_val1 = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i_val, %m_val1
  br i1 %i_lt_m, label %loop_body, label %after_edges

loop_body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt3 = getelementptr inbounds [8 x i8], [8 x i8]* @.str_three_ints, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %scan3, 3
  br i1 %ok3, label %check_u0, label %fail

check_u0:
  %u_val0 = load i32, i32* %u, align 4
  %u_ge_0 = icmp sge i32 %u_val0, 0
  br i1 %u_ge_0, label %check_u_n, label %fail

check_u_n:
  %n_val3 = load i32, i32* %n_ptr, align 4
  %u_lt_n = icmp slt i32 %u_val0, %n_val3
  br i1 %u_lt_n, label %check_v0, label %fail

check_v0:
  %v_val0 = load i32, i32* %v, align 4
  %v_ge_0 = icmp sge i32 %v_val0, 0
  br i1 %v_ge_0, label %check_v_n, label %fail

check_v_n:
  %n_val4 = load i32, i32* %n_ptr, align 4
  %v_lt_n = icmp slt i32 %v_val0, %n_val4
  br i1 %v_lt_n, label %add_edge_call, label %fail

add_edge_call:
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %u_val0, i32 %v_val0, i32 %w_val, i32 1)
  ; i++
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_cond

after_edges:
  ; scanf("%d", s_ptr)
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_one_int, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %s_ptr)
  %ok1 = icmp eq i32 %scan1, 1
  br i1 %ok1, label %check_s0, label %fail

check_s0:
  %s_val0 = load i32, i32* %s_ptr, align 4
  %s_ge_0 = icmp sge i32 %s_val0, 0
  br i1 %s_ge_0, label %check_s_n, label %fail

check_s_n:
  %n_val5 = load i32, i32* %n_ptr, align 4
  %s_lt_n = icmp slt i32 %s_val0, %n_val5
  br i1 %s_lt_n, label %success, label %fail

success:
  store i32 0, i32* %ret, align 4
  br label %retblk

fail:
  store i32 -1, i32* %ret, align 4
  br label %retblk

retblk:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}