; ModuleID = 'dijkstra.ll'
source_filename = "dijkstra.ll"

@.str_inf = private unnamed_addr constant [16 x i8] c"dist[%d] = INF\0A\00", align 1
@.str_val = private unnamed_addr constant [14 x i8] c"dist[%d] = %d\0A\00", align 1

declare i32 @printf(i8*, ...)

define void @dijkstra(i32* %graph, i32 %n, i32 %src) {
entry:
  %dist = alloca [100 x i32], align 16
  %visited = alloca [100 x i32], align 16
  %i = alloca i32, align 4
  %count = alloca i32, align 4
  %u = alloca i32, align 4
  %min = alloca i32, align 4
  %v = alloca i32, align 4

  ; initialize dist[] to INF and visited[] to 0
  store i32 0, i32* %i, align 4
  br label %init_loop

init_loop:                                           ; preds = %init_body, %entry
  %i.val = load i32, i32* %i, align 4
  %init.cmp = icmp slt i32 %i.val, %n
  br i1 %init.cmp, label %init_body, label %after_init

init_body:                                           ; preds = %init_loop
  %i.idx64 = zext i32 %i.val to i64
  %dist.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i.idx64
  store i32 2147483647, i32* %dist.i.ptr, align 4
  %visited.i.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %i.idx64
  store i32 0, i32* %visited.i.ptr, align 4
  %i.next = add nsw i32 %i.val, 1
  store i32 %i.next, i32* %i, align 4
  br label %init_loop

after_init:                                          ; preds = %init_loop
  ; dist[src] = 0
  %src64 = zext i32 %src to i64
  %dist.src.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %src64
  store i32 0, i32* %dist.src.ptr, align 4

  store i32 0, i32* %count, align 4
  br label %outer_loop

outer_loop:                                          ; preds = %outer_inc, %after_sel, %after_init
  %count.val = load i32, i32* %count, align 4
  %n.minus1 = add nsw i32 %n, -1
  %outer.cmp = icmp slt i32 %count.val, %n.minus1
  br i1 %outer.cmp, label %select_u, label %print_phase

select_u:                                            ; preds = %outer_loop
  store i32 -1, i32* %u, align 4
  store i32 2147483647, i32* %min, align 4
  store i32 0, i32* %v, align 4
  br label %sel_loop

sel_loop:                                            ; preds = %sel_inc, %select_u
  %v.val = load i32, i32* %v, align 4
  %sel.cmp = icmp slt i32 %v.val, %n
  br i1 %sel.cmp, label %sel_body, label %after_sel

sel_body:                                            ; preds = %sel_loop
  %v64 = zext i32 %v.val to i64
  %visited.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v64
  %visited.v = load i32, i32* %visited.v.ptr, align 4
  %is.unvisited = icmp eq i32 %visited.v, 0
  br i1 %is.unvisited, label %check_min, label %sel_inc

check_min:                                           ; preds = %sel_body
  %dist.v.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v64
  %dist.v = load i32, i32* %dist.v.ptr, align 4
  %min.cur = load i32, i32* %min, align 4
  %lt.min = icmp slt i32 %dist.v, %min.cur
  br i1 %lt.min, label %update_u, label %sel_inc

update_u:                                            ; preds = %check_min
  store i32 %dist.v, i32* %min, align 4
  store i32 %v.val, i32* %u, align 4
  br label %sel_inc

sel_inc:                                             ; preds = %update_u, %check_min, %sel_body
  %v.next = add nsw i32 %v.val, 1
  store i32 %v.next, i32* %v, align 4
  br label %sel_loop

after_sel:                                           ; preds = %sel_loop
  %u.val = load i32, i32* %u, align 4
  %u.neg1 = icmp eq i32 %u.val, -1
  br i1 %u.neg1, label %print_phase, label %mark_u

mark_u:                                              ; preds = %after_sel
  %u64 = zext i32 %u.val to i64
  %visited.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %u64
  store i32 1, i32* %visited.u.ptr, align 4
  store i32 0, i32* %v, align 4
  br label %relax_loop

relax_loop:                                          ; preds = %relax_inc, %mark_u
  %v2 = load i32, i32* %v, align 4
  %relax.cmp = icmp slt i32 %v2, %n
  br i1 %relax.cmp, label %relax_body, label %outer_inc

relax_body:                                          ; preds = %relax_loop
  %v2.64 = zext i32 %v2 to i64
  %u.cur = load i32, i32* %u, align 4
  %u.64.2 = zext i32 %u.cur to i64
  %row.off = mul nuw nsw i64 %u.64.2, 100
  %g.idx = add i64 %row.off, %v2.64
  %g.ptr = getelementptr inbounds i32, i32* %graph, i64 %g.idx
  %w = load i32, i32* %g.ptr, align 4
  %w.is.zero = icmp eq i32 %w, 0
  br i1 %w.is.zero, label %relax_inc, label %check_visited_v

check_visited_v:                                     ; preds = %relax_body
  %visited.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %visited, i64 0, i64 %v2.64
  %visited.v2 = load i32, i32* %visited.v2.ptr, align 4
  %v.unvisited = icmp eq i32 %visited.v2, 0
  br i1 %v.unvisited, label %check_distu_inf, label %relax_inc

check_distu_inf:                                     ; preds = %check_visited_v
  %dist.u.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %u64
  %dist.u = load i32, i32* %dist.u.ptr, align 4
  %u.is.inf = icmp eq i32 %dist.u, 2147483647
  br i1 %u.is.inf, label %relax_inc, label %maybe_update

maybe_update:                                        ; preds = %check_distu_inf
  %dist.v2.ptr = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %v2.64
  %dist.v2 = load i32, i32* %dist.v2.ptr, align 4
  %sum = add nsw i32 %dist.u, %w
  %cmp.sum = icmp sgt i32 %dist.v2, %sum
  br i1 %cmp.sum, label %do_update, label %relax_inc

do_update:                                           ; preds = %maybe_update
  store i32 %sum, i32* %dist.v2.ptr, align 4
  br label %relax_inc

relax_inc:                                           ; preds = %do_update, %maybe_update, %check_distu_inf, %check_visited_v, %relax_body
  %v2.next = add nsw i32 %v2, 1
  store i32 %v2.next, i32* %v, align 4
  br label %relax_loop

outer_inc:                                           ; preds = %relax_loop
  %count.next = add nsw i32 %count.val, 1
  store i32 %count.next, i32* %count, align 4
  br label %outer_loop

print_phase:                                         ; preds = %after_sel, %outer_loop
  store i32 0, i32* %i, align 4
  br label %print_loop

print_loop:                                          ; preds = %print_inc, %print_phase
  %i.val2 = load i32, i32* %i, align 4
  %print.cmp = icmp slt i32 %i.val2, %n
  br i1 %print.cmp, label %print_body, label %ret

print_body:                                          ; preds = %print_loop
  %i64b = zext i32 %i.val2 to i64
  %dist.i.ptr2 = getelementptr inbounds [100 x i32], [100 x i32]* %dist, i64 0, i64 %i64b
  %dist.i = load i32, i32* %dist.i.ptr2, align 4
  %is.inf = icmp eq i32 %dist.i, 2147483647
  br i1 %is.inf, label %print_inf, label %print_val

print_inf:                                           ; preds = %print_body
  %fmt.inf.ptr = getelementptr inbounds [16 x i8], [16 x i8]* @.str_inf, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.inf.ptr, i32 %i.val2)
  br label %print_inc

print_val:                                           ; preds = %print_body
  %fmt.val.ptr = getelementptr inbounds [14 x i8], [14 x i8]* @.str_val, i64 0, i64 0
  call i32 (i8*, ...) @printf(i8* %fmt.val.ptr, i32 %i.val2, i32 %dist.i)
  br label %print_inc

print_inc:                                           ; preds = %print_val, %print_inf
  %i.next2 = add nsw i32 %i.val2, 1
  store i32 %i.next2, i32* %i, align 4
  br label %print_loop

ret:                                                 ; preds = %print_loop
  ret void
}