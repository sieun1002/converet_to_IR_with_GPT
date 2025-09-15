; ModuleID = 'dijkstra_modular.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

%struct._IO_FILE = type { i8 }
%struct.Graph = type opaque

@stderr = external global %struct._IO_FILE*
@.str = private unnamed_addr constant [13 x i8] c"input error\0A\00", align 1
@.str.dd = private constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private constant [3 x i8] c"%d\00", align 1
@.str.inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str.val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %ret = alloca i32, align 4
  %n = alloca i32, align 4
  %src = alloca i32, align 4
  %graph = alloca [40016 x i8], align 16
  %dist = alloca [164 x i32], align 16
  store i32 0, i32* %ret, align 4
  %graph.ptr = getelementptr inbounds [40016 x i8], [40016 x i8]* %graph, i64 0, i64 0
  %rg = call i32 bitcast (i32 (%struct.Graph*, i32*, i32*)* @read_graph to i32 (i8*, i32*, i32*)*)(i8* %graph.ptr, i32* %n, i32* %src)
  %ok = icmp eq i32 %rg, 0
  br i1 %ok, label %L_ok, label %L_err

L_err:                                            ; preds = %entry
  %stderr.val = load %struct._IO_FILE*, %struct._IO_FILE** @stderr, align 8
  %fmt = getelementptr inbounds [13 x i8], [13 x i8]* @.str, i64 0, i64 0
  %ignored = call i32 (%struct._IO_FILE*, i8*, ...) @fprintf(%struct._IO_FILE* %stderr.val, i8* %fmt)
  store i32 1, i32* %ret, align 4
  br label %L_end

L_ok:                                             ; preds = %entry
  %n.val = load i32, i32* %n, align 4
  %src.val = load i32, i32* %src, align 4
  %dist.ptr = getelementptr inbounds [164 x i32], [164 x i32]* %dist, i64 0, i64 0
  call void bitcast (void (i32*, i32, i32, i32*)* @dijkstra to void (i8*, i32, i32, i32*)*)(i8* %graph.ptr, i32 %n.val, i32 %src.val, i32* %dist.ptr)
  %n.val2 = load i32, i32* %n, align 4
  call void @print_distances(i32* %dist.ptr, i32 %n.val2)
  store i32 0, i32* %ret, align 4
  br label %L_end

L_end:                                            ; preds = %L_ok, %L_err
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}

declare i32 @fprintf(%struct._IO_FILE* nocapture, i8* nocapture, ...)

define void @init_graph([100 x i32]* %matrix, i32 %n) {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.inc ]
  %cmp.outer = icmp slt i32 %i, %n
  br i1 %cmp.outer, label %inner.preheader, label %exit

inner.preheader:                                  ; preds = %outer.cond
  br label %inner.cond

inner.cond:                                       ; preds = %inner.inc, %inner.preheader
  %j = phi i32 [ 0, %inner.preheader ], [ %j.next, %inner.inc ]
  %cmp.inner = icmp slt i32 %j, %n
  br i1 %cmp.inner, label %inner.body, label %outer.inc

inner.body:                                       ; preds = %inner.cond
  %i.ext = sext i32 %i to i64
  %j.ext = sext i32 %j to i64
  %eltptr = getelementptr inbounds [100 x i32], [100 x i32]* %matrix, i64 %i.ext, i64 %j.ext
  store i32 0, i32* %eltptr, align 4
  br label %inner.inc

inner.inc:                                        ; preds = %inner.body
  %j.next = add nsw i32 %j, 1
  br label %inner.cond

outer.inc:                                        ; preds = %inner.cond
  %i.next = add nsw i32 %i, 1
  br label %outer.cond

exit:                                             ; preds = %outer.cond
  ret void
}

define dso_local void @add_edge(i32* nocapture %base, i32 %i, i32 %j, i32 %val, i32 %flag) {
entry:
  %cmp_i_neg = icmp slt i32 %i, 0
  br i1 %cmp_i_neg, label %end, label %check_j

check_j:                                          ; preds = %entry
  %cmp_j_nonneg = icmp sge i32 %j, 0
  br i1 %cmp_j_nonneg, label %do_store, label %end

do_store:                                         ; preds = %check_j
  %i_sext = sext i32 %i to i64
  %j_sext = sext i32 %j to i64
  %i_mul_100 = mul nsw i64 %i_sext, 100
  %idx_lin = add nsw i64 %i_mul_100, %j_sext
  %ptr_ij = getelementptr inbounds i32, i32* %base, i64 %idx_lin
  store i32 %val, i32* %ptr_ij, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %end, label %do_store_sym

do_store_sym:                                     ; preds = %do_store
  %j_mul_100 = mul nsw i64 %j_sext, 100
  %idx_lin_sym = add nsw i64 %j_mul_100, %i_sext
  %ptr_ji = getelementptr inbounds i32, i32* %base, i64 %idx_lin_sym
  store i32 %val, i32* %ptr_ji, align 4
  br label %end

end:                                              ; preds = %do_store_sym, %do_store, %check_j, %entry
  ret void
}

