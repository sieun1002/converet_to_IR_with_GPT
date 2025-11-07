; ModuleID = 'selection_sort_module'
target triple = "x86_64-unknown-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) {
L1210:
  %cmp_n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_n_le_1, label %L12A8, label %L1230

L1230:                                               ; preds = %L1210, %L127B, %L1290
  %idx = phi i32 [ 0, %L1210 ], [ %i_cur_phi, %L127B ], [ %i_cur_phi_1290, %L1290 ]
  %p = phi i32* [ %arr, %L1210 ], [ %p_next, %L127B ], [ %p_next_1290, %L1290 ]
  %n_minus1 = add nsw i32 %n, -1
  %i_cur = add nsw i32 %idx, 1
  %orig = load i32, i32* %p, align 4
  %cmp_n_le_i = icmp sle i32 %n, %i_cur
  br i1 %cmp_n_le_i, label %L1290, label %L1262_pre

L1262_pre:
  %scan0 = getelementptr inbounds i32, i32* %p, i64 1
  br label %L1262

L1262:                                               ; preds = %L1262_pre, %L1250, %L126B
  %j = phi i32 [ %i_cur, %L1262_pre ], [ %j_next_1250, %L1250 ], [ %j_next_126B, %L126B ]
  %scanPtr = phi i32* [ %scan0, %L1262_pre ], [ %scan_next_1250, %L1250 ], [ %scan_next_126B, %L126B ]
  %minVal = phi i32 [ %orig, %L1262_pre ], [ %minVal, %L1250 ], [ %currVal, %L126B ]
  %minPtr = phi i32* [ %p, %L1262_pre ], [ %minPtr, %L1250 ], [ %scanPtr, %L126B ]
  %i_cur_phi = phi i32 [ %i_cur, %L1262_pre ], [ %i_cur_phi, %L1250 ], [ %i_cur_phi, %L126B ]
  %p_phi = phi i32* [ %p, %L1262_pre ], [ %p_phi, %L1250 ], [ %p_phi, %L126B ]
  %orig_phi = phi i32 [ %orig, %L1262_pre ], [ %orig_phi, %L1250 ], [ %orig_phi, %L126B ]
  %currVal = load i32, i32* %scanPtr, align 4
  %cmp_ge = icmp sge i32 %currVal, %minVal
  br i1 %cmp_ge, label %L1250, label %L126B

L1250:                                               ; preds = %L1262
  %j_next_1250 = add nsw i32 %j, 1
  %scan_next_1250 = getelementptr inbounds i32, i32* %scanPtr, i64 1
  %cmp_eq_end_1250 = icmp eq i32 %n, %j_next_1250
  br i1 %cmp_eq_end_1250, label %L127B, label %L1262

L126B:                                               ; preds = %L1262
  %j_next_126B = add nsw i32 %j, 1
  %scan_next_126B = getelementptr inbounds i32, i32* %scanPtr, i64 1
  %cmp_ne_end_126B = icmp ne i32 %n, %j_next_126B
  br i1 %cmp_ne_end_126B, label %L1262, label %L127B

L127B:                                               ; preds = %L1250, %L126B
  %exitMinVal = phi i32 [ %minVal, %L1250 ], [ %currVal, %L126B ]
  %exitMinPtr = phi i32* [ %minPtr, %L1250 ], [ %scanPtr, %L126B ]
  store i32 %exitMinVal, i32* %p_phi, align 4
  store i32 %orig_phi, i32* %exitMinPtr, align 4
  %p_next = getelementptr inbounds i32, i32* %p_phi, i64 1
  %cmp_i_ne_last = icmp ne i32 %i_cur_phi, %n_minus1
  br i1 %cmp_i_ne_last, label %L1230, label %L1288

L1290:                                               ; preds = %L1230
  store i32 %orig, i32* %p, align 4
  %p_next_1290 = getelementptr inbounds i32, i32* %p, i64 1
  %i_cur_phi_1290 = add nsw i32 %i_cur, 0
  %cmp_i_ne_last_1290 = icmp ne i32 %i_cur_phi_1290, %n_minus1
  br i1 %cmp_i_ne_last_1290, label %L1230, label %L1288

L1288:                                               ; preds = %L127B, %L1290
  ret void

L12A8:                                               ; preds = %L1210
  ret void
}