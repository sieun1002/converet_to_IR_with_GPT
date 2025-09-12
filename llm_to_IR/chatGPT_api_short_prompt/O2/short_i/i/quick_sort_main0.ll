; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x0000000000001240
; Intent: in-place quicksort (ascending, signed i32) over inclusive indices [l..r] (confidence=0.95). Evidence: pivot from middle element, two-pointer partition, recursive calls on subranges.
; Preconditions: arr points to a valid i32 array; 0 <= l, r fit in i64; l and r are valid indices into arr; uses signed comparisons.
; Postconditions: arr[l..r] is sorted in nondecreasing order (signed 32-bit).

; Only the necessary external declarations:
; (none)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %l, i64 %r) local_unnamed_addr {
entry:
  ; if (l >= r) return
  %cmp.lr = icmp sge i64 %l, %r
  br i1 %cmp.lr, label %ret, label %partition

partition:
  ; pivot = arr[l + ((r - l) >> 1)]
  %sub = sub i64 %r, %l
  %shr = ashr i64 %sub, 1
  %mid = add i64 %l, %shr
  %midptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  br label %loop_header

loop_header:
  ; i and j for the Hoare partition
  %i.phi = phi i64 [ %l, %partition ], [ %i.after, %after_swap ]
  %j.phi = phi i64 [ %r, %partition ], [ %j.after, %after_swap ]
  br label %inc_i

; advance i while a[i] < pivot
inc_i:
  %i.cur = phi i64 [ %i.phi, %loop_header ], [ %i.next, %inc_i ]
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ival = load i32, i32* %iptr, align 4
  %cmp.i = icmp slt i32 %ival, %pivot
  %i.next = add i64 %i.cur, 1
  br i1 %cmp.i, label %inc_i, label %done_i

done_i:
  br label %dec_j

; decrease j while a[j] > pivot
dec_j:
  %j.cur = phi i64 [ %j.phi, %done_i ], [ %j.prev, %dec_j ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %jval = load i32, i32* %jptr, align 4
  %cmp.j = icmp sgt i32 %jval, %pivot
  %j.prev = add i64 %j.cur, -1
  br i1 %cmp.j, label %dec_j, label %done_j

done_j:
  ; if i > j break
  %cross = icmp sgt i64 %i.cur, %j.cur
  br i1 %cross, label %after_partition, label %do_swap

do_swap:
  ; swap a[i] and a[j]
  store i32 %jval, i32* %iptr, align 4
  store i32 %ival, i32* %jptr, align 4
  %i.after = add i64 %i.cur, 1
  %j.after = add i64 %j.cur, -1
  br label %after_swap

after_swap:
  br label %loop_header

after_partition:
  ; recurse on subranges [l..j] and [i..r]
  %need.left = icmp slt i64 %l, %j.cur
  br i1 %need.left, label %recurse_left, label %maybe_right

recurse_left:
  call void @quick_sort(i32* %arr, i64 %l, i64 %j.cur)
  br label %maybe_right

maybe_right:
  %need.right = icmp slt i64 %i.cur, %r
  br i1 %need.right, label %recurse_right, label %ret

recurse_right:
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %r)
  br label %ret

ret:
  ret void
}