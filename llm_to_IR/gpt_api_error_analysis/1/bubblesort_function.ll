; ModuleID = 'bubble_sort.ll'
source_filename = "bubble_sort"

define void @bubble_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %return, label %init

init:
  br label %outer.header

outer.header:
  %bound = phi i64 [ %n, %init ], [ %last, %update.bound ]
  %cond_outer = icmp ugt i64 %bound, 1
  br i1 %cond_outer, label %outer.body, label %return

outer.body:
  br label %inner.header

inner.header:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inner.latch ]
  %last = phi i64 [ 0, %outer.body ], [ %last.updated, %inner.latch ]
  %cond_inner = icmp ult i64 %i, %bound
  br i1 %cond_inner, label %inner.body, label %after.inner

inner.body:
  %im1 = add i64 %i, -1
  %ptr_im1 = getelementptr inbounds i32, i32* %arr, i64 %im1
  %a = load i32, i32* %ptr_im1, align 4
  %ptr_i = getelementptr inbounds i32, i32* %arr, i64 %i
  %b = load i32, i32* %ptr_i, align 4
  %cmp_gt = icmp sgt i32 %a, %b
  br i1 %cmp_gt, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %ptr_im1, align 4
  store i32 %a, i32* %ptr_i, align 4
  br label %inner.latch

no.swap:
  br label %inner.latch

inner.latch:
  %last.updated = select i1 %cmp_gt, i64 %i, i64 %last
  %i.next = add i64 %i, 1
  br label %inner.header

after.inner:
  %had.swap = icmp ne i64 %last, 0
  br i1 %had.swap, label %update.bound, label %return

update.bound:
  br label %outer.header

return:
  ret void
}