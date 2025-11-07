; ModuleID = 'read_graph_module'
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
  %i = alloca i32, align 4
  %ret = alloca i32, align 4
  %fmt1.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %scanf1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %n_ptr, i32* %m)
  %cmp.scanf1 = icmp eq i32 %scanf1, 2
  br i1 %cmp.scanf1, label %check_nm, label %err

check_nm:                                         ; preds = %entry
  %n.load = load i32, i32* %n_ptr, align 4
  %m.load = load i32, i32* %m, align 4
  %n.gt0 = icmp sgt i32 %n.load, 0
  %n.le100 = icmp sle i32 %n.load, 100
  %n.ok = and i1 %n.gt0, %n.le100
  %m.ge0 = icmp sge i32 %m.load, 0
  %all.ok = and i1 %n.ok, %m.ge0
  br i1 %all.ok, label %init_g, label %err

init_g:                                           ; preds = %check_nm
  call void @init_graph(%struct.graph* %g, i32 %n.load)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %do_add, %init_g
  %i.cur = load i32, i32* %i, align 4
  %m.cur = load i32, i32* %m, align 4
  %i.ge.m = icmp sge i32 %i.cur, %m.cur
  br i1 %i.ge.m, label %after_edges, label %read_edge

read_edge:                                        ; preds = %loop
  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %scanf2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %u, i32* %v, i32* %w)
  %cmp.scanf2 = icmp eq i32 %scanf2, 3
  br i1 %cmp.scanf2, label %validate_edge, label %err

validate_edge:                                    ; preds = %read_edge
  %u.val = load i32, i32* %u, align 4
  %v.val = load i32, i32* %v, align 4
  %n.reload1 = load i32, i32* %n_ptr, align 4
  %u.ge0 = icmp sge i32 %u.val, 0
  %u.lt.n = icmp slt i32 %u.val, %n.reload1
  %u.ok = and i1 %u.ge0, %u.lt.n
  %v.ge0 = icmp sge i32 %v.val, 0
  %v.lt.n = icmp slt i32 %v.val, %n.reload1
  %v.ok = and i1 %v.ge0, %v.lt.n
  %uv.ok = and i1 %u.ok, %v.ok
  br i1 %uv.ok, label %do_add, label %err

do_add:                                           ; preds = %validate_edge
  %w.val = load i32, i32* %w, align 4
  call void @add_edge(%struct.graph* %g, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
  %i.old = load i32, i32* %i, align 4
  %i.next = add nsw i32 %i.old, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after_edges:                                      ; preds = %loop
  %fmt3.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %scanf3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %src_ptr)
  %cmp.scanf3 = icmp eq i32 %scanf3, 1
  br i1 %cmp.scanf3, label %validate_src, label %err

validate_src:                                     ; preds = %after_edges
  %src.val = load i32, i32* %src_ptr, align 4
  %n.reload2 = load i32, i32* %n_ptr, align 4
  %src.ge0 = icmp sge i32 %src.val, 0
  %src.lt.n = icmp slt i32 %src.val, %n.reload2
  %src.ok = and i1 %src.ge0, %src.lt.n
  br i1 %src.ok, label %ok_ret, label %err

ok_ret:                                           ; preds = %validate_src
  store i32 0, i32* %ret, align 4
  br label %exit

err:                                              ; preds = %validate_src, %after_edges, %validate_edge, %read_edge, %check_nm, %entry
  store i32 -1, i32* %ret, align 4
  br label %exit

exit:                                             ; preds = %err, %ok_ret
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}