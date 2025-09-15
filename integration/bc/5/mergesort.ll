; ModuleID = 'mergesort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1

; Function Attrs: sspstrong
define i32 @main() #0 {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.idx0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr.idx0, align 4
  %arr.idx1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %arr.idx1, align 4
  %arr.idx2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %arr.idx2, align 4
  %arr.idx3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %arr.idx3, align 4
  %arr.idx4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %arr.idx4, align 4
  %arr.idx5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %arr.idx5, align 4
  %arr.idx6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %arr.idx6, align 4
  %arr.idx7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %arr.idx7, align 4
  %arr.idx8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr.idx8, align 4
  %arr.idx9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %arr.idx9, align 4
  %base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  call void @merge_sort(i32* noundef %base, i64 noundef 10)
  br label %loop

loop:                                             ; preds = %body, %entry
  %i = phi i64 [ 0, %entry ], [ %inc, %body ]
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %body, label %after

body:                                             ; preds = %loop
  %elem.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i
  %val = load i32, i32* %elem.ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call.printf = call i32 (i8*, ...) @printf(i8* noundef %fmtptr, i32 noundef %val)
  %inc = add i64 %i, 1
  br label %loop

after:                                            ; preds = %loop
  %call.putchar = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8* noundef, ...)

declare i32 @putchar(i32 noundef)

