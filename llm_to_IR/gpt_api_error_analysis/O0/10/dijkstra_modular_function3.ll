; ModuleID = 'read_graph.ll'
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.2d = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.3d = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str.1d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %s_ptr) local_unnamed_addr {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %i = alloca i32, align 4
  %0 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.2d, i64 0, i64 0
  %1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %0, i32* %n_ptr, i32* %m)
  %2 = icmp eq i32 %1, 2
  br i1 %2, label %check_n_m, label %ret_err

check_n_m:
  %3 = load i32, i32* %n_ptr, align 4
  %4 = icmp sgt i32 %3, 0
  br i1 %4, label %n_le_100, label %ret_err

n_le_100:
  %5 = icmp sle i32 %3, 100
  br i1 %5, label %check_m_nonneg, label %ret_err

check_m_nonneg:
  %6 = load i32, i32* %m, align 4
  %7 = icmp sge i32 %6, 0
  br i1 %7, label %init_and_loop, label %ret_err

init_and_loop:
  call void @init_graph(%struct.graph* %g, i32 %3)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %8 = load i32, i32* %i, align 4
  %9 = load i32, i32* %m, align 4
  %10 = icmp slt i32 %8, %9
  br i1 %10, label %read_edge, label %after_edges

read_edge:
  %11 = getelementptr inbounds [8 x i8], [8 x i8]* @.str.3d, i64 0, i64 0
  %12 = call i32 (i8*, ...) @__isoc99_scanf(i8* %11, i32* %u, i32* %v, i32* %w)
  %13 = icmp eq i32 %12, 3
  br i1 %13, label %validate_u, label %ret_err

validate_u:
  %14 = load i32, i32* %u, align 4
  %15 = icmp sge i32 %14, 0
  br i1 %15, label %u_lt_n, label %ret_err

u_lt_n:
  %16 = load i32, i32* %n_ptr, align 4
  %17 = icmp slt i32 %14, %16
  br i1 %17, label %validate_v_ge0, label %ret_err

validate_v_ge0:
  %18 = load i32, i32* %v, align 4
  %19 = icmp sge i32 %18, 0
  br i1 %19, label %v_lt_n, label %ret_err

v_lt_n:
  %20 = load i32, i32* %n_ptr, align 4
  %21 = icmp slt i32 %18, %20
  br i1 %21, label %add_edge_call, label %ret_err

add_edge_call:
  %22 = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %14, i32 %18, i32 %22, i32 1)
  %23 = add nsw i32 %8, 1
  store i32 %23, i32* %i, align 4
  br label %loop

after_edges:
  %24 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.1d, i64 0, i64 0
  %25 = call i32 (i8*, ...) @__isoc99_scanf(i8* %24, i32* %s_ptr)
  %26 = icmp eq i32 %25, 1
  br i1 %26, label %validate_s_ge0, label %ret_err

validate_s_ge0:
  %27 = load i32, i32* %s_ptr, align 4
  %28 = icmp sge i32 %27, 0
  br i1 %28, label %s_lt_n, label %ret_err

s_lt_n:
  %29 = load i32, i32* %n_ptr, align 4
  %30 = icmp slt i32 %27, %29
  br i1 %30, label %ret_ok, label %ret_err

ret_ok:
  ret i32 0

ret_err:
  ret i32 -1
}