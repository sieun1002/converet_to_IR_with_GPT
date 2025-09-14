; ModuleID = 'read_graph'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: read_graph  ; Address: 0x401230
; Intent: Read a graph from stdin, initialize it, add edges, and read a source vertex (confidence=0.95). Evidence: calls to init_graph/add_edge and scanf with "%d %d" then "%d %d %d" then "%d".
; Preconditions: %g must be a valid graph handle for init_graph/add_edge; %n and %s must be valid i32* pointers. Input format: N M, then M lines of "u v w", then "s".
; Postconditions: Returns 0 on success; -1 on any input/validation error. Graph initialized with N nodes (1<=N<=100), M>=0 edges added with flag=1; s in [0, N).

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00"
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00"
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00"

; Only the needed extern declarations:
declare i32 @___isoc99_scanf(i8*, ...)
declare void @init_graph(i8*, i32)
declare void @add_edge(i8*, i32, i32, i32, i32)

define dso_local i32 @read_graph(i8* %g, i32* %n, i32* %s) local_unnamed_addr {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4

  %fmt_dd_gep = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @___isoc99_scanf(i8* %fmt_dd_gep, i32* %n, i32* %m)
  %ok0 = icmp eq i32 %call0, 2
  br i1 %ok0, label %check_nm, label %error

check_nm:
  %nval = load i32, i32* %n, align 4
  %gt0 = icmp sgt i32 %nval, 0
  %le100 = icmp sle i32 %nval, 100
  %n_ok = and i1 %gt0, %le100
  %mval = load i32, i32* %m, align 4
  %m_ge0 = icmp sge i32 %mval, 0
  %nm_ok = and i1 %n_ok, %m_ge0
  br i1 %nm_ok, label %do_init, label %error

do_init:
  call void @init_graph(i8* %g, i32 %nval)
  br label %loop.cond

loop.cond:
  %i = phi i32 [ 0, %do_init ], [ %i.next, %loop.body.end ]
  %mcur = load i32, i32* %m, align 4
  %cmp_i = icmp slt i32 %i, %mcur
  br i1 %cmp_i, label %loop.body, label %after_edges

loop.body:
  %fmt_ddd_gep = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @___isoc99_scanf(i8* %fmt_ddd_gep, i32* %u, i32* %v, i32* %w)
  %ok1 = icmp eq i32 %call1, 3
  br i1 %ok1, label %validate_uv, label %error

validate_uv:
  %uu = load i32, i32* %u, align 4
  %vv = load i32, i32* %v, align 4
  %uu_ge0 = icmp sge i32 %uu, 0
  %uu_lt_n = icmp slt i32 %uu, %nval
  %uu_ok = and i1 %uu_ge0, %uu_lt_n
  %vv_ge0 = icmp sge i32 %vv, 0
  %vv_lt_n = icmp slt i32 %vv, %nval
  %vv_ok = and i1 %vv_ge0, %vv_lt_n
  %uv_ok = and i1 %uu_ok, %vv_ok
  br i1 %uv_ok, label %add_e, label %error

add_e:
  %ww = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %uu, i32 %vv, i32 %ww, i32 1)
  br label %loop.body.end

loop.body.end:
  %i.next = add nsw i32 %i, 1
  br label %loop.cond

after_edges:
  %fmt_d_gep = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @___isoc99_scanf(i8* %fmt_d_gep, i32* %s)
  %ok2 = icmp eq i32 %call2, 1
  br i1 %ok2, label %check_s, label %error

check_s:
  %sval = load i32, i32* %s, align 4
  %s_ge0 = icmp sge i32 %sval, 0
  %s_lt_n = icmp slt i32 %sval, %nval
  %s_ok = and i1 %s_ge0, %s_lt_n
  br i1 %s_ok, label %success, label %error

error:
  ret i32 -1

success:
  ret i32 0
}