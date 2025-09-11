; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x00000000000010C0
; Intent: Bottom-up mergesort of 10 ints then print them (confidence=0.87). Evidence: width doubling (r13), merge of two runs with bounds to 10 and 4 passes.
; Preconditions: none
; Postconditions: Prints 10 integers followed by newline; returns 0

; Only the necessary external declarations:
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.strnl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %0, align 4
  %1 = getelementptr inbounds i32, i32* %0, i64 1
  store i32 1, i32* %1, align 4
  %2 = getelementptr inbounds i32, i32* %0, i64 2
  store i32 5, i32* %2, align 4
  %3 = getelementptr inbounds i32, i32* %0, i64 3
  store i32 3, i32* %3, align 4
  %4 = getelementptr inbounds i32, i32* %0, i64 4
  store i32 7, i32* %4, align 4
  %5 = getelementptr inbounds i32, i32* %0, i64 5
  store i32 2, i32* %5, align 4
  %6 = getelementptr inbounds i32, i32* %0, i64 6
  store i32 8, i32* %6, align 4
  %7 = getelementptr inbounds i32, i32* %0, i64 7
  store i32 6, i32* %7, align 4
  %8 = getelementptr inbounds i32, i32* %0, i64 8
  store i32 4, i32* %8, align 4
  %9 = getelementptr inbounds i32, i32* %0, i64 9
  store i32 0, i32* %9, align 4

  %tmp.raw = call noalias i8* @malloc(i64 40)
  %tmp.null = icmp eq i8* %tmp.raw, null
  br i1 %tmp.null, label %print_only, label %sort_start

sort_start:                                        ; preds = %entry
  %tmp = bitcast i8* %tmp.raw to i32*
  %inptr.init = bitcast [10 x i32]* %arr to i32*
  %outptr.init = %tmp
  br label %pass_loop

pass_loop:                                         ; preds = %after_pass, %sort_start
  %inptr = phi i32* [ %inptr.init, %sort_start ], [ %inptr.next, %after_pass ]
  %outptr = phi i32* [ %outptr.init, %sort_start ], [ %outptr.next, %after_pass ]
  %width = phi i64 [ 1, %sort_start ], [ %width.shl, %after_pass ]
  %passes = phi i32 [ 4, %sort_start ], [ %passes.dec, %after_pass ]
  br label %chunk_loop

chunk_loop:                                        ; preds = %chunk_next, %pass_loop
  %i = phi i64 [ 0, %pass_loop ], [ %i.next, %chunk_next ]
  %cmp.i.end = icmp ult i64 %i, 10
  br i1 %cmp.i.end, label %prepare_chunk, label %after_chunks

prepare_chunk:                                     ; preds = %chunk_loop
  %i.plus.w = add i64 %i, %width
  %i.plus.tw = add i64 %i.plus.w, %width
  %mid.cmp = icmp ult i64 %i.plus.w, 10
  %mid = select i1 %mid.cmp, i64 %i.plus.w, i64 10
  %right.cmp = icmp ult i64 %i.plus.tw, 10
  %right = select i1 %right.cmp, i64 %i.plus.tw, i64 10
  %no_range = icmp ule i64 %right, %i
  br i1 %no_range, label %chunk_next, label %merge_loop

merge_loop:                                        ; preds = %merge_takeR, %merge_takeL, %prepare_chunk
  %L = phi i64 [ %i, %prepare_chunk ], [ %L.nextL, %merge_takeL ], [ %L.cur, %merge_takeR ]
  %R = phi i64 [ %mid, %prepare_chunk ], [ %R.cur, %merge_takeL ], [ %R.nextR, %merge_takeR ]
  %D = phi i64 [ %i, %prepare_chunk ], [ %D.nextL, %merge_takeL ], [ %D.nextR, %merge_takeR ]
  %dest.lt = icmp ult i64 %D, %right
  br i1 %dest.lt, label %choose_source, label %chunk_next

choose_source:                                     ; preds = %merge_loop
  %L.has = icmp ult i64 %L, %mid
  br i1 %L.has, label %check_R, label %take_from_R_only

check_R:                                           ; preds = %choose_source
  %R.has = icmp ult i64 %R, %right
  br i1 %R.has, label %compare_vals, label %take_from_L_only

compare_vals:                                      ; preds = %check_R
  %L.ptr = getelementptr inbounds i32, i32* %inptr, i64 %L
  %R.ptr = getelementptr inbounds i32, i32* %inptr, i64 %R
  %L.val = load i32, i32* %L.ptr, align 4
  %R.val = load i32, i32* %R.ptr, align 4
  %r_lt_l = icmp slt i32 %R.val, %L.val
  br i1 %r_lt_l, label %merge_takeR, label %merge_takeL

take_from_L_only:                                  ; preds = %check_R
  %L.ptr.only = getelementptr inbounds i32, i32* %inptr, i64 %L
  %L.val.only = load i32, i32* %L.ptr.only, align 4
  %D.ptr.onlyL = getelementptr inbounds i32, i32* %outptr, i64 %D
  store i32 %L.val.only, i32* %D.ptr.onlyL, align 4
  %D.nextL.only = add i64 %D, 1
  %L.nextL.only = add i64 %L, 1
  br label %merge_loop_latchL

