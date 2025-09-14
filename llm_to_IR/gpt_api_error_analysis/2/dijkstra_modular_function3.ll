; ModuleID = 'read_graph'
target triple = "x86_64-pc-linux-gnu"

@.fmt_two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.fmt_three = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.fmt_one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %graph, i32* %nptr, i32* %startptr) {
entry:
  %m.addr = alloca i32, align 4
  %u.addr = alloca i32, align 4
  %v.addr = alloca i32, align 4
  %w.addr = alloca i32, align 4
  %fmt_two_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_two, i64 0, i64 0
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_two_ptr, i32* %nptr, i32* %m.addr)
  %cmp_scanf2 = icmp eq i32 %call_scanf2, 2
  br i1 %cmp_scanf2, label %check_nm, label %ret_err

check_nm:
  %n.load1 = load i32, i32* %nptr, align 4
  %n_gt0 = icmp sgt i32 %n.load1, 0
  %n_le100 = icmp sle i32 %n.load1, 100
  %n_ok = and i1 %n_gt0, %n_le100
  %m.load1 = load i32, i32* %m.addr, align 4
  %m_ge0 = icmp sge i32 %m.load1, 0
  %nm_ok = and i1 %n_ok, %m_ge0
  br i1 %nm_ok, label %init_call, label %ret_err

init_call:
  %n.load2 = load i32, i32* %nptr, align 4
  call void @init_graph(i8* %graph, i32 %n.load2)
  br label %loop.cond

loop.cond:
  %i.phi = phi i32 [ 0, %init_call ], [ %i.next, %loop.latch ]
  %m.load2 = load i32, i32* %m.addr, align 4
  %i_lt_m = icmp slt i32 %i.phi, %m.load2
  br i1 %i_lt_m, label %loop.body, label %after_loop

loop.body:
  %fmt_three_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.fmt_three, i64 0, i64 0
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_three_ptr, i32* %u.addr, i32* %v.addr, i32* %w.addr)
  %cmp_scanf3 = icmp eq i32 %call_scanf3, 3
  br i1 %cmp_scanf3, label %check_uv, label %ret_err

check_uv:
  %u.load1 = load i32, i32* %u.addr, align 4
  %u_ge0 = icmp sge i32 %u.load1, 0
  %n.load3 = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u.load1, %n.load3
  %u_ok = and i1 %u_ge0, %u_lt_n
  %v.load1 = load i32, i32* %v.addr, align 4
  %v_ge0 = icmp sge i32 %v.load1, 0
  %n.load4 = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %v.load1, %n.load4
  %v_ok = and i1 %v_ge0, %v_lt_n
  %uv_ok = and i1 %u_ok, %v_ok
  br i1 %uv_ok, label %do_add, label %ret_err

do_add:
  %w.load1 = load i32, i32* %w.addr, align 4
  call void @add_edge(i8* %graph, i32 %u.load1, i32 %v.load1, i32 %w.load1, i32 1)
  br label %loop.latch

loop.latch:
  %i.next = add nsw i32 %i.phi, 1
  br label %loop.cond

after_loop:
  %fmt_one_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt_one, i64 0, i64 0
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt_one_ptr, i32* %startptr)
  %cmp_scanf1 = icmp eq i32 %call_scanf1, 1
  br i1 %cmp_scanf1, label %check_start, label %ret_err

check_start:
  %start.load1 = load i32, i32* %startptr, align 4
  %start_ge0 = icmp sge i32 %start.load1, 0
  %n.load5 = load i32, i32* %nptr, align 4
  %start_lt_n = icmp slt i32 %start.load1, %n.load5
  %start_ok = and i1 %start_ge0, %start_lt_n
  br i1 %start_ok, label %ret_ok, label %ret_err

ret_err:
  br label %ret

ret_ok:
  br label %ret

ret:
  %retval = phi i32 [ -1, %ret_err ], [ 0, %ret_ok ]
  ret i32 %retval
}