define i32 @read_graph(%struct.Graph* %g, i32* %nptr, i32* %startptr) {
entry:
  %ret = alloca i32, align 4
  %m = alloca i32, align 4
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %fmt1ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1ptr, i32* %nptr, i32* %m)
  %cmp1 = icmp eq i32 %call1, 2
  br i1 %cmp1, label %check_nm, label %error

check_nm:                                         ; preds = %entry
  %nload = load i32, i32* %nptr, align 4
  %n_gt0 = icmp sgt i32 %nload, 0
  %n_le100 = icmp sle i32 %nload, 100
  %n_ok = and i1 %n_gt0, %n_le100
  %mload = load i32, i32* %m, align 4
  %m_ge0 = icmp sge i32 %mload, 0
  %init_ok = and i1 %n_ok, %m_ge0
  br i1 %init_ok, label %do_init, label %error

do_init:                                          ; preds = %check_nm
  call void bitcast (void ([100 x i32]*, i32)* @init_graph to void (%struct.Graph*, i32)*)(%struct.Graph* %g, i32 %nload)
  store i32 0, i32* %i, align 4
  br label %loop_cond

loop_cond:                                        ; preds = %do_add, %do_init
  %i_cur = load i32, i32* %i, align 4
  %m_cur = load i32, i32* %m, align 4
  %i_lt_m = icmp slt i32 %i_cur, %m_cur
  br i1 %i_lt_m, label %loop_body, label %after_edges

loop_body:                                        ; preds = %loop_cond
  %fmt3ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3ptr, i32* %u, i32* %v, i32* %w)
  %cmp3 = icmp eq i32 %call2, 3
  br i1 %cmp3, label %validate_u, label %error

validate_u:                                       ; preds = %loop_body
  %u_val = load i32, i32* %u, align 4
  %u_ge0 = icmp sge i32 %u_val, 0
  %n_for_u = load i32, i32* %nptr, align 4
  %u_lt_n = icmp slt i32 %u_val, %n_for_u
  %u_ok = and i1 %u_ge0, %u_lt_n
  br i1 %u_ok, label %validate_v, label %error

validate_v:                                       ; preds = %validate_u
  %v_val = load i32, i32* %v, align 4
  %v_ge0 = icmp sge i32 %v_val, 0
  %n_for_v = load i32, i32* %nptr, align 4
  %v_lt_n = icmp slt i32 %v_val, %n_for_v
  %v_ok = and i1 %v_ge0, %v_lt_n
  br i1 %v_ok, label %do_add, label %error

do_add:                                           ; preds = %validate_v
  %w_val = load i32, i32* %w, align 4
  call void bitcast (void (i32*, i32, i32, i32, i32)* @add_edge to void (%struct.Graph*, i32, i32, i32, i32)*)(%struct.Graph* %g, i32 %u_val, i32 %v_val, i32 %w_val, i32 1)
  %i_next_src = load i32, i32* %i, align 4
  %i_next = add nsw i32 %i_next_src, 1
  store i32 %i_next, i32* %i, align 4
  br label %loop_cond

after_edges:                                      ; preds = %loop_cond
  %fmt1dptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1dptr, i32* %startptr)
  %cmp_s = icmp eq i32 %call3, 1
  br i1 %cmp_s, label %validate_start, label %error

validate_start:                                   ; preds = %after_edges
  %s_val = load i32, i32* %startptr, align 4
  %s_ge0 = icmp sge i32 %s_val, 0
  %n_for_s = load i32, i32* %nptr, align 4
  %s_lt_n = icmp slt i32 %s_val, %n_for_s
  %s_ok = and i1 %s_ge0, %s_lt_n
  br i1 %s_ok, label %success, label %error

success:                                          ; preds = %validate_start
  store i32 0, i32* %ret, align 4
  br label %ret_block

error:                                            ; preds = %validate_start, %after_edges, %validate_v, %validate_u, %loop_body, %check_nm, %entry
  store i32 -1, i32* %ret, align 4
  br label %ret_block

ret_block:                                        ; preds = %error, %success
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}

declare i32 @__isoc99_scanf(i8*, ...)

