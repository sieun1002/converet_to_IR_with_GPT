; ModuleID = 'bubble_sort'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_init = icmp ule i64 %n, 1
  br i1 %cmp_init, label %ret, label %outer.preheader

outer.preheader:
  br label %outer.header

outer.header:
  %upper = phi i64 [ %n, %outer.preheader ], [ %new_upper, %outer.cont ]
  %cmp_upper = icmp ugt i64 %upper, 1
  br i1 %cmp_upper, label %inner.preheader, label %ret

inner.preheader:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %inner.preheader ], [ %i.next, %inner.latch ]
  %last_swap = phi i64 [ 0, %inner.preheader ], [ %last_sel, %inner.latch ]
  %cond2 = icmp ult i64 %i, %upper
  br i1 %cond2, label %inner.body, label %after_inner

inner.body:
  %im1 = add i64 %i, -1
  %ptr_prev = getelementptr i32, i32* %arr, i64 %im1
  %val_prev = load i32, i32* %ptr_prev, align 4
  %ptr_curr = getelementptr i32, i32* %arr, i64 %i
  %val_curr = load i32, i32* %ptr_curr, align 4
  %cmpswap = icmp sgt i32 %val_prev, %val_curr
  br i1 %cmpswap, label %do_swap, label %no_swap

do_swap:
  store i32 %val_curr, i32* %ptr_prev, align 4
  store i32 %val_prev, i32* %ptr_curr, align 4
  br label %inner.latch

no_swap:
  br label %inner.latch

inner.latch:
  %last_sel = phi i64 [ %i, %do_swap ], [ %last_swap, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after_inner:
  %is_zero = icmp eq i64 %last_swap, 0
  br i1 %is_zero, label %ret, label %outer.cont

outer.cont:
  %new_upper = add i64 %last_swap, 0
  br label %outer.header

ret:
  ret void
}