; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

define dso_local void @quick_sort(i32* %a, i64 %left, i64 %right) local_unnamed_addr {
entry:
  br label %outer.head

outer.head:
  %l = phi i64 [ %left, %entry ], [ %l.next, %after.recurse ]
  %r = phi i64 [ %right, %entry ], [ %r.next, %after.recurse ]
  %cmp.lr = icmp slt i64 %l, %r
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:
  %diff = sub i64 %r, %l
  %half = sdiv i64 %diff, 2
  %mid = add i64 %l, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %a, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %inner.top

inner.top:
  %i.cur = phi i64 [ %l, %partition.init ], [ %i.after, %inner.cont ]
  %j.cur = phi i64 [ %r, %partition.init ], [ %j.after, %inner.cont ]
  br label %i.scan.loop

i.scan.loop:
  %i.scan.i = phi i64 [ %i.cur, %inner.top ], [ %i.inc, %i.inc.block ]
  %a_i_ptr = getelementptr inbounds i32, i32* %a, i64 %i.scan.i
  %a_i = load i32, i32* %a_i_ptr, align 4
  %cmp_i = icmp slt i32 %a_i, %pivot
  br i1 %cmp_i, label %i.inc.block, label %j.scan.entry

i.inc.block:
  %i.inc = add i64 %i.scan.i, 1
  br label %i.scan.loop

j.scan.entry:
  br label %j.scan.loop

j.scan.loop:
  %j.scan.j = phi i64 [ %j.cur, %j.scan.entry ], [ %j.dec, %j.dec.block ]
  %a_j_ptr = getelementptr inbounds i32, i32* %a, i64 %j.scan.j
  %a_j = load i32, i32* %a_j_ptr, align 4
  %cmp_j = icmp sgt i32 %a_j, %pivot
  br i1 %cmp_j, label %j.dec.block, label %check.swap

j.dec.block:
  %j.dec = add i64 %j.scan.j, -1
  br label %j.scan.loop

check.swap:
  %cmp_ij = icmp sle i64 %i.scan.i, %j.scan.j
  br i1 %cmp_ij, label %do.swap, label %partition.decide

do.swap:
  %tmp_i = load i32, i32* %a_i_ptr, align 4
  %tmp_j = load i32, i32* %a_j_ptr, align 4
  store i32 %tmp_j, i32* %a_i_ptr, align 4
  store i32 %tmp_i, i32* %a_j_ptr, align 4
  %i.after = add i64 %i.scan.i, 1
  %j.after = add i64 %j.scan.j, -1
  br label %inner.cont

inner.cont:
  br label %inner.top

partition.decide:
  %left_len = sub i64 %j.scan.j, %l
  %right_len = sub i64 %r, %i.scan.i
  %cmp_sizes = icmp sge i64 %left_len, %right_len
  br i1 %cmp_sizes, label %right.first, label %left.first

left.first:
  %cmp_lj = icmp slt i64 %l, %j.scan.j
  br i1 %cmp_lj, label %call.left, label %skip.left

call.left:
  call void @quick_sort(i32* %a, i64 %l, i64 %j.scan.j)
  br label %skip.left

skip.left:
  br label %after.recurse

right.first:
  %cmp_ir = icmp slt i64 %i.scan.i, %r
  br i1 %cmp_ir, label %call.right, label %skip.right

call.right:
  call void @quick_sort(i32* %a, i64 %i.scan.i, i64 %r)
  br label %skip.right

skip.right:
  br label %after.recurse

after.recurse:
  %l.next = phi i64 [ %i.scan.i, %skip.left ], [ %l, %skip.right ]
  %r.next = phi i64 [ %r, %skip.left ], [ %j.scan.j, %skip.right ]
  br label %outer.head

ret:
  ret void
}