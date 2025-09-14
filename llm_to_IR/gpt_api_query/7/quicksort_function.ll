; ModuleID = 'quick_sort_module'
source_filename = "quick_sort.ll"

define void @quick_sort(i32* %arr, i64 %low, i64 %high) {
entry:
  br label %head

head:
  %low.phi = phi i64 [ %low, %entry ], [ %low.new, %cont ], [ %low.new2, %cont2 ]
  %high.phi = phi i64 [ %high, %entry ], [ %high.new, %cont ], [ %high.new2, %cont2 ]
  %cmp.init = icmp slt i64 %low.phi, %high.phi
  br i1 %cmp.init, label %partition, label %ret

partition:
  ; i = low, j = high
  %i0 = %low.phi
  %j0 = %high.phi
  ; mid = low + ashr(( (high - low) + lshr(high-low,63) ),1)
  %delta = sub i64 %high.phi, %low.phi
  %sign = lshr i64 %delta, 63
  %delta.adj = add i64 %delta, %sign
  %half = ashr i64 %delta.adj, 1
  %mid = add i64 %low.phi, %half
  ; pivot = arr[mid]
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %inc_i

inc_i:
  %i.cur = phi i64 [ %i0, %partition ], [ %i.inc, %inc_i.cont ], [ %i.next, %do_swap ]
  %j.seed = phi i64 [ %j0, %partition ], [ %j.keep, %inc_i.cont ], [ %j.next, %do_swap ]
  %ai.ptr = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %ai = load i32, i32* %ai.ptr, align 4
  %cmp.i = icmp slt i32 %ai, %pivot
  br i1 %cmp.i, label %inc_i.cont, label %dec_j

inc_i.cont:
  %i.inc = add i64 %i.cur, 1
  %j.keep = %j.seed
  br label %inc_i

dec_j:
  %j.cur = phi i64 [ %j.seed, %inc_i ], [ %j.dec, %dec_j.cont ]
  %aj.ptr = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %aj = load i32, i32* %aj.ptr, align 4
  %cmp.j = icmp sgt i32 %aj, %pivot
  br i1 %cmp.j, label %dec_j.cont, label %check_swap

dec_j.cont:
  %j.dec = add i64 %j.cur, -1
  br label %dec_j

check_swap:
  %le.ij = icmp sle i64 %i.cur, %j.cur
  br i1 %le.ij, label %do_swap, label %after_partition

do_swap:
  %ai.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %aj.ptr2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %ai.val2 = load i32, i32* %ai.ptr2, align 4
  %aj.val2 = load i32, i32* %aj.ptr2, align 4
  store i32 %aj.val2, i32* %ai.ptr2, align 4
  store i32 %ai.val2, i32* %aj.ptr2, align 4
  %i.next = add i64 %i.cur, 1
  %j.next = add i64 %j.cur, -1
  %le.ij2 = icmp sle i64 %i.next, %j.next
  br i1 %le.ij2, label %inc_i, label %after_partition_from_swap

after_partition_from_swap:
  br label %after_partition

after_partition:
  %i.out = phi i64 [ %i.cur, %check_swap ], [ %i.next, %after_partition_from_swap ]
  %j.out = phi i64 [ %j.cur, %check_swap ], [ %j.next, %after_partition_from_swap ]
  %left.size = sub i64 %j.out, %low.phi
  %right.size = sub i64 %high.phi, %i.out
  %left.lt.right = icmp slt i64 %left.size, %right.size
  br i1 %left.lt.right, label %left_path, label %right_path

left_path:
  %do.left.cond = icmp slt i64 %low.phi, %j.out
  br i1 %do.left.cond, label %do_left_call, label %skip_left_call

do_left_call:
  call void @quick_sort(i32* %arr, i64 %low.phi, i64 %j.out)
  br label %after_left_call

skip_left_call:
  br label %after_left_call

after_left_call:
  %low.new = %i.out
  %high.new = %high.phi
  br label %cont

cont:
  br label %head

right_path:
  %do.right.cond = icmp slt i64 %i.out, %high.phi
  br i1 %do.right.cond, label %do_right_call, label %skip_right_call

do_right_call:
  call void @quick_sort(i32* %arr, i64 %i.out, i64 %high.phi)
  br label %after_right_call

skip_right_call:
  br label %after_right_call

after_right_call:
  %low.new2 = %low.phi
  %high.new2 = %j.out
  br label %cont2

cont2:
  br label %head

ret:
  ret void
}