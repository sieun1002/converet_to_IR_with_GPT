; ModuleID = 'heapsort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001450(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %heapify.init

heapify.init:
  %half = lshr i64 %n, 1
  br label %heapify.check

heapify.check:
  %i_old = phi i64 [ %half, %heapify.init ], [ %i_next, %heapify.inner.break ]
  %i_is_zero = icmp eq i64 %i_old, 0
  br i1 %i_is_zero, label %sort.init, label %heapify.sift.init

heapify.sift.init:
  %j_init = add i64 %i_old, -1
  br label %heapify.sift.loop

heapify.sift.loop:
  %cur = phi i64 [ %j_init, %heapify.sift.init ], [ %m_idx, %heapify.swap.cont ]
  %tw = shl i64 %cur, 1
  %left = add i64 %tw, 1
  %has_left = icmp ult i64 %left, %n
  br i1 %has_left, label %hasleft, label %heapify.inner.break

hasleft:
  %leftptr = getelementptr inbounds i32, i32* %a, i64 %left
  %leftv = load i32, i32* %leftptr, align 4
  %right = add i64 %left, 1
  %has_right = icmp ult i64 %right, %n
  br i1 %has_right, label %cmp_children, label %choose_noright

cmp_children:
  %rightptr = getelementptr inbounds i32, i32* %a, i64 %right
  %rightv = load i32, i32* %rightptr, align 4
  %right_gt_left = icmp sgt i32 %rightv, %leftv
  br i1 %right_gt_left, label %choose_right, label %choose_left_fromcmp

choose_noright:
  br label %after_choose

choose_left_fromcmp:
  br label %after_choose

choose_right:
  br label %after_choose

after_choose:
  %m_idx = phi i64 [ %left, %choose_noright ], [ %left, %choose_left_fromcmp ], [ %right, %choose_right ]
  %parentptr = getelementptr inbounds i32, i32* %a, i64 %cur
  %parentv = load i32, i32* %parentptr, align 4
  %childptr = getelementptr inbounds i32, i32* %a, i64 %m_idx
  %childv = load i32, i32* %childptr, align 4
  %need_swap = icmp slt i32 %parentv, %childv
  br i1 %need_swap, label %heapify.do.swap, label %heapify.inner.break

heapify.do.swap:
  store i32 %childv, i32* %parentptr, align 4
  store i32 %parentv, i32* %childptr, align 4
  br label %heapify.swap.cont

heapify.swap.cont:
  br label %heapify.sift.loop

heapify.inner.break:
  %i_next = phi i64 [ %j_init, %heapify.sift.loop ], [ %j_init, %after_choose ]
  br label %heapify.check

sort.init:
  %m0 = add i64 %n, -1
  br label %sort.check

sort.check:
  %m = phi i64 [ %m0, %sort.init ], [ %m_next, %sort.after.inner ]
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %ret, label %sort.swaproot

sort.swaproot:
  %rootptr = getelementptr inbounds i32, i32* %a, i64 0
  %rootv = load i32, i32* %rootptr, align 4
  %mptr = getelementptr inbounds i32, i32* %a, i64 %m
  %mv = load i32, i32* %mptr, align 4
  store i32 %mv, i32* %rootptr, align 4
  store i32 %rootv, i32* %mptr, align 4
  br label %sort.sift.loop

sort.sift.loop:
  %cur2 = phi i64 [ 0, %sort.swaproot ], [ %m_idx2, %sort.swap.cont ]
  %tw2 = shl i64 %cur2, 1
  %left2 = add i64 %tw2, 1
  %has_left2 = icmp ult i64 %left2, %m
  br i1 %has_left2, label %sort.hasleft, label %sort.inner.break

sort.hasleft:
  %lptr2 = getelementptr inbounds i32, i32* %a, i64 %left2
  %lv2 = load i32, i32* %lptr2, align 4
  %right2 = add i64 %left2, 1
  %has_right2 = icmp ult i64 %right2, %m
  br i1 %has_right2, label %sort.cmpchildren, label %sort.choose_noright

sort.cmpchildren:
  %rptr2 = getelementptr inbounds i32, i32* %a, i64 %right2
  %rv2 = load i32, i32* %rptr2, align 4
  %right_gt_left2 = icmp sgt i32 %rv2, %lv2
  br i1 %right_gt_left2, label %sort.choose_right, label %sort.choose_left_fromcmp

sort.choose_noright:
  br label %sort.afterchoose

sort.choose_left_fromcmp:
  br label %sort.afterchoose

sort.choose_right:
  br label %sort.afterchoose

sort.afterchoose:
  %m_idx2 = phi i64 [ %left2, %sort.choose_noright ], [ %left2, %sort.choose_left_fromcmp ], [ %right2, %sort.choose_right ]
  %pptr2 = getelementptr inbounds i32, i32* %a, i64 %cur2
  %pv2 = load i32, i32* %pptr2, align 4
  %cptr2 = getelementptr inbounds i32, i32* %a, i64 %m_idx2
  %cv2 = load i32, i32* %cptr2, align 4
  %need_swap2 = icmp slt i32 %pv2, %cv2
  br i1 %need_swap2, label %sort.do.swap, label %sort.inner.break

sort.do.swap:
  store i32 %cv2, i32* %pptr2, align 4
  store i32 %pv2, i32* %cptr2, align 4
  br label %sort.swap.cont

sort.swap.cont:
  br label %sort.sift.loop

sort.inner.break:
  br label %sort.after.inner

sort.after.inner:
  %m_next = add i64 %m, -1
  br label %sort.check

ret:
  ret void
}