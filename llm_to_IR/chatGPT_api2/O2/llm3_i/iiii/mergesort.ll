; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Print an array of 10 ints, sorted ascending using iterative mergesort if malloc succeeds; otherwise print unsorted (confidence=0.90). Evidence: iterative run-doubling merge loops; prints with "%d " 10 times.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 6, i32 8, i32 4, i32 0], [10 x i32]* %arr, align 16
  %tmp.raw = call noalias i8* @malloc(i64 40)
  %cmpnull = icmp eq i8* %tmp.raw, null
  br i1 %cmpnull, label %print, label %sort_entry

sort_entry:                                        ; preds = %entry
  %src0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst0 = bitcast i8* %tmp.raw to i32*
  br label %outer_header

outer_header:                                      ; preds = %swap_and_continue, %sort_entry
  %src.phi = phi i32* [ %src0, %sort_entry ], [ %dst.next, %swap_and_continue ]
  %dst.phi = phi i32* [ %dst0, %sort_entry ], [ %src.next, %swap_and_continue ]
  %run.phi = phi i64 [ 1, %sort_entry ], [ %run.next, %swap_and_continue ]
  %rem.phi = phi i32 [ 4, %sort_entry ], [ %rem.next, %swap_and_continue ]
  br label %inner_header

inner_header:                                      ; preds = %inner_merge_done, %outer_header
  %i.phi = phi i64 [ 0, %outer_header ], [ %right, %inner_merge_done ]
  %cond_i = icmp ult i64 %i.phi, 10
  br i1 %cond_i, label %compute_bounds, label %outer_next

compute_bounds:                                    ; preds = %inner_header
  %left = %i.phi
  %left_plus_run = add i64 %left, %run.phi
  %cmp_lpr_n = icmp ult i64 %left_plus_run, 10
  %mid = select i1 %cmp_lpr_n, i64 %left_plus_run, i64 10
  %rightcand = add i64 %left_plus_run, %run.phi
  %cmp_rc_n = icmp ult i64 %rightcand, 10
  %right = select i1 %cmp_rc_n, i64 %rightcand, i64 10
  %l0 = %left
  %r0 = %mid
  %out0 = %left
  br label %merge_loop

merge_loop:                                        ; preds = %after_store, %compute_bounds
  %l = phi i64 [ %l0, %compute_bounds ], [ %l.next, %after_store ]
  %r = phi i64 [ %r0, %compute_bounds ], [ %r.next, %after_store ]
  %out = phi i64 [ %out0, %compute_bounds ], [ %out.next, %after_store ]
  %done = icmp eq i64 %out, %right
  br i1 %done, label %inner_merge_done, label %choose

choose:                                            ; preds = %merge_loop
  %l_lt_mid = icmp ult i64 %l, %mid
  br i1 %l_lt_mid, label %check_r, label %take_right_only

check_r:                                           ; preds = %choose
  %r_lt_right = icmp ult i64 %r, %right
  br i1 %r_lt_right, label %compare_vals, label %take_left

compare_vals:                                      ; preds = %check_r
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %l
  %lval = load i32, i32* %lptr, align 4
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rval = load i32, i32* %rptr, align 4
  %cmp_r_lt_l = icmp slt i32 %rval, %lval
  br i1 %cmp_r_lt_l, label %take_right, label %take_left

take_left:                                         ; preds = %check_r, %compare_vals
  %dstptr = getelementptr inbounds i32, i32* %dst.phi, i64 %out
  %lval.sel = phi i32 [ %lval, %compare_vals ], [ load i32, i32* %lptr, align 4, %check_r ]
  store i32 %lval.sel, i32* %dstptr, align 4
  %l.next = add i64 %l, 1
  %r.next = %r
  br label %after_store

take_right:                                        ; preds = %compare_vals
  %dstptr2 = getelementptr inbounds i32, i32* %dst.phi, i64 %out
  store i32 %rval, i32* %dstptr2, align 4
  %l.next1 = %l
  %r.next1 = add i64 %r, 1
  br label %after_store

take_right_only:                                   ; preds = %choose
  %rptr2 = getelementptr inbounds i32, i32* %src.phi, i64 %r
  %rval2 = load i32, i32* %rptr2, align 4
  %dstptr3 = getelementptr inbounds i32, i32* %dst.phi, i64 %out
  store i32 %rval2, i32* %dstptr3, align 4
  %l.next2 = %l
  %r.next2 = add i64 %r, 1
  br label %after_store

after_store:                                       ; preds = %take_right_only, %take_right, %take_left
  %l.next = phi i64 [ %l.next2, %take_right_only ], [ %l.next1, %take_right ], [ %l.next, %take_left ]
  %r.next = phi i64 [ %r.next2, %take_right_only ], [ %r.next1, %take_right ], [ %r.next, %take_left ]
  %out.next = add i64 %out, 1
  br label %merge_loop

inner_merge_done:                                  ; preds = %merge_loop
  br label %inner_header

outer_next:                                        ; preds = %inner_header
  %rem.next = add nsw i32 %rem.phi, -1
  %stop = icmp eq i32 %rem.next, 0
  br i1 %stop, label %after_sort, label %swap_and_continue

swap_and_continue:                                 ; preds = %outer_next
  %src.next = %dst.phi
  %dst.next = %src.phi
  %run.next = shl i64 %run.phi, 1
  br label %outer_header

after_sort:                                        ; preds = %outer_next
  ; If final destination is not the stack array, copy 10 ints back
  %arrbase = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %need_copy = icmp ne i32* %dst.phi, %arrbase
  br i1 %need_copy, label %copy_loop, label %free_and_print

copy_loop:                                         ; preds = %after_sort, %copy_loop
  %ci = phi i64 [ 0, %after_sort ], [ %ci.next, %copy_loop ]
  %csrcptr = getelementptr inbounds i32, i32* %dst.phi, i64 %ci
  %cval = load i32, i32* %csrcptr, align 4
  %cdstptr = getelementptr inbounds i32, i32* %arrbase, i64 %ci
  store i32 %cval, i32* %cdstptr, align 4
  %ci.next = add i64 %ci, 1
  %copy.done = icmp eq i64 %ci.next, 10
  br i1 %copy.done, label %free_and_print, label %copy_loop

free_and_print:                                    ; preds = %copy_loop, %after_sort
  call void @free(i8* %tmp.raw)
  br label %print

print:                                             ; preds = %free_and_print, %entry
  %pbase = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %print.loop

print.loop:                                        ; preds = %print.loop, %print
  %pi = phi i64 [ 0, %print ], [ %pi.next, %print.loop ]
  %pptr = getelementptr inbounds i32, i32* %pbase, i64 %pi
  %pval = load i32, i32* %pptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %fmtcast = bitcast i8* %fmtptr to i8*
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtcast, i32 %pval)
  %pi.next = add i64 %pi, 1
  %pldone = icmp eq i64 %pi.next, 10
  br i1 %pldone, label %print.nl, label %print.loop

print.nl:                                          ; preds = %print.loop
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %nlcast = bitcast i8* %nlptr to i8*
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlcast)
  ret i32 0
}