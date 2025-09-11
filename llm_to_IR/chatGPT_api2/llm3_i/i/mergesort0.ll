; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 ints then print (confidence=0.95). Evidence: iterative merge with width doubling; __printf_chk prints values
; Preconditions: Fixed-size array of 10 ints; ascending sort; malloc may fail -> prints original order
; Postconditions: Prints 10 integers followed by newline

@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  store [10 x i32] [i32 9, i32 1, i32 5, i32 3, i32 7, i32 2, i32 8, i32 6, i32 4, i32 0], [10 x i32]* %arr, align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %tmp.raw = call noalias i8* @malloc(i64 40)
  %isnull = icmp eq i8* %tmp.raw, null
  br i1 %isnull, label %print, label %have_tmp

have_tmp:                                            ; preds = %entry
  %tmp = bitcast i8* %tmp.raw to i32*
  br label %pass_loop

pass_loop:                                           ; preds = %after_pass, %have_tmp
  %round = phi i32 [ 0, %have_tmp ], [ %round.next, %after_pass ]
  %width = phi i64 [ 1, %have_tmp ], [ %width.next, %after_pass ]
  %srcp = phi i32* [ %arrp, %have_tmp ], [ %src.next, %after_pass ]
  %dstp = phi i32* [ %tmp, %have_tmp ], [ %dst.next, %after_pass ]
  br label %i_loop

i_loop:                                              ; preds = %after_merge, %pass_loop
  %i = phi i64 [ 0, %pass_loop ], [ %i.next, %after_merge ]
  %i.cond = icmp ult i64 %i, 10
  br i1 %i.cond, label %do_merge, label %finish_pass

do_merge:                                            ; preds = %i_loop
  %i.plus.w = add i64 %i, %width
  %mid.cmp = icmp ult i64 %i.plus.w, 10
  %mid = select i1 %mid.cmp, i64 %i.plus.w, i64 10
  %tw = shl i64 %width, 1
  %i.plus.tw = add i64 %i, %tw
  %right.cmp = icmp ult i64 %i.plus.tw, 10
  %right = select i1 %right.cmp, i64 %i.plus.tw, i64 10
  %has.range = icmp ugt i64 %right, %i
  br i1 %has.range, label %merge_loop.init, label %after_merge

merge_loop.init:                                     ; preds = %do_merge
  br label %merge_loop

merge_loop:                                          ; preds = %pick_right, %pick_left, %merge_loop.init
  %l = phi i64 [ %i, %merge_loop.init ], [ %l.next, %pick_left ], [ %l2, %pick_right ]
  %r = phi i64 [ %mid, %merge_loop.init ], [ %r1, %pick_left ], [ %r.next, %pick_right ]
  %o = phi i64 [ %i, %merge_loop.init ], [ %o.next, %pick_left ], [ %o2, %pick_right ]
  %o.cmp.end = icmp ult i64 %o, %right
  br i1 %o.cmp.end, label %check_left_avail, label %merge_done

check_left_avail:                                    ; preds = %merge_loop
  %l.avail = icmp ult i64 %l, %mid
  br i1 %l.avail, label %check_right_avail, label %emit_right_only

check_right_avail:                                   ; preds = %check_left_avail
  %r.avail = icmp ult i64 %r, %right
  br i1 %r.avail, label %compare_vals, label %emit_left_only

compare_vals:                                        ; preds = %check_right_avail
  %lp = getelementptr inbounds i32, i32* %srcp, i64 %l
  %lv = load i32, i32* %lp, align 4
  %rp = getelementptr inbounds i32, i32* %srcp, i64 %r
  %rv = load i32, i32* %rp, align 4
  %r.lt.l = icmp slt i32 %rv, %lv
  br i1 %r.lt.l, label %pick_right, label %pick_left

emit_left_only:                                      ; preds = %check_right_avail
  %lp2 = getelementptr inbounds i32, i32* %srcp, i64 %l
  %lv2 = load i32, i32* %lp2, align 4
  %op = getelementptr inbounds i32, i32* %dstp, i64 %o
  store i32 %lv2, i32* %op, align 4
  %l.next = add i64 %l, 1
  %o.next = add i64 %o, 1
  br label %merge_loop

emit_right_only:                                     ; preds = %check_left_avail
  %r2p = getelementptr inbounds i32, i32* %srcp, i64 %r
  %r2v = load i32, i32* %r2p, align 4
  %o2p = getelementptr inbounds i32, i32* %dstp, i64 %o
  store i32 %r2v, i32* %o2p, align 4
  %r.next = add i64 %r, 1
  %o2 = add i64 %o, 1
  %l2 = %l
  %r1 = %r.next
  br label %merge_loop

pick_left:                                           ; preds = %compare_vals
  %op1 = getelementptr inbounds i32, i32* %dstp, i64 %o
  store i32 %lv, i32* %op1, align 4
  %l.next2 = add i64 %l, 1
  %o.next = add i64 %o, 1
  %r1 = %r
  br label %merge_loop

pick_right:                                          ; preds = %compare_vals
  %op2 = getelementptr inbounds i32, i32* %dstp, i64 %o
  store i32 %rv, i32* %op2, align 4
  %r.next2 = add i64 %r, 1
  %o2 = add i64 %o, 1
  %l2 = %l
  %r1 = %r.next2
  br label %merge_loop

merge_done:                                          ; preds = %merge_loop
  br label %after_merge

after_merge:                                         ; preds = %merge_done, %do_merge
  %i.next = add i64 %right, 0
  br label %i_loop

finish_pass:                                         ; preds = %i_loop
  %is_last = icmp eq i32 %round, 3
  br i1 %is_last, label %after_all_passes, label %after_pass

after_pass:                                          ; preds = %finish_pass
  %src.next = %dstp
  %dst.next = %srcp
  %width.next = shl i64 %width, 1
  %round.next = add i32 %round, 1
  br label %pass_loop

after_all_passes:                                    ; preds = %finish_pass
  %dst.is.arr = icmp eq i32* %dstp, i32* %arrp
  br i1 %dst.is.arr, label %free_and_print, label %copy_back

copy_back:                                           ; preds = %after_all_passes
  br label %copy_loop

copy_loop:                                           ; preds = %copy_step, %copy_back
  %ci = phi i64 [ 0, %copy_back ], [ %ci.next, %copy_step ]
  %cc = icmp ult i64 %ci, 10
  br i1 %cc, label %copy_step, label %free_and_print

copy_step:                                           ; preds = %copy_loop
  %src.e = getelementptr inbounds i32, i32* %dstp, i64 %ci
  %v = load i32, i32* %src.e, align 4
  %dst.e = getelementptr inbounds i32, i32* %arrp, i64 %ci
  store i32 %v, i32* %dst.e, align 4
  %ci.next = add i64 %ci, 1
  br label %copy_loop

free_and_print:                                      ; preds = %copy_loop, %after_all_passes
  call void @free(i8* %tmp.raw)
  br label %print

print:                                               ; preds = %free_and_print, %entry
  br label %pl.loop

pl.loop:                                             ; preds = %pl.step, %print
  %pi = phi i64 [ 0, %print ], [ %pi.next, %pl.step ]
  %pc = icmp ult i64 %pi, 10
  br i1 %pc, label %pl.step, label %pl.done

pl.step:                                             ; preds = %pl.loop
  %pe = getelementptr inbounds i32, i32* %arrp, i64 %pi
  %pv = load i32, i32* %pe, align 4
  %fmtp = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtp, i32 %pv)
  %pi.next = add i64 %pi, 1
  br label %pl.loop

pl.done:                                             ; preds = %pl.loop
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlp)
  ret i32 0
}