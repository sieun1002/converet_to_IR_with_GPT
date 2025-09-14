; ModuleID = 'read_graph.ll'
source_filename = "read_graph.ll"

@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_single = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare dso_local i32 @___isoc99_scanf(i8*, ...)
declare dso_local void @init_graph(i8*, i32)
declare dso_local void @add_edge(i8*, i32, i32, i32, i32)

define dso_local i32 @read_graph(i8* %g, i32* %n_ptr, i32* %start_ptr) local_unnamed_addr {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  ; scanf("%d %d", n_ptr, &m)
  %fmt_dd = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 3
  %call0 = call i32 (i8*, ...) @___isoc99_scanf(i8* %fmt_dd, i32* %n_ptr, i32* %m)
  %cmp0 = icmp eq i32 %call0, 2
  br i1 %cmp0, label %chk_n_pos, label %fail

chk_n_pos:
  %n0 = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n0, 0
  br i1 %n_pos, label %chk_n_le_100, label %fail

chk_n_le_100:
  %n_le_100 = icmp sle i32 %n0, 100
  br i1 %n_le_100, label %chk_m_ge_0, label %fail

chk_m_ge_0:
  %m0 = load i32, i32* %m, align 4
  %m_ge_0 = icmp sge i32 %m0, 0
  br i1 %m_ge_0, label %init, label %fail

init:
  call void @init_graph(i8* %g, i32 %n0)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i_cur = load i32, i32* %i, align 4
  %m_cur = load i32, i32* %m, align 4
  %cond = icmp slt i32 %i_cur, %m_cur
  br i1 %cond, label %loop_body, label %after_loop

loop_body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt_ddd = getelementptr inbounds [9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @___isoc99_scanf(i8* %fmt_ddd, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %call1, 3
  br i1 %ok3, label %validate_uv, label %fail

validate_uv:
  %u_val = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %u_val, 0
  br i1 %u_nonneg, label %chk_u_lt_n, label %fail

chk_u_lt_n:
  %n1 = load i32, i32* %n_ptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n1
  br i1 %u_lt_n, label %chk_v_nonneg, label %fail

chk_v_nonneg:
  %v_val = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %v_val, 0
  br i1 %v_nonneg, label %chk_v_lt_n, label %fail

chk_v_lt_n:
  %n2 = load i32, i32* %n_ptr, align 4
  %v_lt_n = icmp slt i32 %v_val, %n2
  br i1 %v_lt_n, label %do_add_edge, label %fail

do_add_edge:
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next = add nsw i32 %i_cur, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_loop:
  ; scanf("%d", start_ptr)
  %call2 = call i32 (i8*, ...) @___isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_single, i64 0, i64 0), i32* %start_ptr)
  %ok1 = icmp eq i32 %call2, 1
  br i1 %ok1, label %chk_s_nonneg, label %fail

chk_s_nonneg:
  %s0 = load i32, i32* %start_ptr, align 4
  %s_nonneg = icmp sge i32 %s0, 0
  br i1 %s_nonneg, label %chk_s_lt_n, label %fail

chk_s_lt_n:
  %n3 = load i32, i32* %n_ptr, align 4
  %s_lt_n = icmp slt i32 %s0, %n3
  br i1 %s_lt_n, label %success, label %fail

success:
  store i32 0, i32* %ret, align 4
  br label %end

fail:
  store i32 -1, i32* %ret, align 4
  br label %end

end:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}