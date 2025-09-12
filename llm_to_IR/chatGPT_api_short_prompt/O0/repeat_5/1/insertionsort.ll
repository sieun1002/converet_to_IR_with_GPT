; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of i32 array (confidence=0.97). Evidence: key=a[i], shift while key<a[j-1], place at j; outer i from 1 to n-1
; Preconditions: a points to at least n i32 elements (or n == 0)
; Postconditions: a[0..n) is sorted in nondecreasing order

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  br label %outer.header

outer.header:
  %i = phi i64 [ 1, entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %outer.body, label %ret

outer.body:
  %a_i_ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %a_i_ptr, align 4
  br label %inner.check

inner.check:
  %j = phi i64 [ %i, %outer.body ], [ %j.dec, %inner.shifted ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %insert, label %inner.cmp

inner.cmp:
  %j_minus1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %a, i64 %j_minus1
  %val_jm1 = load i32, i32* %ptr_jm1, align 4
  %lt = icmp slt i32 %key, %val_jm1
  br i1 %lt, label %inner.shifted, label %insert

inner.shifted:
  %ptr_j = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %val_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %inner.check

insert:
  %j.final = phi i64 [ %j, %inner.cmp ], [ %j, %inner.check ]
  %ptr_insert = getelementptr inbounds i32, i32* %a, i64 %j.final
  store i32 %key, i32* %ptr_insert, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %outer.header

ret:
  ret void
}