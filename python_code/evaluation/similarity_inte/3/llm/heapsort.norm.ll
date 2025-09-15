; ModuleID = '/home/nata20034/workspace/convert_to_IR_with_LLM/integration/bc/3/heapsort.ll'
source_filename = "llvm-link"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

@.str.before = private unnamed_addr constant [19 x i8] c"Before Heap Sort: \00", align 1
@.str.after = private unnamed_addr constant [18 x i8] c"After Heap Sort: \00", align 1
@.str.d = private unnamed_addr constant [4 x i8] c"%d \00", align 1

define i32 @main() #0 {
entry:
  %arr = alloca [9 x i32], align 16
  %elt0.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 0
  store i32 7, i32* %elt0.ptr, align 16
  %elt1.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 1
  store i32 3, i32* %elt1.ptr, align 4
  %elt2.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 2
  store i32 9, i32* %elt2.ptr, align 8
  %elt3.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 3
  store i32 1, i32* %elt3.ptr, align 4
  %elt4.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 4
  store i32 4, i32* %elt4.ptr, align 16
  %elt5.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 5
  store i32 8, i32* %elt5.ptr, align 4
  %elt6.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 6
  store i32 2, i32* %elt6.ptr, align 8
  %elt7.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 7
  store i32 6, i32* %elt7.ptr, align 4
  %elt8.ptr = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 8
  store i32 5, i32* %elt8.ptr, align 16
  %call.printf.before = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([19 x i8], [19 x i8]* @.str.before, i64 0, i64 0))
  br label %loop.print.before

loop.print.before:                                ; preds = %loop.body.before, %entry
  %i.ptr.0 = phi i64 [ 0, %entry ], [ %i.next, %loop.body.before ]
  %cmp.i = icmp ult i64 %i.ptr.0, 9
  br i1 %cmp.i, label %loop.body.before, label %loop.end.before

loop.body.before:                                 ; preds = %loop.print.before
  %elt.ptr.cur = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %i.ptr.0
  %elt.val = load i32, i32* %elt.ptr.cur, align 4
  %call.printf.num.before = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elt.val)
  %i.next = add i64 %i.ptr.0, 1
  br label %loop.print.before

loop.end.before:                                  ; preds = %loop.print.before
  %call.putchar.nl1 = call i32 @putchar(i32 10)
  call void @heap_sort(i32* nonnull %elt0.ptr, i64 9)
  %call.printf.after = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([18 x i8], [18 x i8]* @.str.after, i64 0, i64 0))
  br label %loop.print.after

loop.print.after:                                 ; preds = %loop.body.after, %loop.end.before
  %j.ptr.0 = phi i64 [ 0, %loop.end.before ], [ %j.next, %loop.body.after ]
  %cmp.j = icmp ult i64 %j.ptr.0, 9
  br i1 %cmp.j, label %loop.body.after, label %loop.end.after

loop.body.after:                                  ; preds = %loop.print.after
  %elt.ptr.cur2 = getelementptr inbounds [9 x i32], [9 x i32]* %arr, i64 0, i64 %j.ptr.0
  %elt.val2 = load i32, i32* %elt.ptr.cur2, align 4
  %call.printf.num.after = call i32 (i8*, ...) @printf(i8* noundef nonnull dereferenceable(1) getelementptr inbounds ([4 x i8], [4 x i8]* @.str.d, i64 0, i64 0), i32 %elt.val2)
  %j.next = add i64 %j.ptr.0, 1
  br label %loop.print.after

loop.end.after:                                   ; preds = %loop.print.after
  %call.putchar.nl2 = call i32 @putchar(i32 10)
  ret i32 0
}

declare i32 @printf(i8*, ...)

declare i32 @putchar(i32)

