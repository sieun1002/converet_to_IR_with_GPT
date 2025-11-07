; ModuleID = 'selection_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

define void @selection_sort(i32* nocapture noundef %arr, i32 noundef %len) local_unnamed_addr {
entry:
  %cmp1 = icmp sle i32 %len, 1
  br i1 %cmp1, label %ret, label %outer.preheader

outer.preheader:
  %nminus1 = add nsw i32 %len, -1
  br label %outer

outer:
  %i = phi i32 [ 0, %outer.preheader ], [ %i.next, %outer.latch ]
  %base.ptr = phi i32* [ %arr, %outer.preheader ], [ %next.base, %outer.latch ]
  %cur = load i32, i32* %base.ptr, align 4
  %i.plus1 = add nuw nsw i32 %i, 1
  %has_more = icmp slt i32 %i.plus1, %len
  br i1 %has_more, label %inner, label %noinner

inner:
  %j = phi i32 [ %i.plus1, %outer ], [ %j.next, %inner ]
  %min.ptr = phi i32* [ %base.ptr, %outer ], [ %min.ptr.next, %inner ]
  %min.val = phi i32 [ %cur, %outer ], [ %min.val.next, %inner ]
  %j.gep = getelementptr inbounds i32, i32* %arr, i32 %j
  %j.val = load i32, i32* %j.gep, align 4
  %cmp.lt = icmp slt i32 %j.val, %min.val
  %min.ptr.next = select i1 %cmp.lt, i32* %j.gep, i32* %min.ptr
  %min.val.next = select i1 %cmp.lt, i32 %j.val, i32 %min.val
  %j.next = add nuw nsw i32 %j, 1
  %j.cont = icmp slt i32 %j.next, %len
  br i1 %j.cont, label %inner, label %inner.exit

inner.exit:
  %final.min.ptr1 = phi i32* [ %min.ptr.next, %inner ]
  %final.min.val1 = phi i32 [ %min.val.next, %inner ]
  br label %swap

noinner:
  br label %swap

swap:
  %final.min.ptr = phi i32* [ %final.min.ptr1, %inner.exit ], [ %base.ptr, %noinner ]
  %final.min.val = phi i32 [ %final.min.val1, %inner.exit ], [ %cur, %noinner ]
  store i32 %final.min.val, i32* %base.ptr, align 4
  store i32 %cur, i32* %final.min.ptr, align 4
  br label %outer.latch

outer.latch:
  %next.base = getelementptr inbounds i32, i32* %base.ptr, i32 1
  %i.next = add nuw nsw i32 %i, 1
  %cont.outer = icmp slt i32 %i.next, %nminus1
  br i1 %cont.outer, label %outer, label %ret

ret:
  ret void
}