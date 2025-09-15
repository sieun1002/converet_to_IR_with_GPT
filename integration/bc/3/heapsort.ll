; ModuleID = 'heapsort.bc'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [19 x i8] c"Before Heap Sort: \00", align 1
@.str.after = private unnamed_addr constant [18 x i8] c"After Heap Sort: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() #0 {
entry:
  %arr = alloca [9 x i32], align 16
  %len = alloca i64, align 8
  %i.ptr = alloca i64, align 8
  %j.ptr = alloca i64, align 8
  %before.ptr = getelementptr inbounds [19 x i8], [19 x i8]* @.str.before, i64 0, i64 0
  %after.ptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.after, i64 0, i64 0
  %fmtd.ptr = getelementptr inbounds [4 x i8], [4 x i8]* @.str.d, i64 0, i64 0
  %elt0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %elt0.ptr, align 4
  %elt1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %elt1.ptr, align 4
  %elt2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %elt2.ptr, align 4
  %elt3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %elt3.ptr, align 4
  %elt4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %elt4.ptr, align 4
  %elt5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %elt5.ptr, align 4
  %elt6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %elt6.ptr, align 4
  %elt7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7.ptr, align 4
  %elt8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %elt8.ptr, align 4
  store i64 9, i64* %len, align 8
  %call.printf.before = call i32 (i8*, ...) @printf(i8* %before.ptr)
  store i64 0, i64* %i.ptr, align 8
  br label %loop.print.before

loop.print.before:                                ; preds = %loop.body.before, %entry
  %i.val = load i64, i64* %i.ptr, align 8
  %len.val = load i64, i64* %len, align 8
  %cmp.i = icmp ult i64 %i.val, %len.val
  br i1 %cmp.i, label %loop.body.before, label %loop.end.before

loop.body.before:                                 ; preds = %loop.print.before
  %elt.ptr.cur = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.val
  %elt.val = load i32, i32* %elt.ptr.cur, align 4
  %call.printf.num.before = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elt.val)
  %i.next = add i64 %i.val, 1
  store i64 %i.next, i64* %i.ptr, align 8
  br label %loop.print.before

loop.end.before:                                  ; preds = %loop.print.before
  %call.putchar.nl1 = call i32 @putchar(i32 10)
  %len.val.hs = load i64, i64* %len, align 8
  %arr.base.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  call void @heap_sort(i32* %arr.base.ptr, i64 %len.val.hs)
  %call.printf.after = call i32 (i8*, ...) @printf(i8* %after.ptr)
  store i64 0, i64* %j.ptr, align 8
  br label %loop.print.after

loop.print.after:                                 ; preds = %loop.body.after, %loop.end.before
  %j.val = load i64, i64* %j.ptr, align 8
  %len.val2 = load i64, i64* %len, align 8
  %cmp.j = icmp ult i64 %j.val, %len.val2
  br i1 %cmp.j, label %loop.body.after, label %loop.end.after

loop.body.after:                                  ; preds = %loop.print.after
  %elt.ptr.cur2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.val
  %elt.val2 = load i32, i32* %elt.ptr.cur2, align 4
  %call.printf.num.after = call i32 (i8*, ...) @printf(i8* %fmtd.ptr, i32 %elt.val2)
  %j.next = add i64 %j.val, 1
  store i64 %j.next, i64* %j.ptr, align 8
  br label %loop.print.after

loop.end.after:                                   ; preds = %loop.print.after
  %call.putchar.nl2 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.header

build.header:                                     ; preds = %sift.exit, %build.init
  %i_prev = phi i64 [ %half, %build.init ], [ %i_dec, %sift.exit ]
  %i_dec = add i64 %i_prev, -1
  %test_nonzero = icmp ne i64 %i_prev, 0
  br i1 %test_nonzero, label %sift.entry, label %build.done

sift.entry:                                       ; preds = %build.header
  br label %sift.loop

