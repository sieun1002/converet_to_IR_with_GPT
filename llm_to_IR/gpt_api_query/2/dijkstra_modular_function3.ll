; ModuleID = 'read_graph.ll'
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.dd  = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d   = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %start_ptr) local_unnamed_addr {
entry:
  %ret = alloca i32, align 4
  %m   = alloca i32, align 4
  %i   = alloca i32, align 4
  %u   = alloca i32, align 4
  %v   = alloca i32, align 4
  %w   = alloca i32, align 4

  store i32 0, i32* %ret, align 4

  ; scanf("%d %d", n_ptr, &m)
  %fmt1 = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %sc1  = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %n_ptr, i32* %m)
  %ok1  = icmp eq i32 %sc1, 2
  br i1 %ok1, label %check_nm, label %error

check_nm:                                         ; preds = %entry
  %n    = load i32, i32* %n_ptr, align 4
  %n_gt0 = icmp sgt i32 %n, 0
  %n_le100 = icmp sle i32 %n, 100
  %mval = load i32, i32* %m, align 4
  %m_ge0 = icmp sge i32 %mval, 0
  %tmp1 = and i1 %n_gt0, %n_le100
  %oknm = and i1 %tmp1, %m_ge0
  br i1 %oknm, label %init, label %error

init:                                             ; preds = %check_nm
  call void @init_graph(%struct.graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %add_edge, %init
  %icur = load i32, i32* %i, align 4
  %mcur = load i32, i32* %m, align 4
  %ge = icmp sge i32 %icur, %mcur
  br i1 %ge, label %after_edges, label %read_edge

read_edge:                                        ; preds = %loop
  %fmt2 = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %sc2  = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %u, i32* %v, i32* %w)
  %ok2  = icmp eq i32 %sc2, 3
  br i1 %ok2, label %check_uv, label %error

check_uv:                                         ; preds = %read_edge
  %uval = load i32, i32* %u, align 4
  %vval = load i32, i32* %v, align 4
  %wval = load i32, i32* %w, align 4

  %u_ge0 = icmp sge i32 %uval, 0
  %u_lt_n = icmp slt i32 %uval, %n
  %v_ge0 = icmp sge i32 %vval, 0
  %v_lt_n = icmp slt i32 %vval, %n

  %ok_u = and i1 %u_ge0, %u_lt_n
  %ok_v = and i1 %v_ge0, %v_lt_n
  %ok_uv = and i1 %ok_u, %ok_v
  br i1 %ok_uv, label %add_edge, label %error

add_edge:                                         ; preds = %check_uv
  call void @add_edge(%struct.graph* %g, i32 %uval, i32 %vval, i32 %wval, i32 1)
  %inext = add nsw i32 %icur, 1
  store i32 %inext, i32* %i, align 4
  br label %loop

after_edges:                                      ; preds = %loop
  ; scanf("%d", start_ptr)
  %fmt3 = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %sc3  = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %start_ptr)
  %ok3  = icmp eq i32 %sc3, 1
  br i1 %ok3, label %check_start, label %error

check_start:                                      ; preds = %after_edges
  %s = load i32, i32* %start_ptr, align 4
  %s_ge0 = icmp sge i32 %s, 0
  %s_lt_n = icmp slt i32 %s, %n
  %ok_s = and i1 %s_ge0, %s_lt_n
  br i1 %ok_s, label %success, label %error

error:                                            ; preds = %check_start, %after_edges, %check_uv, %read_edge, %check_nm, %entry
  store i32 -1, i32* %ret, align 4
  br label %end

success:                                          ; preds = %check_start
  store i32 0, i32* %ret, align 4
  br label %end

end:                                              ; preds = %success, %error
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}