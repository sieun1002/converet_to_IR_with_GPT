; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/6/dijkstra_modular_function3.ll"
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.two = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.three = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.one = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(%struct.graph*, i32)

declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %src_ptr) {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  store i32 0, i32* %m, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull getelementptr inbounds ([6 x i8], [6 x i8]* @.str.two, i64 0, i64 0), i32* %n_ptr, i32* nonnull %m)
  %cmp_sc1 = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_sc1, label %after_first_scanf, label %return

after_first_scanf:                                ; preds = %entry
  %n_val1 = load i32, i32* %n_ptr, align 4
  %cmp_n_pos = icmp sgt i32 %n_val1, 0
  br i1 %cmp_n_pos, label %check_n_upper, label %return

check_n_upper:                                    ; preds = %after_first_scanf
  %cmp_n_le = icmp slt i32 %n_val1, 101
  %m_val0 = load i32, i32* %m, align 4
  %cmp_m_ge0 = icmp sgt i32 %m_val0, -1
  %or.cond = select i1 %cmp_n_le, i1 %cmp_m_ge0, i1 false
  br i1 %or.cond, label %init_and_loop, label %return

init_and_loop:                                    ; preds = %check_n_upper
  call void @init_graph(%struct.graph* %g, i32 %n_val1)
  br label %loop_cond

loop_cond:                                        ; preds = %add_edge_block, %init_and_loop
  %i.0 = phi i32 [ 0, %init_and_loop ], [ %i_inc, %add_edge_block ]
  %m_val1 = load i32, i32* %m, align 4
  %cmp_i_m.not = icmp slt i32 %i.0, %m_val1
  br i1 %cmp_i_m.not, label %read_edge, label %after_edges

read_edge:                                        ; preds = %loop_cond
  %call_scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull getelementptr inbounds ([9 x i8], [9 x i8]* @.str.three, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %cmp_sc2 = icmp eq i32 %call_scanf2, 3
  %u_val0 = load i32, i32* %u, align 4
  %cmp_u_ge0 = icmp sgt i32 %u_val0, -1
  %or.cond1 = select i1 %cmp_sc2, i1 %cmp_u_ge0, i1 false
  br i1 %or.cond1, label %validate_u_upper, label %return

validate_u_upper:                                 ; preds = %read_edge
  %n_val4 = load i32, i32* %n_ptr, align 4
  %cmp_u_lt_n = icmp slt i32 %u_val0, %n_val4
  %v_val0 = load i32, i32* %v, align 4
  %cmp_v_ge0 = icmp sgt i32 %v_val0, -1
  %or.cond2 = select i1 %cmp_u_lt_n, i1 %cmp_v_ge0, i1 false
  br i1 %or.cond2, label %validate_v_upper, label %return

validate_v_upper:                                 ; preds = %validate_u_upper
  %cmp_v_lt_n = icmp slt i32 %v_val0, %n_val4
  br i1 %cmp_v_lt_n, label %add_edge_block, label %return

add_edge_block:                                   ; preds = %validate_v_upper
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u_val0, i32 %v_val0, i32 %w_val, i32 1)
  %i_inc = add nuw nsw i32 %i.0, 1
  br label %loop_cond

after_edges:                                      ; preds = %loop_cond
  %call_scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* nonnull getelementptr inbounds ([3 x i8], [3 x i8]* @.str.one, i64 0, i64 0), i32* %src_ptr)
  %cmp_sc3 = icmp eq i32 %call_scanf3, 1
  br i1 %cmp_sc3, label %check_src_range, label %return

check_src_range:                                  ; preds = %after_edges
  %src_val0 = load i32, i32* %src_ptr, align 4
  %cmp_src_ge0 = icmp sgt i32 %src_val0, -1
  br i1 %cmp_src_ge0, label %check_src_upper, label %return

check_src_upper:                                  ; preds = %check_src_range
  %n_val6 = load i32, i32* %n_ptr, align 4
  %cmp_src_lt_n = icmp slt i32 %src_val0, %n_val6
  %spec.select = select i1 %cmp_src_lt_n, i32 0, i32 -1
  br label %return

return:                                           ; preds = %check_src_upper, %check_src_range, %after_edges, %validate_v_upper, %validate_u_upper, %read_edge, %after_first_scanf, %check_n_upper, %entry
  %ret.0 = phi i32 [ -1, %entry ], [ -1, %check_n_upper ], [ -1, %after_first_scanf ], [ -1, %read_edge ], [ -1, %validate_u_upper ], [ -1, %validate_v_upper ], [ -1, %after_edges ], [ -1, %check_src_range ], [ %spec.select, %check_src_upper ]
  ret i32 %ret.0
}
