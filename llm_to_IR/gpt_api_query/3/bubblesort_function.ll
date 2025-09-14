; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort.c"
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %exit, label %outer_header

outer_header:
  %limit = phi i64 [ %n, %entry ], [ %last, %outer_latch ]
  br label %inner_header

inner_header:
  %i = phi i64 [ 1, %outer_header ], [ %i.next, %inner_latch ]
  %last = phi i64 [ 0, %outer_header ], [ %last.next, %inner_latch ]
  %cond2 = icmp ult i64 %i, %limit
  br i1 %cond2, label %inner_body, label %outer_check

inner_body:
  %i_minus1 = add i64 %i, -1
  %ptr1 = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %a = load i32, i32* %ptr1, align 4
  %ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr2, align 4
  %cmpab = icmp sgt i32 %a, %b
  br i1 %cmpab, label %do_swap, label %no_swap

do_swap:
  store i32 %b, i32* %ptr1, align 4
  store i32 %a, i32* %ptr2, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %last.next = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_header

outer_check:
  %iszero = icmp eq i64 %last, 0
  br i1 %iszero, label %exit, label %outer_latch

outer_latch:
  %gt1 = icmp ugt i64 %last, 1
  br i1 %gt1, label %outer_header, label %exit

exit:
  ret void
}