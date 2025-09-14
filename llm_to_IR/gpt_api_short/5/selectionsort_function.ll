; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort on an int array (confidence=0.98). Evidence: inner loop tracks min index; conditional update when arr[j] < arr[min]; swap at end of outer iteration.
; Preconditions: arr points to at least n i32 elements (n >= 0).
; Postconditions: arr is sorted in non-decreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  br label %outer

outer:                                            ; i loop
  %i = phi i32 [ 0, %entry ], [ %i.next, %outer.latch ]
  %nminus1 = add nsw i32 %n, -1
  %cond.outer = icmp slt i32 %i, %nminus1
  br i1 %cond.outer, label %outer.body, label %exit

outer.body:
  %minidx.init = add nsw i32 %i, 0
  %j.init = add nsw i32 %i, 1
  br label %inner

inner:                                            ; j loop
  %minidx = phi i32 [ %minidx.init, %outer.body ], [ %minidx.next, %inner.latch ]
  %j = phi i32 [ %j.init, %outer.body ], [ %j.next, %inner.latch ]
  %cond.inner = icmp slt i32 %j, %n
  br i1 %cond.inner, label %inner.body, label %after.inner

inner.body:
  %j64 = sext i32 %j to i64
  %ptrj = getelementptr inbounds i32, i32* %arr, i64 %j64
  %valj = load i32, i32* %ptrj, align 4
  %min64 = sext i32 %minidx to i64
  %ptrmin = getelementptr inbounds i32, i32* %arr, i64 %min64
  %valmin = load i32, i32* %ptrmin, align 4
  %isless = icmp slt i32 %valj, %valmin
  %minidx.next = select i1 %isless, i32 %j, i32 %minidx
  br label %inner.latch

inner.latch:
  %j.next = add nsw i32 %j, 1
  br label %inner

after.inner:
  %i64 = sext i32 %i to i64
  %ptri = getelementptr inbounds i32, i32* %arr, i64 %i64
  %vali = load i32, i32* %ptri, align 4
  %min64b = sext i32 %minidx to i64
  %ptrmin2 = getelementptr inbounds i32, i32* %arr, i64 %min64b
  %valmin2 = load i32, i32* %ptrmin2, align 4
  store i32 %valmin2, i32* %ptri, align 4
  store i32 %vali, i32* %ptrmin2, align 4
  br label %outer.latch

outer.latch:
  %i.next = add nsw i32 %i, 1
  br label %outer

exit:
  ret void
}