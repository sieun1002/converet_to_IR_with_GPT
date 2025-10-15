; ModuleID = 'merge_sort_module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @malloc(i64 noundef)
declare void @free(i8* noundef)
declare i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)

define void @merge_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret.early, label %alloc

alloc:
  %size.bytes = shl i64 %n, 2
  %blk.i8 = call i8* @malloc(i64 %size.bytes)
  %isnull = icmp eq i8* %blk.i8, null
  br i1 %isnull, label %ret.early, label %init

init:
  %blk.i32 = bitcast i8* %blk.i8 to i32*
  br label %outer.header

outer.header:
  %src.cur = phi i32* [ %arr, %init ], [ %src.next, %after.inner ]
  %tmp.cur = phi i32* [ %blk.i32, %init ], [ %tmp.next, %after.inner ]
  %run.cur = phi i64 [ 1, %init ], [ %run.next, %after.inner ]
  %cond_run_lt_n = icmp ult i64 %run.cur, %n
  br i1 %cond_run_lt_n, label %inner.entry, label %finish

inner.entry:
  br label %inner.cond

inner.cond:
  %i.cur = phi i64 [ 0, %inner.entry ], [ %i.next, %after.merge ]
  %cond_i_lt_n = icmp ult i64 %i.cur, %n
  br i1 %cond_i_lt_n, label %inner.body, label %after.inner

inner.body:
  %left.idx = add i64 %i.cur, 0
  %mid.calc = add i64 %i.cur, %run.cur
  %mid.le.n = icmp ule i64 %mid.calc, %n
  %mid.idx = select i1 %mid.le.n, i64 %mid.calc, i64 %n
  %two.run = shl i64 %run.cur, 1
  %right.calc = add i64 %i.cur, %two.run
  %right.le.n = icmp ule i64 %right.calc, %n
  %right.idx = select i1 %right.le.n, i64 %right.calc, i64 %n
  br label %merge.header

merge.header:
  %l.cur = phi i64 [ %left.idx, %inner.body ], [ %l.next, %merge.cont ]
  %r.cur = phi i64 [ %mid.idx, %inner.body ], [ %r.next, %merge.cont ]
  %k.cur = phi i64 [ %left.idx, %inner.body ], [ %k.next, %merge.cont ]
  %cond_k_lt_right = icmp ult i64 %k.cur, %right.idx
  br i1 %cond_k_lt_right, label %merge.body, label %after.merge

merge.body:
  %cond_l_avail = icmp ult i64 %l.cur, %mid.idx
  br i1 %cond_l_avail, label %check.r, label %choose.right

check.r:
  %cond_r_avail = icmp ult i64 %r.cur, %right.idx
  br i1 %cond_r_avail, label %compare.lr, label %choose.left

compare.lr:
  %l.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %l.cur
  %l.val = load i32, i32* %l.ptr, align 4
  %r.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %r.cur
  %r.val = load i32, i32* %r.ptr, align 4
  %l_le_r = icmp sle i32 %l.val, %r.val
  br i1 %l_le_r, label %choose.left, label %choose.right

choose.left:
  %l.ptr.store = getelementptr inbounds i32, i32* %src.cur, i64 %l.cur
  %l.val.store = load i32, i32* %l.ptr.store, align 4
  %t.ptr.l = getelementptr inbounds i32, i32* %tmp.cur, i64 %k.cur
  store i32 %l.val.store, i32* %t.ptr.l, align 4
  %l.inc = add i64 %l.cur, 1
  %k.inc.l = add i64 %k.cur, 1
  br label %merge.cont

choose.right:
  %r.ptr.store = getelementptr inbounds i32, i32* %src.cur, i64 %r.cur
  %r.val.store = load i32, i32* %r.ptr.store, align 4
  %t.ptr.r = getelementptr inbounds i32, i32* %tmp.cur, i64 %k.cur
  store i32 %r.val.store, i32* %t.ptr.r, align 4
  %r.inc = add i64 %r.cur, 1
  %k.inc.r = add i64 %k.cur, 1
  br label %merge.cont

merge.cont:
  %l.next = phi i64 [ %l.inc, %choose.left ], [ %l.cur, %choose.right ]
  %r.next = phi i64 [ %r.cur, %choose.left ], [ %r.inc, %choose.right ]
  %k.next = phi i64 [ %k.inc.l, %choose.left ], [ %k.inc.r, %choose.right ]
  br label %merge.header

after.merge:
  %two.run.2 = shl i64 %run.cur, 1
  %i.next = add i64 %i.cur, %two.run.2
  br label %inner.cond

after.inner:
  %src.next = phi i32* [ %tmp.cur, %inner.cond ]
  %tmp.next = phi i32* [ %src.cur, %inner.cond ]
  %run.next = shl i64 %run.cur, 1
  br label %outer.header

finish:
  %src.ne.arr = icmp ne i32* %src.cur, %arr
  br i1 %src.ne.arr, label %do.copy, label %after.copy

do.copy:
  %dst.i8 = bitcast i32* %arr to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %sz.bytes = shl i64 %n, 2
  %memcpy.ret = call i8* @memcpy(i8* %dst.i8, i8* %src.i8, i64 %sz.bytes)
  br label %after.copy

after.copy:
  call void @free(i8* %blk.i8)
  br label %ret.early

ret.early:
  ret void
}