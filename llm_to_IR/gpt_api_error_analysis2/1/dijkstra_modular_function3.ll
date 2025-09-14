; ModuleID = 'read_graph_module'
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str_dd  = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_d   = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %graph, i32* %nptr, i32* %sptr) {
entry:
  %E = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  %fmt1ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_dd, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %nptr, i32* %E)
  %cmp_scan1 = icmp eq i32 %scan1, 2
  br i1 %cmp_scan1, label %check_ne, label %fail

check_ne:
  %n0 = load i32, i32* %nptr, align 4
  %cmp_n_pos = icmp sgt i32 %n0, 0
  br i1 %cmp_n_pos, label %check_n_max, label %fail

check_n_max:
  %n1 = load i32, i32* %nptr, align 4
  %cmp_n_le = icmp sle i32 %n1, 100
  br i1 %cmp_n_le, label %check_e_nonneg, label %fail

check_e_nonneg:
  %E0 = load i32, i32* %E, align 4
  %cmp_e = icmp sge i32 %E0, 0
  br i1 %cmp_e, label %init, label %fail

init:
  %n2 = load i32, i32* %nptr, align 4
  call void @init_graph(%struct.graph* %graph, i32 %n2)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i0 = load i32, i32* %i, align 4
  %E1 = load i32, i32* %E, align 4
  %cmp_i = icmp slt i32 %i0, %E1
  br i1 %cmp_i, label %loop.body, label %afterloop

loop.body:
  %fmt3ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str_ddd, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %u, i32* %v, i32* %w)
  %cmp_scan3 = icmp eq i32 %scan3, 3
  br i1 %cmp_scan3, label %chk_u0, label %fail

chk_u0:
  %u0 = load i32, i32* %u, align 4
  %u_ge0 = icmp sge i32 %u0, 0
  br i1 %u_ge0, label %chk_u_n, label %fail

chk_u_n:
  %n3 = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u0, %n3
  br i1 %u_lt_n, label %chk_v0, label %fail

chk_v0:
  %v0 = load i32, i32* %v, align 4
  %v_ge0 = icmp sge i32 %v0, 0
  br i1 %v_ge0, label %chk_v_n, label %fail

chk_v_n:
  %n4 = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %v0, %n4
  br i1 %v_lt_n, label %do_add, label %fail

do_add:
  %w0 = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %graph, i32 %u0, i32 %v0, i32 %w0, i32 1)
  %i1 = load i32, i32* %i, align 4
  %i2 = add nsw i32 %i1, 1
  store i32 %i2, i32* %i, align 4
  br label %loop.cond

afterloop:
  %fmt1ptr2 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_d, i64 0, i64 0
  %scan_last = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr2, i32* %sptr)
  %cmp_scan_last = icmp eq i32 %scan_last, 1
  br i1 %cmp_scan_last, label %chk_s0, label %fail

chk_s0:
  %s0 = load i32, i32* %sptr, align 4
  %s_ge0 = icmp sge i32 %s0, 0
  br i1 %s_ge0, label %chk_s_n, label %fail

chk_s_n:
  %n5 = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %s0, %n5
  br i1 %s_lt_n, label %succ, label %fail

fail:
  br label %end

succ:
  br label %end

end:
  %ret = phi i32 [ -1, %fail ], [ 0, %succ ]
  ret i32 %ret
}