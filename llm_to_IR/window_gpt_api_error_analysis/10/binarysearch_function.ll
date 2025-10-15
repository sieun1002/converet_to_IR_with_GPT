; ModuleID = 'binary_search_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @binary_search(i32* %arr, i64 %n, i32 %key) local_unnamed_addr {
entry:
  br label %loop.cond

loop.cond:                                          ; preds = %loop.latch, %entry
  %lo.phi = phi i64 [ 0, %entry ], [ %lo.next, %loop.latch ]
  %hi.phi = phi i64 [ %n, %entry ], [ %hi.next, %loop.latch ]
  %cmp = icmp ult i64 %lo.phi, %hi.phi
  br i1 %cmp, label %loop.body, label %after.loop

loop.body:                                          ; preds = %loop.cond
  %diff = sub i64 %hi.phi, %lo.phi
  %half = lshr i64 %diff, 1
  %mid = add i64 %lo.phi, %half
  %ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %val = load i32, i32* %ptr, align 4
  %cmp.le = icmp sle i32 %key, %val
  br i1 %cmp.le, label %set.hi, label %set.lo

set.lo:                                             ; preds = %loop.body
  %mid.plus1 = add i64 %mid, 1
  br label %loop.latch

set.hi:                                             ; preds = %loop.body
  br label %loop.latch

loop.latch:                                         ; preds = %set.hi, %set.lo
  %lo.next = phi i64 [ %mid.plus1, %set.lo ], [ %lo.phi, %set.hi ]
  %hi.next = phi i64 [ %hi.phi, %set.lo ], [ %mid, %set.hi ]
  br label %loop.cond

after.loop:                                         ; preds = %loop.cond
  %cmp.lo.n = icmp ult i64 %lo.phi, %n
  br i1 %cmp.lo.n, label %check.eq, label %ret.neg

check.eq:                                           ; preds = %after.loop
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %lo.phi
  %val2 = load i32, i32* %ptr2, align 4
  %eq = icmp eq i32 %key, %val2
  br i1 %eq, label %ret.idx, label %ret.neg

ret.idx:                                            ; preds = %check.eq
  %idx.trunc = trunc i64 %lo.phi to i32
  ret i32 %idx.trunc

ret.neg:                                            ; preds = %check.eq, %after.loop
  ret i32 -1
}