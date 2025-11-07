; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external constant [0 x i8]
@unk_2008 = external constant [0 x i8]
@__stack_chk_guard = external global i64

declare i8* @_malloc(i64)
declare void @_free(i8*)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()
declare i64 @llvm.smin.i64(i64, i64) nounwind readnone

define i32 @main() {
entry_10c0:
  %canary.slot = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %src = alloca i32*, align 8
  %dst = alloca i32*, align 8
  %stack_ptr_save = alloca i32*, align 8
  %i = alloca i64, align 8
  %j = alloca i64, align 8
  %k = alloca i64, align 8
  %left = alloca i64, align 8
  %mid = alloca i64, align 8
  %right = alloca i64, align 8
  %width = alloca i64, align 8
  %n = alloca i64, align 8
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary.slot, align 8

  store i64 10, i64* %n, align 8

  %g0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %arr.vec0.ptr = bitcast [10 x i32]* %arr to <4 x i32>*
  store <4 x i32> %g0, <4 x i32>* %arr.vec0.ptr, align 16

  %g1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr.el4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr.vec1.ptr = bitcast i32* %arr.el4 to <4 x i32>*
  store <4 x i32> %g1, <4 x i32>* %arr.vec1.ptr, align 16

  %arr.el8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.el8, align 4

  %arr.el9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.el9, align 4

  %arr.as.i32ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32* %arr.as.i32ptr, i32** %stack_ptr_save, align 8

  %m = call i8* @_malloc(i64 40)
  %mcast = bitcast i8* %m to i32*
  %malloc_is_null = icmp eq i32* %mcast, null
  br i1 %malloc_is_null, label %loc_142E, label %after_malloc

after_malloc:
  store i32* %arr.as.i32ptr, i32** %src, align 8
  store i32* %mcast, i32** %dst, align 8

  store i64 1, i64* %width, align 8
  br label %outer_loop_1140

outer_loop_1140:
  %w = load i64, i64* %width, align 8
  %nn = load i64, i64* %n, align 8
  %cont = icmp slt i64 %w, %nn
  br i1 %cont, label %init_outer_pass_128A, label %finish_sort_1380

init_outer_pass_128A:
  store i64 0, i64* %i, align 8
  br label %inner_chunk_1280

inner_chunk_1280:
  %i.cur = load i64, i64* %i, align 8
  %n.cur = load i64, i64* %n, align 8
  %i_lt_n = icmp slt i64 %i.cur, %n.cur
  br i1 %i_lt_n, label %prepare_bounds_12B8, label %pass_done_1380

prepare_bounds_12B8:
  %w.cur = load i64, i64* %width, align 8
  %left.v = add i64 %i.cur, 0
  store i64 %left.v, i64* %left, align 8
  %mid.cand = add nsw i64 %i.cur, %w.cur
  %mid.min = call i64 @llvm.smin.i64(i64 %mid.cand, i64 %n.cur)
  store i64 %mid.min, i64* %mid, align 8
  %two.w = shl i64 %w.cur, 1
  %right.cand = add nsw i64 %i.cur, %two.w
  %right.min = call i64 @llvm.smin.i64(i64 %right.cand, i64 %n.cur)
  store i64 %right.min, i64* %right, align 8

  store i64 %left.v, i64* %k, align 8
  store i64 %mid.min, i64* %j, align 8

  br label %merge_loop_cmp_12D7

merge_loop_cmp_12D7:
  %L = load i64, i64* %left, align 8
  %M = load i64, i64* %mid, align 8
  %R = load i64, i64* %right, align 8
  %J = load i64, i64* %j, align 8
  %cmpL = icmp slt i64 %L, %M
  %cmpR = icmp slt i64 %J, %R
  %both = and i1 %cmpL, %cmpR
  br i1 %both, label %merge_select_1158, label %copy_tails_check_1313

merge_select_1158:
  %src.ptr.a = load i32*, i32** %src, align 8
  %src.L.ptr = getelementptr inbounds i32, i32* %src.ptr.a, i64 %L
  %src.J.ptr = getelementptr inbounds i32, i32* %src.ptr.a, i64 %J
  %valL = load i32, i32* %src.L.ptr, align 4
  %valJ = load i32, i32* %src.J.ptr, align 4
  %takeJ = icmp slt i32 %valJ, %valL
  br i1 %takeJ, label %take_right_115C, label %take_left_11C4

take_right_115C:
  %dst.ptr.a = load i32*, i32** %dst, align 8
  %k.cur = load i64, i64* %k, align 8
  %dst.k.ptr = getelementptr inbounds i32, i32* %dst.ptr.a, i64 %k.cur
  store i32 %valJ, i32* %dst.k.ptr, align 4
  %k.next = add nsw i64 %k.cur, 1
  store i64 %k.next, i64* %k, align 8
  %J.next = add nsw i64 %J, 1
  store i64 %J.next, i64* %j, align 8
  br label %merge_loop_cmp_12D7

take_left_11C4:
  %dst.ptr.b = load i32*, i32** %dst, align 8
  %k.cur.b = load i64, i64* %k, align 8
  %dst.k.ptr.b = getelementptr inbounds i32, i32* %dst.ptr.b, i64 %k.cur.b
  store i32 %valL, i32* %dst.k.ptr.b, align 4
  %k.next.b = add nsw i64 %k.cur.b, 1
  store i64 %k.next.b, i64* %k, align 8
  %L.next = add nsw i64 %L, 1
  store i64 %L.next, i64* %left, align 8
  br label %merge_loop_cmp_12D7

copy_tails_check_1313:
  %L2 = load i64, i64* %left, align 8
  %M2 = load i64, i64* %mid, align 8
  %moreLeft = icmp slt i64 %L2, %M2
  br i1 %moreLeft, label %copy_left_tail_12F0, label %copy_right_tail_1331

copy_left_tail_12F0:
  %dst.ptr.c = load i32*, i32** %dst, align 8
  %src.ptr.c = load i32*, i32** %src, align 8
  %k.c = load i64, i64* %k, align 8
  %L.c = load i64, i64* %left, align 8
  %dst.k.ptr.c = getelementptr inbounds i32, i32* %dst.ptr.c, i64 %k.c
  %src.L.ptr.c = getelementptr inbounds i32, i32* %src.ptr.c, i64 %L.c
  %v.c = load i32, i32* %src.L.ptr.c, align 4
  store i32 %v.c, i32* %dst.k.ptr.c, align 4
  %k.inc.c = add nsw i64 %k.c, 1
  %L.inc.c = add nsw i64 %L.c, 1
  store i64 %k.inc.c, i64* %k, align 8
  store i64 %L.inc.c, i64* %left, align 8
  %M3 = load i64, i64* %mid, align 8
  %moreLeft2 = icmp slt i64 %L.inc.c, %M3
  br i1 %moreLeft2, label %copy_left_tail_12F0, label %copy_right_tail_1331

copy_right_tail_1331:
  %J2 = load i64, i64* %j, align 8
  %R2 = load i64, i64* %right, align 8
  %moreRight = icmp slt i64 %J2, %R2
  br i1 %moreRight, label %copy_right_iter_134E, label %advance_chunk_1372

copy_right_iter_134E:
  %dst.ptr.d = load i32*, i32** %dst, align 8
  %src.ptr.d = load i32*, i32** %src, align 8
  %k.d = load i64, i64* %k, align 8
  %J.d = load i64, i64* %j, align 8
  %dst.k.ptr.d = getelementptr inbounds i32, i32* %dst.ptr.d, i64 %k.d
  %src.J.ptr.d = getelementptr inbounds i32, i32* %src.ptr.d, i64 %J.d
  %v.d = load i32, i32* %src.J.ptr.d, align 4
  store i32 %v.d, i32* %dst.k.ptr.d, align 4
  %k.inc.d = add nsw i64 %k.d, 1
  %J.inc.d = add nsw i64 %J.d, 1
  store i64 %k.inc.d, i64* %k, align 8
  store i64 %J.inc.d, i64* %j, align 8
  br label %copy_right_tail_1331

advance_chunk_1372:
  %i.cur2 = load i64, i64* %i, align 8
  %w.cur2 = load i64, i64* %width, align 8
  %two.w2 = shl i64 %w.cur2, 1
  %i.next = add nsw i64 %i.cur2, %two.w2
  store i64 %i.next, i64* %i, align 8
  br label %inner_chunk_1280

pass_done_1380:
  %src.old = load i32*, i32** %src, align 8
  %dst.old = load i32*, i32** %dst, align 8
  store i32* %dst.old, i32** %src, align 8
  store i32* %src.old, i32** %dst, align 8
  %w3 = load i64, i64* %width, align 8
  %w.next = shl i64 %w3, 1
  store i64 %w.next, i64* %width, align 8
  br label %outer_loop_1140

finish_sort_1380:
  %stack.ptr = load i32*, i32** %stack_ptr_save, align 8
  %src.final = load i32*, i32** %src, align 8
  %need_copy = icmp ne i32* %src.final, %stack.ptr
  br i1 %need_copy, label %do_copy_13AD, label %skip_copy_13C6

do_copy_13AD:
  %t.init = alloca i64, align 8
  store i64 0, i64* %t.init, align 8
  br label %copy_loop_13BC

copy_loop_13BC:
  %t = load i64, i64* %t.init, align 8
  %t.lt = icmp slt i64 %t, 10
  br i1 %t.lt, label %copy_body_13C1, label %after_copy_13C6

copy_body_13C1:
  %src.ptr.cp = load i32*, i32** %src, align 8
  %stack.ptr.cp = load i32*, i32** %stack_ptr_save, align 8
  %src.t = getelementptr inbounds i32, i32* %src.ptr.cp, i64 %t
  %stack.t = getelementptr inbounds i32, i32* %stack.ptr.cp, i64 %t
  %v.cp = load i32, i32* %src.t, align 4
  store i32 %v.cp, i32* %stack.t, align 4
  %t.next = add nsw i64 %t, 1
  store i64 %t.next, i64* %t.init, align 8
  br label %copy_loop_13BC

after_copy_13C6:
  %dst.to.free = load i32*, i32** %dst, align 8
  %free.ptr = bitcast i32* %dst.to.free to i8*
  call void @_free(i8* %free.ptr)
  br label %print_prep_13CE

skip_copy_13C6:
  %dst.to.free2 = load i32*, i32** %dst, align 8
  %free.ptr2 = bitcast i32* %dst.to.free2 to i8*
  call void @_free(i8* %free.ptr2)
  br label %print_prep_13CE

loc_142E:
  br label %print_prep_13CE

print_prep_13CE:
  %fmt.ptr = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  %piter = alloca i64, align 8
  store i64 0, i64* %piter, align 8
  br label %print_loop_13E0

print_loop_13E0:
  %idx = load i64, i64* %piter, align 8
  %idx.lt = icmp slt i64 %idx, 10
  br i1 %idx.lt, label %do_print_13E0, label %after_prints_13FA

do_print_13E0:
  %arr.ptr.print = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %idx
  %edx.val = load i32, i32* %arr.ptr.print, align 4
  %callp = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt.ptr, i32 %edx.val)
  %idx.next = add nsw i64 %idx, 1
  store i64 %idx.next, i64* %piter, align 8
  br label %print_loop_13E0

after_prints_13FA:
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %guard.end = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary.slot, align 8
  %ok = icmp eq i64 %guard.end, %saved
  br i1 %ok, label %epilogue_1421, label %loc_1435

loc_1435:
  call void @___stack_chk_fail()
  unreachable

epilogue_1421:
  ret i32 0
}