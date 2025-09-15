; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/dijkstra_modular.ll'
source_filename = "llvm-link"
target triple = "x86_64-pc-linux-gnu"

%struct.graph = type opaque

@stream = external global i8*, align 8
@byte_40202C = external global [0 x i8], align 1
@.str.dd = private unnamed_addr constant [6 x i8] c"%d %d\00", align 1
@.str.ddd = private unnamed_addr constant [9 x i8] c"%d %d %d\00", align 1
@.str.d = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [15 x i8] c"dist[%d] = %d\0A\00", align 1

define i32 @main() {
entry:
  %var_8 = alloca i32, align 4
  %var_C = alloca i32, align 4
  %buf_graph = alloca i8, align 16
  %buf_dist = alloca i8, align 16
  %0 = bitcast i8* %buf_graph to %struct.graph*
  %call_read = call i32 @read_graph(%struct.graph* nonnull %0, i32* nonnull %var_8, i32* nonnull %var_C)
  %cmp_zero = icmp eq i32 %call_read, 0
  br i1 %cmp_zero, label %loc_401724, label %loc_err

loc_err:                                          ; preds = %entry
  %stream_val = load i8*, i8** @stream, align 8
  %call_fprintf = call i32 (i8*, i8*, ...) @fprintf(i8* %stream_val, i8* getelementptr inbounds ([0 x i8], [0 x i8]* @byte_40202C, i64 0, i64 0))
  br label %loc_401753

loc_401724:                                       ; preds = %entry
  %n_val = load i32, i32* %var_8, align 4
  %m_val = load i32, i32* %var_C, align 4
  %1 = bitcast i8* %buf_graph to [100 x i32]*
  %2 = bitcast i8* %buf_dist to i32*
  call void @dijkstra([100 x i32]* nonnull %1, i32 %n_val, i32 %m_val, i32* nonnull %2)
  %n_val2 = load i32, i32* %var_8, align 4
  call void @print_distances(i32* nonnull %2, i32 %n_val2)
  br label %loc_401753

loc_401753:                                       ; preds = %loc_401724, %loc_err
  %var_4.0 = phi i32 [ 0, %loc_401724 ], [ 1, %loc_err ]
  ret i32 %var_4.0
}

declare i32 @fprintf(i8*, i8*, ...)

define dso_local void @init_graph(i32* noundef %p, i32 noundef %n) {
entry:
  %cmp.n.pos = icmp sgt i32 %n, 0
  br i1 %cmp.n.pos, label %outer.loop, label %done

outer.loop:                                       ; preds = %outer.cont, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.cont ]
  br label %inner.loop

inner.loop:                                       ; preds = %inner.body, %outer.loop
  %j = phi i32 [ 0, %outer.loop ], [ %j.next, %inner.body ]
  %j.cmp = icmp slt i32 %j, %n
  br i1 %j.cmp, label %inner.body, label %outer.cont

inner.body:                                       ; preds = %inner.loop
  %i64 = zext i32 %i to i64
  %mul = mul nuw nsw i64 %i64, 100
  %j64 = zext i32 %j to i64
  %index = add nuw nsw i64 %mul, %j64
  %elem.ptr = getelementptr inbounds i32, i32* %p, i64 %index
  store i32 0, i32* %elem.ptr, align 4
  %j.next = add nuw nsw i32 %j, 1
  br label %inner.loop

outer.cont:                                       ; preds = %inner.loop
  %i.next = add nuw nsw i32 %i, 1
  %i.cmp = icmp slt i32 %i.next, %n
  br i1 %i.cmp, label %outer.loop, label %done

done:                                             ; preds = %outer.cont, %entry
  ret void
}

