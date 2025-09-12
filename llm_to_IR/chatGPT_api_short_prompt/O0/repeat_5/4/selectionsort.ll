; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort on an i32 array (confidence=0.95). Evidence: tracks minimum index via arr[j] < arr[min], then swaps with arr[i].
; Preconditions: arr points to at least n contiguous i32 elements; n >= 0.
; Postconditions: arr[0..n) sorted in nondecreasing order.

; Only the necessary external declarations:

define dso_local void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  %n.minus1 = add i32 %n, -1
  br label %for.i.cond

for.i.cond:                                         ; i in [0, n-2]
  %i = phi i32 [ 0, %entry ], [ %i.next, %for.i.inc ]
  %i.lt.nm1 = icmp slt i32 %i, %n.minus1
  br i1 %i.lt.nm1, label %for.i.body, label %ret

for.i.body:
  %min0 = %i
  %j.init = add i32 %i, 1
  br label %for.j.cond

for.j.cond:                                         ; j in [i+1, n)
  %j = phi i32 [ %j.init, %for.i.body ], [ %j.next, %for.j.body ]
  %minidx = phi i32 [ %min0, %for.i.body ], [ %minidx.next, %for.j.body ]
  %j.lt.n = icmp slt i32 %j, %n
  br i1 %j.lt.n, label %for.j.body, label %after.j

for.j.body:
  %j.sext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.sext
  %val.j = load i32, i32* %j.ptr, align 4
  %min.sext = sext i32 %minidx to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.sext
  %val.min = load i32, i32* %min.ptr, align 4
  %is.less = icmp slt i32 %val.j, %val.min
  %minidx.next = select i1 %is.less, i32 %j, i32 %minidx
  %j.next = add i32 %j, 1
  br label %for.j.cond

after.j:
  ; swap arr[i] and arr[minidx]
  %i.sext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.sext
  %tmp = load i32, i32* %i.ptr, align 4
  %minidx.out = phi i32 [ %minidx, %for.j.cond ]
  %min.out.sext = sext i32 %minidx.out to i64
  %min.out.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.out.sext
  %val.min.out = load i32, i32* %min.out.ptr, align 4
  store i32 %val.min.out, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.out.ptr, align 4
  br label %for.i.inc

for.i.inc:
  %i.next = add i32 %i, 1
  br label %for.i.cond

ret:
  ret void
}