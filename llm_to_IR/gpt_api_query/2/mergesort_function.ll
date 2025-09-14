; LLVM 14 IR for function: merge_sort
; Signature: void merge_sort(int* dest, size_t n)

declare i8* @malloc(i64)
declare void @free(i8*)
declare i8* @memcpy(i8*, i8*, i64)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %src.addr = alloca i32*
  %tmp.addr = alloca i32*
  %run.addr = alloca i64
  %start.addr = alloca i64
  %left.addr = alloca i64
  %mid.addr = alloca i64
  %right.addr = alloca i64
  %i.addr = alloca i64
  %j.addr = alloca i64
  %k.addr = alloca i64
  %ptr.addr = alloca i8*

  %n_le_1 = icmp ule i64 %n, 1
  br i1 %n_le_1, label %ret, label %alloc

alloc:
  %sizeBytes = shl i64 %n, 2
  %ptr = call i8* @malloc(i64 %sizeBytes)
  store i8* %ptr, i8** %ptr.addr
  %null = icmp eq i8* %ptr, null
  br i1 %null, label %ret, label %init

init:
  %tmp_i32 = bitcast i8* %ptr to i32*
  store i32* %dest, i32** %src.addr
  store i32* %tmp_i32, i32** %tmp.addr
  store i64 1, i64* %run.addr
  br label %outer_check

outer_check:
  %run_val = load i64, i64* %run.addr
  %run_lt_n = icmp ult i64 %run_val, %n
  br i1 %run_lt_n, label %outer_body, label %after_outer

outer_body:
  store i64 0, i64* %start.addr
  br label %inner_check

inner_check:
  %start_val = load i64, i64* %start.addr
  %start_lt_n = icmp ult i64 %start_val, %n
  br i1 %start_lt_n, label %inner_setup, label %after_inner

inner_setup:
  ; left = start
  store i64 %start_val, i64* %left.addr

  ; mid = min(start + run, n)
  %run_val2 = load i64, i64* %run.addr
  %mid_sum = add i64 %start_val, %run_val2
  %mid_sum_le_n = icmp ule i64 %mid_sum, %n
  %mid_sel = select i1 %mid_sum_le_n, i64 %mid_sum, i64 %n
  store i64 %mid_sel, i64* %mid.addr

  ; right = min(start + 2*run, n)
  %two_run = add i64 %run_val2, %run_val2
  %right_sum = add i64 %start_val, %two_run
  %right_sum_le_n = icmp ule i64 %right_sum, %n
  %right_sel = select i1 %right_sum_le_n, i64 %right_sum, i64 %n
  store i64 %right_sel, i64* %right.addr

  ; i = left; j = mid; k = left
  store i64 %start_val, i64* %i.addr
  store i64 %mid_sel, i64* %j.addr
  store i64 %start_val, i64* %k.addr

  br label %merge_check

merge_check:
  %k_val = load i64, i64* %k.addr
  %right_val = load i64, i64* %right.addr
  %k_lt_right = icmp ult i64 %k_val, %right_val
  br i1 %k_lt_right, label %choose, label %after_merge

choose:
  %i_val = load i64, i64* %i.addr
  %mid_val = load i64, i64* %mid.addr
  %i_lt_mid = icmp ult i64 %i_val, %mid_val
  br i1 %i_lt_mid, label %maybe_left, label %take_right

maybe_left:
  %j_val = load i64, i64* %j.addr
  %right_val2 = load i64, i64* %right.addr
  %j_ge_right = icmp uge i64 %j_val, %right_val2
  br i1 %j_ge_right, label %take_left, label %cmp_values

cmp_values:
  %srcptr = load i32*, i32** %src.addr
  %ivptr = getelementptr inbounds i32, i32* %srcptr, i64 %i_val
  %ival = load i32, i32* %ivptr, align 4
  %jvptr = getelementptr inbounds i32, i32* %srcptr, i64 %j_val
  %jval = load i32, i32* %jvptr, align 4
  %le_ij = icmp sle i32 %ival, %jval
  br i1 %le_ij, label %take_left, label %take_right

take_left:
  ; tmp[k] = src[i]; i++
  %i_cur = load i64, i64* %i.addr
  %srcptr2 = load i32*, i32** %src.addr
  %ivptr2 = getelementptr inbounds i32, i32* %srcptr2, i64 %i_cur
  %ival2 = load i32, i32* %ivptr2, align 4
  %tmpptr = load i32*, i32** %tmp.addr
  %outptr = getelementptr inbounds i32, i32* %tmpptr, i64 %k_val
  store i32 %ival2, i32* %outptr, align 4
  %i_next = add i64 %i_cur, 1
  store i64 %i_next, i64* %i.addr
  br label %inc_k

take_right:
  ; tmp[k] = src[j]; j++
  %j_cur = load i64, i64* %j.addr
  %srcptr3 = load i32*, i32** %src.addr
  %jptr2 = getelementptr inbounds i32, i32* %srcptr3, i64 %j_cur
  %jval2 = load i32, i32* %jptr2, align 4
  %tmpptr2 = load i32*, i32** %tmp.addr
  %outptr2 = getelementptr inbounds i32, i32* %tmpptr2, i64 %k_val
  store i32 %jval2, i32* %outptr2, align 4
  %j_next = add i64 %j_cur, 1
  store i64 %j_next, i64* %j.addr
  br label %inc_k

inc_k:
  %k_now = load i64, i64* %k.addr
  %k_next = add i64 %k_now, 1
  store i64 %k_next, i64* %k.addr
  br label %merge_check

after_merge:
  ; start += 2*run
  %run_now = load i64, i64* %run.addr
  %two_run2 = add i64 %run_now, %run_now
  %start_now = load i64, i64* %start.addr
  %start_next = add i64 %start_now, %two_run2
  store i64 %start_next, i64* %start.addr
  br label %inner_check

after_inner:
  ; swap src and tmp
  %src_cur = load i32*, i32** %src.addr
  %tmp_cur = load i32*, i32** %tmp.addr
  store i32* %tmp_cur, i32** %src.addr
  store i32* %src_cur, i32** %tmp.addr
  ; run <<= 1
  %run_cur = load i64, i64* %run.addr
  %run_next = shl i64 %run_cur, 1
  store i64 %run_next, i64* %run.addr
  br label %outer_check

after_outer:
  %src_final = load i32*, i32** %src.addr
  %src_eq_dest = icmp eq i32* %src_final, %dest
  br i1 %src_eq_dest, label %do_free, label %do_copy

do_copy:
  %bytes = shl i64 %n, 2
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src_final to i8*
  call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %bytes)
  br label %do_free

do_free:
  %ptr_alloc = load i8*, i8** %ptr.addr
  call void @free(i8* %ptr_alloc)
  br label %ret

ret:
  ret void
}