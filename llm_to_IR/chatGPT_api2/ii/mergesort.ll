; ModuleID = 'main'
target triple = "x86_64-unknown-linux-gnu"

; Symbol: main  ; Address: 0x10C0
; Intent: Bottom-up mergesort of 10 integers, then print them (confidence=0.95). Evidence: iterative merge with width doubling; temp buffer via malloc and final "%d " printing loop.
; Preconditions: none
; Postconditions: prints the 10 integers; if malloc fails, prints the original unsorted sequence.

@.str = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.nl = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)

define dso_local i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
entry:
  %a = alloca [10 x i32], align 16
  %a0 = getelementptr inbounds [10 x i32], [10 x i32]* %a, i64 0, i64 0
  %p0 = getelementptr inbounds i32, i32* %a0, i64 0
  store i32 9, i32* %p0, align 4
  %p1 = getelementptr inbounds i32, i32* %a0, i64 1
  store i32 1, i32* %p1, align 4
  %p2 = getelementptr inbounds i32, i32* %a0, i64 2
  store i32 5, i32* %p2, align 4
  %p3 = getelementptr inbounds i32, i32* %a0, i64 3
  store i32 3, i32* %p3, align 4
  %p4 = getelementptr inbounds i32, i32* %a0, i64 4
  store i32 7, i32* %p4, align 4
  %p5 = getelementptr inbounds i32, i32* %a0, i64 5
  store i32 2, i32* %p5, align 4
  %p6 = getelementptr inbounds i32, i32* %a0, i64 6
  store i32 8, i32* %p6, align 4
  %p7 = getelementptr inbounds i32, i32* %a0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds i32, i32* %a0, i64 8
  store i32 4, i32* %p8, align 4
  %p9 = getelementptr inbounds i32, i32* %a0, i64 9
  store i32 0, i32* %p9, align 4
  %tmpraw = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %tmpraw, null
  br i1 %isnull, label %print_entry, label %sort_entry

sort_entry:
  %tmp = bitcast i8* %tmpraw to i32*
  br label %pass_header

pass_header:
  %width = phi i32 [ 1, %sort_entry ], [ %width.next, %post_pass ]
  %src = phi i32* [ %a0, %sort_entry ], [ %src.next, %post_pass ]
  %dst = phi i32* [ %tmp, %sort_entry ], [ %dst.next, %post_pass ]
  br label %merge_loop_header

merge_loop_header:
  %i = phi i32 [ 0, %pass_header ], [ %i.next, %merge_done ]
  %i.ge.n = icmp sge i32 %i, 10
  br i1 %i.ge.n, label %post_pass, label %do_merge

do_merge:
  %mid.sum = add i32 %i, %width
  %mid.gt = icmp sgt i32 %mid.sum, 10
  %mid = select i1 %mid.gt, i32 10, i32 %mid.sum
  %tw = shl i32 %width, 1
  %right.sum = add i32 %i, %tw
  %right.gt = icmp sgt i32 %right.sum, 10
  %right = select i1 %right.gt, i32 10, i32 %right.sum
  br label %merge_inner

merge_inner:
  %l = phi i32 [ %i, %do_merge ], [ %l.next, %write_left ], [ %l.next2, %write_right ]
  %r = phi i32 [ %mid, %do_merge ], [ %r.next1, %write_left ], [ %r.next, %write_right ]
  %k = phi i32 [ %i, %do_merge ], [ %k.next1, %write_left ], [ %k.next, %write_right ]
  %k.ge.right = icmp sge i32 %k, %right
  br i1 %k.ge.right, label %merge_done, label %choose

choose:
  %l.lt.mid = icmp slt i32 %l, %mid
  br i1 %l.lt.mid, label %right_check, label %take_right_pre

right_check:
  %r.ge.right = icmp sge i32 %r, %right
  br i1 %r.ge.right, label %take_left_pre, label %cmp_vals

