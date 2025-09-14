; ModuleID = 'selection_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: selection_sort ; Address: 0x1169
; Intent: In-place ascending selection sort of a 32-bit int array (confidence=0.99). Evidence: nested loops tracking min index; swap of a[i] with a[min]; comparisons on 32-bit elements using jge/jl.
; Preconditions: arr points to at least n 32-bit elements.
; Postconditions: arr[0..n-1] is sorted in nondecreasing order.

; Only the necessary external declarations:

; Use the IDA symbol here (e.g., @heap_sort or @main)
define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
entry:
  %n_minus_1 = add i32 %n, -1
  %cmp_has_loop = icmp sgt i32 %n, 1
  br i1 %cmp_has_loop, label %for.i.cond, label %for.end

for.i.cond:                                        ; preds = %entry, %for.i.inc
  %i = phi i32 [ 0, %entry ], [ %i.next, %for.i.inc ]
  %i_lt = icmp slt i32 %i, %n_minus_1
  br i1 %i_lt, label %for.i.body, label %for.end

for.i.body:                                        ; preds = %for.i.cond
  %min0 = phi i32 [ %i, %for.i.cond ]
  %j0 = add i32 %i, 1
  br label %for.j.cond

for.j.cond:                                        ; preds = %for.j.inc, %for.i.body
  %min.phi = phi i32 [ %min0, %for.i.body ], [ %min.next, %for.j.inc ]
  %j = phi i32 [ %j0, %for.i.body ], [ %j.next, %for.j.inc ]
  %j_lt = icmp slt i32 %j, %n
  br i1 %j_lt, label %for.j.body, label %after.j

for.j.body:                                        ; preds = %for.j.cond
  %j.idx.ext = sext i32 %j to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx.ext
  %j.val = load i32, i32* %j.ptr, align 4
  %min.idx.ext = sext i32 %min.phi to i64
  %min.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.idx.ext
  %min.val = load i32, i32* %min.ptr, align 4
  %is_less = icmp slt i32 %j.val, %min.val
  %min.next = select i1 %is_less, i32 %j, i32 %min.phi
  br label %for.j.inc

for.j.inc:                                         ; preds = %for.j.body
  %j.next = add i32 %j, 1
  br label %for.j.cond

after.j:                                           ; preds = %for.j.cond
  ; swap arr[i] and arr[min.phi]
  %i.idx.ext = sext i32 %i to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx.ext
  %tmp = load i32, i32* %i.ptr, align 4
  %min.final.ext = sext i32 %min.phi to i64
  %min.final.ptr = getelementptr inbounds i32, i32* %arr, i64 %min.final.ext
  %min.val.final = load i32, i32* %min.final.ptr, align 4
  store i32 %min.val.final, i32* %i.ptr, align 4
  store i32 %tmp, i32* %min.final.ptr, align 4
  br label %for.i.inc

for.i.inc:                                         ; preds = %after.j
  %i.next = add i32 %i, 1
  br label %for.i.cond

for.end:                                           ; preds = %for.i.cond, %entry
  ret void
}