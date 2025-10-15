; ModuleID = 'heap_sort_module'
target triple = "x86_64-pc-windows-msvc"

define void @heap_sort(i32* %arr, i64 %n) {
entry:
  %cmp_n_le1 = icmp ule i64 %n, 1
  br i1 %cmp_n_le1, label %ret, label %build.entry

build.entry:                                       ; preds = %entry
  %half = lshr i64 %n, 1
  %half_is_zero = icmp eq i64 %half, 0
  br i1 %half_is_zero, label %sort.phase2.init, label %build.outer.init

build.outer.init:                                  ; preds = %build.entry
  %i.start = add i64 %half, -1
  br label %build.sift.header

build.sift.header:                                 ; preds = %build.sift.end, %build.swap, %build.outer.init
  %i.cur = phi i64 [ %i.start, %build.outer.init ], [ %i.cur, %build.swap ], [ %i.next, %build.sift.end ]
  %j.cur = phi i64 [ %i.start, %build.outer.init ], [ %largest, %build.swap ], [ %i.next, %build.sift.end ]
  %shl2 = shl i64 %j.cur, 1
  %k = add i64 %shl2, 1
  %k_valid = icmp ult i64 %k, %n
  br i1 %k_valid, label %build.k.valid, label %build.sift.end

build.k.valid:                                     ; preds = %build.sift.header
  %kp1 = add i64 %k, 1
  %kp1_valid = icmp ult i64 %kp1, %n
  br i1 %kp1_valid, label %build.kp1.valid, label %build.choose.k

build.kp1.valid:                                   ; preds = %build.k.valid
  %gep_kp1 = getelementptr inbounds i32, i32* %arr, i64 %kp1
  %val_kp1 = load i32, i32* %gep_kp1, align 4
  %gep_k = getelementptr inbounds i32, i32* %arr, i64 %k
  %val_k = load i32, i32* %gep_k, align 4
  %cmp_kp1_gt_k = icmp sgt i32 %val_kp1, %val_k
  %largest.sel = select i1 %cmp_kp1_gt_k, i64 %kp1, i64 %k
  br label %build.after.choose

build.choose.k:                                    ; preds = %build.k.valid
  br label %build.after.choose

build.after.choose:                                ; preds = %build.choose.k, %build.kp1.valid
  %largest = phi i64 [ %largest.sel, %build.kp1.valid ], [ %k, %build.choose.k ]
  %gep_j = getelementptr inbounds i32, i32* %arr, i64 %j.cur
  %val_j = load i32, i32* %gep_j, align 4
  %gep_l = getelementptr inbounds i32, i32* %arr, i64 %largest
  %val_l = load i32, i32* %gep_l, align 4
  %cmp_j_lt_l = icmp slt i32 %val_j, %val_l
  br i1 %cmp_j_lt_l, label %build.swap, label %build.sift.end

build.swap:                                        ; preds = %build.after.choose
  %tmp_j = load i32, i32* %gep_j, align 4
  store i32 %val_l, i32* %gep_j, align 4
  store i32 %tmp_j, i32* %gep_l, align 4
  br label %build.sift.header

build.sift.end:                                    ; preds = %build.after.choose, %build.sift.header
  %is_zero_i = icmp eq i64 %i.cur, 0
  %i.next = add i64 %i.cur, -1
  br i1 %is_zero_i, label %sort.phase2.init, label %build.sift.header

sort.phase2.init:                                  ; preds = %build.sift.end, %build.entry
  %end.init = add i64 %n, -1
  br label %outer2.loop.check

outer2.loop.check:                                 ; preds = %outer2.iter.done, %sort.phase2.init
  %end.cur = phi i64 [ %end.init, %sort.phase2.init ], [ %end.next, %outer2.iter.done ]
  %cond_end_nonzero = icmp ne i64 %end.cur, 0
  br i1 %cond_end_nonzero, label %outer2.iter.start, label %ret

outer2.iter.start:                                 ; preds = %outer2.loop.check
  %a0 = getelementptr inbounds i32, i32* %arr, i64 0
  %v0 = load i32, i32* %a0, align 4
  %aend = getelementptr inbounds i32, i32* %arr, i64 %end.cur
  %vend = load i32, i32* %aend, align 4
  store i32 %vend, i32* %a0, align 4
  store i32 %v0, i32* %aend, align 4
  br label %sift2.header

sift2.header:                                      ; preds = %sift2.swap, %outer2.iter.start
  %j2 = phi i64 [ 0, %outer2.iter.start ], [ %largest2, %sift2.swap ]
  %limit = phi i64 [ %end.cur, %outer2.iter.start ], [ %limit, %sift2.swap ]
  %shl2_2 = shl i64 %j2, 1
  %k2 = add i64 %shl2_2, 1
  %k2_valid = icmp ult i64 %k2, %limit
  br i1 %k2_valid, label %sift2.k.valid, label %outer2.iter.done

sift2.k.valid:                                     ; preds = %sift2.header
  %k2p1 = add i64 %k2, 1
  %k2p1_valid = icmp ult i64 %k2p1, %limit
  br i1 %k2p1_valid, label %sift2.kp1.valid, label %sift2.choose.k

sift2.kp1.valid:                                   ; preds = %sift2.k.valid
  %gep_k2p1 = getelementptr inbounds i32, i32* %arr, i64 %k2p1
  %val_k2p1 = load i32, i32* %gep_k2p1, align 4
  %gep_k2 = getelementptr inbounds i32, i32* %arr, i64 %k2
  %val_k2 = load i32, i32* %gep_k2, align 4
  %cmp_k2p1_gt_k2 = icmp sgt i32 %val_k2p1, %val_k2
  %largest2.sel = select i1 %cmp_k2p1_gt_k2, i64 %k2p1, i64 %k2
  br label %sift2.after.choose

sift2.choose.k:                                    ; preds = %sift2.k.valid
  br label %sift2.after.choose

sift2.after.choose:                                ; preds = %sift2.choose.k, %sift2.kp1.valid
  %largest2 = phi i64 [ %largest2.sel, %sift2.kp1.valid ], [ %k2, %sift2.choose.k ]
  %gep_j2 = getelementptr inbounds i32, i32* %arr, i64 %j2
  %val_j2 = load i32, i32* %gep_j2, align 4
  %gep_l2 = getelementptr inbounds i32, i32* %arr, i64 %largest2
  %val_l2 = load i32, i32* %gep_l2, align 4
  %cmp_j2_lt_l2 = icmp slt i32 %val_j2, %val_l2
  br i1 %cmp_j2_lt_l2, label %sift2.swap, label %outer2.iter.done

sift2.swap:                                        ; preds = %sift2.after.choose
  %tmp_j2 = load i32, i32* %gep_j2, align 4
  store i32 %val_l2, i32* %gep_j2, align 4
  store i32 %tmp_j2, i32* %gep_l2, align 4
  br label %sift2.header

outer2.iter.done:                                  ; preds = %sift2.after.choose, %sift2.header
  %end.next = add i64 %end.cur, -1
  br label %outer2.loop.check

ret:                                               ; preds = %outer2.loop.check, %entry
  ret void
}