; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: bottom-up merge sort of a fixed 10-int array, then print (confidence=0.95). Evidence: malloc(40), four merge passes (log2(10)), __printf_chk loop over 10 ints.
; Preconditions: None
; Postconditions: Prints the sorted 10 integers followed by a newline; returns 0.

@.fmt = private unnamed_addr constant [4 x i8] c"%d \00"
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00"
@__stack_chk_guard = external global i64

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
%saved_canary = alloca i64, align 8
%arr = alloca [10 x i32], align 16
%guard0 = load i64, i64* @__stack_chk_guard, align 8
store i64 %guard0, i64* %saved_canary, align 8
; initialize a = {9,1,5,3,7,2,8,6,4,0}
%a0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
store i32 9, i32* %a0, align 4
%a1 = getelementptr inbounds i32, i32* %a0, i64 1
store i32 1, i32* %a1, align 4
%a2 = getelementptr inbounds i32, i32* %a0, i64 2
store i32 5, i32* %a2, align 4
%a3 = getelementptr inbounds i32, i32* %a0, i64 3
store i32 3, i32* %a3, align 4
%a4 = getelementptr inbounds i32, i32* %a0, i64 4
store i32 7, i32* %a4, align 4
%a5 = getelementptr inbounds i32, i32* %a0, i64 5
store i32 2, i32* %a5, align 4
%a6 = getelementptr inbounds i32, i32* %a0, i64 6
store i32 8, i32* %a6, align 4
%a7 = getelementptr inbounds i32, i32* %a0, i64 7
store i32 6, i32* %a7, align 4
%a8 = getelementptr inbounds i32, i32* %a0, i64 8
store i32 4, i32* %a8, align 4
%a9 = getelementptr inbounds i32, i32* %a0, i64 9
store i32 0, i32* %a9, align 4

%tmpraw = call i8* @malloc(i64 40)
%isnull = icmp eq i8* %tmpraw, null
br i1 %isnull, label %print, label %merge_prep

merge_prep:
%src0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
%dst0 = bitcast i8* %tmpraw to i32*
br label %outer_header

outer_header:
%src = phi i32* [ %src0, %merge_prep ], [ %src_next, %swap ]
%dst = phi i32* [ %dst0, %merge_prep ], [ %dst_next, %swap ]
%run = phi i32 [ 1, %merge_prep ], [ %run_next, %swap ]
%pass = phi i32 [ 4, %merge_prep ], [ %pass_next, %swap ]
br label %inner_header

inner_header:
%i = phi i64 [ 0, %outer_header ], [ %i_next, %inner_after ]
%cond = icmp uge i64 %i, 10
br i1 %cond, label %after_pass, label %do_merge

do_merge:
%run64 = sext i32 %run to i64
%midtmp = add i64 %i, %run64
%mid_sel = icmp ult i64 %midtmp, 10
%mid = select i1 %mid_sel, i64 %midtmp, i64 10
%tworun = shl i64 %run64, 1
%righttmp = add i64 %i, %tworun
%right_sel = icmp ult i64 %righttmp, 10
%right = select i1 %right_sel, i64 %righttmp, i64 10
br label %merge_loop

merge_loop:
%l = phi i64 [ %i, %do_merge ], [ %l_inc, %take_left ], [ %l_keep_r, %take_right ], [ %l_inc_nc, %take_left_nc ], [ %l_keep_nc, %take_right_nc ]
%r = phi i64 [ %mid, %do_merge ], [ %r_keep_l, %take_left ], [ %r_inc, %take_right ], [ %r_keep_nc, %take_left_nc ], [ %r_inc_nc, %take_right_nc ]
%out = phi i64 [ %i, %do_merge ], [ %out_inc_l, %take_left ], [ %out_inc_r, %take_right ], [ %out_inc_l_nc, %take_left_nc ], [ %out_inc_r_nc, %take_right_nc ]
%done = icmp uge i64 %out, %right
br i1 %done, label %inner_after, label %choose

choose:
%l_lt_mid = icmp ult i64 %l, %mid
br i1 %l_lt_mid, label %check_r, label %take_right_nc

check_r:
%r_ge_right = icmp uge i64 %r, %right
br i1 %r_ge_right, label %take_left_nc, label %compare_vals

