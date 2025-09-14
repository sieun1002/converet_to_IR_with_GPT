; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.c"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer_init

outer_init:                                        ; preds = %entry
  br label %outer_check

outer_check:                                       ; preds = %outer_init, %set_limit
  %limit = phi i64 [ %n, %outer_init ], [ %last, %set_limit ]
  %cmp1 = icmp ugt i64 %limit, 1
  br i1 %cmp1, label %outer_body_init, label %ret

outer_body_init:                                   ; preds = %outer_check
  br label %inner_check

inner_check:                                       ; preds = %outer_body_init, %after_iter
  %i = phi i64 [ 1, %outer_body_init ], [ %i.next, %after_iter ]
  %last.phi = phi i64 [ 0, %outer_body_init ], [ %last.updated, %after_iter ]
  %cond = icmp ult i64 %i, %limit
  br i1 %cond, label %inner_body, label %outer_after_inner

inner_body:                                        ; preds = %inner_check
  %i.minus = sub i64 %i, 1
  %ptr.left = getelementptr inbounds i32, i32* %arr, i64 %i.minus
  %val.left = load i32, i32* %ptr.left, align 4
  %ptr.right = getelementptr inbounds i32, i32* %arr, i64 %i
  %val.right = load i32, i32* %ptr.right, align 4
  %cmp.ab = icmp sle i32 %val.left, %val.right
  br i1 %cmp.ab, label %no_swap, label %do_swap

no_swap:                                           ; preds = %inner_body
  br label %after_iter

do_swap:                                           ; preds = %inner_body
  store i32 %val.right, i32* %ptr.left, align 4
  store i32 %val.left, i32* %ptr.right, align 4
  br label %after_iter

after_iter:                                        ; preds = %no_swap, %do_swap
  %last.updated = phi i64 [ %last.phi, %no_swap ], [ %i, %do_swap ]
  %i.next = add i64 %i, 1
  br label %inner_check

outer_after_inner:                                 ; preds = %inner_check
  %no_swaps = icmp eq i64 %last.phi, 0
  br i1 %no_swaps, label %ret, label %set_limit

set_limit:                                         ; preds = %outer_after_inner
  %last = add i64 %last.phi, 0
  br label %outer_check

ret:                                               ; preds = %outer_after_inner, %outer_check, %entry
  ret void
}