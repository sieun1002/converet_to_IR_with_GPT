; ModuleID = 'bubble_sort_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  br label %outer_check

outer_check:
  %last.cur = phi i64 [ %n, %entry ], [ %last.next, %update_last ]
  %cond = icmp ugt i64 %last.cur, 1
  br i1 %cond, label %outer_body_init, label %exit

outer_body_init:
  %last.in.pass = add i64 %last.cur, 0
  br label %inner_header

inner_header:
  %i.phi = phi i64 [ 1, %outer_body_init ], [ %i.next, %inner_latch ]
  %swapped.phi = phi i64 [ 0, %outer_body_init ], [ %swapped.next, %inner_latch ]
  %inner.cond = icmp ult i64 %i.phi, %last.in.pass
  br i1 %inner.cond, label %compare, label %after_inner

compare:
  %idxm1 = add i64 %i.phi, -1
  %ptr.m1 = getelementptr inbounds i32, i32* %arr, i64 %idxm1
  %ptr.i = getelementptr inbounds i32, i32* %arr, i64 %i.phi
  %left = load i32, i32* %ptr.m1, align 4
  %right = load i32, i32* %ptr.i, align 4
  %cmpSwap = icmp sgt i32 %left, %right
  br i1 %cmpSwap, label %do_swap, label %no_swap

do_swap:
  store i32 %right, i32* %ptr.m1, align 4
  store i32 %left, i32* %ptr.i, align 4
  br label %inner_latch

no_swap:
  br label %inner_latch

inner_latch:
  %swapped.next = phi i64 [ %i.phi, %do_swap ], [ %swapped.phi, %no_swap ]
  %i.next = add i64 %i.phi, 1
  br label %inner_header

after_inner:
  %noSwaps = icmp eq i64 %swapped.phi, 0
  br i1 %noSwaps, label %exit, label %update_last

update_last:
  %last.next = add i64 %swapped.phi, 0
  br label %outer_check

exit:
  ret void
}