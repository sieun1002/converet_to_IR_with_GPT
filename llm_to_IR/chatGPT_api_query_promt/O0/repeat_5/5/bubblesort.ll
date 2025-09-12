; ModuleID = 'bubble_sort'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.header

outer.header:
  %last = phi i64 [ %n, %entry ], [ %swapped.end, %outer.latch ]
  %gt1 = icmp ugt i64 %last, 1
  br i1 %gt1, label %inner.init, label %ret

inner.init:
  br label %inner.loop

inner.loop:
  %i = phi i64 [ 1, %inner.init ], [ %i.next, %inner.update ]
  %swapped = phi i64 [ 0, %inner.init ], [ %swapped.next, %inner.update ]
  %cond = icmp ult i64 %i, %last
  br i1 %cond, label %inner.body, label %inner.exit

inner.body:
  %i.minus1 = sub i64 %i, 1
  %a.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.minus1
  %b.ptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %a = load i32, i32* %a.ptr, align 4
  %b = load i32, i32* %b.ptr, align 4
  %gt = icmp sgt i32 %a, %b
  br i1 %gt, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %a.ptr, align 4
  store i32 %a, i32* %b.ptr, align 4
  br label %inner.update

no.swap:
  br label %inner.update

inner.update:
  %swapped.next = phi i64 [ %i, %do.swap ], [ %swapped, %no.swap ]
  %i.next = add i64 %i, 1
  br label %inner.loop

inner.exit:
  %swapped.end = phi i64 [ %swapped, %inner.loop ]
  %none = icmp eq i64 %swapped.end, 0
  br i1 %none, label %ret, label %outer.latch

outer.latch:
  br label %outer.header

ret:
  ret void
}