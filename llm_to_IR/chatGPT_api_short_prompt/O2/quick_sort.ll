; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 ints and print (confidence=0.85). Evidence: malloc(40) + iterative merge loops; __printf_chk("%d ") sequence
; Preconditions: none
; Postconditions: prints sorted sequence then newline; returns 0

; Only the necessary external declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

define dso_local i32 @main(i32 %argc, i8** %argv, i8** %envp) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arrp = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arrp, align 4
  %p1 = getelementptr inbounds i32, i32* %arrp, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arrp, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arrp, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arrp, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arrp, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arrp, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arrp, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arrp, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arrp, i64 9
  store i32 0, i32* %p9, align 4
  %buf.i8 = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %buf.i8, null
  br i1 %isnull, label %print, label %sort

sort:                                             ; preds = %entry
  %buf = bitcast i8* %buf.i8 to i32*
  br label %pass_loop

pass_loop:                                        ; preds = %after_inner, %sort
  %pass = phi i32 [ 0, %sort ], [ %pass.next, %after_inner ]
  %src = phi i32* [ %arrp, %sort ], [ %src.next, %after_inner ]
  %dst = phi i32* [ %buf, %sort ], [ %dst.next, %after_inner ]
  %width = phi i32 [ 1, %sort ], [ %width.next, %after_inner ]
  br label %inner

inner:                                            ; preds = %merge_done, %pass_loop
  %start = phi i32 [ 0, %pass_loop ], [ %start.next, %merge_done ]
  %cmp.start = icmp sge i32 %start, 10
  br i1 %cmp.start, label %after_inner, label %do_merge

do_merge:                                         ; preds = %inner
  %mid.raw = add nsw i32 %start, %width
  %mid.gt = icmp sgt i32 %mid.raw, 10
  %mid = select i1 %mid.gt, i32 10, i32 %mid.raw
  %end.raw = add nsw i32 %mid, %width
  %end.gt = icmp sgt i32 %end.raw, 10
  %end = select i1 %end.gt, i32 10, i32 %end.raw
  br label %merge_loop

merge_loop:                                       ; preds = %merge_copy, %do_merge
  %k = phi i32 [ %start, %do_merge ], [ %k.next, %merge_copy ]
  %i = phi i32 [ %start, %do_merge ], [ %i.next, %merge_copy ]
  %j = phi i32 [ %mid, %do_merge ], [ %j.next, %merge_copy ]
  %cond.k = icmp slt i32 %k, %end
  br i1 %cond.k, label %merge_body, label %merge_done

merge_body:                                       ; preds = %merge_loop
  %left.has = icmp slt i32 %i, %mid
  br i1 %left.has, label %check_right, label %take_right

check_right:                                      ; preds = %merge_body
  %right.has = icmp slt i32 %j, %end
  br i1 %right.has, label %cmp_vals, label %take_left

cmp_vals:                                         ; preds = %check_right
  %iptr = getelementptr inbounds i32, i32* %src, i64 0
  %ival.ptr = getelementptr inbounds i32, i32* %iptr, i64 0
  %i.elem.ptr = getelementptr inbounds i32, i32* %src, i64 0
  %li.ptr = getelementptr inbounds i32, i32* %src, i64 sext(i32 %i) to i64
  %rj.ptr = getelementptr inbounds i32, i32* %src, i64 sext(i32 %j) to i64
  %li = load i32, i32* %li.ptr, align 4
  %rj = load i32, i32* %rj.ptr, align 4
  %le = icmp sle i32 %li, %rj
  br i1 %le, label %take_left, label %take_right

take_left:                                        ; preds = %check_right, %cmp_vals
  %val.left = phi i32 [ load i32, i32* %li.ptr, align 4, %cmp_vals ], [ load i32, i32* %li2.ptr, align 4, %check_right ]
  ; In %check_right path (right exhausted), we need li2.ptr = src + i
  %li2.ptr = getelementptr inbounds i32, i32* %src, i64 sext(i32 %i) to i64
  br label %merge_copy

take_right:                                       ; preds = %merge_body, %cmp_vals
  %val.right = phi i32 [ %rj, %cmp_vals ], [ load i32, i32* %rj2.ptr, align 4, %merge_body ]
  ; In %merge_body path (left exhausted), rj2.ptr = src + j
  %rj2.ptr = getelementptr inbounds i32, i32* %src, i64 sext(i32 %j) to i64
  br label %merge_copy

merge_copy:                                       ; preds = %take_right, %take_left
  %chosen = phi i32 [ %val.left, %take_left ], [ %val.right, %take_right ]
  %i.next = phi i32 [ add (i32 %i, i32 1), %take_left ], [ %i, %take_right ]
  %j.next = phi i32 [ %j, %take_left ], [ add (i32 %j, i32 1), %take_right ]
  %dst.k.ptr = getelementptr inbounds i32, i32* %dst, i64 sext(i32 %k) to i64
  store i32 %chosen, i32* %dst.k.ptr, align 4
  %k.next = add nsw i32 %k, 1
  br label %merge_loop

merge_done:                                       ; preds = %merge_loop
  %twoW = shl i32 %width, 1
  %start.next = add nsw i32 %start, %twoW
  br label %inner

after_inner:                                      ; preds = %inner
  %pass.next = add nuw nsw i32 %pass, 1
  %width.next = shl i32 %width, 1
  %more = icmp slt i32 %pass.next, 4
  %src.next = select i1 %more, i32* %dst, i32* %src
  %dst.next = select i1 %more, i32* %src, i32* %dst
  br i1 %more, label %pass_loop, label %post_sort

post_sort:                                        ; preds = %after_inner
  call void @free(i8* %buf.i8)
  br label %print

print:                                            ; preds = %post_sort, %entry
  %fmt.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %nl.ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %print
  %idx = phi i32 [ 0, %print ], [ %idx.next, %print.loop ]
  %end.print = icmp eq i32 %idx, 10
  br i1 %end.print, label %print.nl, label %print.body

print.body:                                       ; preds = %print.loop
  %elem.ptr = getelementptr inbounds i32, i32* %arrp, i64 sext(i32 %idx) to i64
  %val = load i32, i32* %elem.ptr, align 4
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt.ptr, i32 %val)
  %idx.next = add nuw nsw i32 %idx, 1
  br label %print.loop

print.nl:                                         ; preds = %print.loop
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nl.ptr)
  ret i32 0
}