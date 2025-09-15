; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/1/dijkstra_modular_function3.ll"
target triple = "x86_64-unknown-linux-gnu"

%struct.Graph = type opaque

@.str.dd = private constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(%struct.Graph*, i32)

declare void @add_edge(%struct.Graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.Graph* %g, i32* %nptr, i32* %startptr) {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0), i32* %nptr, i32* nonnull %m)
  %cmp1 = icmp eq i32 %call1, 2
  br i1 %cmp1, label %check_nm, label %error

check_nm:                                         ; preds = %entry
  %nload = load i32, i32* %nptr, align 4
  %0 = add i32 %nload, -1
  %1 = icmp ult i32 %0, 100
  %mload = load i32, i32* %m, align 4
  %m_ge0 = icmp sgt i32 %mload, -1
  %init_ok = and i1 %1, %m_ge0
  br i1 %init_ok, label %do_init, label %error

do_init:                                          ; preds = %check_nm
  call void @init_graph(%struct.Graph* %g, i32 %nload)
  br label %loop_cond

loop_cond:                                        ; preds = %do_add, %do_init
  %i.0 = phi i32 [ 0, %do_init ], [ %i_next, %do_add ]
  %m_cur = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i.0, %m_cur
  br i1 %i_lt_m, label %loop_body, label %after_edges

loop_body:                                        ; preds = %loop_cond
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %cmp3 = icmp eq i32 %call2, 3
  br i1 %cmp3, label %validate_u, label %error

validate_u:                                       ; preds = %loop_body
  %u_val = load i32, i32* %u, align 4
  %u_ge0 = icmp sgt i32 %u_val, -1
  %n_for_u = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n_for_u
  %u_ok = and i1 %u_ge0, %u_lt_n
  br i1 %u_ok, label %validate_v, label %error

validate_v:                                       ; preds = %validate_u
  %v_val = load i32, i32* %v, align 4
  %v_ge0 = icmp sgt i32 %v_val, -1
  %v_lt_n = icmp slt i32 %v_val, %n_for_u
  %v_ok = and i1 %v_ge0, %v_lt_n
  br i1 %v_ok, label %do_add, label %error

do_add:                                           ; preds = %validate_v
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(%struct.Graph* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next = add nuw nsw i32 %i.0, 1
  br label %loop_cond

after_edges:                                      ; preds = %loop_cond
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* %startptr)
  %cmp_s = icmp eq i32 %call3, 1
  br i1 %cmp_s, label %validate_start, label %error

validate_start:                                   ; preds = %after_edges
  %s_val = load i32, i32* %startptr, align 4
  %s_ge0 = icmp sgt i32 %s_val, -1
  %n_for_s = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %s_val, %n_for_s
  %s_ok = and i1 %s_ge0, %s_lt_n
  br i1 %s_ok, label %ret_block, label %error

error:                                            ; preds = %validate_start, %after_edges, %validate_v, %validate_u, %loop_body, %check_nm, %entry
  br label %ret_block

ret_block:                                        ; preds = %validate_start, %error
  %ret.0 = phi i32 [ -1, %error ], [ 0, %validate_start ]
  ret i32 %ret.0
}
