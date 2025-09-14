; ModuleID = 'binary_search'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: binary_search ; Address: 0x1169
; Intent: binary search index in sorted int array (confidence=0.98). Evidence: midpoint calc with 4-byte stride; final equality check then return index or -1
; Preconditions: arr points to an array of at least n 32-bit signed integers sorted in nondecreasing order
; Postconditions: returns index in [0,n) where arr[index]==key, else -1

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local i64 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %while.cond

while.cond:                                       ; preds = %while.latch, %entry
  %lo = phi i64 [ 0, %entry ], [ %lo.next, %while.latch ]
  %hi = phi i64 [ %n, %entry ], [ %hi.next, %while.latch ]
  %cmp = icmp ult i64 %lo, %hi
  br i1 %cmp, label %while.body, label %while.end

while.body:                                       ; preds = %while.cond
  %diff = sub i64 %hi, %lo
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  %mid.plus = add i64 %mid, 1
  %lo.next = select i1 %le, i64 %lo, i64 %mid.plus
  %hi.next = select i1 %le, i64 %mid, i64 %hi
  br label %while.latch

while.latch:                                      ; preds = %while.body
  br label %while.cond

while.end:                                        ; preds = %while.cond
  %inrange = icmp ult i64 %lo, %n
  br i1 %inrange, label %check, label %ret.neg

check:                                            ; preds = %while.end
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:                                          ; preds = %check
  ret i64 %lo

ret.neg:                                          ; preds = %check, %while.end
  ret i64 -1
}