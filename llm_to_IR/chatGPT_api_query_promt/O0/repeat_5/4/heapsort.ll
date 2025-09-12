; ModuleID = 'heap_sort.ll'
source_filename = "heap_sort"

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %heapify.init

heapify.init:
  %i_next0 = lshr i64 %n, 1
  br label %heapify.loop

heapify.loop:
  %i_next = phi i64 [ %i_next0, %heapify.init ], [ %i_next.dec, %after_sift_heapify ]
  %has_more = icmp ne i64 %i_next, 0
  br i1 %has_more, label %heapify.body, label %extract.init

heapify.body:
  %i.init = add i64 %i_next, -1
  br label %sift.h.loop

sift.h.loop:
  %i.h = phi i64 [ %i.init, %heapify.body ], [ %k.sel.h, %sift.h.swap ]
  %doub.h = shl i64 %i.h, 1
  %j.h = add i64 %doub.h, 1
  %j.ge.n = icmp uge i64 %j.h, %n
  br i1 %j.ge.n, label %after_sift_heapify, label %has.right.h

has.right.h:
  %j1.h = add i64 %j.h, 1
  %r.in.range.h = icmp ult i64 %j1.h, %n
  br i1 %r.in.range.h, label %cmp.siblings.h, label %choose.left.h

cmp.siblings.h:
  %ptr.r.h = getelementptr inbounds i32, i32* %arr, i64 %j1.h
  %val.r.h = load i32, i32* %ptr.r.h, align 4
  %ptr.l.h = getelementptr inbounds i32, i32* %arr, i64 %j.h
  %val.l.h = load i32, i32* %ptr.l.h, align 4
  %right.gt.left.h = icmp sgt i32 %val.r.h, %val.l.h
  br i1 %right.gt.left.h, label %choose.right.h, label %choose.left.h

choose.right.h:
  br label %cmp.parent.h

choose.left.h:
  br label %cmp.parent.h

cmp.parent.h:
  %k.sel.h = phi i64 [ %j1.h, %choose.right.h ], [ %j.h, %choose.left.h ]
  %ptr.i.h = getelementptr inbounds i32, i32* %arr, i64 %i.h
  %val.i.h = load i32, i32* %ptr.i.h, align 4
  %ptr.k.h = getelementptr inbounds i32, i32* %arr, i64 %k.sel.h
  %val.k.h = load i32, i32* %ptr.k.h, align 4
  %i.ge.k.h = icmp sge i32 %val.i.h, %val.k.h
  br i1 %i.ge.k.h, label %after_sift_heapify, label %sift.h.swap

sift.h.swap:
  store i32 %val.k.h, i32* %ptr.i.h, align 4
  store i32 %val.i.h, i32* %ptr.k.h, align 4
  br label %sift.h.loop

after_sift_heapify:
  %i_next.dec = add i64 %i_next, -1
  br label %heapify.loop

extract.init:
  %limit0 = add i64 %n, -1
  br label %extract.loop

extract.loop:
  %limit = phi i64 [ %limit0, %extract.init ], [ %limit.dec, %after_sift_extract ]
  %cont = icmp ne i64 %limit, 0
  br i1 %cont, label %extract.body, label %ret

extract.body:
  %ptr0 = %arr
  %val0 = load i32, i32* %ptr0, align 4
  %ptrL = getelementptr inbounds i32, i32* %arr, i64 %limit
  %valL = load i32, i32* %ptrL, align 4
  store i32 %valL, i32* %ptr0, align 4
  store i32 %val0, i32* %ptrL, align 4
  br label %sift.e.loop

sift.e.loop:
  %i.e = phi i64 [ 0, %extract.body ], [ %k.sel.e, %sift.e.swap ]
  %doub.e = shl i64 %i.e, 1
  %j.e = add i64 %doub.e, 1
  %j.ge.limit = icmp uge i64 %j.e, %limit
  br i1 %j.ge.limit, label %after_sift_extract, label %has.right.e

has.right.e:
  %j1.e = add i64 %j.e, 1
  %r.in.range.e = icmp ult i64 %j1.e, %limit
  br i1 %r.in.range.e, label %cmp.siblings.e, label %choose.left.e

cmp.siblings.e:
  %ptr.r.e = getelementptr inbounds i32, i32* %arr, i64 %j1.e
  %val.r.e = load i32, i32* %ptr.r.e, align 4
  %ptr.l.e = getelementptr inbounds i32, i32* %arr, i64 %j.e
  %val.l.e = load i32, i32* %ptr.l.e, align 4
  %right.gt.left.e = icmp sgt i32 %val.r.e, %val.l.e
  br i1 %right.gt.left.e, label %choose.right.e, label %choose.left.e

choose.right.e:
  br label %cmp.parent.e

choose.left.e:
  br label %cmp.parent.e

cmp.parent.e:
  %k.sel.e = phi i64 [ %j1.e, %choose.right.e ], [ %j.e, %choose.left.e ]
  %ptr.i.e = getelementptr inbounds i32, i32* %arr, i64 %i.e
  %val.i.e = load i32, i32* %ptr.i.e, align 4
  %ptr.k.e = getelementptr inbounds i32, i32* %arr, i64 %k.sel.e
  %val.k.e = load i32, i32* %ptr.k.e, align 4
  %i.ge.k.e = icmp sge i32 %val.i.e, %val.k.e
  br i1 %i.ge.k.e, label %after_sift_extract, label %sift.e.swap

sift.e.swap:
  store i32 %val.k.e, i32* %ptr.i.e, align 4
  store i32 %val.i.e, i32* %ptr.k.e, align 4
  br label %sift.e.loop

after_sift_extract:
  %limit.dec = add i64 %limit, -1
  br label %extract.loop

ret:
  ret void
}