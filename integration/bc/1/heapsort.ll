; ModuleID = 'heapsort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.fmt_before = private unnamed_addr constant [8 x i8] c"Before:\00"
@.fmt_after = private unnamed_addr constant [7 x i8] c"After:\00"
@.fmt_d = private unnamed_addr constant [4 x i8] c"%d \00"

define dso_local i32 @main() {
entry:
  %arr = alloca [9 x i32], align 16
  %p0 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %p0, align 4
  %p1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %p1, align 4
  %p2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %p2, align 4
  %p3 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %p3, align 4
  %p4 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %p4, align 4
  %p5 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %p5, align 4
  %p6 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %p6, align 4
  %p7 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %p7, align 4
  %p8 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %p8, align 4
  %fmt_before_ptr = getelementptr inbounds [8 x i8], [8 x i8]* @.fmt_before, i64 0, i64 0
  %call_banner1 = call i32 (i8*, ...) @printf(i8* noundef %fmt_before_ptr)
  br label %loop1.cond

loop1.cond:                                       ; preds = %loop1.latch, %entry
  %i = phi i64 [ 0, %entry ], [ %i.next, %loop1.latch ]
  %cmp1 = icmp ult i64 %i, 9
  br i1 %cmp1, label %loop1.body, label %loop1.end

loop1.body:                                       ; preds = %loop1.cond
  %elem.ptr1 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i
  %elem1 = load i32, i32* %elem.ptr1, align 4
  %fmt_d_ptr1 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %call_print1 = call i32 (i8*, ...) @printf(i8* noundef %fmt_d_ptr1, i32 noundef %elem1)
  br label %loop1.latch

loop1.latch:                                      ; preds = %loop1.body
  %i.next = add i64 %i, 1
  br label %loop1.cond

loop1.end:                                        ; preds = %loop1.cond
  %nl1 = call i32 @putchar(i32 noundef 10)
  %arr.base = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* noundef %arr.base, i64 noundef 9)
  %fmt_after_ptr = getelementptr inbounds [7 x i8], [7 x i8]* @.fmt_after, i64 0, i64 0
  %call_banner2 = call i32 (i8*, ...) @printf(i8* noundef %fmt_after_ptr)
  br label %loop2.cond

loop2.cond:                                       ; preds = %loop2.latch, %loop1.end
  %j = phi i64 [ 0, %loop1.end ], [ %j.next, %loop2.latch ]
  %cmp2 = icmp ult i64 %j, 9
  br i1 %cmp2, label %loop2.body, label %loop2.end

loop2.body:                                       ; preds = %loop2.cond
  %elem.ptr2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j
  %elem2 = load i32, i32* %elem.ptr2, align 4
  %fmt_d_ptr2 = getelementptr inbounds [4 x i8], [4 x i8]* @.fmt_d, i64 0, i64 0
  %call_print2 = call i32 (i8*, ...) @printf(i8* noundef %fmt_d_ptr2, i32 noundef %elem2)
  br label %loop2.latch

loop2.latch:                                      ; preds = %loop2.body
  %j.next = add i64 %j, 1
  br label %loop2.cond

