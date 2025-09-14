; ModuleID = 'read_graph.ll'
source_filename = "read_graph.c"

%struct.graph = type opaque

@.str.dd = private unnamed_addr constant [5 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %nptr, i32* %sptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  ; scanf("%d %d", nptr, &m)
  %fmt.dd.ptr = getelementptr inbounds [5 x i8], [5 x i8]* @.str.dd, i64 0, i64 0
  %scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt.dd.ptr, i32* %nptr, i32* %m)
  %ok2 = icmp eq i32 %scan2, 2
  br i1 %ok2, label %check_bounds, label %fail2

fail2:
  store i32 -1, i32* %ret, align 4
  br label %done

check_bounds:
  %n = load i32, i32* %nptr, align 4
  %n_le_0 = icmp sle i32 %n, 0
  br i1 %n_le_0, label %fail_bounds, label %check_n_hi

check_n_hi:
  %n_gt_100 = icmp sgt i32 %n, 100
  br i1 %n_gt_100, label %fail_bounds, label %check_m

check_m:
  %mval = load i32, i32* %m, align 4
  %m_lt_0 = icmp slt i32 %mval, 0
  br i1 %m_lt_0, label %fail_bounds, label %init_g

fail_bounds:
  store i32 -1, i32* %ret, align 4
  br label %done

init_g:
  call void @init_graph(%struct.graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:
  %i.cur = load i32, i32* %i, align 4
  %m.cur = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i.cur, %m.cur
  br i1 %i_lt_m, label %loop.body, label %after_loop

loop.body:
  ; scanf("%d %d %d", &u, &v, &w)
  %fmt.ddd.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt.ddd.ptr, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %scan3, 3
  br i1 %ok3, label %check_uv, label %fail_edge_scan

fail_edge_scan:
  store i32 -1, i32* %ret, align 4
  br label %done

check_uv:
  %uval = load i32, i32* %u, align 4
  %u_ge_0 = icmp sge i32 %uval, 0
  br i1 %u_ge_0, label %check_u_hi, label %fail_uv

check_u_hi:
  %u_lt_n = icmp slt i32 %uval, %n
  br i1 %u_lt_n, label %check_v_lo, label %fail_uv

check_v_lo:
  %vval = load i32, i32* %v, align 4
  %v_ge_0 = icmp sge i32 %vval, 0
  br i1 %v_ge_0, label %check_v_hi, label %fail_uv

check_v_hi:
  %v_lt_n = icmp slt i32 %vval, %n
  br i1 %v_lt_n, label %add_edge_call, label %fail_uv

fail_uv:
  store i32 -1, i32* %ret, align 4
  br label %done

add_edge_call:
  %wval = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %uval, i32 %vval, i32 %wval, i32 1)
  %inc = add nsw i32 %i.cur, 1
  store i32 %inc, i32* %i, align 4
  br label %loop.cond

after_loop:
  ; scanf("%d", sptr)
  %fmt.d.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt.d.ptr, i32* %sptr)
  %ok1 = icmp eq i32 %scan1, 1
  br i1 %ok1, label %check_start, label %fail_start_scan

fail_start_scan:
  store i32 -1, i32* %ret, align 4
  br label %done

check_start:
  %s = load i32, i32* %sptr, align 4
  %s_ge_0 = icmp sge i32 %s, 0
  br i1 %s_ge_0, label %check_s_hi, label %fail_start_bounds

check_s_hi:
  %s_lt_n = icmp slt i32 %s, %n
  br i1 %s_lt_n, label %success, label %fail_start_bounds

fail_start_bounds:
  store i32 -1, i32* %ret, align 4
  br label %done

success:
  store i32 0, i32* %ret, align 4
  br label %done

done:
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}