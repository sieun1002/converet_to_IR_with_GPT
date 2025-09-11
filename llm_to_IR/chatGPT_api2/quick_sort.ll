; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x00000000000010C0
; Intent: Sort 10 integers with bottom-up mergesort and print them (confidence=0.92). Evidence: malloc(40) and iterative merge passes with doubling run length; printing 10 ints with "%d " then newline.
; Preconditions: None (uses a fixed local array of 10 ints).
; Postconditions: Prints the 10 integers in ascending order, separated by spaces and a newline.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

; Only the needed extern declarations:
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 9, i32* %arr0, align 4
  %p1 = getelementptr inbounds i32, i32* %arr0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %arr0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %arr0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %arr0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %arr0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %arr0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %arr0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %arr0, i64 9
  store i32 0, i32* %p9, align 4
  %buf.raw = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %buf.raw, null
  br i1 %isnull, label %print, label %sort_setup

sort_setup:                                       ; preds = %entry
  %buf = bitcast i8* %buf.raw to i32*
  br label %outer

outer:                                            ; preds = %outer_end, %sort_setup
  %width = phi i64 [ 1, %sort_setup ], [ %width.next, %outer_end ]
  %src = phi i32* [ %arr0, %sort_setup ], [ %dst2, %outer_end ]
  %dst = phi i32* [ %buf, %sort_setup ], [ %src2, %outer_end ]
  %width_ge_n = icmp uge i64 %width, 10
  br i1 %width_ge_n, label %outer_done, label %inner

inner:                                            ; preds = %outer, %inner_end
  %i = phi i64 [ 0, %outer ], [ %i.next, %inner_end ]
  %twoW = shl i64 %width, 1
  %m.tmp = add i64 %i, %width
  %m.lt = icmp ult i64 %m.tmp, 10
  %m = select i1 %m.lt, i64 %m.tmp, i64 10
  %r.tmp = add i64 %m.tmp, %width
  %r.lt = icmp ult i64 %r.tmp, 10
  %r = select i1 %r.lt, i64 %r.tmp, i64 10
  br label %merge.header

merge.header:                                     ; preds = %merge.body_done, %inner
  %a = phi i64 [ %i, %inner ], [ %a.new, %merge.body_done ]
  %b = phi i64 [ %m, %inner ], [ %b.new, %merge.body_done ]
  %k = phi i64 [ %i, %inner ], [ %k.new, %merge.body_done ]
  %k.lt.r = icmp ult i64 %k, %r
  br i1 %k.lt.r, label %merge.body, label %merge.done

merge.body:                                       ; preds = %merge.header
  %b.lt.r = icmp ult i64 %b, %r
  %a.ge.m = icmp uge i64 %a, %m
  br i1 %b.lt.r, label %check_left, label %take_left

check_left:                                       ; preds = %merge.body
  br i1 %a.ge.m, label %take_right, label %cmp_lr

cmp_lr:                                           ; preds = %check_left
  %left.ptr = getelementptr inbounds i32, i32* %src, i64 %a
  %left.val = load i32, i32* %left.ptr, align 4
  %right.ptr = getelementptr inbounds i32, i32* %src, i64 %b
  %right.val = load i32, i32* %right.ptr, align 4
  %right.lt.left = icmp slt i32 %right.val, %left.val
  br i1 %right.lt.left, label %take_right.withvals, label %take_left.withvals

take_right:                                       ; preds = %check_left
  %right.ptr0 = getelementptr inbounds i32, i32* %src, i64 %b
  %right.val0 = load i32, i32* %right.ptr0, align 4
  br label %write_right

take_right.withvals:                              ; preds = %cmp_lr
  br label %write_right

write_right:                                      ; preds = %take_right.withvals, %take_right
  %right.val.phi = phi i32 [ %right.val0, %take_right ], [ %right.val, %take_right.withvals ]
  %b.inc = add i64 %b, 1
  %dst.ptr.k = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %right.val.phi, i32* %dst.ptr.k, align 4
  %k.inc = add i64 %k, 1
  br label %merge.body_done

take_left:                                        ; preds = %merge.body
  %left.ptr0 = getelementptr inbounds i32, i32* %src, i64 %a
  %left.val0 = load i32, i32* %left.ptr0, align 4
  br label %write_left

take_left.withvals:                               ; preds = %cmp_lr
  br label %write_left

write_left:                                       ; preds = %take_left.withvals, %take_left
  %left.val.phi = phi i32 [ %left.val0, %take_left ], [ %left.val, %take_left.withvals ]
  %a.inc = add i64 %a, 1
  %dst.ptr.k2 = getelementptr inbounds i32, i32* %dst, i64 %k
  store i32 %left.val.phi, i32* %dst.ptr.k2, align 4
  %k.inc2 = add i64 %k, 1
  br label %merge.body_done

merge.body_done:                                  ; preds = %write_left, %write_right
  %a.new = phi i64 [ %a, %write_right ], [ %a.inc, %write_left ]
  %b.new = phi i64 [ %b.inc, %write_right ], [ %b, %write_left ]
  %k.new = phi i64 [ %k.inc, %write_right ], [ %k.inc2, %write_left ]
  br label %merge.header

merge.done:                                       ; preds = %merge.header
  br label %inner_end

inner_end:                                        ; preds = %merge.done
  %i.next = add i64 %i, %twoW
  %more = icmp ult i64 %i.next, 10
  br i1 %more, label %inner, label %outer_end

outer_end:                                        ; preds = %inner_end
  %src2 = phi i32* [ %src, %inner_end ]
  %dst2 = phi i32* [ %dst, %inner_end ]
  %width.next = shl i64 %width, 1
  br label %outer

outer_done:                                       ; preds = %outer
  %src.i8 = bitcast i32* %src to i8*
  %arr.i8 = bitcast i32* %arr0 to i8*
  %src.is.arr = icmp eq i8* %src.i8, %arr.i8
  br i1 %src.is.arr, label %after_copy, label %copy_loop

copy_loop:                                        ; preds = %outer_done, %copy_loop
  %ci = phi i64 [ 0, %outer_done ], [ %ci.next, %copy_loop ]
  %s.ptr = getelementptr inbounds i32, i32* %src, i64 %ci
  %val = load i32, i32* %s.ptr, align 4
  %d.ptr = getelementptr inbounds i32, i32* %arr0, i64 %ci
  store i32 %val, i32* %d.ptr, align 4
  %ci.next = add i64 %ci, 1
  %cont = icmp ult i64 %ci.next, 10
  br i1 %cont, label %copy_loop, label %after_copy

after_copy:                                       ; preds = %copy_loop, %outer_done
  call void @free(i8* %buf.raw)
  br label %print

print:                                            ; preds = %after_copy, %entry
  %pi = phi i64 [ 0, %after_copy ], [ 0, %entry ]
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  br label %print.loop

print.loop:                                       ; preds = %print.loop, %print
  %i.print = phi i64 [ %pi, %print ], [ %i.next.print, %print.loop ]
  %elem.ptr = getelementptr inbounds i32, i32* %arr0, i64 %i.print
  %elem = load i32, i32* %elem.ptr, align 4
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmt, i32 %elem)
  %i.next.print = add i64 %i.print, 1
  %more.print = icmp ult i64 %i.next.print, 10
  br i1 %more.print, label %print.loop, label %print.end

print.end:                                        ; preds = %print.loop
  %nlp = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlp)
  ret i32 0
}