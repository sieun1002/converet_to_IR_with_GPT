; ModuleID = 'bubble_sort.ll'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @bubble_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %outer.preheader

outer.preheader:
  br label %outer

outer:
  %bound = phi i64 [ %n, %outer.preheader ], [ %nextBound, %set.bound ]
  %cmp_bound = icmp ugt i64 %bound, 1
  br i1 %cmp_bound, label %inner.preheader, label %ret

inner.preheader:
  br label %inner

inner:
  %i = phi i64 [ 1, %inner.preheader ], [ %i.next, %cont ]
  %last = phi i64 [ 0, %inner.preheader ], [ %last.next, %cont ]
  %cmp_i = icmp ult i64 %i, %bound
  br i1 %cmp_i, label %inner.body, label %outer.latch

inner.body:
  %im1 = add i64 %i, -1
  %p_prev = getelementptr inbounds i32, i32* %arr, i64 %im1
  %prev = load i32, i32* %p_prev, align 4
  %p_curr = getelementptr inbounds i32, i32* %arr, i64 %i
  %curr = load i32, i32* %p_curr, align 4
  %gt = icmp sgt i32 %prev, %curr
  br i1 %gt, label %do.swap, label %no.swap

do.swap:
  store i32 %curr, i32* %p_prev, align 4
  store i32 %prev, i32* %p_curr, align 4
  br label %cont

no.swap:
  br label %cont

cont:
  %last.updated = phi i64 [ %i, %do.swap ], [ %last, %no.swap ]
  %i.next = add i64 %i, 1
  %last.next = %last.updated
  br label %inner

outer.latch:
  %last.exit = phi i64 [ %last, %inner ]
  %no_swaps = icmp eq i64 %last.exit, 0
  br i1 %no_swaps, label %ret, label %set.bound

set.bound:
  %nextBound = trunc i64 %last.exit to i64
  br label %outer

ret:
  ret void
}