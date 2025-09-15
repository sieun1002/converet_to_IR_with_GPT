; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function3.ll'
source_filename = "/home/nata20034/workspace/convert_to_IR_with_LLM/llm_to_IR/gpt_api_error_analysis/7/dijkstra_modular_function3.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1

declare i32 @__isoc99_scanf(i8*, ...)

declare void @init_graph(i8*, i32)

declare void @add_edge(i8*, i32, i32, i32, i32)

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %src_ptr) local_unnamed_addr {
entry:
  %m.addr = alloca i32, align 4
  %u.addr = alloca i32, align 4
  %v.addr = alloca i32, align 4
  %w.addr = alloca i32, align 4
  %scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 3), i32* %n_ptr, i32* nonnull %m.addr)
  %cmp.scan1 = icmp eq i32 %scan1, 2
  br i1 %cmp.scan1, label %check_nm, label %retblock

check_nm:                                         ; preds = %entry
  %n.load1 = load i32, i32* %n_ptr, align 4
  %cmp.n.gt0 = icmp sgt i32 %n.load1, 0
  br i1 %cmp.n.gt0, label %check_n_le_100, label %retblock

check_n_le_100:                                   ; preds = %check_nm
  %cmp.n.le100 = icmp slt i32 %n.load1, 101
  %m.load1 = load i32, i32* %m.addr, align 4
  %cmp.m.ge0 = icmp sgt i32 %m.load1, -1
  %or.cond = select i1 %cmp.n.le100, i1 %cmp.m.ge0, i1 false
  br i1 %or.cond, label %init_graph_block, label %retblock

init_graph_block:                                 ; preds = %check_n_le_100
  call void @init_graph(i8* %g, i32 %n.load1)
  br label %loop.header

loop.header:                                      ; preds = %add_edge_block, %init_graph_block
  %i.addr.0 = phi i32 [ 0, %init_graph_block ], [ %i.next, %add_edge_block ]
  %m.load2 = load i32, i32* %m.addr, align 4
  %cmp.i.m = icmp slt i32 %i.addr.0, %m.load2
  br i1 %cmp.i.m, label %read_edge, label %post_loop

read_edge:                                        ; preds = %loop.header
  %scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @.str3, i64 0, i64 0), i32* nonnull %u.addr, i32* nonnull %v.addr, i32* nonnull %w.addr)
  %cmp.scan3 = icmp eq i32 %scan3, 3
  br i1 %cmp.scan3, label %check_u_ge0, label %retblock

check_u_ge0:                                      ; preds = %read_edge
  %u.load1 = load i32, i32* %u.addr, align 4
  %cmp.u.ge0 = icmp sgt i32 %u.load1, -1
  br i1 %cmp.u.ge0, label %check_u_lt_n, label %retblock

check_u_lt_n:                                     ; preds = %check_u_ge0
  %n.load4 = load i32, i32* %n_ptr, align 4
  %cmp.u.ltn = icmp slt i32 %u.load1, %n.load4
  br i1 %cmp.u.ltn, label %check_v_ge0, label %retblock

check_v_ge0:                                      ; preds = %check_u_lt_n
  %v.load1 = load i32, i32* %v.addr, align 4
  %cmp.v.ge0 = icmp sgt i32 %v.load1, -1
  br i1 %cmp.v.ge0, label %check_v_lt_n, label %retblock

check_v_lt_n:                                     ; preds = %check_v_ge0
  %cmp.v.ltn = icmp slt i32 %v.load1, %n.load4
  br i1 %cmp.v.ltn, label %add_edge_block, label %retblock

add_edge_block:                                   ; preds = %check_v_lt_n
  %w.load1 = load i32, i32* %w.addr, align 4
  call void @add_edge(i8* %g, i32 %u.load1, i32 %v.load1, i32 %w.load1, i32 1)
  %i.next = add nuw nsw i32 %i.addr.0, 1
  br label %loop.header

post_loop:                                        ; preds = %loop.header
  %scan.src = call i32 (i8*, ...) @__isoc99_scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @.str1, i64 0, i64 0), i32* %src_ptr)
  %cmp.scan.src = icmp eq i32 %scan.src, 1
  br i1 %cmp.scan.src, label %check_src_ge0, label %retblock

check_src_ge0:                                    ; preds = %post_loop
  %src.load1 = load i32, i32* %src_ptr, align 4
  %cmp.src.ge0 = icmp sgt i32 %src.load1, -1
  br i1 %cmp.src.ge0, label %check_src_lt_n, label %retblock

check_src_lt_n:                                   ; preds = %check_src_ge0
  %n.load6 = load i32, i32* %n_ptr, align 4
  %cmp.src.ltn = icmp slt i32 %src.load1, %n.load6
  %. = select i1 %cmp.src.ltn, i32 0, i32 -1
  br label %retblock

retblock:                                         ; preds = %check_src_lt_n, %check_src_ge0, %post_loop, %check_v_lt_n, %check_v_ge0, %check_u_lt_n, %check_u_ge0, %read_edge, %check_n_le_100, %check_nm, %entry
  %ret.addr.0 = phi i32 [ -1, %entry ], [ -1, %check_nm ], [ -1, %check_n_le_100 ], [ -1, %read_edge ], [ -1, %check_u_ge0 ], [ -1, %check_u_lt_n ], [ -1, %check_v_ge0 ], [ -1, %check_v_lt_n ], [ -1, %post_loop ], [ -1, %check_src_ge0 ], [ %., %check_src_lt_n ]
  ret i32 %ret.addr.0
}
