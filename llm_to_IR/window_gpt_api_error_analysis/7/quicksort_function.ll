; ModuleID = 'quick_sort_module'
source_filename = "quick_sort_module"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* %arr, i32 %left, i32 %right) {
entry:
  br label %outer.header

outer.header:                                      ; preds = %outer.update, %entry
  %l = phi i32 [ %left, %entry ], [ %new_left, %outer.update ]
  %r = phi i32 [ %right, %entry ], [ %new_right, %outer.update ]
  %cmp.lr = icmp slt i32 %l, %r
  br i1 %cmp.lr, label %outer.body, label %ret

outer.body:                                        ; preds = %outer.header
  %i0 = add i32 %l, 0
  %j0 = add i32 %r, 0
  %diff = sub nsw i32 %r, %l
  %half = sdiv i32 %diff, 2
  %mid = add nsw i32 %l, %half
  %mid64 = sext i32 %mid to i64
  %mid.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid64
  %pivot = load i32, i32* %mid.ptr, align 4
  br label %i.scan

i.scan:                                            ; preds = %do_swap, %i.inc, %outer.body
  %i.cur = phi i32 [ %i0, %outer.body ], [ %i.next, %i.inc ], [ %i.after_swap, %do_swap ]
  %j.start = phi i32 [ %j0, %outer.body ], [ %j.start, %i.inc ], [ %j.after_swap, %do_swap ]
  %i.idx64 = sext i32 %i.cur to i64
  %i.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %i.val = load i32, i32* %i.ptr, align 4
  %cmp.i = icmp slt i32 %i.val, %pivot
  br i1 %cmp.i, label %i.inc, label %j.scan.entry

i.inc:                                             ; preds = %i.scan
  %i.next = add nsw i32 %i.cur, 1
  br label %i.scan

j.scan.entry:                                      ; preds = %i.scan
  br label %j.scan

j.scan:                                            ; preds = %j.dec, %j.scan.entry
  %j.cur = phi i32 [ %j.start, %j.scan.entry ], [ %j.next, %j.dec ]
  %i.fixed = phi i32 [ %i.cur, %j.scan.entry ], [ %i.fixed, %j.dec ]
  %j.idx64 = sext i32 %j.cur to i64
  %j.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.idx64
  %j.val = load i32, i32* %j.ptr, align 4
  %cmp.j = icmp sgt i32 %j.val, %pivot
  br i1 %cmp.j, label %j.dec, label %check.swap

j.dec:                                             ; preds = %j.scan
  %j.next = add nsw i32 %j.cur, -1
  br label %j.scan

check.swap:                                        ; preds = %j.scan
  %le.ij = icmp sle i32 %i.fixed, %j.cur
  br i1 %le.ij, label %do_swap, label %partition.done

do_swap:                                           ; preds = %check.swap
  %i.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %i.idx64
  %val.i = load i32, i32* %i.ptr.swap, align 4
  %j.idx64.swap = sext i32 %j.cur to i64
  %j.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %j.idx64.swap
  %val.j = load i32, i32* %j.ptr.swap, align 4
  store i32 %val.j, i32* %i.ptr.swap, align 4
  store i32 %val.i, i32* %j.ptr.swap, align 4
  %i.after_swap = add nsw i32 %i.fixed, 1
  %j.after_swap = add nsw i32 %j.cur, -1
  br label %i.scan

partition.done:                                    ; preds = %check.swap
  br label %post.partition

post.partition:                                    ; preds = %partition.done
  %left.size = sub nsw i32 %j.cur, %l
  %right.size = sub nsw i32 %r, %i.fixed
  %choose.left = icmp slt i32 %left.size, %right.size
  br i1 %choose.left, label %left.branch, label %right.branch

left.branch:                                       ; preds = %post.partition
  %need.left = icmp slt i32 %l, %j.cur
  br i1 %need.left, label %call.left, label %skip.left

call.left:                                         ; preds = %left.branch
  call void @quick_sort(i32* %arr, i32 %l, i32 %j.cur)
  br label %skip.left

skip.left:                                         ; preds = %call.left, %left.branch
  br label %outer.update

right.branch:                                      ; preds = %post.partition
  %need.right = icmp slt i32 %i.fixed, %r
  br i1 %need.right, label %call.right, label %skip.right

call.right:                                        ; preds = %right.branch
  call void @quick_sort(i32* %arr, i32 %i.fixed, i32 %r)
  br label %skip.right

skip.right:                                        ; preds = %call.right, %right.branch
  br label %outer.update

outer.update:                                      ; preds = %skip.right, %skip.left
  %new_left = phi i32 [ %i.fixed, %skip.left ], [ %l, %skip.right ]
  %new_right = phi i32 [ %r, %skip.left ], [ %j.cur, %skip.right ]
  br label %outer.header

ret:                                               ; preds = %outer.header
  ret void
}