; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Iterative mergesort of 10 fixed ints then print them (confidence=0.95). Evidence: doubling run size over 4 passes and merge loop; prints "%d ".
; Preconditions: None (if malloc fails, prints unsorted input).
; Postconditions: Prints 10 integers followed by newline.

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00"
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00"

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrptr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %gep0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %gep0, align 4
  %gep1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %gep1, align 4
  %gep2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %gep2, align 4
  %gep3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %gep3, align 4
  %gep4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %gep4, align 4
  %gep5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %gep5, align 4
  %gep6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %gep6, align 4
  %gep7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %gep7, align 4
  %gep8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %gep8, align 4
  %gep9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %gep9, align 4
  %heapRaw = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %heapRaw, null
  br i1 %isnull, label %print_init, label %sort_init

sort_init:                                         ; preds = %entry
  %heap = bitcast i8* %heapRaw to i32*
  br label %pass_loop

pass_loop:                                         ; preds = %swap_and_next, %sort_init
  %pass = phi i32 [ 0, %sort_init ], [ %pass.next, %swap_and_next ]
  %run = phi i32 [ 1, %sort_init ], [ %run.next, %swap_and_next ]
  %src = phi i32* [ %arrptr0, %sort_init ], [ %dst.next, %swap_and_next ]
  %dst = phi i32* [ %heap, %sort_init ], [ %src.next, %swap_and_next ]
  br label %base_loop

base_loop:                                         ; preds = %base_next, %pass_loop
  %base = phi i32 [ 0, %pass_loop ], [ %base.next, %base_next ]
  %cond_base = icmp ule i32 %base, 9
  br i1 %cond_base, label %merge_prep, label %after_base

merge_prep:                                        ; preds = %base_loop
  %tworun = shl i32 %run, 1
  %tmp1 = add i32 %base, %run
  %gt1 = icmp ugt i32 %tmp1, 10
  %mid = select i1 %gt1, i32 10, i32 %tmp1
  %tmp2 = add i32 %base, %tworun
  %gt2 = icmp ugt i32 %tmp2, 10
  %right = select i1 %gt2, i32 10, i32 %tmp2
  %right_le_base = icmp ule i32 %right, %base
  br i1 %right_le_base, label %base_next, label %merge_loop_init

merge_loop_init:                                   ; preds = %merge_prep
  br label %merge_loop

merge_loop:                                        ; preds = %merge_continue, %merge_loop_init
  %di = phi i32 [ %base, %merge_loop_init ], [ %di.next, %merge_continue ]
  %li = phi i32 [ %base, %merge_loop_init ], [ %li.next2, %merge_continue ]
  %ri = phi i32 [ %mid, %merge_loop_init ], [ %ri.next2, %merge_continue ]
  %cond_di = icmp ult i32 %di, %right
  br i1 %cond_di, label %choose, label %base_next

choose:                                            ; preds = %merge_loop
  %left_av = icmp ult i32 %li, %mid
  %right_av = icmp ult i32 %ri, %right
  br i1 %left_av, label %left_avail, label %pick_right_only

left_avail:                                        ; preds = %choose
  br i1 %right_av, label %both_avail, label %pick_left_only

both_avail:                                        ; preds = %left_avail
  %li64 = zext i32 %li to i64
  %ri64 = zext i32 %ri to i64
  %src_li_ptr = getelementptr inbounds i32, i32* %src, i64 %li64
  %leftVal = load i32, i32* %src_li_ptr, align 4
  %src_ri_ptr = getelementptr inbounds i32, i32* %src, i64 %ri64
  %rightVal = load i32, i32* %src_ri_ptr, align 4
  %cmp = icmp slt i32 %rightVal, %leftVal
  br i1 %cmp, label %do_store_right, label %do_store_left

pick_left_only:                                    ; preds = %left_avail
  br label %do_store_left

pick_right_only:                                   ; preds = %choose
  br label %do_store_right

do_store_left:                                     ; preds = %both_avail, %pick_left_only
  %di64L = zext i32 %di to i64
  %dst_di_ptrL = getelementptr inbounds i32, i32* %dst, i64 %di64L
  %li64b = zext i32 %li to i64
  %src_li_ptr2 = getelementptr inbounds i32, i32* %src, i64 %li64b
  %leftValFinal = load i32, i32* %src_li_ptr2, align 4
  store i32 %leftValFinal, i32* %dst_di_ptrL, align 4
  %di.nextL = add i32 %di, 1
  %li.next = add i32 %li, 1
  br label %merge_continue

do_store_right:                                    ; preds = %pick_right_only, %both_avail
  %di64R = zext i32 %di to i64
  %dst_di_ptrR = getelementptr inbounds i32, i32* %dst, i64 %di64R
  %ri64b = zext i32 %ri to i64
  %src_ri_ptr2 = getelementptr inbounds i32, i32* %src, i64 %ri64b
  %rightValFinal = load i32, i32* %src_ri_ptr2, align 4
  store i32 %rightValFinal, i32* %dst_di_ptrR, align 4
  %di.nextR = add i32 %di, 1
  %ri.next = add i32 %ri, 1
  br label %merge_continue

merge_continue:                                    ; preds = %do_store_right, %do_store_left
  %di.next = phi i32 [ %di.nextL, %do_store_left ], [ %di.nextR, %do_store_right ]
  %li.next2 = phi i32 [ %li.next, %do_store_left ], [ %li, %do_store_right ]
  %ri.next2 = phi i32 [ %ri, %do_store_left ], [ %ri.next, %do_store_right ]
  br label %merge_loop

base_next:                                         ; preds = %merge_loop, %merge_prep
  %base.next = add i32 %base, %tworun
  br label %base_loop

after_base:                                        ; preds = %base_loop
  %is_last = icmp eq i32 %pass, 3
  br i1 %is_last, label %finish_passes, label %swap_and_next

swap_and_next:                                     ; preds = %after_base
  %src.next = %dst
  %dst.next = %src
  %run.next = shl i32 %run, 1
  %pass.next = add i32 %pass, 1
  br label %pass_loop

finish_passes:                                     ; preds = %after_base
  %need_copy = icmp ne i32* %dst, %arrptr0
  br i1 %need_copy, label %copy_loop, label %after_copy

copy_loop:                                         ; preds = %copy_loop, %finish_passes
  %ci = phi i32 [ 0, %finish_passes ], [ %ci.next, %copy_loop ]
  %ci64 = zext i32 %ci to i64
  %src_ptr_copy = getelementptr inbounds i32, i32* %dst, i64 %ci64
  %val_copy = load i32, i32* %src_ptr_copy, align 4
  %dst_ptr_copy = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %ci64
  store i32 %val_copy, i32* %dst_ptr_copy, align 4
  %ci.next = add i32 %ci, 1
  %cont_copy = icmp ult i32 %ci.next, 10
  br i1 %cont_copy, label %copy_loop, label %after_copy

after_copy:                                        ; preds = %copy_loop, %finish_passes
  call void @free(i8* %heapRaw)
  br label %print_init

print_init:                                        ; preds = %after_copy, %entry
  br label %print_loop

print_loop:                                        ; preds = %do_print, %print_init
  %i = phi i32 [ 0, %print_init ], [ %i.next, %do_print ]
  %condPrint = icmp ult i32 %i, 10
  br i1 %condPrint, label %do_print, label %print_newline

do_print:                                          ; preds = %print_loop
  %i64 = zext i32 %i to i64
  %elem_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %i64
  %val = load i32, i32* %elem_ptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %i.next = add i32 %i, 1
  br label %print_loop

print_newline:                                     ; preds = %print_loop
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}