define i32 @min_index(i32* nocapture readonly %a, i32* nocapture readonly %b, i32 %n) {
entry:
  br label %loop.header

loop.header:                                      ; preds = %cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %cont ]
  %minv = phi i32 [ 2147483647, %entry ], [ %minv.next, %cont ]
  %idx = phi i32 [ -1, %entry ], [ %idx.next, %cont ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %loop.body, label %exit

loop.body:                                        ; preds = %loop.header
  %b.ptr = getelementptr inbounds i32, i32* %b, i32 %i
  %b.val = load i32, i32* %b.ptr, align 4
  %b.isnz = icmp ne i32 %b.val, 0
  br i1 %b.isnz, label %noUpdate, label %maybe

maybe:                                            ; preds = %loop.body
  %a.ptr = getelementptr inbounds i32, i32* %a, i32 %i
  %a.val = load i32, i32* %a.ptr, align 4
  %isless = icmp slt i32 %a.val, %minv
  br i1 %isless, label %doUpdate, label %noUpdate

doUpdate:                                         ; preds = %maybe
  br label %cont

noUpdate:                                         ; preds = %maybe, %loop.body
  br label %cont

cont:                                             ; preds = %noUpdate, %doUpdate
  %minv.next = phi i32 [ %minv, %noUpdate ], [ %a.val, %doUpdate ]
  %idx.next = phi i32 [ %idx, %noUpdate ], [ %i, %doUpdate ]
  %i.next = add nsw i32 %i, 1
  br label %loop.header

exit:                                             ; preds = %loop.header
  ret i32 %idx
}

define void @dijkstra(i32* %adj, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  %memset.call = call i8* @memset(i8* %s.i8, i32 0, i64 400)
  br label %init.loop

init.loop:                                        ; preds = %init.latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.latch ]
  %init.cmp = icmp slt i32 %i, %n
  br i1 %init.cmp, label %init.body, label %init.end

init.body:                                        ; preds = %init.loop
  %i.ext = sext i32 %i to i64
  %dist.i.ptr = getelementptr inbounds i32, i32* %dist, i64 %i.ext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  br label %init.latch

init.latch:                                       ; preds = %init.body
  %i.next = add nsw i32 %i, 1
  br label %init.loop

init.end:                                         ; preds = %init.loop
  %src.ext = sext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds i32, i32* %dist, i64 %src.ext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer.loop

outer.loop:                                       ; preds = %outer.latch, %init.end
  %iter = phi i32 [ 0, %init.end ], [ %iter.next, %outer.latch ]
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %iter, %n.minus1
  br i1 %outer.cmp, label %outer.body, label %done

outer.body:                                       ; preds = %outer.loop
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %after.u

after.u:                                          ; preds = %outer.body
  %u.ext = sext i32 %u to i64
  %s.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %u.ext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner.loop

inner.loop:                                       ; preds = %inner.latch, %after.u
  %v = phi i32 [ 0, %after.u ], [ %v.next, %inner.latch ]
  %inner.cmp = icmp slt i32 %v, %n
  br i1 %inner.cmp, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner.loop
  %v.ext = sext i32 %v to i64
  %u.mul = mul nsw i32 %u, 100
  %u.mul.ext = sext i32 %u.mul to i64
  %idx = add nsw i64 %u.mul.ext, %v.ext
  %adj.ptr = getelementptr inbounds i32, i32* %adj, i64 %idx
  %adj.val = load i32, i32* %adj.ptr, align 4
  %adj.is.zero = icmp eq i32 %adj.val, 0
  br i1 %adj.is.zero, label %inner.latch, label %check.sv

check.sv:                                         ; preds = %inner.body
  %s.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 %v.ext
  %s.v = load i32, i32* %s.v.ptr, align 4
  %s.v.nonzero = icmp ne i32 %s.v, 0
  br i1 %s.v.nonzero, label %inner.latch, label %check.du

check.du:                                         ; preds = %check.sv
  %dist.u.ptr = getelementptr inbounds i32, i32* %dist, i64 %u.ext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %du.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %du.is.inf, label %inner.latch, label %compute.alt

compute.alt:                                      ; preds = %check.du
  %alt = add nsw i32 %dist.u, %adj.val
  %dist.v.ptr = getelementptr inbounds i32, i32* %dist, i64 %v.ext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %alt.lt = icmp slt i32 %alt, %dist.v
  br i1 %alt.lt, label %update, label %inner.latch

update:                                           ; preds = %compute.alt
  store i32 %alt, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %update, %compute.alt, %check.du, %check.sv, %inner.body
  %v.next = add nsw i32 %v, 1
  br label %inner.loop

outer.latch:                                      ; preds = %inner.loop
  %iter.next = add nsw i32 %iter, 1
  br label %outer.loop

done:                                             ; preds = %outer.body, %outer.loop
  ret void
}

declare i8* @memset(i8*, i32, i64)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %after_print, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %after_print ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idxext = sext i32 %i to i64
  %eltptr = getelementptr inbounds i32, i32* %dist, i64 %idxext
  %val = load i32, i32* %eltptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %fmt_inf_ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str.inf, i64 0, i64 0
  %call_inf = call i32 (i8*, ...) @printf(i8* %fmt_inf_ptr, i32 %i)
  br label %after_print

print_val:                                        ; preds = %body
  %fmt_val_ptr = getelementptr inbounds [15 x i8], [15 x i8]* @.str.val, i64 0, i64 0
  %call_val = call i32 (i8*, ...) @printf(i8* %fmt_val_ptr, i32 %i, i32 %val)
  br label %after_print

after_print:                                      ; preds = %print_val, %print_inf
  %i.next = add nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}

declare i32 @printf(i8*, ...)
