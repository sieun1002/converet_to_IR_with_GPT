; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x1189
; Intent: In-place quicksort on int32 array with inclusive [l..r] indices (confidence=0.94). Evidence: median pivot, bidirectional partition, swap, recurse-on-smaller-side with tail-loop on larger.
; Preconditions: arr must be valid for indices [l..r] (inclusive). l and r are signed 64-bit indices with l,r within bounds of arr.
; Postconditions: arr[l..r] is sorted ascending.

define dso_local void @quick_sort(i32* nocapture %arr, i64 %l, i64 %r) local_unnamed_addr {
entry:
  br label %while.header

while.header:                                      ; preds = %skip.right.call, %skip.left.call, %entry
  %lcur = phi i64 [ %l, %entry ], [ %l.next.left, %skip.left.call ], [ %l.next.right, %skip.right.call ]
  %rcur = phi i64 [ %r, %entry ], [ %r.next.left, %skip.left.call ], [ %r.next.right, %skip.right.call ]
  %cmp.lr = icmp slt i64 %lcur, %rcur
  br i1 %cmp.lr, label %partition.init, label %exit

partition.init:                                    ; preds = %while.header
  %d = sub i64 %rcur, %lcur
  %half = sdiv i64 %d, 2
  %mid = add i64 %lcur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %i.scan

i.scan:                                            ; preds = %continue.loop, %partition.init, %i.scan.inc
  %i = phi i64 [ %lcur, %partition.init ], [ %i.inc, %i.scan.inc ], [ %i.after.swap, %continue.loop ]
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i
  %vi = load i32, i32* %pi, align 4
  %cmpI = icmp sgt i32 %pivot, %vi
  br i1 %cmpI, label %i.scan.inc, label %j.scan

i.scan.inc:                                        ; preds = %i.scan
  %i.inc = add i64 %i, 1
  br label %i.scan

j.scan:                                            ; preds = %i.scan, %j.scan.dec, %continue.loop
  %j = phi i64 [ %rcur, %i.scan ], [ %j.dec, %j.scan.dec ], [ %j.after.swap, %continue.loop ]
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j
  %vj = load i32, i32* %pj, align 4
  %cmpJ = icmp slt i32 %pivot, %vj
  br i1 %cmpJ, label %j.scan.dec, label %compare.ij

j.scan.dec:                                        ; preds = %j.scan
  %j.dec = add i64 %j, -1
  br label %j.scan

compare.ij:                                        ; preds = %j.scan
  %cmp_ij = icmp sgt i64 %i, %j
  br i1 %cmp_ij, label %partition.after, label %do.swap

do.swap:                                           ; preds = %compare.ij
  %pi2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %vi2 = load i32, i32* %pi2, align 4
  %pj2 = getelementptr inbounds i32, i32* %arr, i64 %j
  %vj2 = load i32, i32* %pj2, align 4
  store i32 %vj2, i32* %pi2, align 4
  store i32 %vi2, i32* %pj2, align 4
  %i.after.swap = add i64 %i, 1
  %j.after.swap = add i64 %j, -1
  br label %swap.inc.check

swap.inc.check:                                    ; preds = %do.swap
  %i.cont = phi i64 [ %i.after.swap, %do.swap ]
  %j.cont = phi i64 [ %j.after.swap, %do.swap ]
  %cmp_continue = icmp sle i64 %i.cont, %j.cont
  br i1 %cmp_continue, label %continue.loop, label %partition.after2

continue.loop:                                     ; preds = %swap.inc.check
  br label %i.scan

partition.after2:                                  ; preds = %swap.inc.check
  br label %partition.after

partition.after:                                   ; preds = %partition.after2, %compare.ij
  %i.final = phi i64 [ %i, %compare.ij ], [ %i.cont, %partition.after2 ]
  %j.final = phi i64 [ %j, %compare.ij ], [ %j.cont, %partition.after2 ]
  %left_size = sub i64 %j.final, %lcur
  %right_size = sub i64 %rcur, %i.final
  %cmp_sizes = icmp sge i64 %left_size, %right_size
  br i1 %cmp_sizes, label %recurse.rightfirst, label %recurse.leftfirst

recurse.leftfirst:                                 ; preds = %partition.after
  %cond_left = icmp slt i64 %lcur, %j.final
  br i1 %cond_left, label %do.left.call, label %skip.left.call

do.left.call:                                      ; preds = %recurse.leftfirst
  call void @quick_sort(i32* %arr, i64 %lcur, i64 %j.final)
  br label %skip.left.call

skip.left.call:                                    ; preds = %do.left.call, %recurse.leftfirst
  %l.next.left = %i.final
  %r.next.left = %rcur
  br label %while.header

recurse.rightfirst:                                ; preds = %partition.after
  %cond_right = icmp slt i64 %i.final, %rcur
  br i1 %cond_right, label %do.right.call, label %skip.right.call

do.right.call:                                     ; preds = %recurse.rightfirst
  call void @quick_sort(i32* %arr, i64 %i.final, i64 %rcur)
  br label %skip.right.call

skip.right.call:                                   ; preds = %do.right.call, %recurse.rightfirst
  %l.next.right = %lcur
  %r.next.right = %j.final
  br label %while.header

exit:                                              ; preds = %while.header
  ret void
}