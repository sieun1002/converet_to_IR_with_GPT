; ModuleID = 'mergesort_from_ida'
source_filename = "mergesort_from_ida.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str1 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare noalias i8* @malloc(i64)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @free(i8*)

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) {
entry:
  %arr = alloca [10 x i32], align 16
  ; initialize local array with: 9,1,5,3,7,2,8,6,4,0
  %p0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 9
  store i32 0, i32* %p9, align 4

  ; allocate temp buffer of 40 bytes (10 * 4)
  %tmp = call noalias i8* @malloc(i64 40)
  %malloc_ok = icmp ne i8* %tmp, null
  br i1 %malloc_ok, label %sort, label %print

sort:                                             ; preds = %entry
  %dst0 = bitcast i8* %tmp to i32*
  %src0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  br label %pass_loop

pass_loop:                                        ; preds = %after_chunks, %sort
  %size = phi i32 [ 1, %sort ], [ %size.next, %after_chunks ]
  %passes_left = phi i32 [ 4, %sort ], [ %passes_left.dec, %after_chunks ]
  %srcphi = phi i32* [ %src0, %sort ], [ %src.next, %after_chunks ]
  %dstphi = phi i32* [ %dst0, %sort ], [ %dst.next, %after_chunks ]
  br label %chunk_loop

chunk_loop:                                       ; preds = %chunk_next, %pass_loop
  %i = phi i32 [ 0, %pass_loop ], [ %i.next, %chunk_next ]
  %double_size = shl i32 %size, 1
  %i_plus_size = add i32 %i, %size
  %mid.lt = icmp slt i32 %i_plus_size, 10
  %mid = select i1 %mid.lt, i32 %i_plus_size, i32 10
  %i_plus_double = add i32 %i, %double_size
  %right.lt = icmp slt i32 %i_plus_double, 10
  %right = select i1 %right.lt, i32 %i_plus_double, i32 10
  %right_le_left = icmp sle i32 %right, %i
  br i1 %right_le_left, label %chunk_next, label %merge

merge:                                            ; preds = %chunk_loop
  br label %merge_loop

merge_loop:                                       ; preds = %take_right_only, %after_take_l, %merge
  %l = phi i32 [ %i, %merge ], [ %l.next, %after_take_l ], [ %l.stay, %take_right_only ]
  %r = phi i32 [ %mid, %merge ], [ %r.stay, %after_take_l ], [ %r.next, %take_right_only ]
  %k = phi i32 [ %i, %merge ], [ %k.next.l, %after_take_l ], [ %k.next.r, %take_right_only ]
  %done = icmp eq i32 %k, %right
  br i1 %done, label %merge_done, label %decide

decide:                                           ; preds = %merge_loop
  %left_has = icmp slt i32 %l, %mid
  br i1 %left_has, label %if_left_has, label %take_right_only

if_left_has:                                      ; preds = %decide
  %right_has = icmp slt i32 %r, %right
  br i1 %right_has, label %both_have, label %take_left

both_have:                                        ; preds = %if_left_has
  %l.idx = sext i32 %l to i64
  %r.idx = sext i32 %r to i64
  %lptr = getelementptr inbounds i32, i32* %srcphi, i64 %l.idx
  %rptr = getelementptr inbounds i32, i32* %srcphi, i64 %r.idx
  %lv = load i32, i32* %lptr, align 4
  %rv = load i32, i32* %rptr, align 4
  %rv_lt_lv = icmp slt i32 %rv, %lv
  br i1 %rv_lt_lv, label %take_right, label %take_left

take_left:                                        ; preds = %both_have, %if_left_has
  %l.idx.tl = sext i32 %l to i64
  %lptr.tl = getelementptr inbounds i32, i32* %srcphi, i64 %l.idx.tl
  %lv.tl = load i32, i32* %lptr.tl, align 4
  %k.idx.l = sext i32 %k to i64
  %dptr.l = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx.l
  store i32 %lv.tl, i32* %dptr.l, align 4
  %l.next = add i32 %l, 1
  %k.next.l = add i32 %k, 1
  br label %after_take_l

take_right:                                       ; preds = %both_have
  %r.idx.tr = sext i32 %r to i64
  %rptr.tr = getelementptr inbounds i32, i32* %srcphi, i64 %r.idx.tr
  %rv.tr = load i32, i32* %rptr.tr, align 4
  %k.idx.r = sext i32 %k to i64
  %dptr.r = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx.r
  store i32 %rv.tr, i32* %dptr.r, align 4
  %r.next = add i32 %r, 1
  %k.next.r = add i32 %k, 1
  br label %take_right_only

after_take_l:                                     ; preds = %take_left
  %l.stay = phi i32 [ %l.next, %take_left ]
  %r.stay = phi i32 [ %r, %take_left ]
  br label %merge_loop

take_right_only:                                  ; preds = %decide, %take_right
  %l.stay2 = phi i32 [ %l, %decide ], [ %l, %take_right ]
  %r.next2 = phi i32 [ %r, %decide ], [ %r.next, %take_right ]
  %k.next2 = phi i32 [ %k, %decide ], [ %k.next.r, %take_right ]
  ; if left exhausted, or came from take_right: write from right
  %r.inb = icmp slt i32 %r.next2, %right
  br i1 %r.inb, label %write_right2, label %merge_done

write_right2:                                     ; preds = %take_right_only
  %r.idx.to = sext i32 %r.next2 to i64
  %rptr.to = getelementptr inbounds i32, i32* %srcphi, i64 %r.idx.to
  %rv.to = load i32, i32* %rptr.to, align 4
  %k.idx.to = sext i32 %k.next2 to i64
  %dptr.to = getelementptr inbounds i32, i32* %dstphi, i64 %k.idx.to
  store i32 %rv.to, i32* %dptr.to, align 4
  %r.next = add i32 %r.next2, 1
  %k.next.r2 = add i32 %k.next2, 1
  br label %merge_loop

merge_done:                                       ; preds = %take_right_only, %merge_loop
  br label %chunk_next

chunk_next:                                       ; preds = %merge_done, %chunk_loop
  %i.next = add i32 %i, %double_size
  %cont = icmp sle i32 %i.next, 9
  br i1 %cont, label %chunk_loop, label %after_chunks

after_chunks:                                     ; preds = %chunk_next
  %size.next = shl i32 %size, 1
  %passes_left.dec = add i32 %passes_left, -1
  %done.passes = icmp eq i32 %passes_left.dec, 0
  br i1 %done.passes, label %finalize, label %swap_and_continue

swap_and_continue:                                ; preds = %after_chunks
  %src.next = %dstphi
  %dst.next = %srcphi
  br label %pass_loop

finalize:                                         ; preds = %after_chunks
  ; if last destination != original array, copy back 10 ints
  %arr.base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %dst.ne.arr = icmp ne i32* %dstphi, %arr.base
  br i1 %dst.ne.arr, label %copyback, label %after_copy

copyback:                                         ; preds = %finalize
  br label %copy_loop

copy_loop:                                        ; preds = %copy_loop, %copyback
  %ci = phi i32 [ 0, %copyback ], [ %ci.next, %copy_loop ]
  %ci.idx = sext i32 %ci to i64
  %src.cp.ptr = getelementptr inbounds i32, i32* %dstphi, i64 %ci.idx
  %val.cp = load i32, i32* %src.cp.ptr, align 4
  %dst.cp.ptr = getelementptr inbounds i32, i32* %arr.base, i64 %ci.idx
  store i32 %val.cp, i32* %dst.cp.ptr, align 4
  %ci.next = add i32 %ci, 1
  %cp.cont = icmp slt i32 %ci.next, 10
  br i1 %cp.cont, label %copy_loop, label %after_copy

after_copy:                                       ; preds = %copy_loop, %finalize
  call void @free(i8* %tmp)
  br label %print

print:                                            ; preds = %after_copy, %entry
  ; print 10 integers from local array
  br label %print_loop

print_loop:                                       ; preds = %print_loop, %print
  %pi = phi i32 [ 0, %print ], [ %pi.next, %print_loop ]
  %pi.idx = sext i32 %pi to i64
  %pptr = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %pi.idx
  %pval = load i32, i32* %pptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %pval)
  %pi.next = add i32 %pi, 1
  %pcont = icmp slt i32 %pi.next, 10
  br i1 %pcont, label %print_loop, label %print_nl

print_nl:                                         ; preds = %print_loop
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str1, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}