; target
target triple = "x86_64-pc-linux-gnu"

; libc declarations
declare noalias noundef i8* @malloc(i64 noundef)
declare noundef i8* @memcpy(i8* noundef, i8* noundef, i64 noundef)
declare void @free(i8* noundef)

; void merge_sort(int *dest, size_t n)
define void @merge_sort(i32* noundef %dest, i64 noundef %n) {
entry:
  %n_le1 = icmp ule i64 %n, 1
  br i1 %n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %raw = call noalias noundef i8* @malloc(i64 noundef %bytes)
  %isnull = icmp eq i8* %raw, null
  br i1 %isnull, label %ret, label %setup

setup:
  %buf = bitcast i8* %raw to i32*
  br label %outer.cond

outer.cond:
  %src.phi = phi i32* [ %dest, %setup ], [ %tmp.swap, %outer.latch ]
  %tmp.phi = phi i32* [ %buf, %setup ], [ %src.swap, %outer.latch ]
  %width = phi i64 [ 1, %setup ], [ %width.dbl, %outer.latch ]
  %cond.outer = icmp ult i64 %width, %n
  br i1 %cond.outer, label %inner.head, label %after.outer

inner.head:
  %start = phi i64 [ 0, %outer.cond ], [ %start.next, %after.merge ]
  %start_lt_n = icmp ult i64 %start, %n
  br i1 %start_lt_n, label %merge.setup, label %after.inner

merge.setup:
  %mid.cand = add i64 %start, %width
  %mid.gt.n = icmp ugt i64 %mid.cand, %n
  %mid = select i1 %mid.gt.n, i64 %n, i64 %mid.cand
  %twoW = add i64 %width, %width
  %end.cand = add i64 %start, %twoW
  %end.gt.n = icmp ugt i64 %end.cand, %n
  %end = select i1 %end.gt.n, i64 %n, i64 %end.cand
  br label %merge.loop.head

merge.loop.head:
  %k = phi i64 [ %start, %merge.setup ], [ %k.next, %merge.latch ]
  %l = phi i64 [ %start, %merge.setup ], [ %l.next.phi, %merge.latch ]
  %r = phi i64 [ %mid,   %merge.setup ], [ %r.next.phi, %merge.latch ]
  %k_lt_end = icmp ult i64 %k, %end
  br i1 %k_lt_end, label %cmp.choose, label %merge.done

cmp.choose:
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right, label %take.right

check_right:
  %r_lt_end = icmp ult i64 %r, %end
  br i1 %r_lt_end, label %compare.values, label %take.left

compare.values:
  %lptr.c = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lv.c = load i32, i32* %lptr.c, align 4
  %rptr.c = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rv.c = load i32, i32* %rptr.c, align 4
  %left_gt_right = icmp sgt i32 %lv.c, %rv.c
  br i1 %left_gt_right, label %take.right, label %take.left

take.left:
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lv = load i32, i32* %lptr, align 4
  %wptr.l = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %lv, i32* %wptr.l, align 4
  %l.inc = add i64 %l, 1
  %k.inc.l = add i64 %k, 1
  br label %merge.latch

take.right:
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rv = load i32, i32* %rptr, align 4
  %wptr.r = getelementptr inbounds i32, i32* %tmp.phi, i64 %k
  store i32 %rv, i32* %wptr.r, align 4
  %r.inc = add i64 %r, 1
  %k.inc.r = add i64 %k, 1
  br label %merge.latch

merge.latch:
  %k.next = phi i64 [ %k.inc.l, %take.left ], [ %k.inc.r, %take.right ]
  %l.next.phi = phi i64 [ %l.inc, %take.left ], [ %l, %take.right ]
  %r.next.phi = phi i64 [ %r, %take.left ], [ %r.inc, %take.right ]
  br label %merge.loop.head

merge.done:
  %start.next = add i64 %start, %twoW
  br label %after.merge

after.merge:
  br label %inner.head

after.inner:
  br label %outer.latch

outer.latch:
  %width.dbl = shl i64 %width, 1
  %src.swap = %src.phi
  %tmp.swap = %tmp.phi
  br label %outer.cond

after.outer:
  %src.ne.dest = icmp ne i32* %src.phi, %dest
  br i1 %src.ne.dest, label %do.memcpy, label %do.free

do.memcpy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %ignored = call noundef i8* @memcpy(i8* noundef %dest.i8, i8* noundef %src.i8, i64 noundef %bytes)
  br label %do.free

do.free:
  call void @free(i8* noundef %raw)
  br label %ret

ret:
  ret void
}