define dso_local void @add_edge(i32* nocapture %base, i32 %row, i32 %col, i32 %val, i32 %sym) {
entry:
  %0 = or i32 %row, %col
  %1 = icmp sgt i32 %0, -1
  br i1 %1, label %do_store, label %ret

do_store:                                         ; preds = %entry
  %row64 = sext i32 %row to i64
  %col64 = sext i32 %col to i64
  %mul = mul nsw i64 %row64, 100
  %idx = add nsw i64 %mul, %col64
  %ptr1 = getelementptr inbounds i32, i32* %base, i64 %idx
  store i32 %val, i32* %ptr1, align 4
  %symnz.not = icmp eq i32 %sym, 0
  br i1 %symnz.not, label %ret, label %sym_store

sym_store:                                        ; preds = %do_store
  %mul2 = mul nsw i64 %col64, 100
  %idx2 = add nsw i64 %mul2, %row64
  %ptr2 = getelementptr inbounds i32, i32* %base, i64 %idx2
  store i32 %val, i32* %ptr2, align 4
  br label %ret

ret:                                              ; preds = %sym_store, %do_store, %entry
  ret void
}

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
  %2 = bitcast %struct.graph* %g to i32*
  call void @init_graph(i32* %2, i32 %n.load)
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
  call void @add_edge(i32* %2, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
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

declare i32 @__isoc99_scanf(i8*, ...)

define i32 @min_index(i32* %arr, i32* %flag, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %latch, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %latch ]
  %minval = phi i32 [ 2147483647, %entry ], [ %minval.next, %latch ]
  %minidx = phi i32 [ -1, %entry ], [ %minidx.next, %latch ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %check_flag, label %exit

check_flag:                                       ; preds = %loop
  %idx.ext = sext i32 %i to i64
  %flag.ptr = getelementptr inbounds i32, i32* %flag, i64 %idx.ext
  %flag.val = load i32, i32* %flag.ptr, align 4
  %iszero = icmp eq i32 %flag.val, 0
  br i1 %iszero, label %maybe_update, label %latch

maybe_update:                                     ; preds = %check_flag
  %arr.ptr = getelementptr inbounds i32, i32* %arr, i64 %idx.ext
  %arr.val = load i32, i32* %arr.ptr, align 4
  %lt = icmp slt i32 %arr.val, %minval
  %spec.select = select i1 %lt, i32 %arr.val, i32 %minval
  %spec.select1 = select i1 %lt, i32 %i, i32 %minidx
  br label %latch

latch:                                            ; preds = %maybe_update, %check_flag
  %minval.next = phi i32 [ %minval, %check_flag ], [ %spec.select, %maybe_update ]
  %minidx.next = phi i32 [ %minidx, %check_flag ], [ %spec.select1, %maybe_update ]
  %i.next = add i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret i32 %minidx
}

define void @dijkstra([100 x i32]* %graph, i32 %n, i32 %src, i32* %dist) {
entry:
  %s = alloca [100 x i32], align 16
  %s.i8 = bitcast [100 x i32]* %s to i8*
  call void @llvm.memset.p0i8.i64(i8* noundef nonnull align 16 dereferenceable(400) %s.i8, i8 0, i64 400, i1 false)
  br label %init

init:                                             ; preds = %init.body, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %init.body ]
  %cmp.init = icmp slt i32 %i, %n
  br i1 %cmp.init, label %init.body, label %after.init

init.body:                                        ; preds = %init
  %i.sext = sext i32 %i to i64
  %dist.i.ptr = getelementptr i32, i32* %dist, i64 %i.sext
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %i.next = add i32 %i, 1
  br label %init

after.init:                                       ; preds = %init
  %src.sext = sext i32 %src to i64
  %dist.src.ptr = getelementptr i32, i32* %dist, i64 %src.sext
  store i32 0, i32* %dist.src.ptr, align 4
  br label %outer

outer:                                            ; preds = %outer.latch, %after.init
  %j = phi i32 [ 0, %after.init ], [ %j.next, %outer.latch ]
  %n.minus1 = add i32 %n, -1
  %cmp.outer = icmp slt i32 %j, %n.minus1
  br i1 %cmp.outer, label %outer.body, label %done

outer.body:                                       ; preds = %outer
  %s.base = getelementptr inbounds [100 x i32], [100 x i32]* %s, i64 0, i64 0
  %u = call i32 @min_index(i32* %dist, i32* nonnull %s.base, i32 %n)
  %u.is.neg1 = icmp eq i32 %u, -1
  br i1 %u.is.neg1, label %done, label %have.u

have.u:                                           ; preds = %outer.body
  %u.sext = sext i32 %u to i64
  %s.u.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %u.sext
  store i32 1, i32* %s.u.ptr, align 4
  br label %inner

inner:                                            ; preds = %inner.latch, %have.u
  %v = phi i32 [ 0, %have.u ], [ %v.next, %inner.latch ]
  %cmp.v = icmp slt i32 %v, %n
  br i1 %cmp.v, label %inner.body, label %outer.latch

inner.body:                                       ; preds = %inner
  %v.sext = sext i32 %v to i64
  %cell.ptr = getelementptr [100 x i32], [100 x i32]* %graph, i64 %u.sext, i64 %v.sext
  %w = load i32, i32* %cell.ptr, align 4
  %edge.nz = icmp ne i32 %w, 0
  %s.v.ptr = getelementptr [100 x i32], [100 x i32]* %s, i64 0, i64 %v.sext
  %s.v.val = load i32, i32* %s.v.ptr, align 4
  %s.v.zero = icmp eq i32 %s.v.val, 0
  %dist.u.ptr = getelementptr i32, i32* %dist, i64 %u.sext
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %dist.u.notinf = icmp ne i32 %dist.u, 2147483647
  %c1 = and i1 %edge.nz, %s.v.zero
  %guard = and i1 %c1, %dist.u.notinf
  br i1 %guard, label %relax, label %inner.latch

relax:                                            ; preds = %inner.body
  %sum = add nsw i32 %dist.u, %w
  %dist.v.ptr = getelementptr i32, i32* %dist, i64 %v.sext
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %lt.cmp = icmp slt i32 %sum, %dist.v
  br i1 %lt.cmp, label %update, label %inner.latch

update:                                           ; preds = %relax
  store i32 %sum, i32* %dist.v.ptr, align 4
  br label %inner.latch

inner.latch:                                      ; preds = %update, %relax, %inner.body
  %v.next = add i32 %v, 1
  br label %inner

outer.latch:                                      ; preds = %inner
  %j.next = add i32 %j, 1
  br label %outer

done:                                             ; preds = %outer.body, %outer
  ret void
}

