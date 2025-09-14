; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort  ; Address: 0x1169
; Intent: In-place selection sort (ascending) of 32-bit integers (confidence=0.98). Evidence: nested loops tracking min index; 4-byte element addressing and unconditional swap
; Preconditions: %arr points to at least %n i32 elements; %n >= 0
; Postconditions: %arr[0..n-1] sorted in nondecreasing order (in-place)

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  %n_minus1 = add i32 %n, -1
  br label %outer.loop

outer.loop:                                         ; preds = %after.swap, %entry
  %i = phi i32 [ 0, %entry ], [ %i.next, %after.swap ]
  %cmp.i = icmp slt i32 %i, %n_minus1
  br i1 %cmp.i, label %inner.init, label %exit

inner.init:                                         ; preds = %outer.loop
  %min.init = %i
  %j.init = add i32 %i, 1
  br label %inner.loop

inner.loop:                                         ; preds = %inner.body, %inner.init
  %j = phi i32 [ %j.init, %inner.init ], [ %j.next, %inner.body ]
  %min = phi i32 [ %min.init, %inner.init ], [ %min.new, %inner.body ]
  %cond = icmp slt i32 %j, %n
  br i1 %cond, label %inner.body, label %after.inner

inner.body:                                         ; preds = %inner.loop
  %j.sext = sext i32 %j to i64
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j.sext
  %val.j = load i32, i32* %ptr.j, align 4
  %min.sext = sext i32 %min to i64
  %ptr.min = getelementptr inbounds i32, i32* %arr, i64 %min.sext
  %val.min = load i32, i32* %ptr.min, align 4
  %cmp.min = icmp slt i32 %val.j, %val.min
  %min.new = select i1 %cmp.min, i32 %j, i32 %min
  %j.next = add i32 %j, 1
  br label %inner.loop

after.inner:                                        ; preds = %inner.loop
  %i.sext = sext i32 %i to i64
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.sext
  %tmp.i = load i32, i32* %ptr.i, align 4
  %min.final.sext = sext i32 %min to i64
  %ptr.min.final = getelementptr inbounds i32, i32* %arr, i64 %min.final.sext
  %val.min.final = load i32, i32* %ptr.min.final, align 4
  store i32 %val.min.final, i32* %ptr.i, align 4
  store i32 %tmp.i, i32* %ptr.min.final, align 4
  br label %after.swap

after.swap:                                         ; preds = %after.inner
  %i.next = add i32 %i, 1
  br label %outer.loop

exit:                                               ; preds = %outer.loop
  ret void
}