; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/4/dijkstra_modular_function3.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(i8*, i32)

declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %start_ptr) {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %call_scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0), i32* %n_ptr, i32* nonnull %m)
  %cmp_scanf1_ok = icmp eq i32 %call_scanf1, 2
  br i1 %cmp_scanf1_ok, label %check_bounds1, label %common.ret

check_bounds1:                                    ; preds = %entry
  %n_val_ldr = load i32, i32* %n_ptr, align 4
  %0 = add i32 %n_val_ldr, -1
  %1 = icmp ult i32 %0, 100
  %m_ldr = load i32, i32* %m, align 4
  %m_nonneg = icmp sgt i32 %m_ldr, -1
  %bounds1_ok = and i1 %1, %m_nonneg
  br i1 %bounds1_ok, label %init, label %common.ret

init:                                             ; preds = %check_bounds1
  call void @init_graph(i8* %g, i32 %n_val_ldr)
  br label %loop_hdr

loop_hdr:                                         ; preds = %add_call, %init
  %i.0 = phi i32 [ 0, %init ], [ %i_next, %add_call ]
  %m_cur = load i32, i32* %m, align 4
  %i_ge_m.not = icmp slt i32 %i.0, %m_cur
  br i1 %i_ge_m.not, label %loop_body, label %after_loop

loop_body:                                        ; preds = %loop_hdr
  %call_scanf_edge = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %scanf_edge_ok = icmp eq i32 %call_scanf_edge, 3
  br i1 %scanf_edge_ok, label %validate_uv, label %common.ret

validate_uv:                                      ; preds = %loop_body
  %u_val = load i32, i32* %u, align 4
  %u_nonneg = icmp sgt i32 %u_val, -1
  %n_val_for_u = load i32, i32* %n_ptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n_val_for_u
  %u_ok = and i1 %u_nonneg, %u_lt_n
  %v_val = load i32, i32* %v, align 4
  %v_nonneg = icmp sgt i32 %v_val, -1
  %v_lt_n = icmp slt i32 %v_val, %n_val_for_u
  %v_ok = and i1 %v_nonneg, %v_lt_n
  %uv_ok = and i1 %u_ok, %v_ok
  br i1 %uv_ok, label %add_call, label %common.ret

add_call:                                         ; preds = %validate_uv
  %w_val = load i32, i32* %w, align 4
  call void @add_edge(i8* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next = add nuw nsw i32 %i.0, 1
  br label %loop_hdr

after_loop:                                       ; preds = %loop_hdr
  %call_scanf_last = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* %start_ptr)
  %scanf_last_ok = icmp eq i32 %call_scanf_last, 1
  br i1 %scanf_last_ok, label %check_start, label %common.ret

check_start:                                      ; preds = %after_loop
  %start_val = load i32, i32* %start_ptr, align 4
  %start_nonneg = icmp sgt i32 %start_val, -1
  %n_val_final = load i32, i32* %n_ptr, align 4
  %start_lt_n = icmp slt i32 %start_val, %n_val_final
  %start_ok = and i1 %start_nonneg, %start_lt_n
  %spec.select = select i1 %start_ok, i32 0, i32 -1
  br label %common.ret

common.ret:                                       ; preds = %check_start, %entry, %check_bounds1, %loop_body, %validate_uv, %after_loop
  %common.ret.op = phi i32 [ -1, %after_loop ], [ -1, %validate_uv ], [ -1, %loop_body ], [ -1, %check_bounds1 ], [ -1, %entry ], [ %spec.select, %check_start ]
  ret i32 %common.ret.op
}
