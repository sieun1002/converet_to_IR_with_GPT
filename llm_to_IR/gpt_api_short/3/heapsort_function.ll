; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heapsort (ascending) for i32 array (confidence=0.98). Evidence: 0-based heap indices (2*i+1), sift-down with signed comparisons; root/end swap loop.
; Preconditions: arr points to at least n 32-bit elements
; Postconditions: arr[0..n-1] sorted in nondecreasing order

; Only the necessary external declarations:
; (none)

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.loop.header

build.loop.header:
  %i_count = phi i64 [ %half, %build.init ], [ %i_next_count, %build.afterSink ]
  %is_zero = icmp eq i64 %i_count, 0
  br i1 %is_zero, label %sort.init, label %build.computeI

build.computeI:
  %i.cur = add i64 %i_count, -1
  br label %sink.loop.header

sink.loop.header:
  %k = phi i64 [ %i.cur, %build.computeI ], [ %k.next, %sink.swap ]
  %i.const = phi i64 [ %i.cur, %build.computeI ], [ %i.const, %sink.swap ]
  %two_k = shl i64 %k, 1
  %left = add i64 %two_k, 1
  %left_ge_n = icmp uge i64 %left, %n
  br i1 %left_ge_n, label %build.afterSink, label %sink.hasLeft

sink.hasLeft:
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right = add i64 %left, 1
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %cmp.rightleft, label %choose.left

cmp.rightleft:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right_gt_left = icmp sgt i32 %right.val, %left.val
  br i1 %right_gt_left, label %choose.right, label %choose.left

choose.right:
  %max.idx.r = phi i64 [ %right, %cmp.rightleft ]
  %max.ptr.r = phi i32* [ %right.ptr, %cmp.rightleft ]
  %max.val.r = phi i32 [ %right.val, %cmp.rightleft ]
  br label %after.choose

choose.left:
  %max.idx.l = phi i64 [ %left, %sink.hasLeft ], [ %left, %cmp.rightleft ]
  %max.ptr.l = phi i32* [ %left.ptr, %sink.hasLeft ], [ %left.ptr, %cmp.rightleft ]
  %max.val.l = phi i32 [ %left.val, %sink.hasLeft ], [ %left.val, %cmp.rightleft ]
  br label %after.choose

after.choose:
  %max.idx = phi i64 [ %max.idx.r, %choose.right ], [ %max.idx.l, %choose.left ]
  %max.ptr = phi i32* [ %max.ptr.r, %choose.right ], [ %max.ptr.l, %choose.left ]
  %max.val = phi i32 [ %max.val.r, %choose.right ], [ %max.val.l, %choose.left ]
  %k.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  %need.swap = icmp slt i32 %k.val, %max.val
  br i1 %need.swap, label %sink.swap, label %sink.break

sink.swap:
  store i32 %max.val, i32* %k.ptr, align 4
  store i32 %k.val, i32* %max.ptr, align 4
  %k.next = add i64 %max.idx, 0
  br label %sink.loop.header

sink.break:
  br label %build.afterSink

build.afterSink:
  %i_next_count = phi i64 [ %i.const, %sink.break ], [ %i.const, %sink.loop.header ]
  br label %build.loop.header

sort.init:
  %last.init = add i64 %n, -1
  br label %sort.loop.header

sort.loop.header:
  %last = phi i64 [ %last.init, %sort.init ], [ %last.next, %after.heapify ]
  %done = icmp eq i64 %last, 0
  br i1 %done, label %ret, label %sort.swap

sort.swap:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %last.ptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %last.val = load i32, i32* %last.ptr, align 4
  store i32 %last.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %last.ptr, align 4
  br label %heapify.header

heapify.header:
  %k2 = phi i64 [ 0, %sort.swap ], [ %k2.next, %heap.swap ]
  %two_k2 = shl i64 %k2, 1
  %left2 = add i64 %two_k2, 1
  %left2_ge_last = icmp uge i64 %left2, %last
  br i1 %left2_ge_last, label %after.heapify, label %heap.hasLeft

heap.hasLeft:
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  %right2 = add i64 %left2, 1
  %right2_lt_last = icmp ult i64 %right2, %last
  br i1 %right2_lt_last, label %heap.cmp.rightleft, label %heap.choose.left

heap.cmp.rightleft:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %right2_gt_left2 = icmp sgt i32 %right2.val, %left2.val
  br i1 %right2_gt_left2, label %heap.choose.right, label %heap.choose.left

heap.choose.right:
  %max2.idx.r = phi i64 [ %right2, %heap.cmp.rightleft ]
  %max2.ptr.r = phi i32* [ %right2.ptr, %heap.cmp.rightleft ]
  %max2.val.r = phi i32 [ %right2.val, %heap.cmp.rightleft ]
  br label %heap.after.choose

heap.choose.left:
  %max2.idx.l = phi i64 [ %left2, %heap.hasLeft ], [ %left2, %heap.cmp.rightleft ]
  %max2.ptr.l = phi i32* [ %left2.ptr, %heap.hasLeft ], [ %left2.ptr, %heap.cmp.rightleft ]
  %max2.val.l = phi i32 [ %left2.val, %heap.hasLeft ], [ %left2.val, %heap.cmp.rightleft ]
  br label %heap.after.choose

heap.after.choose:
  %max2.idx = phi i64 [ %max2.idx.r, %heap.choose.right ], [ %max2.idx.l, %heap.choose.left ]
  %max2.ptr = phi i32* [ %max2.ptr.r, %heap.choose.right ], [ %max2.ptr.l, %heap.choose.left ]
  %max2.val = phi i32 [ %max2.val.r, %heap.choose.right ], [ %max2.val.l, %heap.choose.left ]
  %k2.ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2.val = load i32, i32* %k2.ptr, align 4
  %need.swap2 = icmp slt i32 %k2.val, %max2.val
  br i1 %need.swap2, label %heap.swap, label %after.heapify

heap.swap:
  store i32 %max2.val, i32* %k2.ptr, align 4
  store i32 %k2.val, i32* %max2.ptr, align 4
  %k2.next = add i64 %max2.idx, 0
  br label %heapify.header

after.heapify:
  %last.next = add i64 %last, -1
  br label %sort.loop.header

ret:
  ret void
}