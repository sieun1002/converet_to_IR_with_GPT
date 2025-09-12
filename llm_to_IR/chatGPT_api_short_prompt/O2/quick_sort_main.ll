; ModuleID = 'quick_sort'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: quick_sort ; Address: 0x0000000000001240
; Intent: In-place quicksort of a 32-bit int array between inclusive indices [lo..hi] (confidence=0.96). Evidence: median pivot, Hoare partition, tail-recursion on larger side.
; Preconditions: arr != NULL; 0 <= lo <= hi within array bounds.
; Postconditions: arr[lo..hi] sorted ascending.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)

define dso_local void @quick_sort(i32* nocapture %arr, i64 %lo, i64 %hi) local_unnamed_addr {
entry:
  %cmp.entry = icmp sge i64 %lo, %hi
  br i1 %cmp.entry, label %ret, label %loop

loop:                                             ; while-range loop (tail-recursion elimination)
  %cur_lo = phi i64 [ %lo, %entry ], [ %new_lo, %after_tail ]
  %cur_hi = phi i64 [ %hi, %entry ], [ %new_hi, %after_tail ]
  %cont = icmp sgt i64 %cur_hi, %cur_lo
  br i1 %cont, label %partition_setup, label %ret

partition_setup:
  %diff = sub i64 %cur_hi, %cur_lo
  %half = ashr i64 %diff, 1
  %mid = add i64 %cur_lo, %half
  %midptr = getelementptr inbounds i32, i32* %arr, i64 %mid
  %pivot = load i32, i32* %midptr, align 4
  br label %part_init

part_init:                                        ; initialize/continue partition with i0,j0
  %i0 = phi i64 [ %cur_lo, %partition_setup ], [ %i_next, %do_swap ]
  %j0 = phi i64 [ %cur_hi, %partition_setup ], [ %j_next, %do_swap ]
  br label %scan_i

scan_i:                                           ; while (arr[i] < pivot) i++;
  %i = phi i64 [ %i0, %part_init ], [ %i_inc, %i_inc_b ]
  %iptr = getelementptr inbounds i32, i32* %arr, i64 %i
  %iv = load i32, i32* %iptr, align 4
  %cmp_i = icmp slt i32 %iv, %pivot
  br i1 %cmp_i, label %i_inc_b, label %scan_j

i_inc_b:
  %i_inc = add nsw i64 %i, 1
  br label %scan_i

scan_j:                                           ; while (pivot < arr[j]) j--;
  %j = phi i64 [ %j0, %scan_i ], [ %j_dec, %j_dec_b ]
  %jptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %jv = load i32, i32* %jptr, align 4
  %cmp_j = icmp slt i32 %pivot, %jv
  br i1 %cmp_j, label %j_dec_b, label %after_both

j_dec_b:
  %j_dec = add nsw i64 %j, -1
  br label %scan_j

after_both:                                       ; if (i <= j) swap(arr[i], arr[j]); i++; j--;
  %le = icmp sle i64 %i, %j
  br i1 %le, label %do_swap, label %after_partition

do_swap:
  store i32 %jv, i32* %iptr, align 4
  store i32 %iv, i32* %jptr, align 4
  %i_next = add nsw i64 %i, 1
  %j_next = add nsw i64 %j, -1
  br label %part_init

after_partition:                                   ; now i > j; recurse on smaller side, iterate on larger
  %left_has = icmp slt i64 %cur_lo, %j
  %right_has = icmp slt i64 %i, %cur_hi
  %left_len = sub i64 %j, %cur_lo
  %right_len = sub i64 %cur_hi, %i
  %choose_right_first = icmp sge i64 %left_len, %right_len
  br i1 %choose_right_first, label %right_first, label %left_first

right_first:                                      ; recurse right (smaller/equal), iterate left
  br i1 %right_has, label %call_right, label %skip_right

call_right:
  call void @quick_sort(i32* %arr, i64 %i, i64 %cur_hi)
  br label %skip_right

skip_right:
  %new_lo_r = %cur_lo
  %new_hi_r = %j
  br label %after_tail

left_first:                                       ; recurse left (smaller), iterate right
  br i1 %left_has, label %call_left, label %skip_left

call_left:
  call void @quick_sort(i32* %arr, i64 %cur_lo, i64 %j)
  br label %skip_left

skip_left:
  %new_lo_l = %i
  %new_hi_l = %cur_hi
  br label %after_tail

after_tail:
  %new_lo = phi i64 [ %new_lo_r, %skip_right ], [ %new_lo_l, %skip_left ]
  %new_hi = phi i64 [ %new_hi_r, %skip_right ], [ %new_hi_l, %skip_left ]
  br label %loop

ret:
  ret void
}