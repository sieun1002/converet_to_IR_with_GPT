; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @bubble_sort(i32* %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %outer.header

outer.header:
  %cur_upper = phi i64 [ %n, %entry ], [ %cur_upper.next, %outer.latch ]
  %cond1 = icmp ugt i64 %cur_upper, 1
  br i1 %cond1, label %inner.init, label %exit

inner.init:
  br label %inner.cond

inner.cond:
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.inc ]
  %lastSwap = phi i64 [ 0, %inner.init ], [ %lastSwap.inc, %inner.inc ]
  %cond2 = icmp ult i64 %i, %cur_upper
  br i1 %cond2, label %inner.body, label %outer.latch

inner.body:
  %i_minus1 = add i64 %i, -1
  %ptr_left = getelementptr inbounds i32, i32* %arr, i64 %i_minus1
  %left = load i32, i32* %ptr_left, align 4
  %ptr_right = getelementptr inbounds i32, i32* %arr, i64 %i
  %right = load i32, i32* %ptr_right, align 4
  %cmp_vals = icmp sgt i32 %left, %right
  br i1 %cmp_vals, label %do_swap, label %no_swap

do_swap:
  store i32 %left, i32* %ptr_right, align 4
  store i32 %right, i32* %ptr_left, align 4
  br label %inner.inc

no_swap:
  br label %inner.inc

inner.inc:
  %lastSwap.inc = phi i64 [ %i, %do_swap ], [ %lastSwap, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner.cond

outer.latch:
  %hasSwap = icmp ne i64 %lastSwap, 0
  %cur_upper.next = select i1 %hasSwap, i64 %lastSwap, i64 %cur_upper
  br label %outer.header

exit:
  ret void
}