define void @merge_sort(i32* %dest, i64 %n) {
entry:
  %cmp_n = icmp ule i64 %n, 1
  br i1 %cmp_n, label %ret, label %alloc

alloc:                                            ; preds = %entry
  %size = shl i64 %n, 2
  %tmpraw = call i8* @malloc(i64 %size)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %ret, label %init

init:                                             ; preds = %alloc
  %tmpbuf = bitcast i8* %tmpraw to i32*
  br label %outer

outer:                                            ; preds = %afterInner, %init
  %src = phi i32* [ %dest, %init ], [ %src_next, %afterInner ]
  %buf = phi i32* [ %tmpbuf, %init ], [ %buf_next, %afterInner ]
  %run = phi i64 [ 1, %init ], [ %run_next, %afterInner ]
  %cond_outer = icmp ult i64 %run, %n
  br i1 %cond_outer, label %outer_body, label %outer_end

outer_body:                                       ; preds = %outer_body_end, %outer
  %i = phi i64 [ 0, %outer ], [ %i_next, %outer_body_end ]
  %cond_i = icmp ult i64 %i, %n
  br i1 %cond_i, label %merge_prep, label %outer_body_done

merge_prep:                                       ; preds = %outer_body
  %mid_pre = add i64 %i, %run
  %mid_lt_n = icmp ult i64 %mid_pre, %n
  %mid = select i1 %mid_lt_n, i64 %mid_pre, i64 %n
  %run_twice_prep = shl i64 %run, 1
  %right_pre = add i64 %i, %run_twice_prep
  %right_lt_n = icmp ult i64 %right_pre, %n
  %right = select i1 %right_lt_n, i64 %right_pre, i64 %n
  br label %merge_loop

merge_loop:                                       ; preds = %merge_next, %merge_prep
  %k = phi i64 [ %i, %merge_prep ], [ %k_next, %merge_next ]
  %l = phi i64 [ %i, %merge_prep ], [ %l_next_phi, %merge_next ]
  %r = phi i64 [ %mid, %merge_prep ], [ %r_next_phi, %merge_next ]
  %k_lt_right = icmp ult i64 %k, %right
  br i1 %k_lt_right, label %choose, label %after_merge

choose:                                           ; preds = %merge_loop
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_right_avail, label %take_right_from_choose

check_right_avail:                                ; preds = %choose
  %r_lt_right = icmp ult i64 %r, %right
  br i1 %r_lt_right, label %cmp_values, label %take_left_from_check

cmp_values:                                       ; preds = %check_right_avail
  %l_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_cmp = load i32, i32* %l_ptr_cmp, align 4
  %r_ptr_cmp = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_cmp = load i32, i32* %r_ptr_cmp, align 4
  %le_cmp = icmp sle i32 %l_val_cmp, %r_val_cmp
  br i1 %le_cmp, label %take_left_from_cmp, label %take_right_from_cmp

take_left_from_check:                             ; preds = %check_right_avail
  %l_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_store1 = load i32, i32* %l_ptr_store1, align 4
  %dst_ptr1 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_store1, i32* %dst_ptr1, align 4
  %l_inc1 = add i64 %l, 1
  %k_inc1 = add i64 %k, 1
  br label %merge_next

take_left_from_cmp:                               ; preds = %cmp_values
  %l_ptr_store2 = getelementptr inbounds i32, i32* %src, i64 %l
  %l_val_store2 = load i32, i32* %l_ptr_store2, align 4
  %dst_ptr2 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %l_val_store2, i32* %dst_ptr2, align 4
  %l_inc2 = add i64 %l, 1
  %k_inc2 = add i64 %k, 1
  br label %merge_next

take_right_from_choose:                           ; preds = %choose
  %r_ptr_store1 = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_store1 = load i32, i32* %r_ptr_store1, align 4
  %dst_ptr3 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_store1, i32* %dst_ptr3, align 4
  %r_inc1 = add i64 %r, 1
  %k_inc3 = add i64 %k, 1
  br label %merge_next

take_right_from_cmp:                              ; preds = %cmp_values
  %r_ptr_store2 = getelementptr inbounds i32, i32* %src, i64 %r
  %r_val_store2 = load i32, i32* %r_ptr_store2, align 4
  %dst_ptr4 = getelementptr inbounds i32, i32* %buf, i64 %k
  store i32 %r_val_store2, i32* %dst_ptr4, align 4
  %r_inc2 = add i64 %r, 1
  %k_inc4 = add i64 %k, 1
  br label %merge_next

merge_next:                                       ; preds = %take_right_from_cmp, %take_right_from_choose, %take_left_from_cmp, %take_left_from_check
  %l_next_phi = phi i64 [ %l_inc1, %take_left_from_check ], [ %l_inc2, %take_left_from_cmp ], [ %l, %take_right_from_choose ], [ %l, %take_right_from_cmp ]
  %r_next_phi = phi i64 [ %r, %take_left_from_check ], [ %r, %take_left_from_cmp ], [ %r_inc1, %take_right_from_choose ], [ %r_inc2, %take_right_from_cmp ]
  %k_next = phi i64 [ %k_inc1, %take_left_from_check ], [ %k_inc2, %take_left_from_cmp ], [ %k_inc3, %take_right_from_choose ], [ %k_inc4, %take_right_from_cmp ]
  br label %merge_loop

after_merge:                                      ; preds = %merge_loop
  br label %outer_body_end

outer_body_end:                                   ; preds = %after_merge
  %run_twice = shl i64 %run, 1
  %i_next = add i64 %i, %run_twice
  br label %outer_body

outer_body_done:                                  ; preds = %outer_body
  br label %afterInner

afterInner:                                       ; preds = %outer_body_done
  %src_next = getelementptr inbounds i32, i32* %buf, i64 0
  %buf_next = getelementptr inbounds i32, i32* %src, i64 0
  %run_next = shl i64 %run, 1
  br label %outer

outer_end:                                        ; preds = %outer
  %src_eq_dest = icmp eq i32* %src, %dest
  br i1 %src_eq_dest, label %free_and_ret, label %do_memcpy

do_memcpy:                                        ; preds = %outer_end
  %dest_i8 = bitcast i32* %dest to i8*
  %src_i8 = bitcast i32* %src to i8*
  %memcpy_call = call i8* @memcpy(i8* %dest_i8, i8* %src_i8, i64 %size)
  br label %free_and_ret

free_and_ret:                                     ; preds = %do_memcpy, %outer_end
  call void @free(i8* %tmpraw)
  br label %ret

ret:                                              ; preds = %free_and_ret, %alloc, %entry
  ret void
}

; Function Attrs: nounwind
declare i8* @malloc(i64) #1

; Function Attrs: nounwind
declare i8* @memcpy(i8*, i8*, i64) #1

; Function Attrs: nounwind
declare void @free(i8*) #1

attributes #0 = { sspstrong }
attributes #1 = { nounwind }
