; ModuleID = 'read_graph.ll'
source_filename = "read_graph.c"
target triple = "x86_64-pc-linux-gnu"

%struct.Graph = type opaque

@.str_read2 = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str_read3 = private unnamed_addr constant [8 x i8] c"%d %d %d\00", align 1
@.str_read1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.Graph*, i32)
declare void @add_edge(%struct.Graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.Graph* %g, i32* %n_ptr, i32* %src_ptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  store i32 0, i32* %i, align 4
  %fmt2 = getelementptr inbounds [6 x i8], [6 x i8]* @.str_read2, i64 0, i64 0
  %call0 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2, i32* %n_ptr, i32* %m)
  %ok2 = icmp eq i32 %call0, 2
  br i1 %ok2, label %check_n_m, label %error_return

check_n_m:                                        ; preds = %entry
  %n = load i32, i32* %n_ptr, align 4
  %n_pos = icmp sgt i32 %n, 0
  %n_le_100 = icmp sle i32 %n, 100
  %m_load = load i32, i32* %m, align 4
  %m_nonneg = icmp sge i32 %m_load, 0
  %condn = and i1 %n_pos, %n_le_100
  %cond1 = and i1 %condn, %m_nonneg
  br i1 %cond1, label %init_graph, label %error_return

init_graph:                                       ; preds = %check_n_m
  call void @init_graph(%struct.Graph* %g, i32 %n)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %add_edge_block, %init_graph
  %i_val = load i32, i32* %i, align 4
  %m_cur = load i32, i32* %m, align 4
  %cmp_i = icmp sge i32 %i_val, %m_cur
  br i1 %cmp_i, label %after_edges, label %read_edge

read_edge:                                        ; preds = %loop
  %fmt3 = getelementptr inbounds [8 x i8], [8 x i8]* @.str_read3, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3, i32* %u, i32* %v, i32* %w)
  %ok3 = icmp eq i32 %call1, 3
  br i1 %ok3, label %validate_edge, label %error_return

validate_edge:                                    ; preds = %read_edge
  %u_val = load i32, i32* %u, align 4
  %v_val = load i32, i32* %v, align 4
  %w_val = load i32, i32* %w, align 4
  %u_nonneg = icmp sge i32 %u_val, 0
  %u_lt_n = icmp slt i32 %u_val, %n
  %v_nonneg = icmp sge i32 %v_val, 0
  %v_lt_n = icmp slt i32 %v_val, %n
  %ok_uv = and i1 %u_nonneg, %u_lt_n
  %ok_v = and i1 %v_nonneg, %v_lt_n
  %ok_all = and i1 %ok_uv, %ok_v
  br i1 %ok_all, label %add_edge_block, label %error_return

add_edge_block:                                   ; preds = %validate_edge
  call void @add_edge(%struct.Graph* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next = add nsw i32 %i_val, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop

after_edges:                                      ; preds = %loop
  %fmt1 = getelementptr inbounds [3 x i8], [3 x i8]* @.str_read1, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1, i32* %src_ptr)
  %ok1 = icmp eq i32 %call2, 1
  br i1 %ok1, label %check_src, label %error_return

check_src:                                        ; preds = %after_edges
  %src = load i32, i32* %src_ptr, align 4
  %src_nonneg = icmp sge i32 %src, 0
  %src_lt_n = icmp slt i32 %src, %n
  %ok_src = and i1 %src_nonneg, %src_lt_n
  br i1 %ok_src, label %success, label %error_return

error_return:                                     ; preds = %after_edges, %validate_edge, %read_edge, %check_n_m, %entry
  store i32 -1, i32* %ret, align 4
  br label %ret_block

success:                                          ; preds = %check_src
  store i32 0, i32* %ret, align 4
  br label %ret_block

ret_block:                                        ; preds = %success, %error_return
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}