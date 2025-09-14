target triple = "x86_64-unknown-linux-gnu"

define dso_local void @heap_sort(i32* noundef %arr, i64 noundef %n) local_unnamed_addr {
entry:
  %cmp0 = icmp ule i64 %n, 1
  br i1 %cmp0, label %exit, label %build.init

build.init:
  %half0 = lshr i64 %n, 1
  br label %build.top

build.top:
  %i_old1 = phi i64 [ %half0, %build.init ], [ %i_dec_next6, %build.end ]
  %cond2 = icmp ne i64 %i_old1, 0
  br i1 %cond2, label %build.body, label %sort.init

build.body:
  %i_dec3 = add i64 %i_old1, -1
  br label %sift1.head

sift1.head:
  %k4 = phi i64 [ %i_dec3, %build.body ], [ %k_next18, %sift1.swap ]
  %k2mul5 = add i64 %k4, %k4
  %left6 = add i64 %k2mul5, 1
  %left_ge_n7 = icmp uge i64 %left6, %n
  br i1 %left_ge_n7, label %sift1.break, label %sift1.hasleft

sift1.hasleft:
  %right8 = add i64 %left6, 1
  %right_in_range9 = icmp ult i64 %right8, %n
  %left_ptr10 = getelementptr inbounds i32, i32* %arr, i64 %left6
  %left_val11 = load i32, i32* %left_ptr10, align 4
  br i1 %right_in_range9, label %s1.cmp.right, label %s1.choose.left

s1.cmp.right:
  %right_ptr12 = getelementptr inbounds i32, i32* %arr, i64 %right8
  %right_val13 = load i32, i32* %right_ptr12, align 4
  %gt14 = icmp sgt i32 %right_val13, %left_val11
  br i1 %gt14, label %s1.choose.right, label %s1.choose.left

s1.choose.right:
  br label %s1.m.chosen

s1.choose.left:
  br label %s1.m.chosen

s1.m.chosen:
  %m_idx15 = phi i64 [ %right8, %s1.choose.right ], [ %left6, %s1.choose.left ]
  %k_ptr16 = getelementptr inbounds i32, i32* %arr, i64 %k4
  %k_val17 = load i32, i32* %k_ptr16, align 4
  %m_ptr18 = getelementptr inbounds i32, i32* %arr, i64 %m_idx15
  %m_val19 = load i32, i32* %m_ptr18, align 4
  %ge20 = icmp sge i32 %k_val17, %m_val19
  br i1 %ge20, label %sift1.break, label %sift1.swap

sift1.swap:
  store i32 %m_val19, i32* %k_ptr16, align 4
  store i32 %k_val17, i32* %m_ptr18, align 4
  %k_next18 = add i64 %m_idx15, 0
  br label %sift1.head

sift1.break:
  br label %build.end

build.end:
  %i_dec_next6 = add i64 %i_dec3, 0
  br label %build.top

sort.init:
  %end_init21 = add i64 %n, -1
  br label %sort.loop.cond

sort.loop.cond:
  %end_cur22 = phi i64 [ %end_init21, %sort.init ], [ %end_next37, %after_sift2 ]
  %nz23 = icmp ne i64 %end_cur22, 0
  br i1 %nz23, label %sort.body, label %exit

sort.body:
  %root_ptr24 = getelementptr inbounds i32, i32* %arr, i64 0
  %root_val25 = load i32, i32* %root_ptr24, align 4
  %end_ptr26 = getelementptr inbounds i32, i32* %arr, i64 %end_cur22
  %end_val27 = load i32, i32* %end_ptr26, align 4
  store i32 %end_val27, i32* %root_ptr24, align 4
  store i32 %root_val25, i32* %end_ptr26, align 4
  br label %sift2.head

sift2.head:
  %k2_28 = phi i64 [ 0, %sort.body ], [ %k2_next36, %sift2.swap ]
  %twok29 = add i64 %k2_28, %k2_28
  %left2_30 = add i64 %twok29, 1
  %left_ge_end31 = icmp uge i64 %left2_30, %end_cur22
  br i1 %left_ge_end31, label %after_sift2, label %sift2.hasleft

sift2.hasleft:
  %right2_32 = add i64 %left2_30, 1
  %right_in_range2_33 = icmp ult i64 %right2_32, %end_cur22
  %left_ptr2_34 = getelementptr inbounds i32, i32* %arr, i64 %left2_30
  %left_val2_35 = load i32, i32* %left_ptr2_34, align 4
  br i1 %right_in_range2_33, label %s2.cmp.right, label %s2.choose.left

s2.cmp.right:
  %right_ptr2_36 = getelementptr inbounds i32, i32* %arr, i64 %right2_32
  %right_val2_37 = load i32, i32* %right_ptr2_36, align 4
  %gt2_38 = icmp sgt i32 %right_val2_37, %left_val2_35
  br i1 %gt2_38, label %s2.choose.right, label %s2.choose.left

s2.choose.right:
  br label %s2.m.chosen

s2.choose.left:
  br label %s2.m.chosen

s2.m.chosen:
  %m2_idx39 = phi i64 [ %right2_32, %s2.choose.right ], [ %left2_30, %s2.choose.left ]
  %k2_ptr40 = getelementptr inbounds i32, i32* %arr, i64 %k2_28
  %k2_val41 = load i32, i32* %k2_ptr40, align 4
  %m2_ptr42 = getelementptr inbounds i32, i32* %arr, i64 %m2_idx39
  %m2_val43 = load i32, i32* %m2_ptr42, align 4
  %ge2_44 = icmp sge i32 %k2_val41, %m2_val43
  br i1 %ge2_44, label %after_sift2, label %sift2.swap

sift2.swap:
  store i32 %m2_val43, i32* %k2_ptr40, align 4
  store i32 %k2_val41, i32* %m2_ptr42, align 4
  %k2_next36 = add i64 %m2_idx39, 0
  br label %sift2.head

after_sift2:
  %end_next37 = add i64 %end_cur22, -1
  br label %sort.loop.cond

exit:
  ret void
}