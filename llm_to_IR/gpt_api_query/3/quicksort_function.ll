; ModuleID = 'quick_sort_module'
source_filename = "quick_sort_module"

define dso_local void @quick_sort(i32* %arr, i64 %left, i64 %right) {
entry:
  br label %outer_check

outer_check: ; while (l < r)
  %l.cur = phi i64 [ %left, %entry ], [ %l.next2, %while_cont ]
  %r.cur = phi i64 [ %right, %entry ], [ %r.next2, %while_cont ]
  %haswork = icmp slt i64 %l.cur, %r.cur
  br i1 %haswork, label %partition_init, label %return

partition_init:
  ; i = l, j = r
  ; pivot = arr[l + (r - l)/2]
  %diff = sub i64 %r.cur, %l.cur
  %half = sdiv i64 %diff, 2
  %mid = add i64 %l.cur, %half
  %pivot.ptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %pivot.ptr, align 4
  br label %scan_i_entry

scan_i_entry:
  %i.init = phi i64 [ %l.cur, %partition_init ], [ %i.next, %do_swap ]
  %j.carry = phi i64 [ %r.cur, %partition_init ], [ %j.next, %do_swap ]
  br label %scan_i

scan_i: ; while (arr[i] < pivot) i++
  %i = phi i64 [ %i.init, %scan_i_entry ], [ %i.inc, %scan_i_inc ]
  %pi = getelementptr inbounds i32, i32* %arr, i64 %i
  %vi = load i32, i32* %pi, align 4
  %cmp_i = icmp slt i32 %vi, %pivot
  br i1 %cmp_i, label %scan_i_inc, label %scan_i_done

scan_i_inc:
  %i.inc = add i64 %i, 1
  br label %scan_i

scan_i_done:
  br label %scan_j

scan_j: ; while (arr[j] > pivot) j--
  %i.pass = phi i64 [ %i, %scan_i_done ], [ %i.pass, %scan_j_dec ]
  %j = phi i64 [ %j.carry, %scan_i_done ], [ %j.dec, %scan_j_dec ]
  %pj = getelementptr inbounds i32, i32* %arr, i64 %j
  %vj = load i32, i32* %pj, align 4
  %cmp_j = icmp sgt i32 %vj, %pivot
  br i1 %cmp_j, label %scan_j_dec, label %after_scans

scan_j_dec:
  %j.dec = add i64 %j, -1
  br label %scan_j

after_scans:
  %i.cur = phi i64 [ %i.pass, %scan_j ]
  %j.cur = phi i64 [ %j, %scan_j ]
  %ij_cmp = icmp sle i64 %i.cur, %j.cur
  br i1 %ij_cmp, label %do_swap, label %partition_break

do_swap:
  ; swap arr[i.cur] and arr[j.cur]
  %pi2 = getelementptr inbounds i32, i32* %arr, i64 %i.cur
  %pj2 = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %vi2 = load i32, i32* %pi2, align 4
  %vj2 = load i32, i32* %pj2, align 4
  store i32 %vj2, i32* %pi2, align 4
  store i32 %vi2, i32* %pj2, align 4
  %i.next = add i64 %i.cur, 1
  %j.next = add i64 %j.cur, -1
  br label %scan_i_entry

partition_break:
  ; decide which side to recurse on (smaller first)
  %left_len = sub i64 %j.cur, %l.cur
  %right_len = sub i64 %r.cur, %i.cur
  %left_smaller = icmp slt i64 %left_len, %right_len
  br i1 %left_smaller, label %recurse_left, label %recurse_right

recurse_left:
  ; if (l < j) quick_sort(arr, l, j)
  %nonempty_left = icmp slt i64 %l.cur, %j.cur
  br i1 %nonempty_left, label %do_recurse_left, label %skip_recurse_left

do_recurse_left:
  call void @quick_sort(i32* %arr, i64 %l.cur, i64 %j.cur)
  br label %skip_recurse_left

skip_recurse_left:
  ; left = i, right unchanged
  %l.next2 = %i.cur
  %r.next2 = %r.cur
  br label %while_cont

recurse_right:
  ; if (i < r) quick_sort(arr, i, r)
  %nonempty_right = icmp slt i64 %i.cur, %r.cur
  br i1 %nonempty_right, label %do_recurse_right, label %skip_recurse_right

do_recurse_right:
  call void @quick_sort(i32* %arr, i64 %i.cur, i64 %r.cur)
  br label %skip_recurse_right

skip_recurse_right:
  ; right = j, left unchanged
  %l.next2.r = %l.cur
  %r.next2.r = %j.cur
  br label %while_cont

while_cont:
  %l.next2 = phi i64 [ %l.next2, %skip_recurse_left ], [ %l.next2.r, %skip_recurse_right ]
  %r.next2 = phi i64 [ %r.next2, %skip_recurse_left ], [ %r.next2.r, %skip_recurse_right ]
  br label %outer_check

return:
  ret void
}