define void @heap_sort(i32* nocapture %arr, i64 %n) {
entry:
  %cmp_n_le_1 = icmp ult i64 %n, 2
  br i1 %cmp_n_le_1, label %ret, label %build.init

build.init:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  br label %build.header

build.header:                                     ; preds = %sift.exit, %build.init
  %i_prev = phi i64 [ %half, %build.init ], [ %i_dec, %sift.exit ]
  %i_dec = add i64 %i_prev, -1
  %test_nonzero.not = icmp eq i64 %i_prev, 0
  br i1 %test_nonzero.not, label %extract.header, label %sift.loop

sift.loop:                                        ; preds = %build.header, %do_swap
  %i_cur = phi i64 [ %child, %do_swap ], [ %i_dec, %build.header ]
  %i_dbl = shl i64 %i_cur, 1
  %j = or i64 %i_dbl, 1
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %have_left, label %sift.exit

have_left:                                        ; preds = %sift.loop
  %k = add i64 %i_dbl, 2
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %cmp_right, label %have_left.choose_left_crit_edge

have_left.choose_left_crit_edge:                  ; preds = %have_left
  %child_ptr.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %j
  %child_val.pre.pre = load i32, i32* %child_ptr.phi.trans.insert.phi.trans.insert, align 4
  br label %choose_left

cmp_right:                                        ; preds = %have_left
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %k_gt_j = icmp sgt i32 %k_val, %j_val
  br i1 %k_gt_j, label %child_merge, label %choose_left

choose_left:                                      ; preds = %have_left.choose_left_crit_edge, %cmp_right
  %child_val.pre = phi i32 [ %child_val.pre.pre, %have_left.choose_left_crit_edge ], [ %j_val, %cmp_right ]
  br label %child_merge

child_merge:                                      ; preds = %cmp_right, %choose_left
  %child_val = phi i32 [ %child_val.pre, %choose_left ], [ %k_val, %cmp_right ]
  %child = phi i64 [ %j, %choose_left ], [ %k, %cmp_right ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %i_val = load i32, i32* %i_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %i_ge_child.not = icmp slt i32 %i_val, %child_val
  br i1 %i_ge_child.not, label %do_swap, label %sift.exit

do_swap:                                          ; preds = %child_merge
  store i32 %child_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %child_ptr, align 4
  br label %sift.loop

sift.exit:                                        ; preds = %child_merge, %sift.loop
  br label %build.header

extract.header:                                   ; preds = %build.header, %post.sift
  %m.in = phi i64 [ %m, %post.sift ], [ %n, %build.header ]
  %m = add i64 %m.in, -1
  %m_ne_zero.not = icmp eq i64 %m, 0
  br i1 %m_ne_zero.not, label %ret, label %extract.body

extract.body:                                     ; preds = %extract.header
  %root_val = load i32, i32* %arr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %arr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %post.sift.loop

post.sift.loop:                                   ; preds = %post.do.swap, %extract.body
  %i2_cur = phi i64 [ 0, %extract.body ], [ %child2, %post.do.swap ]
  %i2_dbl = shl i64 %i2_cur, 1
  %j2 = or i64 %i2_dbl, 1
  %j2_lt_m = icmp ult i64 %j2, %m
  br i1 %j2_lt_m, label %post.have_left, label %post.sift

post.have_left:                                   ; preds = %post.sift.loop
  %k2 = add i64 %i2_dbl, 2
  %k2_lt_m = icmp ult i64 %k2, %m
  br i1 %k2_lt_m, label %post.cmp.right, label %post.have_left.post.choose.left_crit_edge

post.have_left.post.choose.left_crit_edge:        ; preds = %post.have_left
  %child2_ptr.phi.trans.insert.phi.trans.insert = getelementptr inbounds i32, i32* %arr, i64 %j2
  %child2_val.pre.pre = load i32, i32* %child2_ptr.phi.trans.insert.phi.trans.insert, align 4
  br label %post.choose.left

post.cmp.right:                                   ; preds = %post.have_left
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %k2_gt_j2 = icmp sgt i32 %k2_val, %j2_val
  br i1 %k2_gt_j2, label %post.child.merge, label %post.choose.left

post.choose.left:                                 ; preds = %post.have_left.post.choose.left_crit_edge, %post.cmp.right
  %child2_val.pre = phi i32 [ %child2_val.pre.pre, %post.have_left.post.choose.left_crit_edge ], [ %j2_val, %post.cmp.right ]
  br label %post.child.merge

post.child.merge:                                 ; preds = %post.cmp.right, %post.choose.left
  %child2_val = phi i32 [ %child2_val.pre, %post.choose.left ], [ %k2_val, %post.cmp.right ]
  %child2 = phi i64 [ %j2, %post.choose.left ], [ %k2, %post.cmp.right ]
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2_cur
  %i2_val = load i32, i32* %i2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %i2_ge_child2.not = icmp slt i32 %i2_val, %child2_val
  br i1 %i2_ge_child2.not, label %post.do.swap, label %post.sift

post.do.swap:                                     ; preds = %post.child.merge
  store i32 %child2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %child2_ptr, align 4
  br label %post.sift.loop

post.sift:                                        ; preds = %post.sift.loop, %post.child.merge
  br label %extract.header

ret:                                              ; preds = %extract.header, %entry
  ret void
}

attributes #0 = { "frame-pointer"="none" }
