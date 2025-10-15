target triple = "x86_64-pc-windows-msvc"

define dso_local void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %heapify.init

heapify.init:
  %i0 = lshr i64 %n, 1
  br label %heapify.dec

heapify.dec:
  %i_pre = phi i64 [ %i0, %heapify.init ], [ %i_pre_next, %heapify.iter.end ]
  %old_nonzero = icmp ne i64 %i_pre, 0
  %i_dec = add i64 %i_pre, -1
  br i1 %old_nonzero, label %heapify.sift.entry, label %post.heapify

heapify.sift.entry:
  br label %heapify.sift.loop

heapify.sift.loop:
  %j = phi i64 [ %i_dec, %heapify.sift.entry ], [ %child.idx.h, %heapify.swap ]
  %twice = shl i64 %j, 1
  %left = add i64 %twice, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %choose.child, label %heapify.iter.end

choose.child:
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp.siblings, label %left.only

left.only:
  %left.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val2 = load i32, i32* %left.ptr2, align 4
  br label %child.merge

cmp.siblings:
  %left.ptr1 = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val1 = load i32, i32* %left.ptr1, align 4
  %right.ptr1 = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val1 = load i32, i32* %right.ptr1, align 4
  %right_gt_left = icmp sgt i32 %right.val1, %left.val1
  br i1 %right_gt_left, label %select.right, label %select.left

select.right:
  br label %child.merge

select.left:
  br label %child.merge

child.merge:
  %child.idx.h = phi i64 [ %left, %left.only ], [ %right, %select.right ], [ %left, %select.left ]
  %child.val.h = phi i32 [ %left.val2, %left.only ], [ %right.val1, %select.right ], [ %left.val1, %select.left ]
  %parent.ptr.h = getelementptr inbounds i32, i32* %arr, i64 %j
  %parent.val.h = load i32, i32* %parent.ptr.h, align 4
  %parent_lt_child = icmp slt i32 %parent.val.h, %child.val.h
  br i1 %parent_lt_child, label %heapify.swap, label %heapify.iter.end

heapify.swap:
  %child.ptr.h = getelementptr inbounds i32, i32* %arr, i64 %child.idx.h
  store i32 %child.val.h, i32* %parent.ptr.h, align 4
  store i32 %parent.val.h, i32* %child.ptr.h, align 4
  br label %heapify.sift.loop

heapify.iter.end:
  %i_pre_next = phi i64 [ %i_dec, %heapify.sift.loop ], [ %i_dec, %child.merge ]
  br label %heapify.dec

post.heapify:
  %k0 = add i64 %n, -1
  br label %outer.cond

outer.cond:
  %k = phi i64 [ %k0, %post.heapify ], [ %k.next, %outer.iter.after ]
  %k.nonzero = icmp ne i64 %k, 0
  br i1 %k.nonzero, label %outer.iter, label %ret

outer.iter:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  store i32 %k.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %k.ptr, align 4
  br label %outer.sift.loop

outer.sift.loop:
  %j2 = phi i64 [ 0, %outer.iter ], [ %child.idx.o, %outer.swap ]
  %twice.o = shl i64 %j2, 1
  %left.o = add i64 %twice.o, 1
  %left_lt_k = icmp ult i64 %left.o, %k
  br i1 %left_lt_k, label %choose.child.o, label %outer.iter.after

choose.child.o:
  %right.o = add i64 %left.o, 1
  %right_lt_k = icmp ult i64 %right.o, %k
  br i1 %right_lt_k, label %cmp.siblings.o, label %left.only.o

left.only.o:
  %left.ptr2.o = getelementptr inbounds i32, i32* %arr, i64 %left.o
  %left.val2.o = load i32, i32* %left.ptr2.o, align 4
  br label %child.merge.o

cmp.siblings.o:
  %left.ptr1.o = getelementptr inbounds i32, i32* %arr, i64 %left.o
  %left.val1.o = load i32, i32* %left.ptr1.o, align 4
  %right.ptr1.o = getelementptr inbounds i32, i32* %arr, i64 %right.o
  %right.val1.o = load i32, i32* %right.ptr1.o, align 4
  %right_gt_left.o = icmp sgt i32 %right.val1.o, %left.val1.o
  br i1 %right_gt_left.o, label %select.right.o, label %select.left.o

select.right.o:
  br label %child.merge.o

select.left.o:
  br label %child.merge.o

child.merge.o:
  %child.idx.o = phi i64 [ %left.o, %left.only.o ], [ %right.o, %select.right.o ], [ %left.o, %select.left.o ]
  %child.val.o = phi i32 [ %left.val2.o, %left.only.o ], [ %right.val1.o, %select.right.o ], [ %left.val1.o, %select.left.o ]
  %parent.ptr.o = getelementptr inbounds i32, i32* %arr, i64 %j2
  %parent.val.o = load i32, i32* %parent.ptr.o, align 4
  %parent_lt_child.o = icmp slt i32 %parent.val.o, %child.val.o
  br i1 %parent_lt_child.o, label %outer.swap, label %outer.iter.after

outer.swap:
  %child.ptr.o = getelementptr inbounds i32, i32* %arr, i64 %child.idx.o
  store i32 %child.val.o, i32* %parent.ptr.o, align 4
  store i32 %parent.val.o, i32* %child.ptr.o, align 4
  br label %outer.sift.loop

outer.iter.after:
  %k.next = add i64 %k, -1
  br label %outer.cond

ret:
  ret void
}