; ModuleID = 'read_graph.ll'

@.str = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str1 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str2 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %ret = alloca i32, align 4
  %g.addr = alloca i8*, align 8
  %n.addr = alloca i32*, align 8
  %start.addr = alloca i32*, align 8
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  store i8* %g, i8** %g.addr, align 8
  store i32* %n_ptr, i32** %n.addr, align 8
  store i32* %start_ptr, i32** %start.addr, align 8
  %0 = load i32*, i32** %n.addr, align 8
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str, i64 0, i64 0), i32* %0, i32* %m)
  %cmp0 = icmp eq i32 %call0, 2
  br i1 %cmp0, label %check_n, label %error

check_n:                                          ; preds = %entry
  %1 = load i32*, i32** %n.addr, align 8
  %nval = load i32, i32* %1, align 4
  %gt0 = icmp sgt i32 %nval, 0
  br i1 %gt0, label %check_n_upper, label %error

check_n_upper:                                    ; preds = %check_n
  %le100 = icmp sle i32 %nval, 100
  br i1 %le100, label %check_m_nonneg, label %error

check_m_nonneg:                                   ; preds = %check_n_upper
  %mval = load i32, i32* %m, align 4
  %m_nonneg = icmp sge i32 %mval, 0
  br i1 %m_nonneg, label %init, label %error

init:                                             ; preds = %check_m_nonneg
  %2 = load i8*, i8** %g.addr, align 8
  call void @init_graph(i8* %2, i32 %nval)
  store i32 0, i32* %i, align 4
  br label %loop.cond

loop.cond:                                        ; preds = %add_edge, %init
  %i.cur = load i32, i32* %i, align 4
  %mval2 = load i32, i32* %m, align 4
  %cmp_i = icmp sge i32 %i.cur, %mval2
  br i1 %cmp_i, label %after_edges, label %read_edge

read_edge:                                        ; preds = %loop.cond
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str1, i64 0, i64 0), i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %call1, 3
  br i1 %ok3, label %check_u, label %error

check_u:                                          ; preds = %read_edge
  %uval = load i32, i32* %u, align 4
  %u_nonneg = icmp sge i32 %uval, 0
  br i1 %u_nonneg, label %check_u_upper, label %error

check_u_upper:                                    ; preds = %check_u
  %3 = load i32*, i32** %n.addr, align 8
  %nval2 = load i32, i32* %3, align 4
  %u_lt_n = icmp slt i32 %uval, %nval2
  br i1 %u_lt_n, label %check_v_nonneg, label %error

check_v_nonneg:                                   ; preds = %check_u_upper
  %vval = load i32, i32* %v, align 4
  %v_nonneg = icmp sge i32 %vval, 0
  br i1 %v_nonneg, label %check_v_upper, label %error

check_v_upper:                                    ; preds = %check_v_nonneg
  %4 = load i32*, i32** %n.addr, align 8
  %nval3 = load i32, i32* %4, align 4
  %v_lt_n = icmp slt i32 %vval, %nval3
  br i1 %v_lt_n, label %add_edge, label %error

add_edge:                                         ; preds = %check_v_upper
  %5 = load i8*, i8** %g.addr, align 8
  %wval = load i32, i32* %w, align 4
  call void @add_edge(i8* %5, i32 %uval, i32 %vval, i32 %wval, i32 1)
  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop.cond

after_edges:                                      ; preds = %loop.cond
  %6 = load i32*, i32** %start.addr, align 8
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str2, i64 0, i64 0), i32* %6)
  %ok1 = icmp eq i32 %call2, 1
  br i1 %ok1, label %check_start_nonneg, label %error

check_start_nonneg:                               ; preds = %after_edges
  %7 = load i32*, i32** %start.addr, align 8
  %startval = load i32, i32* %7, align 4
  %s_nonneg = icmp sge i32 %startval, 0
  br i1 %s_nonneg, label %check_start_upper, label %error

check_start_upper:                                ; preds = %check_start_nonneg
  %8 = load i32*, i32** %n.addr, align 8
  %nval4 = load i32, i32* %8, align 4
  %s_lt_n = icmp slt i32 %startval, %nval4
  br i1 %s_lt_n, label %success, label %error

success:                                          ; preds = %check_start_upper
  store i32 0, i32* %ret, align 4
  br label %return

error:                                            ; preds = %check_start_upper, %check_start_nonneg, %after_edges, %check_v_upper, %check_v_nonneg, %check_u_upper, %check_u, %read_edge, %check_m_nonneg, %check_n_upper, %check_n, %entry
  store i32 -1, i32* %ret, align 4
  br label %return

return:                                           ; preds = %error, %success
  %retval = load i32, i32* %ret, align 4
  ret i32 %retval
}