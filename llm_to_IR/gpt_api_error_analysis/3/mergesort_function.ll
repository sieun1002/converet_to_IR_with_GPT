; ModuleID = 'merge_sort_bottom_up'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %tmp_ptr_i8 = call i8* @malloc(i64 %bytes)
  %isnull = icmp eq i8* %tmp_ptr_i8, null
  br i1 %isnull, label %ret, label %init

init:
  %tmp_ptr = bitcast i8* %tmp_ptr_i8 to i32*
  br label %outer.cond

outer.cond:
  %width.phi = phi i64 [ 1, %init ], [ %width.next, %outer.swap ]
  %src.phi = phi i32* [ %dest, %init ], [ %src.next, %outer.swap ]
  %buf.phi = phi i32* [ %tmp_ptr, %init ], [ %buf.next, %outer.swap ]
  %cmp_width = icmp ult i64 %width.phi, %n
  br i1 %cmp_width, label %inner.cond, label %after.loops

inner.cond:
  %i.phi = phi i64 [ 0, %outer.cond ], [ %i.next, %merge.done ]
  %tw = shl i64 %width.phi, 1
  %i.cmp = icmp ult i64 %i.phi, %n
  br i1 %i.cmp, label %chunk.setup, label %outer.swap

chunk.setup:
  %i_plus_w = add i64 %i.phi, %width.phi
  %mid.le = icmp ule i64 %i_plus_w, %n
  %mid = select i1 %mid.le, i64 %i_plus_w, i64 %n
  %i_plus_2w = add i64 %i.phi, %tw
  %end.le = icmp ule i64 %i_plus_2w, %n
  %end = select i1 %end.le, i64 %i_plus_2w, i64 %n
  br label %merge.header

merge.header:
  %j.phi = phi i64 [ %i.phi, %chunk.setup ], [ %j.next, %choose.left ], [ %j.keep, %choose.right ]
  %k.phi = phi i64 [ %mid, %chunk.setup ], [ %k.keep, %choose.left ], [ %k.next, %choose.right ]
  %d.phi = phi i64 [ %i.phi, %chunk.setup ], [ %d.next.left, %choose.left ], [ %d.next.right, %choose.right ]
  %d.cmp = icmp ult i64 %d.phi, %end
  br i1 %d.cmp, label %choose.pre, label %merge.done

choose.pre:
  %left.avail = icmp ult i64 %j.phi, %mid
  br i1 %left.avail, label %check.right, label %choose.right

check.right:
  %right.avail = icmp ult i64 %k.phi, %end
  br i1 %right.avail, label %cmp.values, label %choose.left

cmp.values:
  %left.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %left.load = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %k.phi
  %right.load = load i32, i32* %right.ptr, align 4
  %le.cmp = icmp sle i32 %left.load, %right.load
  br i1 %le.cmp, label %choose.left, label %choose.right

choose.left:
  %dst.ptr.left = getelementptr inbounds i32, i32* %buf.phi, i64 %d.phi
  %src.l.ptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %j.phi
  %lval2 = load i32, i32* %src.l.ptr2, align 4
  store i32 %lval2, i32* %dst.ptr.left, align 4
  %j.next = add i64 %j.phi, 1
  %k.keep = add i64 %k.phi, 0
  %d.next.left = add i64 %d.phi, 1
  br label %merge.header

choose.right:
  %dst.ptr.right = getelementptr inbounds i32, i32* %buf.phi, i64 %d.phi
  %src.r.ptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %k.phi
  %rval2 = load i32, i32* %src.r.ptr2, align 4
  store i32 %rval2, i32* %dst.ptr.right, align 4
  %k.next = add i64 %k.phi, 1
  %j.keep = add i64 %j.phi, 0
  %d.next.right = add i64 %d.phi, 1
  br label %merge.header

merge.done:
  %i.next = add i64 %i.phi, %tw
  br label %inner.cond

outer.swap:
  %src.next = getelementptr inbounds i32, i32* %buf.phi, i64 0
  %buf.next = getelementptr inbounds i32, i32* %src.phi, i64 0
  %width.next = shl i64 %width.phi, 1
  br label %outer.cond

after.loops:
  %src.ne.dest = icmp ne i32* %src.phi, %dest
  br i1 %src.ne.dest, label %do.copy, label %skip.copy

do.copy:
  %bytes.copy = shl i64 %n, 2
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.phi to i8*
  %memcpy.call = call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes.copy)
  br label %skip.copy

skip.copy:
  call void @free(i8* %tmp_ptr_i8)
  br label %ret

ret:
  ret void
}