; ModuleID = 'merge_sort'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret_early, label %alloc

ret_early:
  ret void

alloc:
  %size_bytes = mul i64 %n, 4
  %bufraw = call i8* @malloc(i64 %size_bytes)
  %buf_is_null = icmp eq i8* %bufraw, null
  br i1 %buf_is_null, label %ret_early2, label %init

ret_early2:
  ret void

init:
  %buf = bitcast i8* %bufraw to i32*
  %run.init = add i64 0, 1
  br label %outer.cond

outer.cond:
  %src.cur = phi i32* [ %arr, %init ], [ %src.next, %outer.latch ]
  %dst.cur = phi i32* [ %buf, %init ], [ %dst.next, %outer.latch ]
  %run.cur = phi i64 [ %run.init, %init ], [ %run.next, %outer.latch ]
  %run_lt_n = icmp ult i64 %run.cur, %n
  br i1 %run_lt_n, label %outer.body, label %after.outer

outer.body:
  br label %inner.cond

inner.cond:
  %start.cur = phi i64 [ 0, %outer.body ], [ %start.next, %pair.done ]
  %start_lt_n = icmp ult i64 %start.cur, %n
  br i1 %start_lt_n, label %pair.init, label %outer.latch

pair.init:
  %sum1 = add i64 %start.cur, %run.cur
  %mid.cmp = icmp ult i64 %sum1, %n
  %mid = select i1 %mid.cmp, i64 %sum1, i64 %n
  %twoRun = add i64 %run.cur, %run.cur
  %end1 = add i64 %start.cur, %twoRun
  %end.cmp = icmp ult i64 %end1, %n
  %end = select i1 %end.cmp, i64 %end1, i64 %n
  br label %merge.cond

merge.cond:
  %i.cur = phi i64 [ %start.cur, %pair.init ], [ %i.next.L, %takeLeft ], [ %i.next.R, %takeRight ]
  %j.cur = phi i64 [ %mid,        %pair.init ], [ %j.pass.L, %takeLeft ], [ %j.next.R, %takeRight ]
  %k.cur = phi i64 [ %start.cur, %pair.init ], [ %k.next.L, %takeLeft ], [ %k.next.R, %takeRight ]
  %k_lt_end = icmp ult i64 %k.cur, %end
  br i1 %k_lt_end, label %avail.left, label %pair.done

avail.left:
  %left_avail = icmp ult i64 %i.cur, %mid
  br i1 %left_avail, label %check.right, label %takeRight

check.right:
  %right_avail = icmp ult i64 %j.cur, %end
  br i1 %right_avail, label %bothAvail, label %takeLeft

bothAvail:
  %ptr.li = getelementptr inbounds i32, i32* %src.cur, i64 %i.cur
  %val.li = load i32, i32* %ptr.li, align 4
  %ptr.rj = getelementptr inbounds i32, i32* %src.cur, i64 %j.cur
  %val.rj = load i32, i32* %ptr.rj, align 4
  %le_sel = icmp sle i32 %val.li, %val.rj
  br i1 %le_sel, label %takeLeft, label %takeRight

takeLeft:
  %ptr.li.store = getelementptr inbounds i32, i32* %src.cur, i64 %i.cur
  %val.li.store = load i32, i32* %ptr.li.store, align 4
  %ptr.dst.kL = getelementptr inbounds i32, i32* %dst.cur, i64 %k.cur
  store i32 %val.li.store, i32* %ptr.dst.kL, align 4
  %i.next.L = add i64 %i.cur, 1
  %j.pass.L = add i64 %j.cur, 0
  %k.next.L = add i64 %k.cur, 1
  br label %merge.cond

takeRight:
  %ptr.rj.store = getelementptr inbounds i32, i32* %src.cur, i64 %j.cur
  %val.rj.store = load i32, i32* %ptr.rj.store, align 4
  %ptr.dst.kR = getelementptr inbounds i32, i32* %dst.cur, i64 %k.cur
  store i32 %val.rj.store, i32* %ptr.dst.kR, align 4
  %i.next.R = add i64 %i.cur, 0
  %j.next.R = add i64 %j.cur, 1
  %k.next.R = add i64 %k.cur, 1
  br label %merge.cond

pair.done:
  %start.next = add i64 %start.cur, %twoRun
  br label %inner.cond

outer.latch:
  %src.next = select i1 true, i32* %dst.cur, i32* %dst.cur
  %dst.next = select i1 true, i32* %src.cur, i32* %src.cur
  %run.next = add i64 %run.cur, %run.cur
  br label %outer.cond

after.outer:
  %src_is_arr = icmp eq i32* %src.cur, %arr
  br i1 %src_is_arr, label %skip_copy, label %do_copy

do_copy:
  %dst8 = bitcast i32* %arr to i8*
  %src8 = bitcast i32* %src.cur to i8*
  %memcpy_res = call i8* @memcpy(i8* %dst8, i8* %src8, i64 %size_bytes)
  br label %skip_copy

skip_copy:
  call void @free(i8* %bufraw)
  ret void
}