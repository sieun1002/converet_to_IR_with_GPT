; ModuleID = 'merge_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: merge_sort  ; Address: 0x11E9
; Intent: Stable in-place merge sort (ascending) on i32 array using auxiliary buffer (confidence=0.95). Evidence: malloc n*4 buffer; iterative doubling runs with merge; final memcpy back if needed
; Preconditions: If %n > 1, %dest must reference at least %n contiguous i32 elements; malloc may fail (function becomes no-op)
; Postconditions: On success, %dest[0..n) is sorted non-decreasingly

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8* nocapture)
declare i8* @memcpy(i8*, i8*, i64)

define dso_local void @merge_sort(i32* %dest, i64 %n) local_unnamed_addr {
entry:
  %cmp_le1 = icmp ule i64 %n, 1
  br i1 %cmp_le1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %buf8 = call noalias i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %buf8, null
  br i1 %isnull, label %ret, label %init

init:
  %buf = bitcast i8* %buf8 to i32*
  br label %outer

outer:
  %run = phi i64 [ 1, %init ], [ %run2, %after_inner ]
  %src = phi i32* [ %dest, %init ], [ %tmp2, %after_inner ]
  %tmp = phi i32* [ %buf, %init ], [ %src2, %after_inner ]
  %cond_run = icmp ult i64 %run, %n
  br i1 %cond_run, label %inner_header, label %outer_done

inner_header:
  %base = phi i64 [ 0, %outer ], [ %base_next, %after_merge ]
  %cont_inner = icmp ult i64 %base, %n
  br i1 %cont_inner, label %merge_prep, label %after_inner

merge_prep:
  %left = add i64 %base, 0
  %t1 = add i64 %base, %run
  %mid = select i1 (icmp ule i64 %t1, %n), i64 %t1, i64 %n
  %two_run = add i64 %run, %run
  %t2 = add i64 %base, %two_run
  %right = select i1 (icmp ule i64 %t2, %n), i64 %t2, i64 %n
  br label %merge_loop

merge_loop:
  %i = phi i64 [ %left, %merge_prep ], [ %i_next, %emit ]
  %j = phi i64 [ %mid, %merge_prep ], [ %j_next, %emit ]
  %k = phi i64 [ %left, %merge_prep ], [ %k_next, %emit ]
  %cond_k = icmp ult i64 %k, %right
  br i1 %cond_k, label %choose, label %after_merge

choose:
  %cond_i = icmp ult i64 %i, %mid
  br i1 %cond_i, label %ci_true, label %take_right

ci_true:
  %cond_j = icmp ult i64 %j, %right
  br i1 %cond_j, label %both_true, label %take_left

both_true:
  %left_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %right_val = load i32, i32* %right_ptr, align 4
  %gt = icmp sgt i32 %left_val, %right_val
  br i1 %gt, label %take_right, label %take_left

take_left:
  %val_l_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %val_l = load i32, i32* %val_l_ptr, align 4
  %i_inc = add i64 %i, 1
  br label %emit

take_right:
  %val_r_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %val_r = load i32, i32* %val_r_ptr, align 4
  %j_inc = add i64 %j, 1
  br label %emit

emit:
  %i_next = phi i64 [ %i_inc, %take_left ], [ %i, %take_right ]
  %j_next = phi i64 [ %j, %take_left ], [ %j_inc, %take_right ]
  %val = phi i32 [ %val_l, %take_left ], [ %val_r, %take_right ]
  %tmp_k_ptr = getelementptr inbounds i32, i32* %tmp, i64 %k
  store i32 %val, i32* %tmp_k_ptr, align 4
  %k_next = add i64 %k, 1
  br label %merge_loop

after_merge:
  %base_next = add i64 %base, %two_run
  br label %inner_header

after_inner:
  ; swap src and tmp; double run
  %src2 = phi i32* [ %tmp, %inner_header ]
  %tmp2 = phi i32* [ %src, %inner_header ]
  %run2 = shl i64 %run, 1
  br label %outer

outer_done:
  %src_ne = icmp ne i32* %src, %dest
  br i1 %src_ne, label %do_memcpy, label %free_then_ret

do_memcpy:
  %nb = shl i64 %n, 2
  %dest8 = bitcast i32* %dest to i8*
  %src8 = bitcast i32* %src to i8*
  %_ = call i8* @memcpy(i8* %dest8, i8* %src8, i64 %nb)
  br label %free_then_ret

free_then_ret:
  call void @free(i8* %buf8)
  br label %ret

ret:
  ret void
}