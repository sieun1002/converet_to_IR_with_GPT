; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit ints (confidence=0.96). Evidence: shift loop using temp; i from 1..n-1 with signed compare temp < a[j-1]
; Preconditions: arr points to at least n writable i32 elements
; Postconditions: arr[0..n-1] sorted in nondecreasing order

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.outer

for.outer:                                            ; i loop
  %i = phi i64 [ 1, entry ], [ %i.next, %for.outer.latch ]
  %cmp.i.n = icmp ult i64 %i, %n
  br i1 %cmp.i.n, label %outer.body, label %ret

outer.body:
  %elt.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %temp = load i32, i32* %elt.ptr, align 4
  %j.init = %i
  br label %inner.cond

inner.cond:
  %j = phi i64 [ %j.init, %outer.body ], [ %j.dec, %inner.body ]
  %j.is.zero = icmp eq i64 %j, 0
  br i1 %j.is.zero, label %after.inner, label %check.swap

check.swap:
  %j.prev = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.prev
  %prev = load i32, i32* %prev.ptr, align 4
  %need.shift = icmp slt i32 %temp, %prev
  br i1 %need.shift, label %inner.body, label %after.inner

inner.body:
  %dst.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dst.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %inner.cond

after.inner:
  %j.out = phi i64 [ %j, %inner.cond ], [ %j, %check.swap ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.out
  store i32 %temp, i32* %ins.ptr, align 4
  br label %for.outer.latch

for.outer.latch:
  %i.next = add i64 %i, 1
  br label %for.outer

ret:
  ret void
}