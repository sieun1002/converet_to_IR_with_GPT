; ModuleID = 'merge_sort.ll'

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %dest.addr = alloca i32*, align 8
  %n.addr = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %src = alloca i32*, align 8
  %buf = alloca i32*, align 8
  %width = alloca i64, align 8
  %i = alloca i64, align 8
  %mid = alloca i64, align 8
  %right = alloca i64, align 8
  %p = alloca i64, align 8
  %q = alloca i64, align 8
  %k = alloca i64, align 8
  %tmp.ptr = alloca i32*, align 8

  store i32* %dest, i32** %dest.addr, align 8
  store i64 %n, i64* %n.addr, align 8

  %n.val = load i64, i64* %n.addr, align 8
  %cmp_small = icmp ule i64 %n.val, 1
  br i1 %cmp_small, label %ret, label %alloc

alloc:
  %n2 = load i64, i64* %n.addr, align 8
  %size.bytes = shl i64 %n2, 2
  %ptr.raw = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %ptr.raw, null
  br i1 %isnull, label %ret, label %init

init:
  store i8* %ptr.raw, i8** %ptr, align 8
  %dest0 = load i32*, i32** %dest.addr, align 8
  store i32* %dest0, i32** %src, align 8
  %buf.cast = bitcast i8* %ptr.raw to i32*
  store i32* %buf.cast, i32** %buf, align 8
  store i64 1, i64* %width, align 8
  br label %outer_check

outer_check:
  %w = load i64, i64* %width, align 8
  %n3 = load i64, i64* %n.addr, align 8
  %more = icmp ult i64 %w, %n3
  br i1 %more, label %outer_body_init, label %after_outer

outer_body_init:
  store i64 0, i64* %i, align 8
  br label %inner_check

inner_check:
  %i.cur = load i64, i64* %i, align 8
  %n4 = load i64, i64* %n.addr, align 8
  %has_more = icmp ult i64 %i.cur, %n4
  br i1 %has_more, label %compute_bounds, label %after_inner

compute_bounds:
  %w.cur = load i64, i64* %width, align 8
  %mid0 = add i64 %i.cur, %w.cur
  %n5 = load i64, i64* %n.addr, align 8
  %mid_gt = icmp ugt i64 %mid0, %n5
  %mid.sel = select i1 %mid_gt, i64 %n5, i64 %mid0
  store i64 %mid.sel, i64* %mid, align 8

  %tw = shl i64 %w.cur, 1
  %right0 = add i64 %i.cur, %tw
  %right_gt = icmp ugt i64 %right0, %n5
  %right.sel = select i1 %right_gt, i64 %n5, i64 %right0
  store i64 %right.sel, i64* %right, align 8

  store i64 %i.cur, i64* %p, align 8
  store i64 %mid.sel, i64* %q, align 8
  store i64 %i.cur, i64* %k, align 8
  br label %merge_check

merge_check:
  %k.cur = load i64, i64* %k, align 8
  %right.cur = load i64, i64* %right, align 8
  %cont = icmp ult i64 %k.cur, %right.cur
  br i1 %cont, label %choose, label %after_merge

choose:
  %p.cur = load i64, i64* %p, align 8
  %mid.cur = load i64, i64* %mid, align 8
  %p_in = icmp ult i64 %p.cur, %mid.cur
  br i1 %p_in, label %check_q, label %take_right

check_q:
  %q.cur = load i64, i64* %q, align 8
  %right.cur2 = load i64, i64* %right, align 8
  %q_in = icmp ult i64 %q.cur, %right.cur2
  br i1 %q_in, label %compare_vals, label %take_left

compare_vals:
  %src.ptr = load i32*, i32** %src, align 8
  %lp = getelementptr inbounds i32, i32* %src.ptr, i64 %p.cur
  %lv = load i32, i32* %lp, align 4
  %rq = getelementptr inbounds i32, i32* %src.ptr, i64 %q.cur
  %rv = load i32, i32* %rq, align 4
  %le = icmp sle i32 %lv, %rv
  br i1 %le, label %take_left, label %take_right

take_left:
  %src.ptr.l = load i32*, i32** %src, align 8
  %p.cur.l = load i64, i64* %p, align 8
  %lp2 = getelementptr inbounds i32, i32* %src.ptr.l, i64 %p.cur.l
  %valL = load i32, i32* %lp2, align 4
  %buf.ptr.l = load i32*, i32** %buf, align 8
  %k.cur.l = load i64, i64* %k, align 8
  %dstL = getelementptr inbounds i32, i32* %buf.ptr.l, i64 %k.cur.l
  store i32 %valL, i32* %dstL, align 4
  %p.next = add i64 %p.cur.l, 1
  store i64 %p.next, i64* %p, align 8
  %k.next.l = add i64 %k.cur.l, 1
  store i64 %k.next.l, i64* %k, align 8
  br label %merge_check

take_right:
  %src.ptr.r = load i32*, i32** %src, align 8
  %q.cur.r = load i64, i64* %q, align 8
  %rq2 = getelementptr inbounds i32, i32* %src.ptr.r, i64 %q.cur.r
  %valR = load i32, i32* %rq2, align 4
  %buf.ptr.r = load i32*, i32** %buf, align 8
  %k.cur.r = load i64, i64* %k, align 8
  %dstR = getelementptr inbounds i32, i32* %buf.ptr.r, i64 %k.cur.r
  store i32 %valR, i32* %dstR, align 4
  %q.next = add i64 %q.cur.r, 1
  store i64 %q.next, i64* %q, align 8
  %k.next.r = add i64 %k.cur.r, 1
  store i64 %k.next.r, i64* %k, align 8
  br label %merge_check

after_merge:
  %w.cur2 = load i64, i64* %width, align 8
  %tw2 = shl i64 %w.cur2, 1
  %i.cur2 = load i64, i64* %i, align 8
  %i.next = add i64 %i.cur2, %tw2
  store i64 %i.next, i64* %i, align 8
  br label %inner_check

after_inner:
  %src.cur = load i32*, i32** %src, align 8
  %buf.cur = load i32*, i32** %buf, align 8
  store i32* %src.cur, i32** %tmp.ptr, align 8
  store i32* %buf.cur, i32** %src, align 8
  %tmp.val = load i32*, i32** %tmp.ptr, align 8
  store i32* %tmp.val, i32** %buf, align 8

  %w.cur3 = load i64, i64* %width, align 8
  %w.next = shl i64 %w.cur3, 1
  store i64 %w.next, i64* %width, align 8
  br label %outer_check

after_outer:
  %src.fin = load i32*, i32** %src, align 8
  %dest.fin = load i32*, i32** %dest.addr, align 8
  %need_copy = icmp ne i32* %src.fin, %dest.fin
  br i1 %need_copy, label %do_memcpy, label %after_memcpy

do_memcpy:
  %n.fin = load i64, i64* %n.addr, align 8
  %bytes = shl i64 %n.fin, 2
  %dst.i8 = bitcast i32* %dest.fin to i8*
  %src.i8 = bitcast i32* %src.fin to i8*
  %_ = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %bytes)
  br label %after_memcpy

after_memcpy:
  %ptr.orig = load i8*, i8** %ptr, align 8
  call void @free(i8* %ptr.orig)
  br label %ret

ret:
  ret void
}