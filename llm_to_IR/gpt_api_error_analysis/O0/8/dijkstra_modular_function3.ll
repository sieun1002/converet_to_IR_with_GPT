; ModuleID = 'read_graph.ll'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.fmt_2d = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.fmt_3d = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.fmt_1d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)
declare void @init_graph(%struct.graph*, i32)
declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %graph, i32* %pn, i32* %psrc) local_unnamed_addr {
entry:
  %status = alloca i32, align 4
  %edgecount = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %fmt2_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.fmt_2d, i64 0, i64 0
  %sc1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2_ptr, i32* %pn, i32* %edgecount)
  %cmp_sc1 = icmp eq i32 %sc1, 2
  br i1 %cmp_sc1, label %check_bounds1, label %error

check_bounds1:                                     ; preds = %entry
  %n0 = load i32, i32* %pn, align 4
  %n_gt0 = icmp sgt i32 %n0, 0
  br i1 %n_gt0, label %check_n_le_100, label %error

check_n_le_100:                                    ; preds = %check_bounds1
  %n1 = load i32, i32* %pn, align 4
  %n_le_100 = icmp sle i32 %n1, 100
  br i1 %n_le_100, label %check_m_ge_0, label %error

check_m_ge_0:                                      ; preds = %check_n_le_100
  %m0 = load i32, i32* %edgecount, align 4
  %m_ge_0 = icmp sge i32 %m0, 0
  br i1 %m_ge_0, label %init_graph_block, label %error

init_graph_block:                                  ; preds = %check_m_ge_0
  %n2 = load i32, i32* %pn, align 4
  call void @init_graph(%struct.graph* %graph, i32 %n2)
  store i32 0, i32* %i, align 4
  br label %loop_header

loop_header:                                       ; preds = %add_edge_block, %init_graph_block
  %i0 = load i32, i32* %i, align 4
  %m1 = load i32, i32* %edgecount, align 4
  %i_ge_m = icmp sge i32 %i0, %m1
  br i1 %i_ge_m, label %after_edges, label %read_edge

read_edge:                                         ; preds = %loop_header
  %fmt3_ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.fmt_3d, i64 0, i64 0
  %sc2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3_ptr, i32* %u, i32* %v, i32* %w)
  %sc2_ok = icmp eq i32 %sc2, 3
  br i1 %sc2_ok, label %validate_u, label %error

validate_u:                                        ; preds = %read_edge
  %u0 = load i32, i32* %u, align 4
  %u_ge_0 = icmp sge i32 %u0, 0
  br i1 %u_ge_0, label %validate_u_lt_n, label %error

validate_u_lt_n:                                   ; preds = %validate_u
  %n3 = load i32, i32* %pn, align 4
  %u_lt_n = icmp slt i32 %u0, %n3
  br i1 %u_lt_n, label %validate_v_ge_0, label %error

validate_v_ge_0:                                   ; preds = %validate_u_lt_n
  %v0 = load i32, i32* %v, align 4
  %v_ge_0 = icmp sge i32 %v0, 0
  br i1 %v_ge_0, label %validate_v_lt_n, label %error

validate_v_lt_n:                                   ; preds = %validate_v_ge_0
  %n4 = load i32, i32* %pn, align 4
  %v_lt_n = icmp slt i32 %v0, %n4
  br i1 %v_lt_n, label %add_edge_block, label %error

add_edge_block:                                    ; preds = %validate_v_lt_n
  %w0 = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %graph, i32 %u0, i32 %v0, i32 %w0, i32 1)
  %i1 = load i32, i32* %i, align 4
  %i_next = add nsw i32 %i1, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_header

after_edges:                                       ; preds = %loop_header
  %fmt1_ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.fmt_1d, i64 0, i64 0
  %sc3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1_ptr, i32* %psrc)
  %sc3_ok = icmp eq i32 %sc3, 1
  br i1 %sc3_ok, label %check_src_ge_0, label %error

check_src_ge_0:                                    ; preds = %after_edges
  %src0 = load i32, i32* %psrc, align 4
  %src_ge_0 = icmp sge i32 %src0, 0
  br i1 %src_ge_0, label %check_src_lt_n, label %error

check_src_lt_n:                                    ; preds = %check_src_ge_0
  %n5 = load i32, i32* %pn, align 4
  %src_lt_n = icmp slt i32 %src0, %n5
  br i1 %src_lt_n, label %success, label %error

success:                                           ; preds = %check_src_lt_n
  store i32 0, i32* %status, align 4
  br label %exit

error:                                             ; preds = %check_src_lt_n, %check_src_ge_0, %after_edges, %validate_v_lt_n, %validate_v_ge_0, %validate_u_lt_n, %validate_u, %read_edge, %check_m_ge_0, %check_n_le_100, %check_bounds1, %entry
  store i32 -1, i32* %status, align 4
  br label %exit

exit:                                              ; preds = %error, %success
  %retv = load i32, i32* %status, align 4
  ret i32 %retv
}