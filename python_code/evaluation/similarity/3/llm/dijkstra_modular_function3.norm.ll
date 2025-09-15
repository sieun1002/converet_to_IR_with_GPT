; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/3/dijkstra_modular_function3.ll"
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(%struct.graph*, i32)

declare void @add_edge(%struct.graph*, i32, i32, i32, i32)

define i32 @read_graph(%struct.graph* %g, i32* %n_ptr, i32* %src_ptr) {
entry:
  %m = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0), i32* %n_ptr, i32* nonnull %m)
  %cmp.scanf1 = icmp eq i32 %scanf1, 2
  br i1 %cmp.scanf1, label %check_nm, label %err

check_nm:                                         ; preds = %entry
  %n.load = load i32, i32* %n_ptr, align 4
  %m.load = load i32, i32* %m, align 4
  %0 = add i32 %n.load, -1
  %1 = icmp ult i32 %0, 100
  %m.ge0 = icmp sgt i32 %m.load, -1
  %all.ok = and i1 %1, %m.ge0
  br i1 %all.ok, label %init_g, label %err

init_g:                                           ; preds = %check_nm
  call void @init_graph(%struct.graph* %g, i32 %n.load)
  br label %loop

loop:                                             ; preds = %do_add, %init_g
  %i.0 = phi i32 [ 0, %init_g ], [ %i.next, %do_add ]
  %m.cur = load i32, i32* %m, align 4
  %i.ge.m.not = icmp slt i32 %i.0, %m.cur
  br i1 %i.ge.m.not, label %read_edge, label %after_edges

read_edge:                                        ; preds = %loop
  %scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0), i32* nonnull %u, i32* nonnull %v, i32* nonnull %w)
  %cmp.scanf2 = icmp eq i32 %scanf2, 3
  br i1 %cmp.scanf2, label %validate_edge, label %err

validate_edge:                                    ; preds = %read_edge
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %n.reload1 = load i32, i32* %n_ptr, align 4
  %u.ge0 = icmp sgt i32 %u.val, -1
  %u.lt.n = icmp slt i32 %u.val, %n.reload1
  %u.ok = and i1 %u.ge0, %u.lt.n
  %v.ge0 = icmp sgt i32 %v.val, -1
  %v.lt.n = icmp slt i32 %v.val, %n.reload1
  %v.ok = and i1 %v.ge0, %v.lt.n
  %uv.ok = and i1 %u.ok, %v.ok
  br i1 %uv.ok, label %do_add, label %err

do_add:                                           ; preds = %validate_edge
  %w.val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
  %i.next = add nuw nsw i32 %i.0, 1
  br label %loop

after_edges:                                      ; preds = %loop
  %scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str.d, i64 0, i64 0), i32* %src_ptr)
  %cmp.scanf3 = icmp eq i32 %scanf3, 1
  br i1 %cmp.scanf3, label %validate_src, label %err

validate_src:                                     ; preds = %after_edges
  %src.val = load i32, i32* %src_ptr, align 4
  %n.reload2 = load i32, i32* %n_ptr, align 4
  %src.ge0 = icmp sgt i32 %src.val, -1
  %src.lt.n = icmp slt i32 %src.val, %n.reload2
  %src.ok = and i1 %src.ge0, %src.lt.n
  br i1 %src.ok, label %exit, label %err

err:                                              ; preds = %validate_src, %after_edges, %validate_edge, %read_edge, %check_nm, %entry
  br label %exit

exit:                                             ; preds = %validate_src, %err
  %ret.0 = phi i32 [ -1, %err ], [ 0, %validate_src ]
  ret i32 %ret.0
}
