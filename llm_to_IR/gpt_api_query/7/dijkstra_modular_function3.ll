; ModuleID = 'read_graph.ll'
source_filename = "read_graph.c"

@.str2 = private unnamed_addr constant [5 x i8] c"%d %d\00", align 1
@.str3 = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8* noundef, ...)

declare void @init_graph(i8* noundef, i32 noundef)
declare void @add_edge(i8* noundef, i32 noundef, i32 noundef, i32 noundef, i32 noundef)

define i32 @read_graph(i8* noundef %g, i32* noundef %pn, i32* noundef %ps) {
entry:
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([5 x i8], [5 x i8]* @.str2, i64 0, i64 0), i32* noundef %pn, i32* noundef %m)
  %ok2 = icmp eq i32 %call0, 2
  br i1 %ok2, label %check_nm, label %error

check_nm:
  %n0 = load i32, i32* %pn, align 4
  %c1 = icmp sgt i32 %n0, 0
  %c2 = icmp sle i32 %n0, 100
  %m0 = load i32, i32* %m, align 4
  %c3 = icmp sge i32 %m0, 0
  %c12 = and i1 %c1, %c2
  %c123 = and i1 %c12, %c3
  br i1 %c123, label %initg, label %error

initg:
  call void @init_graph(i8* noundef %g, i32 noundef %n0)
  store i32 0, i32* %i, align 4
  br label %loop

loop:
  %i1 = load i32, i32* %i, align 4
  %m1 = load i32, i32* %m, align 4
  %cmp = icmp sge i32 %i1, %m1
  br i1 %cmp, label %after_loop, label %read_edge

read_edge:
  %rc = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([8 x i8], [8 x i8]* @.str3, i64 0, i64 0), i32* noundef %u, i32* noundef %v, i32* noundef %w)
  %ok3 = icmp eq i32 %rc, 3
  br i1 %ok3, label %check_u_nonneg, label %error

check_u_nonneg:
  %uval = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %uval, 0
  br i1 %u_nonneg, label %check_u_upper, label %error

check_u_upper:
  %n2 = load i32, i32* %pn, align 4
  %u_lt_n = icmp slt i32 %uval, %n2
  br i1 %u_lt_n, label %check_v_nonneg, label %error

check_v_nonneg:
  %vval = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %vval, 0
  br i1 %v_nonneg, label %check_v_upper, label %error

check_v_upper:
  %n3 = load i32, i32* %pn, align 4
  %v_lt_n = icmp slt i32 %vval, %n3
  br i1 %v_lt_n, label %addedge, label %error

addedge:
  %wval = load i32, i32* %w, align 4
  call void @add_edge(i8* noundef %g, i32 noundef %uval, i32 noundef %vval, i32 noundef %wval, i32 noundef 1)
  %inc = add nsw i32 %i1, 1
  store i32 %inc, i32* %i, align 4
  br label %loop

after_loop:
  %rc2 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* noundef %ps)
  %ok1 = icmp eq i32 %rc2, 1
  br i1 %ok1, label %check_s_nonneg, label %error

check_s_nonneg:
  %sval = load i32, i32* %ps, align 4
  %s_nonneg = icmp sge i32 %sval, 0
  br i1 %s_nonneg, label %check_s_upper, label %error

check_s_upper:
  %n4 = load i32, i32* %pn, align 4
  %s_lt_n = icmp slt i32 %sval, %n4
  br i1 %s_lt_n, label %success, label %error

error:
  ret i32 -1

success:
  ret i32 0
}