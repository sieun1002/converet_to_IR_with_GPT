; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit integers (confidence=0.95). Evidence: shifting arr[j]=arr[j-1] with signed jl compare against key; outer loop i from 1 while i < n (jb).
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: arr[0..n-1] sorted in nondecreasing order by signed 32-bit comparison.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer

outer:
  %i = phi i64 [ 1, %entry ], [ %i.next, %outer.latch ]
  %cond = icmp ult i64 %i, %n
  br i1 %cond, label %outer.body, label %exit

outer.body:
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %ptr.i, align 4
  br label %inner.header

inner.header:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shift ]
  %j_zero = icmp eq i64 %j, 0
  br i1 %j_zero, label %insert, label %inner.cmp

inner.cmp:
  %jm1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %cmp.key = icmp slt i32 %key, %val.jm1
  br i1 %cmp.key, label %inner.shift, label %insert

inner.shift:
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.header

insert:
  %ptr.ins = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %key, i32* %ptr.ins, align 4
  br label %outer.latch

outer.latch:
  %i.next = add i64 %i, 1
  br label %outer

exit:
  ret void
}