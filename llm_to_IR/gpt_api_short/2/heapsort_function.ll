; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heap sort of int array ascending (confidence=0.99). Evidence: build-heap using n>>1 and sift-down with 2*i+1 children; extraction phase swapping root with end-1 and sifting within shrinking bound.
; Preconditions: arr points to at least n 32-bit integers.
; Postconditions: arr[0..n-1] sorted in nondecreasing order.

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build.loop.control.pre

build.loop.control.pre:                              ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.loop.control

build.loop.control:                                  ; preds = %build.after_bubble, %build.loop.control.pre
  %i.old = phi i64 [ %half, %build.loop.control.pre ], [ %i.dec, %build.after_bubble ]
  %i.dec = add i64 %i.old, -1
  %cond.has.iter = icmp ne i64 %i.old, 0
  br i1 %cond.has.iter, label %build.bubble.header, label %after.build

build.bubble.header:                                 ; preds = %build.loop.control
  br label %build.bubble

build.bubble:                                        ; preds = %build.swap.done, %build.bubble.header
  %k = phi i64 [ %i.dec, %build.bubble.header ], [ %child.sel, %build.swap.done ]
  %k.shl = shl i64 %k, 1
  %left = add i64 %k.shl, 1
  %has.left = icmp ult i64 %left, %n
  br i1 %has.left, label %build.choose.child, label %build.after_bubble

build.choose.child:                                  ; preds = %build.bubble
  %right = add i64 %left, 1
  %right.in = icmp ult i64 %right, %n
  %left.ptr = getelementptr inbounds i32, i32* %arr, i64 %left
  %left.val = load i32, i32* %left.ptr, align 4
  br i1 %right.in, label %build.cmp.right, label %build.use.left

build.cmp.right:                                     ; preds = %build.choose.child
  %right.ptr = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %right.ptr, align 4
  %right.gt.left = icmp sgt i32 %right.val, %left.val
  br i1 %right.gt.left, label %build.use.right, label %build.use.left

build.use.left:                                      ; preds = %build.cmp.right, %build.choose.child
  %child.idx.left = phi i64 [ %left, %build.choose.child ], [ %left, %build.cmp.right ]
  br label %build.child.ready

build.use.right:                                     ; preds = %build.cmp.right
  br label %build.child.ready

build.child.ready:                                   ; preds = %build.use.right, %build.use.left
  %child.sel = phi i64 [ %right, %build.use.right ], [ %child.idx.left, %build.use.left ]
  %parent.ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %child.ptr = getelementptr inbounds i32, i32* %arr, i64 %child.sel
  %parent.val = load i32, i32* %parent.ptr, align 4
  %child.val = load i32, i32* %child.ptr, align 4
  %parent.ge.child = icmp sge i32 %parent.val, %child.val
  br i1 %parent.ge.child, label %build.after_bubble, label %build.swap

build.swap:                                          ; preds = %build.child.ready
  store i32 %child.val, i32* %parent.ptr, align 4
  store i32 %parent.val, i32* %child.ptr, align 4
  br label %build.swap.done

build.swap.done:                                     ; preds = %build.swap
  br label %build.bubble

build.after_bubble:                                  ; preds = %build.child.ready, %build.bubble
  br label %build.loop.control

after.build:                                         ; preds = %build.loop.control
  %end.init = add i64 %n, -1
  br label %sort.loop.control

sort.loop.control:                                   ; preds = %after.sift, %after.build
  %end.cur = phi i64 [ %end.init, %after.build ], [ %end.dec, %after.sift ]
  %has.more = icmp ne i64 %end.cur, 0
  br i1 %has.more, label %sort.swap.root, label %ret

sort.swap.root:                                      ; preds = %sort.loop.control
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %end.ptr = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %end.val = load i32, i32* %end.ptr, align 4
  store i32 %end.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %end.ptr, align 4
  br label %sort.bubble

sort.bubble:                                         ; preds = %sort.swap.done, %sort.swap.root
  %ks = phi i64 [ 0, %sort.swap.root ], [ %child.sel.s, %sort.swap.done ]
  %ks.shl = shl i64 %ks, 1
  %left.s = add i64 %ks.shl, 1
  %has.left.s = icmp ult i64 %left.s, %end.cur
  br i1 %has.left.s, label %sort.choose.child, label %after.sift

sort.choose.child:                                   ; preds = %sort.bubble
  %right.s = add i64 %left.s, 1
  %right.in.s = icmp ult i64 %right.s, %end.cur
  %left.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %left.s
  %left.val.s = load i32, i32* %left.ptr.s, align 4
  br i1 %right.in.s, label %sort.cmp.right, label %sort.use.left

sort.cmp.right:                                      ; preds = %sort.choose.child
  %right.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %right.s
  %right.val.s = load i32, i32* %right.ptr.s, align 4
  %right.gt.left.s = icmp sgt i32 %right.val.s, %left.val.s
  br i1 %right.gt.left.s, label %sort.use.right, label %sort.use.left

sort.use.left:                                       ; preds = %sort.cmp.right, %sort.choose.child
  %child.idx.left.s = phi i64 [ %left.s, %sort.choose.child ], [ %left.s, %sort.cmp.right ]
  br label %sort.child.ready

sort.use.right:                                      ; preds = %sort.cmp.right
  br label %sort.child.ready

sort.child.ready:                                    ; preds = %sort.use.right, %sort.use.left
  %child.sel.s = phi i64 [ %right.s, %sort.use.right ], [ %child.idx.left.s, %sort.use.left ]
  %parent.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %ks
  %child.ptr.s = getelementptr inbounds i32, i32* %arr, i64 %child.sel.s
  %parent.val.s = load i32, i32* %parent.ptr.s, align 4
  %child.val.s = load i32, i32* %child.ptr.s, align 4
  %parent.ge.child.s = icmp sge i32 %parent.val.s, %child.val.s
  br i1 %parent.ge.child.s, label %after.sift, label %sort.swap

sort.swap:                                           ; preds = %sort.child.ready
  store i32 %child.val.s, i32* %parent.ptr.s, align 4
  store i32 %parent.val.s, i32* %child.ptr.s, align 4
  br label %sort.swap.done

sort.swap.done:                                      ; preds = %sort.swap
  br label %sort.bubble

after.sift:                                          ; preds = %sort.child.ready, %sort.bubble
  %end.dec = add i64 %end.cur, -1
  br label %sort.loop.control

ret:                                                 ; preds = %sort.loop.control, %entry
  ret void
}