; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/5/dijkstra_modular_function3.ll"
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str_triple = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str_d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(%struct.graph*, i32)

declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 3), i32* %n_ptr, i32* nonnull %m)
  %cmp_sc1 = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_sc1, label %check_nm, label %fail

check_nm:                                         ; preds = %entry
  %n_val0 = load i32, i32* %n_ptr, align 4
  %cmp_n_gt0 = icmp sgt i32 %n_val0, 0
  br i1 %cmp_n_gt0, label %check_n_le, label %fail

check_n_le:                                       ; preds = %check_nm
  %cmp_n_le100 = icmp slt i32 %n_val0, 101
  %m_val0 = load i32, i32* %m, align 4
  %cmp_m_ge0 = icmp sgt i32 %m_val0, -1
  %or.cond = select i1 %cmp_n_le100, i1 %cmp_m_ge0, i1 false
  br i1 %or.cond, label %init_g, label %fail

init_g:                                           ; preds = %check_n_le
  call void @init_graph(%struct.graph* %g, i32 %n_val0)
  br label %loop_hdr

loop_hdr:                                         ; preds = %add_edge_call, %init_g
  %i.0 = phi i32 [ 0, %init_g ], [ %i_inc, %add_edge_call ]
  %m_val1 = load i32, i32* %m, align 4
  %cmp_i_lt_m = icmp slt i32 %i.0, %m_val1
  br i1 %cmp_i_lt_m, label %loop_body, label %after_edges

loop_body:                                        ; preds = %loop_hdr
  %call_scanf_edge = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str_triple, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %cmp_sc3 = icmp eq i32 %call_scanf_edge, 3
  %u_val0 = load i32, i32* %u, align 4
  %cmp_u_ge0 = icmp sgt i32 %u_val0, -1
  %or.cond1 = select i1 %cmp_sc3, i1 %cmp_u_ge0, i1 false
  br i1 %or.cond1, label %check_u_lt_n, label %fail

check_u_lt_n:                                     ; preds = %loop_body
  %n_val3 = load i32, i32* %n_ptr, align 4
  %cmp_u_lt_n = icmp slt i32 %u_val0, %n_val3
  %v_val0 = load i32, i32* %v, align 4
  %cmp_v_ge0 = icmp sgt i32 %v_val0, -1
  %or.cond2 = select i1 %cmp_u_lt_n, i1 %cmp_v_ge0, i1 false
  br i1 %or.cond2, label %check_v_lt_n, label %fail

check_v_lt_n:                                     ; preds = %check_u_lt_n
  %cmp_v_lt_n = icmp slt i32 %v_val0, %n_val3
  br i1 %cmp_v_lt_n, label %add_edge_call, label %fail

add_edge_call:                                    ; preds = %check_v_lt_n
  %w_val0 = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u_val0, i32 %v_val0, i32 %w_val0, i32 1)
  %i_inc = add nuw nsw i32 %i.0, 1
  br label %loop_hdr

after_edges:                                      ; preds = %loop_hdr
  %call_scanf_start = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str_d, i64 0, i64 0), i32* %start_ptr)
  %cmp_sc1b = icmp eq i32 %call_scanf_start, 1
  br i1 %cmp_sc1b, label %check_start_ge0, label %fail

check_start_ge0:                                  ; preds = %after_edges
  %start_val0 = load i32, i32* %start_ptr, align 4
  %cmp_s_ge0 = icmp sgt i32 %start_val0, -1
  br i1 %cmp_s_ge0, label %check_start_lt_n, label %fail

check_start_lt_n:                                 ; preds = %check_start_ge0
  %n_val5 = load i32, i32* %n_ptr, align 4
  %cmp_s_lt_n = icmp slt i32 %start_val0, %n_val5
  br i1 %cmp_s_lt_n, label %exit, label %fail

fail:                                             ; preds = %check_start_lt_n, %check_start_ge0, %after_edges, %check_v_lt_n, %check_u_lt_n, %loop_body, %check_n_le, %check_nm, %entry
  br label %exit

exit:                                             ; preds = %check_start_lt_n, %fail
  %ret.0 = phi i32 [ -1, %fail ], [ 0, %check_start_lt_n ]
  ret i32 %ret.0
}
