; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Binary search for a key in an ascending i32 array; return index or -1 (confidence=0.95). Evidence: lower_bound-style loop with 4-byte element access and final equality check.
; Preconditions: %arr points to at least %n i32s in nondecreasing order.
; Postconditions: Returns i64 index in [0, %n) of the first occurrence equal to %key, or -1 if not found.

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.head

loop.head:
  %lo.cur = phi i64 [ 0, entry ], [ %lo.cur, %update_hi ], [ %lo.next, %update_lo ]
  %hi.cur = phi i64 [ %n, entry ], [ %mid, %update_hi ], [ %hi.cur, %update_lo ]
  %cmp.lohi = icmp ult i64 %lo.cur, %hi.cur
  br i1 %cmp.lohi, label %loop.body, label %after.loop

loop.body:
  %diff = sub i64 %hi.cur, %lo.cur
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.cur, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %update_hi, label %update_lo

update_hi:
  br label %loop.head

update_lo:
  %lo.next = add i64 %mid, 1
  br label %loop.head

after.loop:
  %inrange = icmp ult i64 %lo.cur, %n
  br i1 %inrange, label %check.eq, label %notfound

check.eq:
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo.cur
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %lo.cur

notfound:
  ret i64 -1
}