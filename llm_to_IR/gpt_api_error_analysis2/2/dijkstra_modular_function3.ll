; ModuleID = 'read_graph.ll'
target triple = "x86_64-pc-linux-gnu"

@.str.triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %graph, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %fmt_twop = getelementptr inbounds [9 x i8], [9 x i8]* @.str.triple, i64 0, i64 3
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull %fmt_twop, i32* nonnull %n_ptr, i32* nonnull %m)
  %cmp0 = icmp eq i32 %call0, 2
  br i1 %cmp0, label %check_nm, label %fail

check_nm:
  %n0 = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n0, 0
  br i1 %n_pos, label %check_n_upper, label %fail

check_n_upper:
  %n_le_100 = icmp sle i32 %n0, 100
  br i1 %n_le_100, label %check_m_nonneg, label %fail

check_m_nonneg:
  %m0 = load i32, i32* %m, align 4
  %m_ge_0 = icmp sge i32 %m0, 0
  br i1 %m_ge_0, label %init, label %fail

init:
  call void @init_graph(i8* %graph, i32 %n0)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i0 = load i32, i32* %i, align 4
  %m1 = load i32, i32* %m, align 4
  %i_ge_m = icmp sge i32 %i0, %m1
  br i1 %i_ge_m, label %after_edges, label %read_edge

read_edge:
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.triple, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %got3 = icmp eq i32 %call1, 3
  br i1 %got3, label %check_u0, label %fail

check_u0:
  %u0 = load i32, i32* %u, align 4
  %u_ge_0 = icmp sge i32 %u0, 0
  br i1 %u_ge_0, label %check_u_lt_n, label %fail

check_u_lt_n:
  %n1 = load i32, i32* %n_ptr, align 4
  %u1 = load i32, i32* %u, align 4
  %u_lt_n = icmp slt i32 %u1, %n1
  br i1 %u_lt_n, label %check_v0, label %fail

check_v0:
  %v0 = load i32, i32* %v, align 4
  %v_ge_0 = icmp sge i32 %v0, 0
  br i1 %v_ge_0, label %check_v_lt_n, label %fail

check_v_lt_n:
  %n2 = load i32, i32* %n_ptr, align 4
  %v1 = load i32, i32* %v, align 4
  %v_lt_n = icmp slt i32 %v1, %n2
  br i1 %v_lt_n, label %add_edge_call, label %fail

add_edge_call:
  %u2 = load i32, i32* %u, align 4
  %v2 = load i32, i32* %v, align 4
  %w0 = load i32, i32* %w, align 4
  call void @add_edge(i8* %graph, i32 %u2, i32 %v2, i32 %w0, i32 1)
  %i_next = add nsw i32 %i0, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_edges:
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* nonnull %start_ptr)
  %got1 = icmp eq i32 %call2, 1
  br i1 %got1, label %check_start_nonneg, label %fail

check_start_nonneg:
  %s0 = load i32, i32* %start_ptr, align 4
  %s_ge_0 = icmp sge i32 %s0, 0
  br i1 %s_ge_0, label %check_start_lt_n, label %fail

check_start_lt_n:
  %n3 = load i32, i32* %n_ptr, align 4
  %s1 = load i32, i32* %start_ptr, align 4
  %s_lt_n = icmp slt i32 %s1, %n3
  br i1 %s_lt_n, label %success, label %fail

success:
  ret i32 0

fail:
  ret i32 -1
}