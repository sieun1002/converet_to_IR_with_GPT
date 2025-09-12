; ModuleID = 'heap_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: heap_sort ; Address: 0x1189
; Intent: In-place heapsort (ascending) of a 32-bit int array (confidence=0.99). Evidence: 0-based heap ops (child=2*i+1), sift-down, swap with end and shrink heap.
; Preconditions: arr points to at least n 32-bit integers (if n > 0).
; Postconditions: arr[0..n-1] sorted in non-decreasing order.

; Only the necessary external declarations:

define dso_local void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp.n.le1 = icmp ule i64 %n, 1
  br i1 %cmp.n.le1, label %ret, label %build_init

build_init:                                        ; build heap: i from (n>>1)-1 downto 0
  %half = lshr i64 %n, 1
  br label %build_loop

build_loop:
  %i = phi i64 [ %half, %build_init ], [ %i.dec, %after_sift_build ]
  %i.eq0 = icmp eq i64 %i, 0
  br i1 %i.eq0, label %extract_init, label %pre_sift_build

pre_sift_build:
  %j0 = add i64 %i, -1
  br label %sift_build

sift_build:
  %j = phi i64 [ %j0, %pre_sift_build ], [ %j.next, %did_swap_build ]
  %t = shl i64 %j, 1
  %child = add i64 %t, 1
  %child.ge.n = icmp uge i64 %child, %n
  br i1 %child.ge.n, label %after_sift_build, label %child_bound_build

child_bound_build:
  %right = add i64 %child, 1
  %right.lt.n = icmp ult i64 %right, %n
  br i1 %right.lt.n, label %cmp_children_build, label %choose_child_build

cmp_children_build:
  %gep.right = getelementptr inbounds i32, i32* %arr, i64 %right
  %right.val = load i32, i32* %gep.right, align 4
  %gep.child = getelementptr inbounds i32, i32* %arr, i64 %child
  %child.val = load i32, i32* %gep.child, align 4
  %right.gt.child = icmp sgt i32 %right.val, %child.val
  %max.child = select i1 %right.gt.child, i64 %right, i64 %child
  br label %choose_child_build

choose_child_build:
  %chosen = phi i64 [ %max.child, %cmp_children_build ], [ %child, %child_bound_build ]
  %gep.j = getelementptr inbounds i32, i32* %arr, i64 %j
  %j.val = load i32, i32* %gep.j, align 4
  %gep.chosen = getelementptr inbounds i32, i32* %arr, i64 %chosen
  %chosen.val = load i32, i32* %gep.chosen, align 4
  %parent.ge.child = icmp sge i32 %j.val, %chosen.val
  br i1 %parent.ge.child, label %after_sift_build, label %do_swap_build

do_swap_build:
  store i32 %chosen.val, i32* %gep.j, align 4
  store i32 %j.val, i32* %gep.chosen, align 4
  %j.next = add i64 %chosen, 0
  br label %did_swap_build

did_swap_build:
  br label %sift_build

after_sift_build:
  %i.dec = add i64 %i, -1
  br label %build_loop

extract_init:                                      ; extraction phase: last from n-1 downto 1
  %last0 = add i64 %n, -1
  br label %extract_loop

extract_loop:
  %last = phi i64 [ %last0, %extract_init ], [ %last.dec, %after_sift_ext ]
  %last.ne0 = icmp ne i64 %last, 0
  br i1 %last.ne0, label %swap_root_last, label %ret

swap_root_last:
  %root.ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root.val = load i32, i32* %root.ptr, align 4
  %last.ptr = getelementptr inbounds i32, i32* %arr, i64 %last
  %last.val = load i32, i32* %last.ptr, align 4
  store i32 %last.val, i32* %root.ptr, align 4
  store i32 %root.val, i32* %last.ptr, align 4
  br label %sift_ext

sift_ext:
  %j2 = phi i64 [ 0, %swap_root_last ], [ %j2.next, %did_swap_ext ]
  %t2 = shl i64 %j2, 1
  %child2 = add i64 %t2, 1
  %child.ge.last = icmp uge i64 %child2, %last
  br i1 %child.ge.last, label %after_sift_ext, label %child_bound_ext

child_bound_ext:
  %right2 = add i64 %child2, 1
  %right.lt.last = icmp ult i64 %right2, %last
  br i1 %right.lt.last, label %cmp_children_ext, label %choose_child_ext

cmp_children_ext:
  %gep.right2 = getelementptr inbounds i32, i32* %arr, i64 %right2
  %right.val2 = load i32, i32* %gep.right2, align 4
  %gep.child2 = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child.val2 = load i32, i32* %gep.child2, align 4
  %right.gt.child2 = icmp sgt i32 %right.val2, %child.val2
  %max.child2 = select i1 %right.gt.child2, i64 %right2, i64 %child2
  br label %choose_child_ext

choose_child_ext:
  %chosen2 = phi i64 [ %max.child2, %cmp_children_ext ], [ %child2, %child_bound_ext ]
  %gep.j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j.val2 = load i32, i32* %gep.j2, align 4
  %gep.chosen2 = getelementptr inbounds i32, i32* %arr, i64 %chosen2
  %chosen.val2 = load i32, i32* %gep.chosen2, align 4
  %parent.ge.child2 = icmp sge i32 %j.val2, %chosen.val2
  br i1 %parent.ge.child2, label %after_sift_ext, label %do_swap_ext

do_swap_ext:
  store i32 %chosen.val2, i32* %gep.j2, align 4
  store i32 %j.val2, i32* %gep.chosen2, align 4
  %j2.next = add i64 %chosen2, 0
  br label %did_swap_ext

did_swap_ext:
  br label %sift_ext

after_sift_ext:
  %last.dec = add i64 %last, -1
  br label %extract_loop

ret:
  ret void
}