; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: Bubble sort i32 array with last-swap optimization (confidence=0.95). Evidence: adjacent i32 compares/swaps; outer bound set to last swap index.
; Preconditions: %arr points to at least %n 32-bit elements; %n is the number of elements.
; Postconditions: %arr is sorted in nondecreasing order by signed 32-bit comparison.

define dso_local void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %outer_entry

outer_entry:
  br label %outer_header

outer_header:
  %last.phi = phi i64 [ %n, %outer_entry ], [ %lastSwap.back, %outer_update ]
  %cmp.last.gt1 = icmp ugt i64 %last.phi, 1
  br i1 %cmp.last.gt1, label %outer_body, label %ret

outer_body:
  br label %inner_header

inner_header:
  %i.phi = phi i64 [ 1, %outer_body ], [ %i.next, %inner_continue ]
  %lastSwap.phi = phi i64 [ 0, %outer_body ], [ %lastSwap.next, %inner_continue ]
  %cmp.i.lt.last = icmp ult i64 %i.phi, %last.phi
  br i1 %cmp.i.lt.last, label %inner_body, label %inner_done

inner_body:
  %i.minus1 = add i64 %i.phi, -1
  %p0 = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %p1 = getelementptr inbounds i32, i32* %arr, i64 %i.phi
  %a = load i32, i32* %p0, align 4
  %b = load i32, i32* %p1, align 4
  %cmp.swap = icmp sgt i32 %a, %b
  br i1 %cmp.swap, label %do_swap, label %no_swap

do_swap:
  store i32 %b, i32* %p0, align 4
  store i32 %a, i32* %p1, align 4
  br label %inner_continue

no_swap:
  br label %inner_continue

inner_continue:
  %lastSwap.next = phi i64 [ %i.phi, %do_swap ], [ %lastSwap.phi, %no_swap ]
  %i.next = add nuw nsw i64 %i.phi, 1
  br label %inner_header

inner_done:
  %no_swaps = icmp eq i64 %lastSwap.phi, 0
  br i1 %no_swaps, label %ret, label %outer_update

outer_update:
  %lastSwap.back = phi i64 [ %lastSwap.phi, %inner_done ]
  br label %outer_header

ret:
  ret void
}