; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: In-place ascending insertion sort of i32 array (confidence=0.98). Evidence: shifts a[j-1] → a[j], key compared with jl, i from 1 to n-1.
; Preconditions: arr != null; n elements available.
; Postconditions: arr[0..n-1] sorted nondecreasing.

; Only the necessary external declarations:
; (none)

define dso_local void @insertion_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:
  %i = phi i64 [ 1, %entry ], [ %i.next, %for.inc ]
  %cmp = icmp ult i64 %i, %n
  br i1 %cmp, label %for.body, label %exit

for.body:
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %ptr_i, align 4
  br label %while.cond

while.cond:
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.shift ]
  %j_is_zero = icmp eq i64 %j, 0
  br i1 %j_is_zero, label %after.while, label %check

check:
  %jm1 = add i64 %j, -1
  %ptr_jm1 = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %a_jm1 = load i32, i32* %ptr_jm1, align 4
  %cmp2 = icmp slt i32 %key, %a_jm1
  br i1 %cmp2, label %while.shift, label %after.while

while.shift:
  %ptr_j = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %a_jm1, i32* %ptr_j, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

after.while:
  %j.end = phi i64 [ %j, %while.cond ], [ %j, %check ]
  %ptr_j_end = getelementptr inbounds i32, i32* %arr, i64 %j.end
  store i32 %key, i32* %ptr_j_end, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

exit:
  ret void
}