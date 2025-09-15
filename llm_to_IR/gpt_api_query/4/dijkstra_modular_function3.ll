; ModuleID = 'read_graph.ll'
target triple = "x86_64-unknown-linux-gnu"

@.fmt2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.fmt3 = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.fmt1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %g, i32* %nptr, i32* %sptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  store i32 0, i32* %ret, align 4

  ; scanf("%d %d", nptr, &m)
  %fmt2ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt2, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2ptr, i32* %nptr, i32* %m)
  %ok2 = icmp eq i32 %scan2, 2
  br i1 %ok2, label %after_first_scan, label %error

after_first_scan:
  %nval = load i32, i32* %nptr, align 4
  %cmp_n_pos = icmp sgt i32 %nval, 0
  br i1 %cmp_n_pos, label %check_n_le_100, label %error

check_n_le_100:
  %cmp_n_le100 = icmp sle i32 %nval, 100
  br i1 %cmp_n_le100, label %check_m_nonneg, label %error

check_m_nonneg:
  %mval = load i32, i32* %m, align 4
  %cmp_m_nonneg = icmp sge i32 %mval, 0
  br i1 %cmp_m_nonneg, label %init, label %error

init:
  call void @init_graph(i8* %g, i32 %nval)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_cur = load i32, i32* %i, align 4
  %m_now = load i32, i32* %m, align 4
  %cmp_i_ge_m = icmp sge i32 %i_cur, %m_now
  br i1 %cmp_i_ge_m, label %after_edges, label %read_edge

read_edge:
  %fmt3ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.fmt3, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %scan3, 3
  br i1 %ok3, label %check_u0, label %error

check_u0:
  %uval = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %uval, 0
  br i1 %u_nonneg, label %check_u_lt_n, label %error

check_u_lt_n:
  %n_for_u = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %uval, %n_for_u
  br i1 %u_lt_n, label %check_v0, label %error

check_v0:
  %vval = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %vval, 0
  br i1 %v_nonneg, label %check_v_lt_n, label %error

check_v_lt_n:
  %n_for_v = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %vval, %n_for_v
  br i1 %v_lt_n, label %add, label %error

add:
  %wval = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %uval, i32 %vval, i32 %wval, i32 1)
  %i_next = add nsw i32 %i_cur, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_edges:
  %fmt1ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt1, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %sptr)
  %ok1 = icmp eq i32 %scan1, 1
  br i1 %ok1, label %check_s, label %error

check_s:
  %sval = load i32, i32* %sptr, align 4
  %s_nonneg = icmp sge i32 %sval, 0
  br i1 %s_nonneg, label %check_s_lt_n, label %error

check_s_lt_n:
  %n_for_s = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %sval, %n_for_s
  br i1 %s_lt_n, label %ok, label %error

ok:
  store i32 0, i32* %ret, align 4
  br label %retblk

error:
  store i32 -1, i32* %ret, align 4
  br label %retblk

retblk:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}