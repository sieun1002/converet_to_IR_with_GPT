; ModuleID = 'read_graph_module'
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.dd   = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd  = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str.d    = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  ; scanf("%d %d", n_ptr, &m)
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %rv1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %n_ptr, i32* %m)
  %ok2 = icmp eq i32 %rv1, 2
  br i1 %ok2, label %after_first_scanf, label %fail

after_first_scanf:
  %n = load i32, i32* %n_ptr, align 4
  %n_le_0 = icmp sle i32 %n, 0
  br i1 %n_le_0, label %fail, label %check_n_upper

check_n_upper:
  %n_gt_100 = icmp sgt i32 %n, 100
  br i1 %n_gt_100, label %fail, label %check_m_nonneg

check_m_nonneg:
  %mval = load i32, i32* %m, align 4
  %m_lt_0 = icmp slt i32 %mval, 0
  br i1 %m_lt_0, label %fail, label %init

init:
  call void @init_graph(%struct.graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %m.cur = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i.cur, %m.cur
  br i1 %i_lt_m, label %loop.body, label %after_edges

loop.body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt2 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.ddd, i64 0, i64 0
  %rv2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %rv2, 3
  br i1 %ok3, label %check_u_nonneg, label %fail

check_u_nonneg:
  %u.val = load i32, i32* %u, align 4
  %u_lt_0 = icmp slt i32 %u.val, 0
  br i1 %u_lt_0, label %fail, label %check_u_bound

check_u_bound:
  %n.cur1 = load i32, i32* %n_ptr, align 4
  %u_ge_n = icmp sge i32 %u.val, %n.cur1
  br i1 %u_ge_n, label %fail, label %check_v_nonneg

check_v_nonneg:
  %v.val = load i32, i32* %v, align 4
  %v_lt_0 = icmp slt i32 %v.val, 0
  br i1 %v_lt_0, label %fail, label %check_v_bound

check_v_bound:
  %n.cur2 = load i32, i32* %n_ptr, align 4
  %v_ge_n = icmp sge i32 %v.val, %n.cur2
  br i1 %v_ge_n, label %fail, label %add_edge

add_edge:
  %w.val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

after_edges:
  ; scanf("%d", start_ptr)
  %fmt3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %rv3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %start_ptr)
  %ok1 = icmp eq i32 %rv3, 1
  br i1 %ok1, label %check_start_nonneg, label %fail

check_start_nonneg:
  %s = load i32, i32* %start_ptr, align 4
  %s_lt_0 = icmp slt i32 %s, 0
  br i1 %s_lt_0, label %fail, label %check_start_bound

check_start_bound:
  %n.cur3 = load i32, i32* %n_ptr, align 4
  %s_ge_n = icmp sge i32 %s, %n.cur3
  br i1 %s_ge_n, label %fail, label %ok

ok:
  ret i32 0

fail:
  ret i32 -1
}