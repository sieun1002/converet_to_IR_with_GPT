; ModuleID = 'insertion_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: insertion_sort ; Address: 0x1189
; Intent: in-place ascending insertion sort (confidence=0.98). Evidence: loads key=a[i], shifts while a[j-1] > key, starts i=1 and loops while i<n.
; Preconditions: arr points to at least n 32-bit integers (i32), n treated as unsigned (size_t).
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
; (declare only other externs that are needed)

define dso_local void @insertion_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %for.cond

for.cond:                                          ; i-loop condition
  %i = phi i64 [ 1, entry ], [ %i.next, %for.inc ]
  %cmp.i = icmp ult i64 %i, %n
  br i1 %cmp.i, label %for.body, label %for.end

for.body:                                          ; load key and init j
  %key.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %key = load i32, i32* %key.ptr, align 4
  br label %while.cond

while.cond:                                        ; while (j>0 && a[j-1] > key)
  %j = phi i64 [ %i, %for.body ], [ %j.dec, %while.body ]
  %j.zero = icmp eq i64 %j, 0
  br i1 %j.zero, label %insert, label %while.check

while.check:
  %jm1 = add i64 %j, -1
  %jm1.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %ajm1 = load i32, i32* %jm1.ptr, align 4
  %gt = icmp sgt i32 %ajm1, %key
  br i1 %gt, label %while.body, label %insert

while.body:                                        ; a[j] = a[j-1]; --j
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  store i32 %ajm1, i32* %j.ptr, align 4
  %j.dec = add i64 %j, -1
  br label %while.cond

insert:                                            ; a[j] = key
  %j.ins = phi i64 [ %j, %while.cond ], [ %j, %while.check ]
  %ins.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.ins
  store i32 %key, i32* %ins.ptr, align 4
  br label %for.inc

for.inc:
  %i.next = add i64 %i, 1
  br label %for.cond

for.end:
  ret void
}