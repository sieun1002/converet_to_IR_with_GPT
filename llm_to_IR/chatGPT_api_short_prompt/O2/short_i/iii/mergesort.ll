; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort of a fixed 10-int array, then print values (confidence=0.95). Evidence: iterative merge loops with doubling run size and alternating buffers; __printf_chk prints "%d " and newline.
; Preconditions: None
; Postconditions: Prints 10 integers separated by spaces and a trailing newline; returns 0.

; Only the necessary external declarations:
; declare i32 @printf(i8*, ...)
; declare i32 @putchar(i32)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr.ptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  ; initialize array: [9,1,5,3,7,2,8,6,4,0]
  %p0 = getelementptr inbounds i32, i32* %arr.ptr, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr.ptr, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr.ptr, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr.ptr, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr.ptr, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr.ptr, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr.ptr, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr.ptr, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr.ptr, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr.ptr, i64 9
  store i32 0, i32* %p9, align 4

  %buf.i8 = call noalias i8* @malloc(i64 40)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %print, label %sortinit

sortinit:                                         ; preds = %entry
  %buf = bitcast i8* %buf.i8 to i32*
  br label %pass_loop

pass_loop:                                        ; preds = %swap_and_continue, %sortinit
  %run = phi i32 [ 1, %sortinit ], [ %run.next, %swap_and_continue ]
  %passes = phi i32 [ 4, %sortinit ], [ %passes.dec, %swap_and_continue ]
  %src.phi = phi i32* [ %arr.ptr, %sortinit ], [ %src.next, %swap_and_continue ]
  %dst.phi = phi i32* [ %buf, %sortinit ], [ %dst.next, %swap_and_continue ]
  br label %i_loop

i_loop:                                           ; preds = %i_tail, %pass_loop
  %i = phi i32 [ 0, %pass_loop ], [ %i.next, %i_tail ]
  %mid.tmp = add nsw i32 %i, %run
  %mid.cmp = icmp sgt i32 %mid.tmp, 10
  %mid = select i1 %mid.cmp, i32 10, i32 %mid.tmp
  %right.tmp = add nsw i32 %mid.tmp, %run
  %right.cmp = icmp sgt i32 %right.tmp, 10
  %right = select i1 %right.cmp, i32 10, i32 %right.tmp
  %skipcmp = icmp sle i32 %right, %i
  br i1 %skipcmp, label %i_tail, label %merge_init

merge_init:                                       ; preds = %i_loop
  br label %merge_loop

merge_loop:                                       ; preds = %write_right, %write_left, %merge_init
  %out.idx = phi i32 [ %i, %merge_init ], [ %out.nextL, %write_left ], [ %out.nextR, %write_right ]
  %j = phi i32 [ %i, %merge_init ], [ %j.nextL, %write_left ], [ %j.keepR, %write_right ]
  %k = phi i32 [ %mid, %merge_init ], [ %k.keepL, %write_left ], [ %k.nextR, %write_right ]
  %done = icmp eq i32 %out.idx, %right
  br i1 %done, label %i_tail, label %select_source

select_source:                                    ; preds = %merge_loop
  %j_lt_mid = icmp slt i32 %j, %mid
  br i1 %j_lt_mid, label %left_avail, label %use_right

left_avail:                                       ; preds = %select_source
  %k_lt_right = icmp slt i32 %k, %right
  br i1 %k_lt_right, label %both_avail, label %do_left

both_avail:                                       ; preds = %left_avail
  %j64 = sext i32 %j to i64
  %k64 = sext i32 %k to i64
  %lptr = getelementptr inbounds i32, i32* %src.phi, i64 %j64
  %rptr = getelementptr inbounds i32, i32* %src.phi, i64 %k64
  %lval = load i32, i32* %lptr, align 4
  %rval = load i32, i32* %rptr, align 4
  %r_lt_l = icmp slt i32 %rval, %lval
  br i1 %r_lt_l, label %write_right, label %write_left