take_from_R_only:                                  ; preds = %choose_source
  %R.ptr.only = getelementptr inbounds i32, i32* %inptr, i64 %R
  %R.val.only = load i32, i32* %R.ptr.only, align 4
  %D.ptr.onlyR = getelementptr inbounds i32, i32* %outptr, i64 %D
  store i32 %R.val.only, i32* %D.ptr.onlyR, align 4
  %D.nextR.only = add i64 %D, 1
  %R.nextR.only = add i64 %R, 1
  br label %merge_loop_latchR

merge_takeL:                                       ; preds = %compare_vals
  %D.ptrL = getelementptr inbounds i32, i32* %outptr, i64 %D
  %L.ptr2 = getelementptr inbounds i32, i32* %inptr, i64 %L
  %L.val2 = load i32, i32* %L.ptr2, align 4
  store i32 %L.val2, i32* %D.ptrL, align 4
  %D.nextL = add i64 %D, 1
  %L.nextL = add i64 %L, 1
  br label %merge_loop

merge_takeR:                                       ; preds = %compare_vals
  %D.ptrR = getelementptr inbounds i32, i32* %outptr, i64 %D
  %R.ptr2 = getelementptr inbounds i32, i32* %inptr, i64 %R
  %R.val2 = load i32, i32* %R.ptr2, align 4
  store i32 %R.val2, i32* %D.ptrR, align 4
  %D.nextR = add i64 %D, 1
  %R.nextR = add i64 %R, 1
  br label %merge_loop

merge_loop_latchL:                                 ; preds = %take_from_L_only
  %L.cur = phi i64 [ %L.nextL.only, %take_from_L_only ]
  %R.cur = phi i64 [ %R, %take_from_L_only ]
  %D.curL = phi i64 [ %D.nextL.only, %take_from_L_only ]
  br label %merge_loop

merge_loop_latchR:                                 ; preds = %take_from_R_only
  %L.cur2 = phi i64 [ %L, %take_from_R_only ]
  %R.cur2 = phi i64 [ %R.nextR.only, %take_from_R_only ]
  %D.curR = phi i64 [ %D.nextR.only, %take_from_R_only ]
  br label %merge_loop

chunk_next:                                        ; preds = %merge_loop, %prepare_chunk
  %i.next = add i64 %i, %width
  %i.next2 = add i64 %i.next, %width
  br label %chunk_loop

after_chunks:                                      ; preds = %chunk_loop
  %passes.dec = add nsw i32 %passes, -1
  %is_last = icmp eq i32 %passes.dec, 0
  br i1 %is_last, label %end_sort, label %after_pass

after_pass:                                        ; preds = %after_chunks
  %width.shl = shl i64 %width, 1
  ; swap inptr/outptr
  %inptr.next = %outptr
  %outptr.next = %inptr
  br label %pass_loop

end_sort:                                          ; preds = %after_chunks
  ; outptr holds the destination of the last pass
  %arr.ptr = bitcast [10 x i32]* %arr to i32*
  %need_copy = icmp ne i32* %outptr, %arr.ptr
  br i1 %need_copy, label %copy_loop, label %after_copy

copy_loop:                                         ; preds = %end_sort, %copy_loop
  %ci = phi i64 [ 0, %end_sort ], [ %ci.next, %copy_loop ]
  %cmp.ci = icmp ult i64 %ci, 10
  br i1 %cmp.ci, label %copy_body, label %after_copy

copy_body:                                         ; preds = %copy_loop
  %src.p = getelementptr inbounds i32, i32* %outptr, i64 %ci
  %v = load i32, i32* %src.p, align 4
  %dst.p = getelementptr inbounds i32, i32* %arr.ptr, i64 %ci
  store i32 %v, i32* %dst.p, align 4
  %ci.next = add i64 %ci, 1
  br label %copy_loop

after_copy:                                        ; preds = %copy_loop, %end_sort
  call void @free(i8* %tmp.raw)
  br label %print_sorted

print_only:                                        ; preds = %entry
  br label %print_sorted

print_sorted:                                      ; preds = %after_copy, %print_only
  %print.i = phi i64 [ 0, %print_only ], [ 0, %after_copy ]
  br label %print_loop

print_loop:                                        ; preds = %print_loop, %print_sorted
  %pi = phi i64 [ %print.i, %print_sorted ], [ %pi.next, %print_loop ]
  %cmp.pi = icmp ult i64 %pi, 10
  br i1 %cmp.pi, label %print_body, label %print_nl

print_body:                                        ; preds = %print_loop
  %elem.p = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 %pi
  %elem.v = load i32, i32* %elem.p, align 4
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %elem.v)
  %pi.next = add i64 %pi, 1
  br label %print_loop

print_nl:                                          ; preds = %print_loop
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.strnl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}