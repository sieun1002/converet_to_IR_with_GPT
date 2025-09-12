; LLVM 14 IR for function: merge_sort
; Signature inferred from calling convention:
; void merge_sort(int32_t* dest, uint64_t n)

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  ; if (n <= 1) return;
  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %alloc

alloc:
  %size = shl i64 %n, 2
  %tmp_raw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmp_raw, null
  br i1 %isnull, label %ret, label %cont

cont:
  %tmp = bitcast i8* %tmp_raw to i32*
  br label %outer

outer:
  %width = phi i64 [ 1, %cont ], [ %width2, %after_inner ]
  %src   = phi i32* [ %dest, %cont ], [ %src2, %after_inner ]
  %buf   = phi i32* [ %tmp,  %cont ], [ %buf2, %after_inner ]
  ; while (width < n)
  %outer_cond = icmp ult i64 %width, %n
  br i1 %outer_cond, label %outer_body, label %after_sort

outer_body:
  br label %inner

inner:
  %base = phi i64 [ 0, %outer_body ], [ %base_next, %merge_done ]
  ; if (base >= n) break;
  %inner_cond = icmp ult i64 %base, %n
  br i1 %inner_cond, label %calc_bounds, label %after_inner

calc_bounds:
  %left_start = %base
  %mid_raw = add i64 %base, %width
  %mid_lt_n = icmp ult i64 %mid_raw, %n
  %mid = select i1 %mid_lt_n, i64 %mid_raw, i64 %n

  %twowidth = shl i64 %width, 1
  %right_raw = add i64 %base, %twowidth
  %right_lt_n = icmp ult i64 %right_raw, %n
  %right_end = select i1 %right_lt_n, i64 %right_raw, i64 %n

  %i.init = %left_start
  %j.init = %mid
  %k.init = %left_start
  br label %merge

merge:
  %i = phi i64 [ %i.init, %calc_bounds ], [ %i.next, %take_left ], [ %i, %take_right ]
  %j = phi i64 [ %j.init, %calc_bounds ], [ %j, %take_left ], [ %j.next, %take_right ]
  %k = phi i64 [ %k.init, %calc_bounds ], [ %k.next, %take_left ], [ %k.next2, %take_right ]
  ; while (k < right_end)
  %k_lt_end = icmp ult i64 %k, %right_end
  br i1 %k_lt_end, label %choose, label %merge_done

choose:
  ; if (i < mid)
  %i_lt_mid = icmp ult i64 %i, %mid
  br i1 %i_lt_mid, label %check_j, label %take_right

check_j:
  ; if (j < right_end)
  %j_lt_end = icmp ult i64 %j, %right_end
  br i1 %j_lt_end, label %compare_lr, label %take_left

compare_lr:
  ; load left and right values and compare (signed)
  %left_ptr = getelementptr inbounds i32, i32* %src, i64 %i
  %left_val = load i32, i32* %left_ptr, align 4
  %right_ptr = getelementptr inbounds i32, i32* %src, i64 %j
  %right_val = load i32, i32* %right_ptr, align 4
  %left_le_right = icmp sle i32 %left_val, %right_val
  br i1 %left_le_right, label %take_left, label %take_right

take_left:
  ; value to store: from compare_lr or load (when j >= right_end)
  %left_val.sel = phi i32 [ %left_val, %compare_lr ], [ %left_val.load, %check_j ]
  %buf_k_ptr = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %left_val.sel, i32* %buf_k_ptr, align 4
  %i.next = add i64 %i, 1
  %k.next = add i64 %k, 1
  br label %merge

left_val.load:
  %left_ptr2 = getelementptr inbounds i32, i32* %src, i64 %i
  %left_val.load = load i32, i32* %left_ptr2, align 4
  br label %take_left

take_right:
  ; value to store: from compare_lr or load (when i >= mid)
  %right_val.sel = phi i32 [ %right_val, %compare_lr ], [ %right_val.load, %choose ]
  %buf_k_ptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %right_val.sel, i32* %buf_k_ptr2, align 4
  %j.next = add i64 %j, 1
  %k.next2 = add i64 %k, 1
  br label %merge

right_val.load:
  %right_ptr2 = getelementptr inbounds i32, i32* %src, i64 %j
  %right_val.load = load i32, i32* %right_ptr2, align 4
  br label %take_right

merge_done:
  ; advance to next pair: base += 2*width
  %twowidth2 = shl i64 %width, 1
  %base_next = add i64 %base, %twowidth2
  br label %inner

after_inner:
  ; swap src and buf, width <<= 1
  %src2 = %buf
  %buf2 = %src
  %width2 = shl i64 %width, 1
  br label %outer

after_sort:
  ; if (src != dest) memcpy(dest, src, n*4)
  %src_i8 = bitcast i32* %src to i8*
  %dest_i8 = bitcast i32* %dest to i8*
  %ptr_ne = icmp ne i32* %src, %dest
  br i1 %ptr_ne, label %do_copy, label %after_copy

do_copy:
  call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %size)
  br label %after_copy

after_copy:
  call void @free(i8* %tmp_raw)
  br label %ret

ret:
  ret void
}