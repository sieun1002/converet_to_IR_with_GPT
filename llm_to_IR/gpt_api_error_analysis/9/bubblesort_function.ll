; ModuleID = 'bubble_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define void @bubble_sort(i32* %a, i64 %n) {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %exit, label %outer_preheader

outer_preheader:
  br label %outer_header

outer_header:
  %limit = phi i64 [ %n, %outer_preheader ], [ %last, %after_inner ]
  %cmp.limit.gt1 = icmp ugt i64 %limit, 1
  br i1 %cmp.limit.gt1, label %outer_body_init, label %exit

outer_body_init:
  br label %inner_header

inner_header:
  %i = phi i64 [ 1, %outer_body_init ], [ %i.next, %cont ]
  %last = phi i64 [ 0, %outer_body_init ], [ %last.updated, %cont ]
  %cmp.i.lt.limit = icmp ult i64 %i, %limit
  br i1 %cmp.i.lt.limit, label %inner_body, label %after_inner

inner_body:
  %i.minus.1 = add i64 %i, -1
  %ptr.prev = getelementptr inbounds i32, i32* %a, i64 %i.minus.1
  %val.prev = load i32, i32* %ptr.prev, align 4
  %ptr.i = getelementptr inbounds i32, i32* %a, i64 %i
  %val.i = load i32, i32* %ptr.i, align 4
  %cmp.swap = icmp sgt i32 %val.prev, %val.i
  br i1 %cmp.swap, label %do_swap, label %no_swap

do_swap:
  store i32 %val.i, i32* %ptr.prev, align 4
  store i32 %val.prev, i32* %ptr.i, align 4
  br label %cont

no_swap:
  br label %cont

cont:
  %last.updated = phi i64 [ %i, %do_swap ], [ %last, %no_swap ]
  %i.next = add i64 %i, 1
  br label %inner_header

after_inner:
  %last.eq.zero = icmp eq i64 %last, 0
  br i1 %last.eq.zero, label %exit, label %outer_header

exit:
  ret void
}