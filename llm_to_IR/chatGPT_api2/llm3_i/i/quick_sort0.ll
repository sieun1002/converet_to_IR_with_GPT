; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Bottom-up mergesort (10 ints) and print; falls back to printing unsorted on OOM (confidence=0.95). Evidence: malloc 40B temp buffer; iterative merge with two buffers; printf "%d " loop.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare noalias i8* @malloc(i64) local_unnamed_addr
declare void @free(i8*) local_unnamed_addr
declare i32 @__printf_chk(i32, i8*, ...) local_unnamed_addr

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; local array of 10 ints: initial contents [9,1,5,3,7,2,8,6,4,0]
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %e0 = getelementptr inbounds i32, i32* %arrp, i64 0
  store i32 9, i32* %e0, align 4
  %e1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %e1, align 4
  %e2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %e2, align 4
  %e3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %e3, align 4
  %e4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %e4, align 4
  %e5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %e5, align 4
  %e6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %e6, align 4
  %e7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %e7, align 4
  %e8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %e8, align 4
  %e9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %e9, align 4
  %tmp.raw = call noalias i8* @malloc(i64 40)
  %have_tmp = icmp ne i8* %tmp.raw, null
  br i1 %have_tmp, label %sort_entry, label %print_entry

sort_entry:                                       ; preds = %entry
  %tmp = bitcast i8* %tmp.raw to i32*
  br label %pass_check

pass_check:                                       ; preds = %end_pass, %sort_entry
  %src.phi = phi i32* [ %arrp, %sort_entry ], [ %src.next, %end_pass ]
  %dst.phi = phi i32* [ %tmp, %sort_entry ],   [ %dst.next, %end_pass ]
  %width.phi = phi i32 [ 1, %sort_entry ], [ %width.next, %end_pass ]
  %cond.pass = icmp slt i32 %width.phi, 10
  br i1 %cond.pass, label %pass_body, label %after_passes

pass_body:                                        ; preds = %pass_check
  br label %merge_loop

merge_loop:                                       ; preds = %after_merge, %pass_body
  %base.phi = phi i32 [ 0, %pass_body ], [ %base.next, %after_merge ]
  %cont.merge = icmp slt i32 %base.phi, 10
  br i1 %cont.merge, label %do_merge, label %end_pass

do_merge:                                         ; preds = %merge_loop
  %mid.tmp = add i32 %base.phi, %width.phi
  %mid.cmp = icmp sgt i32 %mid.tmp, 10
  %mid = select i1 %mid.cmp, i32 10, i32 %mid.tmp
  %right.tmp = add i32 %mid.tmp, %width.phi
  %right.cmp = icmp sgt i32 %right.tmp, 10
  %right = select i1 %right.cmp, i32 10, i32 %right.tmp
  br label %merge_inner

merge_inner:                                      ; preds = %merge_iter_end, %do_merge
  %i.phi = phi i32 [ %base.phi, %do_merge ], [ %i.next, %merge_iter_end ]
  %j.phi = phi i32 [ %mid, %do_merge ],      [ %j.next, %merge_iter_end ]
  %k.phi = phi i32 [ %base.phi, %do_merge ], [ %k.next, %merge_iter_end ]
  %cont.k = icmp slt i32 %k.phi, %right
  br i1 %cont.k, label %merge_iter, label %after_merge

merge_iter:                                       ; preds = %merge_inner
  %haveLeft = icmp slt i32 %i.phi, %mid
  %haveRight = icmp slt i32 %j.phi, %right
  br i1 %haveLeft, label %ifLeft, label %takeRight_only

ifLeft:                                           ; preds = %merge_iter
  br i1 %haveRight, label %bothHave, label %takeLeft_only

bothHave:                                         ; preds = %ifLeft
  %i.idx64 = zext i32 %i.phi to i64
  %j.idx64 = zext i32 %j.phi to i64
  %i.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %i.idx64
  %j.ptr = getelementptr inbounds i32, i32* %src.phi, i64 %j.idx64
  %li = load i32, i32* %i.ptr, align 4
  %rj = load i32, i32* %j.ptr, align 4
  %takeLeft = icmp sle i32 %li, %rj
  br i1 %takeLeft, label %takeLeft_val, label %takeRight_val

takeLeft_only:                                    ; preds = %ifLeft
  %i.idx64.lo = zext i32 %i.phi to i64
  %i.ptr.lo = getelementptr inbounds i32, i32* %src.phi, i64 %i.idx64.lo
  %li.lo = load i32, i32* %i.ptr.lo, align 4
  br label %emit_left

