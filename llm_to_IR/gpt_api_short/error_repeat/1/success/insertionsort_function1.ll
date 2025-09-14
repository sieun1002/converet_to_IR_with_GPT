; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of a 32-bit int array (confidence=0.98). Evidence: 4-byte element indexing (shl by 2), signed compare (jl) of key against arr[j-1].
; Preconditions: arr points to at least n i32s.
; Postconditions: arr[0..n-1] sorted in nondecreasing (signed) order; stable.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.header

for.header:                                        ; preds = %for.latch, %entry
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.latch ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %for.end

for.body:                                          ; preds = %for.header
  %gep.i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %gep.i, align 4
  br label %while.cond

while.cond:                                        ; preds = %while.body, %for.body
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j_nonzero = icmp ne i64 %j, 0
  br i1 %j_nonzero, label %while.cmp2, label %while.end

while.cmp2:                                        ; preds = %while.cond
  %j.minus1 = add i64 %j, -1
  %ptr.jm1 = getelementptr inbounds i32, i32* %arr, i64 %j.minus1
  %val.jm1 = load i32, i32* %ptr.jm1, align 4
  %need_move = icmp slt i32 %key, %val.jm1
  br i1 %need_move, label %while.body, label %while.end

while.body:                                        ; preds = %while.cmp2
  %ptr.j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %val.jm1, i32* %ptr.j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:                                         ; preds = %while.cmp2, %while.cond
  %j.final = phi i64 [ %j, %while.cmp2 ], [ %j, %while.cond ]
  %dst = getelementptr inbounds i32, i32* %arr, i64 %j.final
  store i32 %key, i32* %dst, align 4
  br label %for.latch

for.latch:                                         ; preds = %while.end
  %i.next = add i64 %i, 1
  br label %for.header

for.end:                                           ; preds = %for.header
  ret void
}