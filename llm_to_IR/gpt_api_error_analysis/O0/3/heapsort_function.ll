; ModuleID = 'heap_sort_module'
target triple = "x86_64-unknown-linux-gnu"

define void @heap_sort(i32* nocapture %arr, i64 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le_1, label %ret, label %build.init

build.init:
  %half = lshr i64 %n, 1
  br label %build.header

build.header:
  %i_prev = phi i64 [ %half, %build.init ], [ %i_dec, %sift.exit ]
  %i_dec = add i64 %i_prev, -1
  %test_nonzero = icmp ne i64 %i_prev, 0
  br i1 %test_nonzero, label %sift.entry, label %build.done

sift.entry:
  br label %sift.loop

sift.loop:
  %i_cur = phi i64 [ %i_dec, %sift.entry ], [ %i_new, %sift.cont ]
  %i_dbl = shl i64 %i_cur, 1
  %j = add i64 %i_dbl, 1
  %j_lt_n = icmp ult i64 %j, %n
  br i1 %j_lt_n, label %have_left, label %sift.exit

have_left:
  %k = add i64 %j, 1
  %j_ptr = getelementptr inbounds i32, i32* %arr, i64 %j
  %j_val = load i32, i32* %j_ptr, align 4
  %k_lt_n = icmp ult i64 %k, %n
  br i1 %k_lt_n, label %cmp_right, label %choose_left

cmp_right:
  %k_ptr = getelementptr inbounds i32, i32* %arr, i64 %k
  %k_val = load i32, i32* %k_ptr, align 4
  %k_gt_j = icmp sgt i32 %k_val, %j_val
  br i1 %k_gt_j, label %choose_right, label %choose_left

choose_right:
  br label %child_merge

choose_left:
  br label %child_merge

child_merge:
  %child = phi i64 [ %k, %choose_right ], [ %j, %choose_left ]
  %i_ptr = getelementptr inbounds i32, i32* %arr, i64 %i_cur
  %i_val = load i32, i32* %i_ptr, align 4
  %child_ptr = getelementptr inbounds i32, i32* %arr, i64 %child
  %child_val = load i32, i32* %child_ptr, align 4
  %i_ge_child = icmp sge i32 %i_val, %child_val
  br i1 %i_ge_child, label %sift.exit, label %do_swap

do_swap:
  store i32 %child_val, i32* %i_ptr, align 4
  store i32 %i_val, i32* %child_ptr, align 4
  %i_new = add i64 %child, 0
  br label %sift.cont

sift.cont:
  br label %sift.loop

sift.exit:
  br label %build.header

build.done:
  %m_init = add i64 %n, -1
  br label %extract.header

extract.header:
  %m = phi i64 [ %m_init, %build.done ], [ %m_dec, %post.sift ]
  %m_ne_zero = icmp ne i64 %m, 0
  br i1 %m_ne_zero, label %extract.body, label %ret

extract.body:
  %root_ptr = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val = load i32, i32* %root_ptr, align 4
  %m_ptr = getelementptr inbounds i32, i32* %arr, i64 %m
  %m_val = load i32, i32* %m_ptr, align 4
  store i32 %m_val, i32* %root_ptr, align 4
  store i32 %root_val, i32* %m_ptr, align 4
  br label %post.sift.entry

post.sift.entry:
  br label %post.sift.loop

post.sift.loop:
  %i2_cur = phi i64 [ 0, %post.sift.entry ], [ %i2_new, %post.do.swap ]
  %i2_dbl = shl i64 %i2_cur, 1
  %j2 = add i64 %i2_dbl, 1
  %j2_lt_m = icmp ult i64 %j2, %m
  br i1 %j2_lt_m, label %post.have_left, label %post.sift.exit

post.have_left:
  %k2 = add i64 %j2, 1
  %j2_ptr = getelementptr inbounds i32, i32* %arr, i64 %j2
  %j2_val = load i32, i32* %j2_ptr, align 4
  %k2_lt_m = icmp ult i64 %k2, %m
  br i1 %k2_lt_m, label %post.cmp.right, label %post.choose.left

post.cmp.right:
  %k2_ptr = getelementptr inbounds i32, i32* %arr, i64 %k2
  %k2_val = load i32, i32* %k2_ptr, align 4
  %k2_gt_j2 = icmp sgt i32 %k2_val, %j2_val
  br i1 %k2_gt_j2, label %post.choose.right, label %post.choose.left

post.choose.right:
  br label %post.child.merge

post.choose.left:
  br label %post.child.merge

post.child.merge:
  %child2 = phi i64 [ %k2, %post.choose.right ], [ %j2, %post.choose.left ]
  %i2_ptr = getelementptr inbounds i32, i32* %arr, i64 %i2_cur
  %i2_val = load i32, i32* %i2_ptr, align 4
  %child2_ptr = getelementptr inbounds i32, i32* %arr, i64 %child2
  %child2_val = load i32, i32* %child2_ptr, align 4
  %i2_ge_child2 = icmp sge i32 %i2_val, %child2_val
  br i1 %i2_ge_child2, label %post.sift.exit, label %post.do.swap

post.do.swap:
  store i32 %child2_val, i32* %i2_ptr, align 4
  store i32 %i2_val, i32* %child2_ptr, align 4
  %i2_new = add i64 %child2, 0
  br label %post.sift.loop

post.sift.exit:
  %m_dec = add i64 %m, -1
  br label %post.sift

post.sift:
  br label %extract.header

ret:
  ret void
}