takeRight_only:                                   ; preds = %merge_iter
  %j.idx64.ro = zext i32 %j.phi to i64
  %j.ptr.ro = getelementptr inbounds i32, i32* %src.phi, i64 %j.idx64.ro
  %rj.ro = load i32, i32* %j.ptr.ro, align 4
  br label %emit_right

takeLeft_val:                                     ; preds = %bothHave
  br label %emit_left

takeRight_val:                                    ; preds = %bothHave
  br label %emit_right

emit_left:                                        ; preds = %takeLeft_val, %takeLeft_only
  %val.left = phi i32 [ %li, %takeLeft_val ], [ %li.lo, %takeLeft_only ]
  %k.idx64.L = zext i32 %k.phi to i64
  %dst.k.L = getelementptr inbounds i32, i32* %dst.phi, i64 %k.idx64.L
  store i32 %val.left, i32* %dst.k.L, align 4
  %i.next = add i32 %i.phi, 1
  %j.next.L = %j.phi
  %k.next = add i32 %k.phi, 1
  br label %merge_iter_end

emit_right:                                       ; preds = %takeRight_val, %takeRight_only
  %val.right = phi i32 [ %rj, %takeRight_val ], [ %rj.ro, %takeRight_only ]
  %k.idx64.R = zext i32 %k.phi to i64
  %dst.k.R = getelementptr inbounds i32, i32* %dst.phi, i64 %k.idx64.R
  store i32 %val.right, i32* %dst.k.R, align 4
  %j.next = add i32 %j.phi, 1
  %i.next.R = %i.phi
  %k.next.R = add i32 %k.phi, 1
  br label %merge_iter_end

merge_iter_end:                                   ; preds = %emit_right, %emit_left
  %i.next.phi = phi i32 [ %i.next, %emit_left ], [ %i.next.R, %emit_right ]
  %j.next.phi = phi i32 [ %j.next.L, %emit_left ], [ %j.next, %emit_right ]
  %k.next.phi = phi i32 [ %k.next, %emit_left ], [ %k.next.R, %emit_right ]
  br label %merge_inner

after_merge:                                      ; preds = %merge_inner
  %step = shl i32 %width.phi, 1
  %base.next = add i32 %base.phi, %step
  br label %merge_loop

end_pass:                                         ; preds = %merge_loop
  ; swap src/dst and double width
  %width.next = shl i32 %width.phi, 1
  %src.next = %dst.phi
  %dst.next = %src.phi
  br label %pass_check

after_passes:                                     ; preds = %pass_check
  ; If final src != arr, copy back 10 ints
  %need_copy = icmp ne i32* %src.phi, %arrp
  br i1 %need_copy, label %copy_back, label %free_and_print

copy_back:                                        ; preds = %after_passes
  br label %copy_loop

copy_loop:                                        ; preds = %copy_loop, %copy_back
  %ci = phi i32 [ 0, %copy_back ], [ %ci.next, %copy_loop ]
  %ci64 = zext i32 %ci to i64
  %src.ptr.c = getelementptr inbounds i32, i32* %src.phi, i64 %ci64
  %val.c = load i32, i32* %src.ptr.c, align 4
  %dst.ptr.c = getelementptr inbounds i32, i32* %arrp, i64 %ci64
  store i32 %val.c, i32* %dst.ptr.c, align 4
  %ci.next = add i32 %ci, 1
  %cont.c = icmp slt i32 %ci.next, 10
  br i1 %cont.c, label %copy_loop, label %free_and_print

free_and_print:                                   ; preds = %copy_loop, %after_passes
  call void @free(i8* %tmp.raw)
  br label %print_entry

print_entry:                                      ; preds = %free_and_print, %entry
  br label %print_loop

print_loop:                                       ; preds = %print_loop, %print_entry
  %pi = phi i32 [ 0, %print_entry ], [ %pi.next, %print_loop ]
  %pi64 = zext i32 %pi to i64
  %p.ptr = getelementptr inbounds i32, i32* %arrp, i64 %pi64
  %p.val = load i32, i32* %p.ptr, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %p.val)
  %pi.next = add i32 %pi, 1
  %cont.p = icmp slt i32 %pi.next, 10
  br i1 %cont.p, label %print_loop, label %print_nl

print_nl:                                         ; preds = %print_loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}