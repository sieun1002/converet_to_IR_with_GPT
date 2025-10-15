; ModuleID = 'quicksort_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @quick_sort(i32* nocapture %arr, i32 %left, i32 %right) local_unnamed_addr {
entry:
  br label %outer.cond

outer.cond:                                       ; preds = %outer.iter.end, %entry
  %left.cur = phi i32 [ %left, %entry ], [ %left.out, %outer.iter.end ]
  %right.cur = phi i32 [ %right, %entry ], [ %right.out, %outer.iter.end ]
  %cmp.lr = icmp slt i32 %left.cur, %right.cur
  br i1 %cmp.lr, label %partition.init, label %ret

partition.init:                                   ; preds = %outer.cond
  %diff = sub i32 %right.cur, %left.cur
  %half = sdiv i32 %diff, 2
  %mid = add i32 %left.cur, %half
  %mid.ext = sext i32 %mid to i64
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid.ext
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %partition.loop.header

partition.loop.header:                            ; preds = %swap.next, %partition.init
  %l.phi = phi i32 [ %left.cur, %partition.init ], [ %l.next, %swap.next ]
  %r.phi = phi i32 [ %right.cur, %partition.init ], [ %r.next, %swap.next ]
  br label %l.scan

l.scan:                                           ; preds = %l.inc, %partition.loop.header
  %l.cur = phi i32 [ %l.phi, %partition.loop.header ], [ %l.inc.val, %l.inc ]
  %l.idx.ext = sext i32 %l.cur to i64
  %l.ptr = getelementptr inbounds i32, i32* %arr, i64 %l.idx.ext
  %l.val = load i32, i32* %l.ptr, align 4
  %cmp.l = icmp slt i32 %l.val, %pivot
  br i1 %cmp.l, label %l.inc, label %l.done

l.inc:                                            ; preds = %l.scan
  %l.inc.val = add i32 %l.cur, 1
  br label %l.scan

l.done:                                           ; preds = %l.scan
  br label %r.scan

r.scan:                                           ; preds = %r.dec, %l.done
  %r.cur = phi i32 [ %r.phi, %l.done ], [ %r.dec.val, %r.dec ]
  %r.idx.ext = sext i32 %r.cur to i64
  %r.ptr = getelementptr inbounds i32, i32* %arr, i64 %r.idx.ext
  %r.val = load i32, i32* %r.ptr, align 4
  %cmp.r = icmp sgt i32 %r.val, %pivot
  br i1 %cmp.r, label %r.dec, label %r.done

r.dec:                                            ; preds = %r.scan
  %r.dec.val = add i32 %r.cur, -1
  br label %r.scan

r.done:                                           ; preds = %r.scan
  %cmp.le = icmp sle i32 %l.cur, %r.cur
  br i1 %cmp.le, label %do.swap, label %partition.after

do.swap:                                          ; preds = %r.done
  %l.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %l.idx.ext
  %r.ptr.swap = getelementptr inbounds i32, i32* %arr, i64 %r.idx.ext
  %l.load.swap = load i32, i32* %l.ptr.swap, align 4
  %r.load.swap = load i32, i32* %r.ptr.swap, align 4
  store i32 %r.load.swap, i32* %l.ptr.swap, align 4
  store i32 %l.load.swap, i32* %r.ptr.swap, align 4
  br label %swap.next

swap.next:                                        ; preds = %do.swap
  %l.next = add i32 %l.cur, 1
  %r.next = add i32 %r.cur, -1
  br label %partition.loop.header

partition.after:                                  ; preds = %r.done
  %left.span = sub i32 %r.cur, %left.cur
  %right.span = sub i32 %right.cur, %l.cur
  %cmp.span = icmp slt i32 %left.span, %right.span
  br i1 %cmp.span, label %left.smaller, label %right.smaller

left.smaller:                                     ; preds = %partition.after
  %cmp.call.left = icmp slt i32 %left.cur, %r.cur
  br i1 %cmp.call.left, label %recurse.left, label %skip.left

recurse.left:                                     ; preds = %left.smaller
  call void @quick_sort(i32* %arr, i32 %left.cur, i32 %r.cur)
  br label %skip.left

skip.left:                                        ; preds = %recurse.left, %left.smaller
  %left.out.l = add i32 %l.cur, 0
  %right.out.l = add i32 %right.cur, 0
  br label %outer.iter.end

right.smaller:                                    ; preds = %partition.after
  %cmp.call.right = icmp slt i32 %l.cur, %right.cur
  br i1 %cmp.call.right, label %recurse.right, label %skip.right

recurse.right:                                    ; preds = %right.smaller
  call void @quick_sort(i32* %arr, i32 %l.cur, i32 %right.cur)
  br label %skip.right

skip.right:                                       ; preds = %recurse.right, %right.smaller
  %left.out.r = add i32 %left.cur, 0
  %right.out.r = add i32 %r.cur, 0
  br label %outer.iter.end

outer.iter.end:                                   ; preds = %skip.right, %skip.left
  %left.out = phi i32 [ %left.out.l, %skip.left ], [ %left.out.r, %skip.right ]
  %right.out = phi i32 [ %right.out.l, %skip.left ], [ %right.out.r, %skip.right ]
  br label %outer.cond

ret:                                              ; preds = %outer.cond
  ret void
}