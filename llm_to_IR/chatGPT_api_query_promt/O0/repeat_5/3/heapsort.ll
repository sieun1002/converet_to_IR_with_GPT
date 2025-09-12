; ModuleID = 'heap_sort.ll'
source_filename = "heap_sort"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %ret, label %build.init

build.init:                                        ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.cond

build.cond:                                        ; preds = %build.after_inner, %build.init
  %i = phi i64 [ %half, %build.init ], [ %i.next, %build.after_inner ]
  %cond = icmp ne i64 %i, 0
  br i1 %cond, label %build.body, label %sort.init

build.body:                                        ; preds = %build.cond
  %j0 = add i64 %i, -1
  br label %build.inner.head

build.inner.head:                                  ; preds = %build.inner.swap, %build.body
  %j = phi i64 [ %j0, %build.body ], [ %j.next, %build.inner.swap ]
  %t1 = shl i64 %j, 1
  %l = add i64 %t1, 1
  %l_ge_n = icmp uge i64 %l, %n
  br i1 %l_ge_n, label %build.after_inner, label %build.choose_child

build.choose_child:                                ; preds = %build.inner.head
  %r = add i64 %l, 1
  %r_lt_n = icmp ult i64 %r, %n
  %l.ptr = getelementptr inbounds i32, i32* %arr, i64 %l
  %l.val = load i32, i32* %l.ptr, align 4
  br i1 %r_lt_n, label %build.compare_children, label %build.child_is_l

build.compare_children:                            ; preds = %build.choose_child
  %r.ptr = getelementptr inbounds i32, i32* %arr, i64 %r
  %r.val = load i32, i32* %r.ptr, align 4
  %r_gt_l = icmp sgt i32 %r.val, %l.val
  br i1 %r_gt_l, label %build.child_is_r, label %build.child_is_l

build.child_is_r:                                  ; preds = %build.compare_children
  br label %build.have_child

build.child_is_l:                                  ; preds = %build.compare_children, %build.choose_child
  br label %build.have_child

build.have_child:                                  ; preds = %build.child_is_l, %build.child_is_r
  %c = phi i64 [ %r, %build.child_is_r ], [ %l, %build.child_is_l ]
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %j.ptr, align 4
  %c.ptr = getelementptr inbounds i32, i32* %arr, i64 %c
  %c.val = load i32, i32* %c.ptr, align 4
  %ge = icmp sge i32 %j.val, %c.val
  br i1 %ge, label %build.after_inner, label %build.inner.swap

build.inner.swap:                                  ; preds = %build.have_child
  store i32 %c.val, i32* %j.ptr, align 4
  store i32 %j.val, i32* %c.ptr, align 4
  %j.next = add i64 %c, 0
  br label %build.inner.head

build.after_inner:                                 ; preds = %build.have_child, %build.inner.head
  %i.next = add i64 %i, -1
  br label %build.cond

sort.init:                                         ; preds = %build.cond
  %last0 = add i64 %n, -1
  br label %sort.cond

sort.cond:                                         ; preds = %sort.after_inner, %sort.init
  %last = phi i64 [ %last0, %sort.init ], [ %last.dec, %sort.after_inner ]
  %last.ne.zero = icmp ne i64 %last, 0
  br i1 %last.ne.zero, label %sort.outer.body, label %ret

sort.outer.body:                                   ; preds = %sort.cond
  %a0ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %a0 = load i32, i32* %a0ptr, align 4
  %alptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %al = load i32, i32* %alptr, align 4
  store i32 %al, i32* %a0ptr, align 4
  store i32 %a0, i32* %alptr, align 4
  br label %sort.inner.head

sort.inner.head:                                   ; preds = %sort.inner.swap, %sort.outer.body
  %j2 = phi i64 [ 0, %sort.outer.body ], [ %j2.next, %sort.inner.swap ]
  %t2 = shl i64 %j2, 1
  %l2 = add i64 %t2, 1
  %l2_ge_last = icmp uge i64 %l2, %last
  br i1 %l2_ge_last, label %sort.after_inner, label %sort.choose_child

sort.choose_child:                                 ; preds = %sort.inner.head
  %r2 = add i64 %l2, 1
  %r2_lt_last = icmp ult i64 %r2, %last
  %l2.ptr = getelementptr inbounds i32, i32* %arr, i64 %l2
  %l2.val = load i32, i32* %l2.ptr, align 4
  br i1 %r2_lt_last, label %sort.compare_children, label %sort.child_is_l

sort.compare_children:                             ; preds = %sort.choose_child
  %r2.ptr = getelementptr inbounds i32, i32* %arr, i64 %r2
  %r2.val = load i32, i32* %r2.ptr, align 4
  %r2_gt_l2 = icmp sgt i32 %r2.val, %l2.val
  br i1 %r2_gt_l2, label %sort.child_is_r, label %sort.child_is_l

sort.child_is_r:                                   ; preds = %sort.compare_children
  br label %sort.have_child

sort.child_is_l:                                   ; preds = %sort.compare_children, %sort.choose_child
  br label %sort.have_child

sort.have_child:                                   ; preds = %sort.child_is_l, %sort.child_is_r
  %c2 = phi i64 [ %r2, %sort.child_is_r ], [ %l2, %sort.child_is_l ]
  %j2.ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2.val = load i32, i32* %j2.ptr, align 4
  %c2.ptr = getelementptr inbounds i32, i32* %arr, i64 %c2
  %c2.val = load i32, i32* %c2.ptr, align 4
  %ge2 = icmp sge i32 %j2.val, %c2.val
  br i1 %ge2, label %sort.after_inner, label %sort.inner.swap

sort.inner.swap:                                   ; preds = %sort.have_child
  store i32 %c2.val, i32* %j2.ptr, align 4
  store i32 %j2.val, i32* %c2.ptr, align 4
  %j2.next = add i64 %c2, 0
  br label %sort.inner.head

sort.after_inner:                                  ; preds = %sort.have_child, %sort.inner.head
  %last.dec = add i64 %last, -1
  br label %sort.cond

ret:                                               ; preds = %sort.cond, %entry
  ret void
}