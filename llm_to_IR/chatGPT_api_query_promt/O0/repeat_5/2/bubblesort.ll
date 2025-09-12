; ModuleID = 'bubble_sort'
source_filename = "bubble_sort.ll"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %exit, label %outer.header.pre

outer.header.pre:
  br label %outer.header

outer.header:
  %bound = phi i64 [ %n, %outer.header.pre ], [ %last.out, %after.inner.next ]
  %cond = icmp ugt i64 %bound, 1
  br i1 %cond, label %outer.body, label %exit

outer.body:
  br label %inner

inner:
  %i = phi i64 [ 1, %outer.body ], [ %i.next, %inc ]
  %last = phi i64 [ 0, %outer.body ], [ %last.next, %inc ]
  %cmp_i = icmp ult i64 %i, %bound
  br i1 %cmp_i, label %inner.body, label %after.inner

inner.body:
  %im1 = add i64 %i, -1
  %a.ptr = getelementptr inbounds i32, i32* %arr, i64 %im1
  %b.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %a.val = load i32, i32* %a.ptr, align 4
  %b.val = load i32, i32* %b.ptr, align 4
  %gt = icmp sgt i32 %a.val, %b.val
  br i1 %gt, label %do.swap, label %no.swap

do.swap:
  store i32 %b.val, i32* %a.ptr, align 4
  store i32 %a.val, i32* %b.ptr, align 4
  br label %inc.swap

no.swap:
  br label %inc.noswap

inc.swap:
  br label %inc

inc.noswap:
  br label %inc

inc:
  %last.next = phi i64 [ %i, %inc.swap ], [ %last, %inc.noswap ]
  %i.next = add i64 %i, 1
  br label %inner

after.inner:
  %last.out = phi i64 [ %last, %inner ]
  %no_swaps = icmp eq i64 %last.out, 0
  br i1 %no_swaps, label %exit, label %after.inner.next

after.inner.next:
  br label %outer.header

exit:
  ret void
}