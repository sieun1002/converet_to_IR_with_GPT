; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place insertion sort of a 32-bit int array in ascending (signed) order (confidence=0.90). Evidence: 4-byte element indexing, inner loop uses signed jl comparing key < a[j-1] and shifts larger elements right.
; Preconditions: arr points to at least n 32-bit elements; n fits in i64.
; Postconditions: arr[0..n) is sorted in nondecreasing order with signed 32-bit comparisons.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.init = icmp ult i64 1, %n
  br i1 %cmp.init, label %outer.loop, label %exit

outer.loop:                                           ; preds = %entry, %outer.after
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.after ]
  %p.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %p.i, align 4
  br label %inner.check

inner.check:                                          ; preds = %inner.shift, %outer.loop
  %j = phi i64 [ %i, %outer.loop ], [ %j.dec, %inner.shift ]
  %j.iszero = icmp eq i64 %j, 0
  br i1 %j.iszero, label %inner.exit, label %inner.cmp

inner.cmp:                                            ; preds = %inner.check
  %jm1 = add i64 %j, -1
  %p.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %p.jm1, align 4
  %cmp = icmp slt i32 %key, %val.jm1
  br i1 %cmp, label %inner.shift, label %inner.exit

inner.shift:                                          ; preds = %inner.cmp
  %p.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %p.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

inner.exit:                                           ; preds = %inner.cmp, %inner.check
  %j.final = phi i64 [ %j, %inner.cmp ], [ %j, %inner.check ]
  %p.j.final = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %p.j.final, align 4
  br label %outer.after

outer.after:                                          ; preds = %inner.exit
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, %n
  br i1 %cont, label %outer.loop, label %exit

exit:                                                 ; preds = %outer.after, %entry
  ret void
}