declare i8* @memset(i8*, i32, i64)

define void @print_distances(i32* %dist, i32 %n) {
entry:
  br label %loop

loop:                                             ; preds = %inc, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %inc ]
  %cmp = icmp slt i32 %i, %n
  br i1 %cmp, label %body, label %exit

body:                                             ; preds = %loop
  %idx.ext = zext i32 %i to i64
  %ptr = getelementptr inbounds i32, i32* %dist, i64 %idx.ext
  %val = load i32, i32* %ptr, align 4
  %isinf = icmp eq i32 %val, 2147483647
  br i1 %isinf, label %print_inf, label %print_val

print_inf:                                        ; preds = %body
  %call1 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0), i32 %i)
  br label %inc

print_val:                                        ; preds = %body
  %call2 = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([15 x i8], [15 x i8]* @.str_val, i64 0, i64 0), i32 %i, i32 %val)
  br label %inc

inc:                                              ; preds = %print_val, %print_inf
  %i.next = add nuw nsw i32 %i, 1
  br label %loop

exit:                                             ; preds = %loop
  ret void
}

declare i32 @printf(i8*, ...)

; Function Attrs: argmemonly nofree nounwind willreturn writeonly
declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg) #0

attributes #0 = { argmemonly nofree nounwind willreturn writeonly }
