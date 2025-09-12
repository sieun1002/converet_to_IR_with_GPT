; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place ascending heap sort of i32 array (confidence=0.92). Evidence: build max-heap (sift-down from n/2-1..0), then repeatedly swap root with end and sift-down within shrinking heap.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %end, label %build.init

build.init:                                        ; build max-heap
  %half = lshr i64 %n, 1
  br label %build.cond

build.cond:
  %i = phi i64 [ %half, %build.init ], [ %i.next, %build.next ]
  %i_is_zero = icmp eq i64 %i, 0
  br i1 %i_is_zero, label %build.done, label %sift.build.entry

sift.build.entry:
  %k.init = add i64 %i, -1
  br label %sift.build.loop

sift.build.loop:
  %k = phi i64 [ %k.init, %sift.build.entry ], [ %child, %sift.build.swap ]
  %left2 = shl i64 %k, 1
  %left = add i64 %left2, 1
  %left_lt_n = icmp ult i64 %left, %n
  br i1 %left_lt_n, label %sift.build.hasleft, label %sift.build.break

sift.build.hasleft:
  %right = add i64 %left, 1
  %left.ptr = getelementptr i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  %right_lt_n = icmp ult i64 %right, %n
  br i1 %right_lt_n, label %sift.build.hasright, label %sift.build.chooseleft

sift.build.hasright:
  %right.ptr = getelementptr i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right_gt_left = icmp sgt i32 %right.val, %left.val
  %child.sel = select i1 %right_gt_left, i64 %right, i64 %left
  br label %sift.build.child.join

sift.build.chooseleft:
  br label %sift.build.child.join

sift.build.child.join:
  %child = phi i64 [ %child.sel, %sift.build.hasright ], [ %left, %sift.build.chooseleft ]
  %k.ptr = getelementptr i32, i32* %arr, i64 %k
  %k.val = load i32, i32* %k.ptr, align 4
  %child.ptr = getelementptr i32, i32* %arr, i64 %child
  %child.val = load i32, i32* %child.ptr, align 4
  %k_ge_child = icmp sge i32 %k.val, %child.val
  br i1 %k_ge_child, label %sift.build.break, label %sift.build.swap

sift.build.swap:
  store i32 %child.val, i32* %k.ptr, align 4
  store i32 %k.val, i32* %child.ptr, align 4
  br label %sift.build.loop

sift.build.break:
  br label %build.next

build.next:
  %i.next = add i64 %i, -1
  br label %build.cond

build.done:
  %m.init = add i64 %n, -1
  br label %outer.cond

outer.cond:
  %m = phi i64 [ %m.init, %build.done ], [ %m.next, %outer.iter.done ]
  %m_is_zero = icmp eq i64 %m, 0
  br i1 %m_is_zero, label %end, label %outer.iter

outer.iter:
  %root.val = load i32, i32* %arr, align 4
  %m.ptr = getelementptr i32, i32* %arr, i64 %m
  %m.val = load i32, i32* %m.ptr, align 4
  store i32 %m.val, i32* %arr, align 4
  store i32 %root.val, i32* %m.ptr, align 4
  br label %sift2.loop

sift2.loop:
  %k2 = phi i64 [ 0, %outer.iter ], [ %childb, %sift2.swap ]
  %left2b = shl i64 %k2, 1
  %leftb = add i64 %left2b, 1
  %left_lt_m = icmp ult i64 %leftb, %m
  br i1 %left_lt_m, label %sift2.hasleft, label %sift2.break

sift2.hasleft:
  %rightb = add i64 %leftb, 1
  %left.ptr.b = getelementptr i32, i32* %arr, i64 %leftb
  %left.val.b = load i32, i32* %left.ptr.b, align 4
  %right_lt_m = icmp ult i64 %rightb, %m
  br i1 %right_lt_m, label %sift2.hasright, label %sift2.chooseleft

sift2.hasright:
  %right.ptr.b = getelementptr i32, i32* %arr, i64 %rightb
  %right.val.b = load i32, i32* %right.ptr.b, align 4
  %right_gt_left.b = icmp sgt i32 %right.val.b, %left.val.b
  %childb.sel = select i1 %right_gt_left.b, i64 %rightb, i64 %leftb
  br label %sift2.child.join

sift2.chooseleft:
  br label %sift2.child.join

sift2.child.join:
  %childb = phi i64 [ %childb.sel, %sift2.hasright ], [ %leftb, %sift2.chooseleft ]
  %k2.ptr = getelementptr i32, i32* %arr, i64 %k2
  %k2.val = load i32, i32* %k2.ptr, align 4
  %child.ptrb = getelementptr i32, i32* %arr, i64 %childb
  %child.valb = load i32, i32* %child.ptrb, align 4
  %k_ge_child.b = icmp sge i32 %k2.val, %child.valb
  br i1 %k_ge_child.b, label %sift2.break, label %sift2.swap

sift2.swap:
  store i32 %child.valb, i32* %k2.ptr, align 4
  store i32 %k2.val, i32* %child.ptrb, align 4
  br label %sift2.loop

sift2.break:
  br label %outer.iter.done

outer.iter.done:
  %m.next = add i64 %m, -1
  br label %outer.cond

end:
  ret void
}