; ModuleID = 'read_graph.ll'
target triple = "x86_64-unknown-linux-gnu"

%struct.graph = type opaque

@.str.dd  = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str.d   = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %s_ptr) {
entry:
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  ; scanf("%d %d", n_ptr, &m)
  %fmt_dd = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_dd, i32* %n_ptr, i32* %m)
  %ok2 = icmp eq i32 %scan1, 2
  br i1 %ok2, label %check_n_pos, label %ret_err

check_n_pos:
  %n = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n, 0
  br i1 %n_pos, label %check_n_le100, label %ret_err

check_n_le100:
  %n_le100 = icmp sle i32 %n, 100
  br i1 %n_le100, label %check_m_nonneg, label %ret_err

check_m_nonneg:
  %mval = load i32, i32* %m, align 4
  %m_ge0 = icmp sge i32 %mval, 0
  br i1 %m_ge0, label %init, label %ret_err

init:
  call void @init_graph(%struct.graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_cur = load i32, i32* %i, align 4
  %m_now = load i32, i32* %m, align 4
  %i_ge_m = icmp sge i32 %i_cur, %m_now
  br i1 %i_ge_m, label %after_edges, label %read_edge

read_edge:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt_ddd = getelementptr inbounds [8 x i8], [8 x i8]* @.str.ddd, i64 0, i64 0
  %scan_e = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_ddd, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %scan_e, 3
  br i1 %ok3, label %check_u0, label %ret_err

check_u0:
  %uval = load i32, i32* %u, align 4
  %u_ge0 = icmp sge i32 %uval, 0
  br i1 %u_ge0, label %check_u_n, label %ret_err

check_u_n:
  %n2 = load i32, i32* %n_ptr, align 4
  %u_lt_n = icmp slt i32 %uval, %n2
  br i1 %u_lt_n, label %check_v0, label %ret_err

check_v0:
  %vval = load i32, i32* %v, align 4
  %v_ge0 = icmp sge i32 %vval, 0
  br i1 %v_ge0, label %check_v_n, label %ret_err

check_v_n:
  %n3 = load i32, i32* %n_ptr, align 4
  %v_lt_n = icmp slt i32 %vval, %n3
  br i1 %v_lt_n, label %add, label %ret_err

add:
  %uu = load i32, i32* %u, align 4
  %vv = load i32, i32* %v, align 4
  %ww = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %uu, i32 %vv, i32 %ww, i32 1)
  %i_old = load i32, i32* %i, align 4
  %i_next = add nsw i32 %i_old, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_edges:
  ; scanf("%d", s_ptr)
  %fmt_d = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %scan_s = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_d, i32* %s_ptr)
  %ok1 = icmp eq i32 %scan_s, 1
  br i1 %ok1, label %check_s0, label %ret_err

check_s0:
  %sval = load i32, i32* %s_ptr, align 4
  %s_ge0 = icmp sge i32 %sval, 0
  br i1 %s_ge0, label %check_s_n, label %ret_err

check_s_n:
  %n4 = load i32, i32* %n_ptr, align 4
  %s_lt_n = icmp slt i32 %sval, %n4
  br i1 %s_lt_n, label %succ, label %ret_err

succ:
  ret i32 0

ret_err:
  ret i32 -1
}