do_left:                                          ; preds = %left_avail
  %j64only = sext i32 %j to i64
  %lptro = getelementptr inbounds i32, i32* %src.phi, i64 %j64only
  %lonly = load i32, i32* %lptro, align 4
  br label %write_left

use_right:                                        ; preds = %select_source
  %k64only = sext i32 %k to i64
  %rptro = getelementptr inbounds i32, i32* %src.phi, i64 %k64only
  %ronly = load i32, i32* %rptro, align 4
  br label %write_right

write_left:                                       ; preds = %do_left, %both_avail
  %l.to.write = phi i32 [ %lonly, %do_left ], [ %lval, %both_avail ]
  %out64L = sext i32 %out.idx to i64
  %dst.out.L = getelementptr inbounds i32, i32* %dst.phi, i64 %out64L
  store i32 %l.to.write, i32* %dst.out.L, align 4
  %out.nextL = add nsw i32 %out.idx, 1
  %j.nextL = add nsw i32 %j, 1
  %k.keepL = %k
  br label %merge_loop

write_right:                                      ; preds = %use_right, %both_avail
  %r.to.write = phi i32 [ %ronly, %use_right ], [ %rval, %both_avail ]
  %out64R = sext i32 %out.idx to i64
  %dst.out.R = getelementptr inbounds i32, i32* %dst.phi, i64 %out64R
  store i32 %r.to.write, i32* %dst.out.R, align 4
  %out.nextR = add nsw i32 %out.idx, 1
  %k.nextR = add nsw i32 %k, 1
  %j.keepR = %j
  br label %merge_loop

i_tail:                                           ; preds = %merge_loop, %i_loop
  %tworun = shl i32 %run, 1
  %i.next = add nsw i32 %i, %tworun
  %more = icmp sle i32 %i.next, 9
  br i1 %more, label %i_loop, label %after_pass

after_pass:                                       ; preds = %i_tail
  %passes.dec = add nsw i32 %passes, -1
  %run.next = shl i32 %run, 1
  %done.all = icmp eq i32 %passes.dec, 0
  br i1 %done.all, label %after_all_pre, label %swap_and_continue

swap_and_continue:                                ; preds = %after_pass
  %src.next = %dst.phi
  %dst.next = %src.phi
  br label %pass_loop

after_all_pre:                                    ; preds = %after_pass
  br label %after_all

after_all:                                        ; preds = %after_all_pre
  %arrptr2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst.eq.arr = icmp eq i32* %dst.phi, %arrptr2
  br i1 %dst.eq.arr, label %free_and_print, label %copy_then_free

copy_then_free:                                   ; preds = %after_all
  br label %copy_loop

copy_loop:                                        ; preds = %copy_loop, %copy_then_free
  %ci = phi i32 [ 0, %copy_then_free ], [ %ci.next, %copy_loop ]
  %ci64 = sext i32 %ci to i64
  %srcp = getelementptr inbounds i32, i32* %dst.phi, i64 %ci64
  %val = load i32, i32* %srcp, align 4
  %dstp = getelementptr inbounds i32, i32* %arrptr2, i64 %ci64
  store i32 %val, i32* %dstp, align 4
  %ci.next = add nsw i32 %ci, 1
  %copy.done = icmp eq i32 %ci.next, 10
  br i1 %copy.done, label %free_and_print, label %copy_loop

free_and_print:                                   ; preds = %copy_loop, %after_all
  call void @free(i8* %buf.i8)
  br label %print

print:                                            ; preds = %free_and_print, %entry
  %arrptr3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  br label %p_loop

p_loop:                                           ; preds = %p_loop, %print
  %pi = phi i32 [ 0, %print ], [ %pi.next, %p_loop ]
  %pi64 = sext i32 %pi to i64
  %pp = getelementptr inbounds i32, i32* %arrptr3, i64 %pi64
  %v = load i32, i32* %pp, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %v)
  %pi.next = add nsw i32 %pi, 1
  %donep = icmp eq i32 %pi.next, 10
  br i1 %donep, label %p_after, label %p_loop

p_after:                                          ; preds = %p_loop
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}