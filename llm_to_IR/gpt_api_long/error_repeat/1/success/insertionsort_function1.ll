; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place ascending insertion sort of 32-bit integers (confidence=0.95). Evidence: element size 4, loop j>0 shifting while key < a[j-1]
; Preconditions: %arr points to at least %n contiguous i32 elements
; Postconditions: %arr[0..n) is sorted in nondecreasing order

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                         ; preds = %for.inc, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %for.body, label %for.end

for.body:                                         ; preds = %for.cond
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %elem.ptr, align 4
  br label %while.cond

while.cond:                                       ; preds = %while.shifted, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.shifted ]
  %j.zero = icmp eq i64 %j, 0
  br i1 %j.zero, label %while.end, label %while.test

while.test:                                       ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %prev.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %prev = load i32, i32* %prev.ptr, align 4
  %cmp.shift = icmp slt i32 %key, %prev
  br i1 %cmp.shift, label %while.shifted, label %while.end

while.shifted:                                     ; preds = %while.test
  %dest.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %prev, i32* %dest.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                        ; preds = %while.test, %while.cond
  %j.final = phi i64 [ %j, %while.test ], [ %j, %while.cond ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:                                          ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:                                          ; preds = %for.cond
  ret void
}