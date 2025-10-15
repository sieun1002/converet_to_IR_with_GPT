; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.ll"
target triple = "x86_64-unknown-linux-gnu"

define void @bubble_sort(i32* nocapture %a, i64 %n) local_unnamed_addr {
entry:
  %cmp.init = icmp ule i64 %n, 1
  br i1 %cmp.init, label %ret, label %outer.setup

outer.setup:
  br label %outer.cond

outer.cond:
  %limit = phi i64 [ %n, %outer.setup ], [ %last_swap.end, %outer.iter.end ]
  %cmp.limit = icmp ugt i64 %limit, 1
  br i1 %cmp.limit, label %inner.init, label %ret

inner.init:
  br label %inner.cond

inner.cond:
  %j = phi i64 [ 1, %inner.init ], [ %j.next, %inner.body.end ]
  %last_swap = phi i64 [ 0, %inner.init ], [ %last.next, %inner.body.end ]
  %cond.inner = icmp ult i64 %j, %limit
  br i1 %cond.inner, label %inner.body, label %inner.end

inner.body:
  %j.minus1 = add i64 %j, -1
  %ptr1 = getelementptr inbounds i32, i32* %a, i64 %j.minus1
  %ptr2 = getelementptr inbounds i32, i32* %a, i64 %j
  %val1 = load i32, i32* %ptr1, align 4
  %val2 = load i32, i32* %ptr2, align 4
  %cmp.swap = icmp sgt i32 %val1, %val2
  br i1 %cmp.swap, label %do.swap, label %no.swap

do.swap:
  store i32 %val2, i32* %ptr1, align 4
  store i32 %val1, i32* %ptr2, align 4
  br label %inner.body.end

no.swap:
  br label %inner.body.end

inner.body.end:
  %last.next = phi i64 [ %j, %do.swap ], [ %last_swap, %no.swap ]
  %j.next = add i64 %j, 1
  br label %inner.cond

inner.end:
  %last.zero = icmp eq i64 %last_swap, 0
  br i1 %last.zero, label %ret, label %outer.iter.end

outer.iter.end:
  %last_swap.end = phi i64 [ %last_swap, %inner.end ]
  br label %outer.cond

ret:
  ret void
}