; ModuleID = 'merge_sort.ll'
target triple = "x86_64-unknown-linux-gnu"

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  ; if (n <= 1) return;
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %alloc

alloc:
  %bytes = shl i64 %n, 2
  %tmpbuf.i8 = call i8* @malloc(i64 %bytes)
  %tmpbuf = bitcast i8* %tmpbuf.i8 to i32*
  %isnull = icmp eq i32* %tmpbuf, null
  br i1 %isnull, label %ret, label %init

init:
  %src.init = %dest
  %tmp.init = %tmpbuf
  br label %outer_check

outer_check:
  %src.cur = phi i32* [ %src.init, %init ], [ %src.next, %pass_done ]
  %tmp.cur = phi i32* [ %tmp.init, %init ], [ %tmp.next, %pass_done ]
  %run.cur = phi i64 [ 1, %init ], [ %run.next, %pass_done ]
  %cond_outer = icmp ult i64 %run.cur, %n
  br i1 %cond_outer, label %pass_start, label %after_outer

pass_start:
  %i.start = add i64 0, 0
  br label %pass_loop

pass_loop:
  %i.cur = phi i64 [ %i.start, %pass_start ], [ %i.next, %pass_inc ]
  %cond_pass = icmp ult i64 %i.cur, %n
  br i1 %cond_pass, label %merge_prep, label %pass_done

merge_prep:
  ; start = i.cur
  %start = add i64 %i.cur, 0
  ; mid = min(i + run, n)
  %i_plus_run = add i64 %i.cur, %run.cur
  %cmp_mid_over = icmp ugt i64 %i_plus_run, %n
  %mid = select i1 %cmp_mid_over, i64 %n, i64 %i_plus_run
  ; end = min(i + 2*run, n)
  %two_run = shl i64 %run.cur, 1
  %i_plus_two_run = add i64 %i.cur, %two_run
  %cmp_end_over = icmp ugt i64 %i_plus_two_run, %n
  %end = select i1 %cmp_end_over, i64 %n, i64 %i_plus_two_run
  ; li = start, ri = mid, di = start
  br label %merge_loop

merge_loop:
  %li = phi i64 [ %start, %merge_prep ], [ %li.next, %after_store ]
  %ri = phi i64 [ %mid,   %merge_prep ], [ %ri.next, %after_store ]
  %di = phi i64 [ %start, %merge_prep ], [ %di.next, %after_store ]
  ; while (di < end)
  %cond_merge = icmp ult i64 %di, %end
  br i1 %cond_merge, label %choose, label %pass_inc

choose:
  ; if (li < mid)
  %cond_li = icmp ult i64 %li, %mid
  br i1 %cond_li, label %check_ri, label %take_right_direct

check_ri:
  ; if (ri < end)
  %cond_ri = icmp ult i64 %ri, %end
  br i1 %cond_ri, label %compare_vals, label %take_left

compare_vals:
  ; load left = src[li], right = src[ri]
  %left.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %right.ptr = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %left.val = load i32, i32* %left.ptr, align 4
  %right.val = load i32, i32* %right.ptr, align 4
  ; if (left > right) take right else take left (signed compare)
  %cmp_gt = icmp sgt i32 %left.val, %right.val
  br i1 %cmp_gt, label %take_right_loaded, label %take_left_loaded

take_left:
  ; left = src[li]
  %left.ptr2 = getelementptr inbounds i32, i32* %src.cur, i64 %li
  %left.val2 = load i32, i32* %left.ptr2, align 4
  br label %store_left

take_left_loaded:
  br label %store_left

store_left:
  ; merge value = left, li++
  %left.final = phi i32 [ %left.val2, %take_left ], [ %left.val, %take_left_loaded ]
  %out.ptrL = getelementptr inbounds i32, i32* %tmp.cur, i64 %di
  store i32 %left.final, i32* %out.ptrL, align 4
  %li.next = add i64 %li, 1
  br label %after_store

take_right_direct:
  ; ri >= end or li >= mid implies take right (here li >= mid)
  ; right = src[ri]
  %right.ptr2 = getelementptr inbounds i32, i32* %src.cur, i64 %ri
  %right.val2 = load i32, i32* %right.ptr2, align 4
  br label %store_right

take_right_loaded:
  ; use right.val loaded earlier
  br label %store_right

store_right:
  %right.final = phi i32 [ %right.val2, %take_right_direct ], [ %right.val, %take_right_loaded ]
  %out.ptrR = getelementptr inbounds i32, i32* %tmp.cur, i64 %di
  store i32 %right.final, i32* %out.ptrR, align 4
  %ri.next = add i64 %ri, 1
  br label %after_store

after_store:
  %li.phi = phi i64 [ %li.next, %store_left ], [ %li, %store_right ]
  %ri.phi = phi i64 [ %ri, %store_left ], [ %ri.next, %store_right ]
  %di.next = add i64 %di, 1
  br label %merge_loop

pass_inc:
  ; i += 2*run
  %i.next = add i64 %i.cur, %two_run
  br label %pass_loop

pass_done:
  ; swap src and tmp, run <<= 1
  %src.next = %tmp.cur
  %tmp.next = %src.cur
  %run.next = shl i64 %run.cur, 1
  br label %outer_check

after_outer:
  ; if (src.cur != dest) memcpy(dest, src.cur, n*4)
  %need_copy = icmp ne i32* %src.cur, %dest
  br i1 %need_copy, label %do_copy, label %do_free

do_copy:
  %dest.i8 = bitcast i32* %dest to i8*
  %src.i8 = bitcast i32* %src.cur to i8*
  %bytes2 = shl i64 %n, 2
  call i8* @memcpy(i8* %dest.i8, i8* %src.i8, i64 %bytes2)
  br label %do_free

do_free:
  call void @free(i8* %tmpbuf.i8)
  br label %ret

ret:
  ret void
}