sift.loop:                                        ; preds = %sift.cont, %sift.entry
  %i_cur = phi i64 [ %i_dec, %sift.entry ], [ %i_new, %sift.cont ]
  %i_dbl = shl i64 %i_cur, 1
  %j = add i64 %i_dbl, 1
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %have_left, label %sift.exit

have_left:                                        ; preds = %sift.loop
  %k = add i64 %j, 1
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %cmp_right, label %choose_left

cmp_right:                                        ; preds = %have_left
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %k_gt_j = icmp sgt i32 %k_val, %j_val
  br i1 %k_gt_j, label %choose_right, label %choose_left

choose_right:                                     ; preds = %cmp_right
  br label %child_merge

choose_left:                                      ; preds = %cmp_right, %have_left
  br label %child_merge

child_merge:                                      ; preds = %choose_left, %choose_right
  %child = phi i64 [ %k, %choose_right ], [ %j, %choose_left ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %i_val = load i32, i32* %i_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %i_ge_child = icmp sge i32 %i_val, %child_val
  br i1 %i_ge_child, label %sift.exit, label %do_swap

do_swap:                                          ; preds = %child_merge
  store i32 %child_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %child_ptr, align 4
  %i_new = add i64 %child, 0
  br label %sift.cont

sift.cont:                                        ; preds = %do_swap
  br label %sift.loop

sift.exit:                                        ; preds = %child_merge, %sift.loop
  br label %build.header

build.done:                                       ; preds = %build.header
  %m_init = add i64 %n, -1
  br label %extract.header

extract.header:                                   ; preds = %post.sift, %build.done
  %m = phi i64 [ %m_init, %build.done ], [ %m_dec, %post.sift ]
  %m_ne_zero = icmp ne i64 %m, 0
  br i1 %m_ne_zero, label %extract.body, label %ret

extract.body:                                     ; preds = %extract.header
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %post.sift.entry

post.sift.entry:                                  ; preds = %extract.body
  br label %post.sift.loop

post.sift.loop:                                   ; preds = %post.do.swap, %post.sift.entry
  %i2_cur = phi i64 [ 0, %post.sift.entry ], [ %i2_new, %post.do.swap ]
  %i2_dbl = shl i64 %i2_cur, 1
  %j2 = add i64 %i2_dbl, 1
  %j2_lt_m = icmp ult i64 %j2, %m
  br i1 %j2_lt_m, label %post.have_left, label %post.sift.exit

post.have_left:                                   ; preds = %post.sift.loop
  %k2 = add i64 %j2, 1
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_lt_m = icmp ult i64 %k2, %m
  br i1 %k2_lt_m, label %post.cmp.right, label %post.choose.left

post.cmp.right:                                   ; preds = %post.have_left
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %k2_gt_j2 = icmp sgt i32 %k2_val, %j2_val
  br i1 %k2_gt_j2, label %post.choose.right, label %post.choose.left

post.choose.right:                                ; preds = %post.cmp.right
  br label %post.child.merge

post.choose.left:                                 ; preds = %post.cmp.right, %post.have_left
  br label %post.child.merge

post.child.merge:                                 ; preds = %post.choose.left, %post.choose.right
  %child2 = phi i64 [ %k2, %post.choose.right ], [ %j2, %post.choose.left ]
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2_cur
  %i2_val = load i32, i32* %i2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %i2_ge_child2 = icmp sge i32 %i2_val, %child2_val
  br i1 %i2_ge_child2, label %post.sift.exit, label %post.do.swap

post.do.swap:                                     ; preds = %post.child.merge
  store i32 %child2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %child2_ptr, align 4
  %i2_new = add i64 %child2, 0
  br label %post.sift.loop

post.sift.exit:                                   ; preds = %post.child.merge, %post.sift.loop
  %m_dec = add i64 %m, -1
  br label %post.sift

post.sift:                                        ; preds = %post.sift.exit
  br label %extract.header

ret:                                              ; preds = %extract.header, %entry
  ret void
}

attributes #0 = { "frame-pointer"="none" }
