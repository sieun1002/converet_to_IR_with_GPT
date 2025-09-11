; ModuleID = 'mergesort_from_ida'
source_filename = "mergesort_from_ida"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  ; stack array of 10 i32
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0

  ; initialize arr = [9,1,5,3,7,2,8,6,4,0]
  store i32 9,  i32* %arrp, align 4
  %p1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1,  i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5,  i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3,  i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7,  i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2,  i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8,  i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6,  i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4,  i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0,  i32* %p9, align 4

  ; tmp buffer = malloc(40)
  %tmp.raw = call i8* @malloc(i64 40)
  %tmp = bitcast i8* %tmp.raw to i32*
  %have_tmp = icmp ne i32* %tmp, null
  br i1 %have_tmp, label %sort_entry, label %print

; bottom-up mergesort: 4 passes for 10 elements
sort_entry:
  %src0 = %arrp
  %dst0 = %tmp
  br label %pass_loop

pass_loop:                                           ; preds = %pass_end, %sort_entry
  %pass = phi i32 [ 0, %sort_entry ], [ %pass.next, %pass_end ]
  %src = phi i32* [ %src0, %sort_entry ], [ %src.next, %pass_end ]
  %dst = phi i32* [ %dst0, %sort_entry ], [ %dst.next, %pass_end ]
  %run = shl i32 1, %pass
  br label %segment_loop

segment_loop:                                        ; preds = %merge_done, %pass_loop
  %i = phi i32 [ 0, %pass_loop ], [ %i.next, %merge_done ]
  %cont = icmp ult i32 %i, 10
  br i1 %cont, label %do_merge, label %pass_end

do_merge:                                            ; preds = %segment_loop
  ; bounds
  %i.plus.run = add i32 %i, %run
  %mid = call i32 @llvm.umin.i32(i32 %i.plus.run, i32 10)
  %i.plus.2run = add i32 %i, %run
  %i.plus.2run2 = add i32 %i.plus.2run, %run
  %right = call i32 @llvm.umin.i32(i32 %i.plus.2run2, i32 10)

  ; indices
  %l0 = %i
  %r0 = %mid
  %out0 = %i

  br label %merge_loop

merge_loop:                                          ; preds = %take_right, %take_left, %copy_left_rest, %copy_right_rest, %do_merge
  %l = phi i32 [ %l0, %do_merge ], [ %l.nextL, %take_left ], [ %l.nextLR, %copy_left_rest ], [ %l.same, %take_right ], [ %l.same2, %copy_right_rest ]
  %r = phi i32 [ %r0, %do_merge ], [ %r.same, %take_left ], [ %r.same2, %copy_left_rest ], [ %r.nextR, %take_right ], [ %r.nextRR, %copy_right_rest ]
  %out = phi i32 [ %out0, %do_merge ], [ %out.nextL, %take_left ], [ %out.nextLR, %copy_left_rest ], [ %out.nextR, %take_right ], [ %out.nextRR, %copy_right_rest ]

  ; stop when out == right
  %done = icmp eq i32 %out, %right
  br i1 %done, label %merge_done, label %choose

choose:                                              ; preds = %merge_loop
  ; if l < mid and (r >= right or src[l] <= src[r]) -> take left
  %condL = icmp ult i32 %l, %mid
  %r_ge_right = icmp uge i32 %r, %right
  br i1 %condL, label %check_right, label %copy_right_rest

check_right:                                         ; preds = %choose
  %takeL_if_r_done = or i1 %r_ge_right, false
  br i1 %r_ge_right, label %take_left, label %cmp_vals

cmp_vals:                                            ; preds = %check_right
  ; compare src[l] and src[r] as signed
  %l.idx64 = zext i32 %l to i64
  %r.idx64 = zext i32 %r to i64
  %lp = getelementptr inbounds i32, i32* %src, i64 %l.idx64
  %rp = getelementptr inbounds i32, i32* %src, i64 %r.idx64
  %lv = load i32, i32* %lp, align 4
  %rv = load i32, i32* %rp, align 4
  %r_lt_l = icmp slt i32 %rv, %lv
  br i1 %r_lt_l, label %take_right, label %take_left

take_left:                                           ; preds = %cmp_vals, %check_right
  ; write src[l] to dst[out]
  %l.idx64.tl = zext i32 %l to i64
  %out.idx64.tl = zext i32 %out to i64
  %src.l.ptr = getelementptr inbounds i32, i32* %src, i64 %l.idx64.tl
  %dst.out.ptr = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.tl
  %valL = load i32, i32* %src.l.ptr, align 4
  store i32 %valL, i32* %dst.out.ptr, align 4
  %l.nextL = add i32 %l, 1
  %r.same = %r
  %out.nextL = add i32 %out, 1
  br label %merge_loop

