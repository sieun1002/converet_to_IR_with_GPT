target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %exit, label %outer.pre

outer.pre:
  br label %outer.header

outer.header:
  %last = phi i64 [ %n, %outer.pre ], [ %lastswap, %after.inner.update ]
  %cmp_outer = icmp ugt i64 %last, 1
  br i1 %cmp_outer, label %outer.init, label %exit

outer.init:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.init ], [ %i.next, %inner.inc ]
  %lastswap = phi i64 [ 0, %outer.init ], [ %lastswap.next, %inner.inc ]
  %cmp_inner = icmp ult i64 %i, %last
  br i1 %cmp_inner, label %inner.body, label %after.inner

inner.body:
  %i.prev = sub i64 %i, 1
  %ptr.prev = getelementptr i32, i32* %arr, i64 %i.prev
  %ptr.cur = getelementptr i32, i32* %arr, i64 %i
  %a = load i32, i32* %ptr.prev
  %b = load i32, i32* %ptr.cur
  %cmp_swap = icmp sgt i32 %a, %b
  br i1 %cmp_swap, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %ptr.prev
  store i32 %a, i32* %ptr.cur
  br label %inner.inc

no.swap:
  br label %inner.inc

inner.inc:
  %lastswap.next = phi i64 [ %i, %do.swap ], [ %lastswap, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:
  %no.swap.any = icmp eq i64 %lastswap, 0
  br i1 %no.swap.any, label %exit, label %after.inner.update

after.inner.update:
  br label %outer.header

exit:
  ret void
}