cmp_vals:
  %l64 = zext i32 %l to i64
  %r64 = zext i32 %r to i64
  %lptr = getelementptr inbounds i32, i32* %src, i64 %l64
  %rptr = getelementptr inbounds i32, i32* %src, i64 %r64
  %lv = load i32, i32* %lptr, align 4
  %rv = load i32, i32* %rptr, align 4
  %rvltlv = icmp slt i32 %rv, %lv
  br i1 %rvltlv, label %take_right_from_cmp, label %take_left_from_cmp

take_left_pre:
  %l64.pre = zext i32 %l to i64
  %lptr.pre = getelementptr inbounds i32, i32* %src, i64 %l64.pre
  %lv.pre = load i32, i32* %lptr.pre, align 4
  br label %write_left

take_left_from_cmp:
  br label %write_left

write_left:
  %lv.final = phi i32 [ %lv.pre, %take_left_pre ], [ %lv, %take_left_from_cmp ]
  %k64 = zext i32 %k to i64
  %dstk = getelementptr inbounds i32, i32* %dst, i64 %k64
  store i32 %lv.final, i32* %dstk, align 4
  %k.next1 = add i32 %k, 1
  %l.next = add i32 %l, 1
  %r.next1 = %r
  br label %merge_inner

take_right_pre:
  %r64.pre = zext i32 %r to i64
  %rptr.pre = getelementptr inbounds i32, i32* %src, i64 %r64.pre
  %rv.pre = load i32, i32* %rptr.pre, align 4
  br label %write_right

take_right_from_cmp:
  br label %write_right

write_right:
  %rv.final = phi i32 [ %rv.pre, %take_right_pre ], [ %rv, %take_right_from_cmp ]
  %k64r = zext i32 %k to i64
  %dstk.r = getelementptr inbounds i32, i32* %dst, i64 %k64r
  store i32 %rv.final, i32* %dstk.r, align 4
  %k.next = add i32 %k, 1
  %r.next = add i32 %r, 1
  %l.next2 = %l
  br label %merge_inner

merge_done:
  %i.next = add i32 %i, %tw
  br label %merge_loop_header

post_pass:
  %width.next = shl i32 %width, 1
  %width.next.ge.n = icmp sge i32 %width.next, 10
  %src.next = select i1 %width.next.ge.n, i32* %src, i32* %dst
  %dst.next = select i1 %width.next.ge.n, i32* %dst, i32* %src
  br i1 %width.next.ge.n, label %after_pass_not_swapped, label %pass_header

after_pass_not_swapped:
  %dst_is_a = icmp eq i32* %dst, %a0
  br i1 %dst_is_a, label %free_and_print, label %copy_loop

copy_loop:
  %j = phi i32 [ 0, %after_pass_not_swapped ], [ %j.next, %copy_body ]
  %j.ge.n = icmp sge i32 %j, 10
  br i1 %j.ge.n, label %free_and_print, label %copy_body

copy_body:
  %j64 = zext i32 %j to i64
  %srcj = getelementptr inbounds i32, i32* %dst, i64 %j64
  %valj = load i32, i32* %srcj, align 4
  %dstj = getelementptr inbounds i32, i32* %a0, i64 %j64
  store i32 %valj, i32* %dstj, align 4
  %j.next = add i32 %j, 1
  br label %copy_loop

free_and_print:
  call void @free(i8* %tmpraw)
  br label %print_entry

print_entry:
  br label %print_loop

print_loop:
  %pi = phi i32 [ 0, %print_entry ], [ %pi.next, %print_body ]
  %pi.ge.n = icmp sge i32 %pi, 10
  br i1 %pi.ge.n, label %print_nl, label %print_body

print_body:
  %pi64 = zext i32 %pi to i64
  %aptr = getelementptr inbounds i32, i32* %a0, i64 %pi64
  %val = load i32, i32* %aptr, align 4
  %fmtptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str, i64 0, i64 0
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %fmtptr, i32 %val)
  %pi.next = add i32 %pi, 1
  br label %print_loop

print_nl:
  %nlptr = getelementptr inbounds [2 x i8], [2 x i8]* @.nl, i64 0, i64 0
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 1, i8* %nlptr)
  ret i32 0
}