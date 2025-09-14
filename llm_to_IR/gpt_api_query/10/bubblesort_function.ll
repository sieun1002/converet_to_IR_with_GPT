; ModuleID = 'bubble_sort'
source_filename = "bubble_sort"

define dso_local void @bubble_sort(i32* %arr, i64 %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %outer.cond

outer.cond:
  %limit = phi i64 [ %n, %entry ], [ %last, %outer.update ]
  %cmp1 = icmp ugt i64 %limit, 1
  br i1 %cmp1, label %inner.cond, label %ret

inner.cond:
  %j = phi i64 [ 1, %outer.cond ], [ %j.next, %inner.inc ]
  %last.phi = phi i64 [ 0, %outer.cond ], [ %last.next, %inner.inc ]
  %cmpj = icmp ult i64 %j, %limit
  br i1 %cmpj, label %inner.body, label %inner.exit

inner.body:
  %jm1 = add i64 %j, -1
  %a.ptr = getelementptr inbounds i32, i32* %arr, i64 %jm1
  %b.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %a = load i32, i32* %a.ptr, align 4
  %b = load i32, i32* %b.ptr, align 4
  %gt = icmp sgt i32 %a, %b
  br i1 %gt, label %do.swap, label %no.swap

do.swap:
  store i32 %b, i32* %a.ptr, align 4
  store i32 %a, i32* %b.ptr, align 4
  br label %inner.inc

no.swap:
  br label %inner.inc

inner.inc:
  %last.next = phi i64 [ %j, %do.swap ], [ %last.phi, %no.swap ]
  %j.next = add i64 %j, 1
  br label %inner.cond

inner.exit:
  %noswap = icmp eq i64 %last.phi, 0
  br i1 %noswap, label %ret, label %outer.update

outer.update:
  %last = phi i64 [ %last.phi, %inner.exit ]
  br label %outer.cond

ret:
  ret void
}