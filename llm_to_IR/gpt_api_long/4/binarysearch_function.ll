; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search  ; Address: 0x1169
; Intent: Find first index of target in sorted ascending i32 array using lower_bound-style binary search (confidence=0.95). Evidence: [low, high) with high=mid else low=mid+1; final equality check before returning index.
; Preconditions: arr has at least n elements; array sorted non-decreasing (ascending)
; Postconditions: returns index of first equal element if present; otherwise -1

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %target) local_unnamed_addr {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next, %setlow ], [ %low.next.sh, %sethigh ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %setlow ], [ %high.next.sh, %sethigh ]
  %cond = icmp ult i64 %low, %high
  br i1 %cond, label %loop.body, label %after

loop.body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %midptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %midval = load i32, i32* %midptr, align 4
  %cmp_le = icmp sle i32 %target, %midval
  br i1 %cmp_le, label %sethigh, label %setlow

setlow:
  %mid.plus1 = add i64 %mid, 1
  %low.next = %mid.plus1
  %high.next = %high
  br label %loop

sethigh:
  %low.next.sh = %low
  %high.next.sh = %mid
  br label %loop

after:
  %inbounds = icmp ult i64 %low, %n
  br i1 %inbounds, label %check, label %notfound

check:
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %low
  %val = load i32, i32* %ptr, align 4
  %eq = icmp eq i32 %target, %val
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low

notfound:
  ret i64 -1
}