loop2.end:                                        ; preds = %loop2.cond
  %nl2 = call i32 @putchar(i32 noundef 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %n) {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %build.init

build.init:                                       ; preds = %entry
  %half0 = lshr i64 %n, 1
  br label %build.top

build.top:                                        ; preds = %build.end, %build.init
  %i_old1 = phi i64 [ %half0, %build.init ], [ %i_dec_next6, %build.end ]
  %cond2 = icmp ne i64 %i_old1, 0
  br i1 %cond2, label %build.body, label %sort.init

build.body:                                       ; preds = %build.top
  %i_dec3 = add i64 %i_old1, -1
  br label %sift1.head

sift1.head:                                       ; preds = %sift1.swap, %build.body
  %k4 = phi i64 [ %i_dec3, %build.body ], [ %k_next18, %sift1.swap ]
  %k2mul5 = add i64 %k4, %k4
  %left6 = add i64 %k2mul5, 1
  %left_ge_n7 = icmp uge i64 %left6, %n
  br i1 %left_ge_n7, label %sift1.break, label %sift1.hasleft

sift1.hasleft:                                    ; preds = %sift1.head
  %right8 = add i64 %left6, 1
  %right_in_range9 = icmp ult i64 %right8, %n
  %left_ptr10 = getelementptr inbounds i32, i32* %arr, i64 %left6
  %left_val11 = load i32, i32* %left_ptr10, align 4
  br i1 %right_in_range9, label %s1.cmp.right, label %s1.choose.left

s1.cmp.right:                                     ; preds = %sift1.hasleft
  %right_ptr12 = getelementptr inbounds i32, i32* %arr, i64 %right8
  %right_val13 = load i32, i32* %right_ptr12, align 4
  %gt14 = icmp sgt i32 %right_val13, %left_val11
  br i1 %gt14, label %s1.choose.right, label %s1.choose.left

s1.choose.right:                                  ; preds = %s1.cmp.right
  br label %s1.m.chosen

s1.choose.left:                                   ; preds = %s1.cmp.right, %sift1.hasleft
  br label %s1.m.chosen

s1.m.chosen:                                      ; preds = %s1.choose.left, %s1.choose.right
  %m_idx15 = phi i64 [ %right8, %s1.choose.right ], [ %left6, %s1.choose.left ]
  %k_ptr16 = getelementptr inbounds i32, i32* %arr, i64 %k4
  %k_val17 = load i32, i32* %k_ptr16, align 4
  %m_ptr18 = getelementptr inbounds i32, i32* %arr, i64 %m_idx15
  %m_val19 = load i32, i32* %m_ptr18, align 4
  %ge20 = icmp sge i32 %k_val17, %m_val19
  br i1 %ge20, label %sift1.break, label %sift1.swap

sift1.swap:                                       ; preds = %s1.m.chosen
  store i32 %m_val19, i32* %k_ptr16, align 4
  store i32 %k_val17, i32* %m_ptr18, align 4
  %k_next18 = add i64 %m_idx15, 0
  br label %sift1.head

sift1.break:                                      ; preds = %s1.m.chosen, %sift1.head
  br label %build.end

build.end:                                        ; preds = %sift1.break
  %i_dec_next6 = add i64 %i_dec3, 0
  br label %build.top

sort.init:                                        ; preds = %build.top
  %end_init21 = add i64 %n, -1
  br label %sort.loop.cond

sort.loop.cond:                                   ; preds = %after_sift2, %sort.init
  %end_cur22 = phi i64 [ %end_init21, %sort.init ], [ %end_next37, %after_sift2 ]
  %nz23 = icmp ne i64 %end_cur22, 0
  br i1 %nz23, label %sort.body, label %exit

sort.body:                                        ; preds = %sort.loop.cond
  %root_ptr24 = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val25 = load i32, i32* %root_ptr24, align 4
  %end_ptr26 = getelementptr inbounds i32, i32* %arr, i64 %end_cur22
  %end_val27 = load i32, i32* %end_ptr26, align 4
  store i32 %end_val27, i32* %root_ptr24, align 4
  store i32 %root_val25, i32* %end_ptr26, align 4
  br label %sift2.head

sift2.head:                                       ; preds = %sift2.swap, %sort.body
  %k2_28 = phi i64 [ 0, %sort.body ], [ %k2_next36, %sift2.swap ]
  %twok29 = add i64 %k2_28, %k2_28
  %left2_30 = add i64 %twok29, 1
  %left_ge_end31 = icmp uge i64 %left2_30, %end_cur22
  br i1 %left_ge_end31, label %after_sift2, label %sift2.hasleft

sift2.hasleft:                                    ; preds = %sift2.head
  %right2_32 = add i64 %left2_30, 1
  %right_in_range2_33 = icmp ult i64 %right2_32, %end_cur22
  %left_ptr2_34 = getelementptr inbounds i32, i32* %arr, i64 %left2_30
  %left_val2_35 = load i32, i32* %left_ptr2_34, align 4
  br i1 %right_in_range2_33, label %s2.cmp.right, label %s2.choose.left

s2.cmp.right:                                     ; preds = %sift2.hasleft
  %right_ptr2_36 = getelementptr inbounds i32, i32* %arr, i64 %right2_32
  %right_val2_37 = load i32, i32* %right_ptr2_36, align 4
  %gt2_38 = icmp sgt i32 %right_val2_37, %left_val2_35
  br i1 %gt2_38, label %s2.choose.right, label %s2.choose.left

s2.choose.right:                                  ; preds = %s2.cmp.right
  br label %s2.m.chosen

s2.choose.left:                                   ; preds = %s2.cmp.right, %sift2.hasleft
  br label %s2.m.chosen

s2.m.chosen:                                      ; preds = %s2.choose.left, %s2.choose.right
  %m2_idx39 = phi i64 [ %right2_32, %s2.choose.right ], [ %left2_30, %s2.choose.left ]
  %k2_ptr40 = getelementptr inbounds i32, i32* %arr, i64 %k2_28
  %k2_val41 = load i32, i32* %k2_ptr40, align 4
  %m2_ptr42 = getelementptr inbounds i32, i32* %arr, i64 %m2_idx39
  %m2_val43 = load i32, i32* %m2_ptr42, align 4
  %ge2_44 = icmp sge i32 %k2_val41, %m2_val43
  br i1 %ge2_44, label %after_sift2, label %sift2.swap

sift2.swap:                                       ; preds = %s2.m.chosen
  store i32 %m2_val43, i32* %k2_ptr40, align 4
  store i32 %k2_val41, i32* %m2_ptr42, align 4
  %k2_next36 = add i64 %m2_idx39, 0
  br label %sift2.head

after_sift2:                                      ; preds = %s2.m.chosen, %sift2.head
  %end_next37 = add i64 %end_cur22, -1
  br label %sort.loop.cond

exit:                                             ; preds = %sort.loop.cond, %entry
  ret void
}