take_right:                                          ; preds = %cmp_vals
  ; write src[r] to dst[out]
  %r.idx64.tr = zext i32 %r to i64
  %out.idx64.tr = zext i32 %out to i64
  %src.r.ptr = getelementptr inbounds i32, i32* %src, i64 %r.idx64.tr
  %dst.out.ptr2 = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.tr
  %valR = load i32, i32* %src.r.ptr, align 4
  store i32 %valR, i32* %dst.out.ptr2, align 4
  %l.same = %l
  %r.nextR = add i32 %r, 1
  %out.nextR = add i32 %out, 1
  br label %merge_loop

copy_left_rest:                                      ; preds = %choose
  ; r >= right, copy left
  %l.idx64.cl = zext i32 %l to i64
  %out.idx64.cl = zext i32 %out to i64
  %src.l.ptr2 = getelementptr inbounds i32, i32* %src, i64 %l.idx64.cl
  %dst.out.ptr3 = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.cl
  %valL2 = load i32, i32* %src.l.ptr2, align 4
  store i32 %valL2, i32* %dst.out.ptr3, align 4
  %l.nextLR = add i32 %l, 1
  %r.same2 = %r
  %out.nextLR = add i32 %out, 1
  br label %merge_loop

copy_right_rest:                                     ; preds = %choose
  ; l >= mid, copy right
  %r.idx64.cr = zext i32 %r to i64
  %out.idx64.cr = zext i32 %out to i64
  %src.r.ptr2 = getelementptr inbounds i32, i32* %src, i64 %r.idx64.cr
  %dst.out.ptr4 = getelementptr inbounds i32, i32* %dst, i64 %out.idx64.cr
  %valR2 = load i32, i32* %src.r.ptr2, align 4
  store i32 %valR2, i32* %dst.out.ptr4, align 4
  %l.same2 = %l
  %r.nextRR = add i32 %r, 1
  %out.nextRR = add i32 %out, 1
  br label %merge_loop

merge_done:                                          ; preds = %merge_loop
  %two.run = shl i32 %run, 1
  %i.next = add i32 %i, %two.run
  br label %segment_loop

pass_end:                                            ; preds = %segment_loop
  %pass.next = add i32 %pass, 1
  ; prepare swapped pointers for next pass
  %src.next = %dst
  %dst.next = %src
  %done.all = icmp eq i32 %pass.next, 4
  br i1 %done.all, label %after_sort, label %pass_loop

after_sort:                                          ; preds = %pass_end
  ; final sorted data is in %dst (no final swap performed)
  %dst.is.stack = icmp eq i32* %dst, %arrp
  br i1 %dst.is.stack, label %sorted_to_stack, label %copy_back

copy_back:                                           ; preds = %after_sort
  ; copy 10 ints from %dst to %arrp
  br label %copy_loop

copy_loop:                                           ; preds = %copy_loop, %copy_back
  %ci = phi i32 [ 0, %copy_back ], [ %ci.next, %copy_loop ]
  %ci64 = zext i32 %ci to i64
  %src.cp = getelementptr inbounds i32, i32* %dst, i64 %ci64
  %dst.cp = getelementptr inbounds i32, i32* %arrp, i64 %ci64
  %vcp = load i32, i32* %src.cp, align 4
  store i32 %vcp, i32* %dst.cp, align 4
  %ci.next = add i32 %ci, 1
  %cp.done = icmp eq i32 %ci.next, 10
  br i1 %cp.done, label %sorted_to_stack, label %copy_loop

sorted_to_stack:                                     ; preds = %copy_loop, %after_sort
  ; free tmp
  call void @free(i8* %tmp.raw)
  br label %print

print:                                               ; preds = %sorted_to_stack, %entry
  ; print 10 elements: __printf_chk(1, "%d ", val)
  br label %print_loop

print_loop:                                          ; preds = %print_end, %print
  %pi = phi i32 [ 0, %print ], [ %pi.next, %print_end ]
  %pi64 = zext i32 %pi to i64
  %pp = getelementptr inbounds i32, i32* %arrp, i64 %pi64
  %pv = load i32, i32* %pp, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %pv)
  %pi.next = add i32 %pi, 1
  %p.done = icmp eq i32 %pi.next, 10
  br i1 %p.done, label %after_print, label %print_end

print_end:                                           ; preds = %print_loop
  br label %print_loop

after_print:                                         ; preds = %print_loop
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %__ = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}

; Min intrinsic for unsigned i32 to implement min(x, 10)
declare i32 @llvm.umin.i32(i32, i32) nounwind readnone llvm_intrinsic

!llvm.module.flags = !{!0}
!0 = !{i32 1, !"wchar_size", i32 4}