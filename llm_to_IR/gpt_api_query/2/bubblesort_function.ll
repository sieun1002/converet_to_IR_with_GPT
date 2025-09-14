; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @bubble_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp = icmp ule i64 %n, 1
  br i1 %cmp, label %exit, label %outer.loop

outer.loop:
  %bound = phi i64 [ %n, %entry ], [ %newbound, %outer.latch ]
  %condb = icmp ugt i64 %bound, 1
  br i1 %condb, label %inner.init, label %exit

inner.init:
  br label %inner

inner:
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.end ]
  %last = phi i64 [ 0, %inner.init ], [ %last.next, %inner.end ]
  %idx.prev = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %arr, i64 %idx.prev
  %prev = load i32, i32* %ptr.prev, align 4
  %ptr.cur = getelementptr inbounds i32, i32* %arr, i64 %i
  %cur = load i32, i32* %ptr.cur, align 4
  %gt = icmp sgt i32 %prev, %cur
  br i1 %gt, label %swap, label %noswap

swap:
  store i32 %cur, i32* %ptr.prev, align 4
  store i32 %prev, i32* %ptr.cur, align 4
  br label %inner.end

noswap:
  br label %inner.end

inner.end:
  %last.next = phi i64 [ %i, %swap ], [ %last, %noswap ]
  %i.next = add i64 %i, 1
  %cont = icmp ult i64 %i.next, %bound
  br i1 %cont, label %inner, label %after.inner

after.inner:
  %no_swaps = icmp eq i64 %last.next, 0
  br i1 %no_swaps, label %exit, label %outer.latch

outer.latch:
  %newbound = phi i64 [ %last.next, %after.inner ]
  br label %outer.loop

exit:
  ret void
}