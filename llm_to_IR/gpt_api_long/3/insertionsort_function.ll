; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort  ; Address: 0x1189
; Intent: In-place insertion sort of i32 array ascending (confidence=0.98). Evidence: element size 4 (shl by 2) and loop shifting while key < a[j-1]
; Preconditions: %a points to at least %n contiguous i32 elements
; Postconditions: %a[0..n) sorted in non-decreasing order by signed i32 compare

; Only the needed extern declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare other externs only if they are actually called)

define dso_local void @insertion_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cond.entry = icmp ugt i64 %n, 1
  br i1 %cond.entry, label %for.loop, label %ret

for.loop:
  %i = phi i64 [ 1, entry ], [ %i.next, %for.latch ]
  %a_i_ptr = getelementptr inbounds i32, i32* %a, i64 %i
  %key = load i32, i32* %a_i_ptr, align 4
  br label %while.cond

while.cond:
  %j = phi i64 [ %i, %for.loop ], [ %j.dec, %shift.body ]
  %j_gt_zero = icmp ne i64 %j, 0
  br i1 %j_gt_zero, label %check.prev, label %while.end

check.prev:
  %jm1 = add i64 %j, -1
  %a_jm1_ptr = getelementptr inbounds i32, i32* %a, i64 %jm1
  %prev = load i32, i32* %a_jm1_ptr, align 4
  %cmp = icmp slt i32 %key, %prev
  br i1 %cmp, label %shift.body, label %while.end

shift.body:
  %a_j_ptr = getelementptr inbounds i32, i32* %a, i64 %j
  store i32 %prev, i32* %a_j_ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

while.end:
  %j.end = phi i64 [ %j, %check.prev ], [ %j, %while.cond ]
  %a_jend_ptr = getelementptr inbounds i32, i32* %a, i64 %j.end
  store i32 %key, i32* %a_jend_ptr, align 4
  br label %for.latch

for.latch:
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, %n
  br i1 %cont, label %for.loop, label %ret

ret:
  ret void
}