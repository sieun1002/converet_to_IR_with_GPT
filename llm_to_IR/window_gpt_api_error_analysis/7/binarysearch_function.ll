; ModuleID = 'binary_search_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i64 @binary_search(i32* %arr, i64 %len, i32 %key) {
entry:
  br label %loop

loop:
  %low = phi i64 [ 0, %entry ], [ %low.next, %cont ]
  %high = phi i64 [ %len, %entry ], [ %high.next, %cont ]
  %cmp = icmp ult i64 %low, %high
  br i1 %cmp, label %body, label %after

body:
  %diff = sub i64 %high, %low
  %half = lshr i64 %diff, 1
  %mid = add i64 %low, %half
  %p = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %p, align 4
  %le = icmp sle i32 %key, %val
  br i1 %le, label %setHigh, label %setLow

setLow:
  %midplus1 = add i64 %mid, 1
  br label %cont

setHigh:
  br label %cont

cont:
  %low.next = phi i64 [ %midplus1, %setLow ], [ %low, %setHigh ]
  %high.next = phi i64 [ %high, %setLow ], [ %mid, %setHigh ]
  br label %loop

after:
  %inRange = icmp ult i64 %low, %len
  br i1 %inRange, label %check, label %retNotFound

check:
  %p2 = getelementptr inbounds i32, i32* %arr, i64 %low
  %v2 = load i32, i32* %p2, align 4
  %eq = icmp eq i32 %key, %v2
  br i1 %eq, label %retIndex, label %retNotFound

retIndex:
  ret i64 %low

retNotFound:
  ret i64 4294967295
}