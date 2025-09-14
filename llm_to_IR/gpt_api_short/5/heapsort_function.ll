; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heapsort of i32 array ascending (confidence=0.98). Evidence: sift-down using children 2*i+1/2*i+2 and root-last swap loop.
; Preconditions: arr points to at least n elements of 4 bytes each.
; Postconditions: arr[0..n-1] sorted in nondecreasing (signed) order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @heap_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %heapify.init

heapify.init:
  %half = lshr i64 %n, 1
  br label %heapify.loop.check

heapify.loop.check:
  %i.ph = phi i64 [ %half, %heapify.init ], [ %i.next, %after_sift ]
  %i.eq0 = icmp eq i64 %i.ph, 0
  br i1 %i.eq0, label %sort.init, label %heapify.pre

heapify.pre:
  %idx.start = add i64 %i.ph, -1
  br label %sift.loop

sift.loop:
  %curr = phi i64 [ %idx.start, %heapify.pre ], [ %big.idx, %sift.swap ]
  %twice = shl i64 %curr, 1
  %left = add i64 %twice, 1
  %left.oob = icmp uge i64 %left, %n
  br i1 %left.oob, label %after_sift, label %check.right

check.right:
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %cmp.lr, label %choose.big

cmp.lr:
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %gt = icmp sgt i32 %right.val, %left.val
  %big.idx.sel = select i1 %gt, i64 %right, i64 %left
  br label %choose.big

choose.big:
  %big.idx = phi i64 [ %big.idx.sel, %cmp.lr ], [ %left, %check.right ]
  %curr.ptr = getelementptr inbounds i32, i32* %arr, i64 %curr
  %curr.val = load i32, i32* %curr.ptr, align 4
  %big.ptr = getelementptr inbounds i32, i32* %arr, i64 %big.idx
  %big.val = load i32, i32* %big.ptr, align 4
  %ge = icmp sge i32 %curr.val, %big.val
  br i1 %ge, label %after_sift, label %sift.swap

sift.swap:
  store i32 %big.val, i32* %curr.ptr, align 4
  store i32 %curr.val, i32* %big.ptr, align 4
  br label %sift.loop

after_sift:
  %i.next = add i64 %i.ph, -1
  br label %heapify.loop.check

sort.init:
  %j0 = add i64 %n, -1
  br label %sort.loop.check

sort.loop.check:
  %j = phi i64 [ %j0, %sort.init ], [ %j.next, %sift2.after ]
  %j.eq0 = icmp eq i64 %j
  br i1 %j.eq0, label %ret, label %sort.swap.root

sort.swap.root:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  store i32 %j.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %j.ptr, align 4
  br label %sift2.loop

sift2.loop:
  %curr2 = phi i64 [ 0, %sort.swap.root ], [ %big2.idx, %sift2.swap ]
  %twice2 = shl i64 %curr2, 1
  %left2 = add i64 %twice2, 1
  %left2.oob = icmp uge i64 %left2, %j
  br i1 %left2.oob, label %sift2.after, label %check.right2

check.right2:
  %right2 = add i64 %left2, 1
  %right2.in = icmp ult i64 %right2, %j
  %left2.ptr = getelementptr inbounds i32, i32* %arr, i64 %left2
  %left2.val = load i32, i32* %left2.ptr, align 4
  br i1 %right2.in, label %cmp.lr2, label %choose.big2

cmp.lr2:
  %right2.ptr = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right2.val = load i32, i32* %right2.ptr, align 4
  %gt2 = icmp sgt i32 %right2.val, %left2.val
  %big2.idx.sel = select i1 %gt2, i64 %right2, i64 %left2
  br label %choose.big2

choose.big2:
  %big2.idx = phi i64 [ %big2.idx.sel, %cmp.lr2 ], [ %left2, %check.right2 ]
  %curr2.ptr = getelementptr inbounds i32, i32* %arr, i64 %curr2
  %curr2.val = load i32, i32* %curr2.ptr, align 4
  %big2.ptr = getelementptr inbounds i32, i32* %arr, i64 %big2.idx
  %big2.val = load i32, i32* %big2.ptr, align 4
  %ge2 = icmp sge i32 %curr2.val, %big2.val
  br i1 %ge2, label %sift2.after, label %sift2.swap

sift2.swap:
  store i32 %big2.val, i32* %curr2.ptr, align 4
  store i32 %curr2.val, i32* %big2.ptr, align 4
  br label %sift2.loop

sift2.after:
  %j.next = add i64 %j, -1
  br label %sort.loop.check

ret:
  ret void
}