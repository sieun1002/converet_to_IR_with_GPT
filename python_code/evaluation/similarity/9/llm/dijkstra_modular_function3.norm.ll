; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/9/dijkstra_modular_function3.ll"
target triple = "x86_64-pc-linux-gnu"

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(i8*, i32)

declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %graph, i32* %pn, i32* %psrc) local_unnamed_addr {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %call.scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0), i32* %pn, i32* nonnull %m)
  %cmp.scan1.ok = icmp eq i32 %call.scan1, 2
  br i1 %cmp.scan1.ok, label %after_scan1, label %return

after_scan1:                                      ; preds = %entry
  %n.load = load i32, i32* %pn, align 4
  %n.gt0 = icmp sgt i32 %n.load, 0
  %n.le100 = icmp slt i32 %n.load, 101
  %or.cond = and i1 %n.gt0, %n.le100
  %m.load = load i32, i32* %m, align 4
  %m.nonneg = icmp sgt i32 %m.load, -1
  %or.cond1 = select i1 %or.cond, i1 %m.nonneg, i1 false
  br i1 %or.cond1, label %init_and_loop, label %return

init_and_loop:                                    ; preds = %after_scan1
  call void @init_graph(i8* %graph, i32 %n.load)
  br label %loop

loop:                                             ; preds = %add_edge_block, %init_and_loop
  %i.0 = phi i32 [ 0, %init_and_loop ], [ %i.next, %add_edge_block ]
  %m.cur = load i32, i32* %m, align 4
  %i.ge.m.not = icmp slt i32 %i.0, %m.cur
  br i1 %i.ge.m.not, label %read_edge, label %after_edges

read_edge:                                        ; preds = %loop
  %call.scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %scan2.ok = icmp eq i32 %call.scan2, 3
  br i1 %scan2.ok, label %validate_uv, label %return

validate_uv:                                      ; preds = %read_edge
  %u.val = load i32, i32* %u, align 4
  %u.ge0 = icmp sgt i32 %u.val, -1
  br i1 %u.ge0, label %u_lt_n_check, label %return

u_lt_n_check:                                     ; preds = %validate_uv
  %n.for.u = load i32, i32* %pn, align 4
  %u.lt.n = icmp slt i32 %u.val, %n.for.u
  br i1 %u.lt.n, label %v_ge0_check, label %return

v_ge0_check:                                      ; preds = %u_lt_n_check
  %v.val = load i32, i32* %v, align 4
  %v.ge0 = icmp sgt i32 %v.val, -1
  br i1 %v.ge0, label %v_lt_n_check, label %return

v_lt_n_check:                                     ; preds = %v_ge0_check
  %v.lt.n = icmp slt i32 %v.val, %n.for.u
  br i1 %v.lt.n, label %add_edge_block, label %return

add_edge_block:                                   ; preds = %v_lt_n_check
  %w.val = load i32, i32* %w, align 4
  call void @add_edge(i8* %graph, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
  %i.next = add nuw nsw i32 %i.0, 1
  br label %loop

after_edges:                                      ; preds = %loop
  %call.scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* %psrc)
  %scan3.ok = icmp eq i32 %call.scan3, 1
  br i1 %scan3.ok, label %check_src_bounds, label %return

check_src_bounds:                                 ; preds = %after_edges
  %s.val = load i32, i32* %psrc, align 4
  %s.ge0 = icmp sgt i32 %s.val, -1
  br i1 %s.ge0, label %s_lt_n_check, label %return

s_lt_n_check:                                     ; preds = %check_src_bounds
  %n.for.s = load i32, i32* %pn, align 4
  %s.lt.n = icmp slt i32 %s.val, %n.for.s
  %spec.select = select i1 %s.lt.n, i32 0, i32 -1
  br label %return

return:                                           ; preds = %s_lt_n_check, %check_src_bounds, %after_edges, %validate_uv, %u_lt_n_check, %v_ge0_check, %v_lt_n_check, %read_edge, %after_scan1, %entry
  %ret.0 = phi i32 [ -1, %entry ], [ -1, %after_scan1 ], [ -1, %read_edge ], [ -1, %v_lt_n_check ], [ -1, %v_ge0_check ], [ -1, %u_lt_n_check ], [ -1, %validate_uv ], [ -1, %after_edges ], [ -1, %check_src_bounds ], [ %spec.select, %s_lt_n_check ]
  ret i32 %ret.0
}
