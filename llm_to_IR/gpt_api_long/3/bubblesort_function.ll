; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: bubble_sort  ; Address: 0x1189
; Intent: Bubble sort (ascending) with last-swap boundary optimization (confidence=0.95). Evidence: adjacent i32 compare/swap; outer bound set to last swap index.
; Preconditions: a points to at least n contiguous i32 elements; n treated as unsigned length.
; Postconditions: a is sorted in nondecreasing signed 32-bit order.

; Only the needed extern declarations:
; (none)

define dso_local void @bubble_sort(i32* %a, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %outer_check

outer_check:
  %limit = phi i64 [ %n, %entry ], [ %new_limit, %set_limit ]
  %cmp_limit = icmp ugt i64 %limit, 1
  br i1 %cmp_limit, label %inner_init, label %ret

inner_init:
  br label %inner_cond

inner_cond:
  %i = phi i64 [ 1, %inner_init ], [ %i.next, %skip_or_swap ]
  %last = phi i64 [ 0, %inner_init ], [ %last.next, %skip_or_swap ]
  %cont = icmp ult i64 %i, %limit
  br i1 %cont, label %inner_body, label %outer_update

inner_body:
  %idx_left = add i64 %i, -1
  %ptr_left = getelementptr inbounds i32, i32* %a, i64 %idx_left
  %ptr_right = getelementptr inbounds i32, i32* %a, i64 %i
  %val_left = load i32, i32* %ptr_left, align 4
  %val_right = load i32, i32* %ptr_right, align 4
  %le = icmp sle i32 %val_left, %val_right
  br i1 %le, label %skip_or_swap, label %do_swap

do_swap:
  store i32 %val_right, i32* %ptr_left, align 4
  store i32 %val_left, i32* %ptr_right, align 4
  br label %set_last

set_last:
  %last.set = phi i64 [ %i, %do_swap ]
  br label %skip_or_swap

skip_or_swap:
  %last.next = phi i64 [ %last, %inner_body ], [ %last.set, %set_last ]
  %i.next = add i64 %i, 1
  br label %inner_cond

outer_update:
  %no_swaps = icmp eq i64 %last, 0
  br i1 %no_swaps, label %ret, label %set_limit

set_limit:
  %new_limit = phi i64 [ %last, %outer_update ]
  br label %outer_check

ret:
  ret void
}