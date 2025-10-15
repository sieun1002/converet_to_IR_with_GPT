; ModuleID = 'read_graph.ll'
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
  %i = alloca i32, align 4
  %u = alloca i32, align 4
  %v = alloca i32, align 4
  %w = alloca i32, align 4
  %ret = alloca i32, align 4
  %fmt1.ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str.dd, i64 0, i64 0
  %call.scan1 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt1.ptr, i32* %pn, i32* %m)
  %cmp.scan1.ok = icmp eq i32 %call.scan1, 2
  br i1 %cmp.scan1.ok, label %after_scan1, label %bad_input1

bad_input1:                                       ; preds = %entry
  store i32 -1, i32* %ret, align 4
  br label %return

after_scan1:                                      ; preds = %entry
  %n.load = load i32, i32* %pn, align 4
  %n.gt0 = icmp sgt i32 %n.load, 0
  br i1 %n.gt0, label %check_n_hi, label %invalid_bounds1

check_n_hi:                                       ; preds = %after_scan1
  %n.le100 = icmp sle i32 %n.load, 100
  br i1 %n.le100, label %check_m_nonneg, label %invalid_bounds1

check_m_nonneg:                                   ; preds = %check_n_hi
  %m.load = load i32, i32* %m, align 4
  %m.nonneg = icmp sge i32 %m.load, 0
  br i1 %m.nonneg, label %init_and_loop, label %invalid_bounds1

invalid_bounds1:                                  ; preds = %check_n_hi, %check_m_nonneg, %after_scan1
  store i32 -1, i32* %ret, align 4
  br label %return

init_and_loop:                                    ; preds = %check_m_nonneg
  call void @init_graph(i8* %graph, i32 %n.load)
  store i32 0, i32* %i, align 4
  br label %loop

loop:                                             ; preds = %add_edge_block, %init_and_loop
  %i.cur = load i32, i32* %i, align 4
  %m.cur = load i32, i32* %m, align 4
  %i.ge.m = icmp sge i32 %i.cur, %m.cur
  br i1 %i.ge.m, label %after_edges, label %read_edge

read_edge:                                        ; preds = %loop
  %fmt2.ptr = getelementptr inbounds [9 x i8], [9 x i8]* @.str.ddd, i64 0, i64 0
  %call.scan2 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt2.ptr, i32* %u, i32* %v, i32* %w)
  %scan2.ok = icmp eq i32 %call.scan2, 3
  br i1 %scan2.ok, label %validate_uv, label %bad_input2

bad_input2:                                       ; preds = %read_edge
  store i32 -1, i32* %ret, align 4
  br label %return

validate_uv:                                      ; preds = %read_edge
  %u.val = load i32, i32* %u, align 4
  %u.ge0 = icmp sge i32 %u.val, 0
  br i1 %u.ge0, label %u_lt_n_check, label %edge_invalid

u_lt_n_check:                                     ; preds = %validate_uv
  %n.for.u = load i32, i32* %pn, align 4
  %u.lt.n = icmp slt i32 %u.val, %n.for.u
  br i1 %u.lt.n, label %v_ge0_check, label %edge_invalid

v_ge0_check:                                      ; preds = %u_lt_n_check
  %v.val = load i32, i32* %v, align 4
  %v.ge0 = icmp sge i32 %v.val, 0
  br i1 %v.ge0, label %v_lt_n_check, label %edge_invalid

v_lt_n_check:                                     ; preds = %v_ge0_check
  %n.for.v = load i32, i32* %pn, align 4
  %v.lt.n = icmp slt i32 %v.val, %n.for.v
  br i1 %v.lt.n, label %add_edge_block, label %edge_invalid

edge_invalid:                                     ; preds = %u_lt_n_check, %v_ge0_check, %v_lt_n_check, %validate_uv
  store i32 -1, i32* %ret, align 4
  br label %return

add_edge_block:                                   ; preds = %v_lt_n_check
  %w.val = load i32, i32* %w, align 4
  call void @add_edge(i8* %graph, i32 %u.val, i32 %v.val, i32 %w.val, i32 1)
  %i.next = add nsw i32 %i.cur, 1
  store i32 %i.next, i32* %i, align 4
  br label %loop

after_edges:                                      ; preds = %loop
  %fmt3.ptr = getelementptr inbounds [3 x i8], [3 x i8]* @.str.d, i64 0, i64 0
  %call.scan3 = call i32 (i8*, ...) @__isoc99_scanf(i8* %fmt3.ptr, i32* %psrc)
  %scan3.ok = icmp eq i32 %call.scan3, 1
  br i1 %scan3.ok, label %check_src_bounds, label %bad_input3

bad_input3:                                       ; preds = %after_edges
  store i32 -1, i32* %ret, align 4
  br label %return

check_src_bounds:                                 ; preds = %after_edges
  %s.val = load i32, i32* %psrc, align 4
  %s.ge0 = icmp sge i32 %s.val, 0
  br i1 %s.ge0, label %s_lt_n_check, label %invalid_src

s_lt_n_check:                                     ; preds = %check_src_bounds
  %n.for.s = load i32, i32* %pn, align 4
  %s.lt.n = icmp slt i32 %s.val, %n.for.s
  br i1 %s.lt.n, label %ok_ret, label %invalid_src

invalid_src:                                      ; preds = %s_lt_n_check, %check_src_bounds
  store i32 -1, i32* %ret, align 4
  br label %return

ok_ret:                                           ; preds = %s_lt_n_check
  store i32 0, i32* %ret, align 4
  br label %return

return:                                           ; preds = %ok_ret, %invalid_src, %bad_input3, %edge_invalid, %bad_input2, %invalid_bounds1, %bad_input1
  %rv = load i32, i32* %ret, align 4
  ret i32 %rv
}