compare_vals:
%l_ptr = getelementptr inbounds i32, i32* %src, i64 %l
%l_val = load i32, i32* %l_ptr, align 4
%r_ptr = getelementptr inbounds i32, i32* %src, i64 %r
%r_val = load i32, i32* %r_ptr, align 4
%le = icmp sle i32 %l_val, %r_val
br i1 %le, label %take_left, label %take_right

take_left:
%dst_ptr_l = getelementptr inbounds i32, i32* %dst, i64 %out
store i32 %l_val, i32* %dst_ptr_l, align 4
%out_inc_l = add i64 %out, 1
%l_inc = add i64 %l, 1
%r_keep_l = %r
br label %merge_loop

take_right:
%dst_ptr_r = getelementptr inbounds i32, i32* %dst, i64 %out
store i32 %r_val, i32* %dst_ptr_r, align 4
%out_inc_r = add i64 %out, 1
%r_inc = add i64 %r, 1
%l_keep_r = %l
br label %merge_loop

; left-only (right exhausted)
take_left_nc:
%l_ptr_nc = getelementptr inbounds i32, i32* %src, i64 %l
%l_val_nc = load i32, i32* %l_ptr_nc, align 4
%dst_ptr_l_nc = getelementptr inbounds i32, i32* %dst, i64 %out
store i32 %l_val_nc, i32* %dst_ptr_l_nc, align 4
%out_inc_l_nc = add i64 %out, 1
%l_inc_nc = add i64 %l, 1
%r_keep_nc = %r
br label %merge_loop

; right-only (left exhausted)
take_right_nc:
%r_ptr_nc = getelementptr inbounds i32, i32* %src, i64 %r
%r_val_nc = load i32, i32* %r_ptr_nc, align 4
%dst_ptr_r_nc = getelementptr inbounds i32, i32* %dst, i64 %out
store i32 %r_val_nc, i32* %dst_ptr_r_nc, align 4
%out_inc_r_nc = add i64 %out, 1
%r_inc_nc = add i64 %r, 1
%l_keep_nc = %l
br label %merge_loop

inner_after:
%i_next = %right
br label %inner_header

after_pass:
%run_next = shl i32 %run, 1
%pass_next = add i32 %pass, -1
%done_passes = icmp eq i32 %pass_next, 0
br i1 %done_passes, label %finalize, label %swap

swap:
%src_next = %dst
%dst_next = %src
br label %outer_header

finalize:
%arrptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
%needcopy = icmp ne i32* %dst, %arrptr
br i1 %needcopy, label %copy_loop, label %after_copy

copy_loop:
%ci = phi i64 [ 0, %finalize ], [ %ci_next, %copy_body ]
%cend = icmp uge i64 %ci, 10
br i1 %cend, label %copy_done, label %copy_body

copy_body:
%s_ptr = getelementptr inbounds i32, i32* %dst, i64 %ci
%v = load i32, i32* %s_ptr, align 4
%d_ptr = getelementptr inbounds i32, i32* %arrptr, i64 %ci
store i32 %v, i32* %d_ptr, align 4
%ci_next = add i64 %ci, 1
br label %copy_loop

copy_done:
br label %after_copy

after_copy:
call void @free(i8* %tmpraw)
br label %print

print:
%arrbase = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
br label %print_loop

print_loop:
%k = phi i64 [ 0, %print ], [ %k_next, %print_body ]
%pdone = icmp uge i64 %k, 10
br i1 %pdone, label %print_nl, label %print_body

print_body:
%p_ptr = getelementptr inbounds i32, i32* %arrbase, i64 %k
%pv = load i32, i32* %p_ptr, align 4
%fmtp = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt, i64 0, i64 0
%callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtp, i32 %pv)
%k_next = add i64 %k, 1
br label %print_loop

print_nl:
%nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
%callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlp)
br label %epilogue

epilogue:
%guard1 = load i64, i64* @__stack_chk_guard, align 8
%saved = load i64, i64* %saved_canary, align 8
%ok = icmp eq i64 %saved, %guard1
br i1 %ok, label %ret, label %fail

fail:
call void @__stack_chk_fail()
unreachable

ret:
ret i32 0
}