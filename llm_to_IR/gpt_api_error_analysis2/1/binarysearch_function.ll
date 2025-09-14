; ModuleID = 'binary_search'
target triple = "x86_64-pc-linux-gnu"

define i64 @binary_search(i32* %arr, i64 %n, i32 %key) {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next, %body_end ]
  %high = phi i64 [ %n, %entry ], [ %high.next, %body_end ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %after

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %elem.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %elem = load i32, i32* %elem.ptr, align 4
  %le = icmp sle i32 %key, %elem
  br i1 %le, label %set_high, label %set_low

set_high:
  br label %body_end

set_low:
  %mid.plus = add i64 %mid, 1
  br label %body_end

body_end:
  %high.next = phi i64 [ %mid, %set_high ], [ %high, %set_low ]
  %low.next = phi i64 [ %low, %set_high ], [ %mid.plus, %set_low ]
  br label %loop

after:
  %inrange = icmp ult i64 %low, %n
  br i1 %inrange, label %check_eq, label %notfound

check_eq:
  %elem.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %eq = icmp eq i32 %key, %elem2
  br i1 %eq, label %found, label %notfound

found:
  ret i64 %low

notfound:
  ret i64 -1
}