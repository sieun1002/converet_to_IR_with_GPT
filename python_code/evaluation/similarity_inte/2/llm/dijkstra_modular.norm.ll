; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/2/dijkstra_modular.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@stderr = external global i8*, align 8
@.str = private unnamed_addr constant [19 x i8] c"read_graph failed\0A\00", align 1
@.str1 = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str3 = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40000 x i8], align 16
  %dist = alloca [10104 x i32], align 16
  %graph_ptr0 = getelementptr inbounds [40000 x i8], [40000 x i8]* %graph, i64 0, i64 0
  %call_rg = call i32 @read_graph(i8* nonnull %graph_ptr0, i32* nonnull %n, i32* nonnull %src)
  %cmp = icmp eq i32 %call_rg, 0
  br i1 %cmp, label %loc_401724, label %loc_4016FF

loc_4016FF:                                       ; preds = %entry
  %stderrp = load i8*, i8** @stderr, align 8
  %0 = call i64 @fwrite(i8* getelementptr inbounds ([19 x i8], [19 x i8]* @.str, i64 0, i64 0), i64 18, i64 1, i8* %stderrp) #3
  br label %loc_401753

loc_401724:                                       ; preds = %entry
  %nval = load i32, i32* %n, align 4
  %srcval = load i32, i32* %src, align 4
  %dist_ptr = getelementptr inbounds [10104 x i32], [10104 x i32]* %dist, i64 0, i64 0
  %1 = bitcast [40000 x i8]* %graph to i32*
  call void @dijkstra(i32* nonnull %1, i32 %nval, i32 %srcval, i32* nonnull %dist_ptr)
  %nval2 = load i32, i32* %n, align 4
  call void @print_distances(i32* nonnull %dist_ptr, i32 %nval2)
  br label %loc_401753

loc_401753:                                       ; preds = %loc_401724, %loc_4016FF
  %var4.0 = phi i32 [ 0, %loc_401724 ], [ 1, %loc_4016FF ]
  ret i32 %var4.0
}

declare i32 @fprintf(i8*, i8*, ...)

define void @init_graph(i32* %base, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer.not = icmp slt i32 %i, %n
  br i1 %cmp.outer.not, label %inner.cond, label %exit

inner.cond:                                       ; preds = %outer.cond, %inner.body
  %j = phi i32 [ %j.next, %inner.body ], [ 0, %outer.cond ]
  %cmp.inner.not = icmp slt i32 %j, %n
  br i1 %cmp.inner.not, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = zext i32 %i to i64
  %row.off = mul nuw nsw i64 %i.ext, 100
  %j.ext = zext i32 %j to i64
  %elem.off = add nuw nsw i64 %row.off, %j.ext
  %ptr = getelementptr inbounds i32, i32* %base, i64 %elem.off
  store i32 0, i32* %ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nuw nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}

; Function Attrs: nounwind
define dso_local void @add_edge(i32* %base, i32 %i, i32 %j, i32 %val, i32 %flag) #0 {
entry:
  %cmp_i = icmp slt i32 %i, 0
  %cmp_j = icmp slt i32 %j, 0
  %or.cond = select i1 %cmp_i, i1 true, i1 %cmp_j
  br i1 %or.cond, label %ret, label %do_store

do_store:                                         ; preds = %entry
  %i64 = sext i32 %i to i64
  %row_off = mul nsw i64 %i64, 100
  %row_ptr_i81 = getelementptr inbounds i32, i32* %base, i64 %row_off
  %j64 = sext i32 %j to i64
  %elem_ptr = getelementptr inbounds i32, i32* %row_ptr_i81, i64 %j64
  store i32 %val, i32* %elem_ptr, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %ret, label %do_sym

do_sym:                                           ; preds = %do_store
  %row_off2 = mul nsw i64 %j64, 100
  %row_ptr2_i82 = getelementptr inbounds i32, i32* %base, i64 %row_off2
  %elem_ptr2 = getelementptr inbounds i32, i32* %row_ptr2_i82, i64 %i64
  store i32 %val, i32* %elem_ptr2, align 4
  br label %ret

ret:                                              ; preds = %do_sym, %do_store, %entry
  ret void
}

define i32 @read_graph(i8* %g, i32* %n_ptr, i32* %src_ptr) {
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
  %0 = bitcast i8* %g to i32*
  call void @init_graph(i32* %0, i32 %n.load1)
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
  call void @add_edge(i32* %0, i32 %u.load1, i32 %v.load1, i32 %w.load1, i32 1)
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

declare i32 @__isoc99_scanf(i8*, ...)

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %best = phi i32 [ 2147483647, %entry ], [ %best.next, %cont ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check, label %exit

check:                                            ; preds = %loop
  %i.sext = zext i32 %i to i64
  %b.ptr = getelementptr inbounds i32, i32* %b, i64 %i.sext
  %b.val = load i32, i32* %b.ptr, align 4
  %iszero = icmp eq i32 %b.val, 0
  br i1 %iszero, label %maybe_update, label %cont_no_update

maybe_update:                                     ; preds = %check
  %a.ptr = getelementptr inbounds i32, i32* %a, i64 %i.sext
  %a.val = load i32, i32* %a.ptr, align 4
  %lt2 = icmp slt i32 %a.val, %best
  br i1 %lt2, label %cont, label %cont_no_update

cont_no_update:                                   ; preds = %maybe_update, %check
  br label %cont

cont:                                             ; preds = %maybe_update, %cont_no_update
  %best.next = phi i32 [ %best, %cont_no_update ], [ %a.val, %maybe_update ]
  %minidx.next = phi i32 [ %minidx, %cont_no_update ], [ %i, %maybe_update ]
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minidx
}

define void @dijkstra(i32* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 0, i64 400, i1 false)
  br label %init_loop

init_loop:                                        ; preds = %init_body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init_body ]
  %cmp.i = icmp slt i32 %i, %n
  br i1 %cmp.i, label %init_body, label %after_init

init_body:                                        ; preds = %init_loop
  %i64 = zext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add nuw nsw i32 %i, 1
  br label %init_loop

after_init:                                       ; preds = %init_loop
  %src64 = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer_loop

outer_loop:                                       ; preds = %outer_latch, %after_init
  %count = phi i32 [ 0, %after_init ], [ %count.next, %outer_latch ]
  %n.minus1 = add nsw i32 %n, -1
  %cmp.count = icmp slt i32 %count, %n.minus1
  br i1 %cmp.count, label %outer_body, label %ret

outer_body:                                       ; preds = %outer_loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* nonnull %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %ret, label %got_u

got_u:                                            ; preds = %outer_body
  %u64 = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u64
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner_loop

inner_loop:                                       ; preds = %inner_latch, %got_u
  %v = phi i32 [ 0, %got_u ], [ %v.next, %inner_latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %inner_check_edge, label %outer_latch

inner_check_edge:                                 ; preds = %inner_loop
  %u.mul100 = mul nsw i64 %u64, 100
  %row.ptr = getelementptr inbounds i32, i32* %graph, i64 %u.mul100
  %v64 = zext i32 %v to i64
  %g.uv.ptr = getelementptr inbounds i32, i32* %row.ptr, i64 %v64
  %w = load i32, i32* %g.uv.ptr, align 4
  %w.iszero = icmp eq i32 %w, 0
  br i1 %w.iszero, label %inner_latch, label %inner_check_s

inner_check_s:                                    ; preds = %inner_check_edge
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v64
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.visited.not = icmp eq i32 %s.v, 0
  br i1 %s.v.visited.not, label %inner_check_du, label %inner_latch

inner_check_du:                                   ; preds = %inner_check_s
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.isinf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.isinf, label %inner_latch, label %inner_relax_cmp

inner_relax_cmp:                                  ; preds = %inner_check_du
  %alt = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt.dv = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt.dv, label %inner_store, label %inner_latch

inner_store:                                      ; preds = %inner_relax_cmp
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner_latch

inner_latch:                                      ; preds = %inner_store, %inner_relax_cmp, %inner_check_du, %inner_check_s, %inner_check_edge
  %v.next = add nuw nsw i32 %v, 1
  br label %inner_loop

outer_latch:                                      ; preds = %inner_loop
  %count.next = add nuw nsw i32 %count, 1
  br label %outer_loop

ret:                                              ; preds = %outer_body, %outer_loop
  ret void
}

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #1

define void @print_distances(i32* nocapture readonly %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp.not = icmp slt i32 %i, %n
  br i1 %cmp.not, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %elem.ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %elem.ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0), i32 %i)
  br label %inc

print_val:                                        ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str.val, i64 0, i64 0), i32 %i, i32 %val)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: nofree nounwind
declare noundef i64 @fwrite(i8* nocapture noundef, i64 noundef, i64 noundef, i8* nocapture noundef) #2

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nounwind willreturn writeonly }
attributes #2 = { nofree nounwind }
attributes #3 = { cold }
