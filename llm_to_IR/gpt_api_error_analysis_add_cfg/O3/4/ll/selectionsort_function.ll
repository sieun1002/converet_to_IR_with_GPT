; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
bb_1210:
  %cmp_entry = icmp sle i32 %n, 1
  br i1 %cmp_entry, label %locret_12A8, label %bb_prologue

bb_prologue:
  %n_minus1 = add i32 %n, -1
  br label %loc_1230

loc_1230:
  %rbx_curr = phi i32* [ %arr, %bb_prologue ], [ %rbx_next_from_127B, %loc_127B ], [ %rbx_next_from_1290, %loc_1290 ]
  %r10_prev = phi i32 [ 0, %bb_prologue ], [ %r10_after_inc, %loc_127B ], [ %r10_after_inc, %loc_1290 ]
  %r9_init = add i32 %r10_prev, 0
  %r10_after_inc = add i32 %r10_prev, 1
  %base_val = load i32, i32* %rbx_curr, align 4
  %cond_n_le_r10 = icmp sle i32 %n, %r10_after_inc
  br i1 %cond_n_le_r10, label %loc_1290, label %bb_123e

bb_123e:
  %r12_next = getelementptr inbounds i32, i32* %rbx_curr, i64 1
  %min_init = add i32 %base_val, 0
  %edx_start = add i32 %r10_after_inc, 0
  %rax_start = getelementptr inbounds i32, i32* %r12_next, i64 0
  br label %loc_1262

loc_1262:
  %rax_ptr = phi i32* [ %rax_start, %bb_123e ], [ %rax_next_1250, %loc_1250 ], [ %rax_next_126b, %bb_126b ]
  %edx_j = phi i32 [ %edx_start, %bb_123e ], [ %edx_next_1250, %loc_1250 ], [ %edx_next_126b, %bb_126b ]
  %min_val = phi i32 [ %min_init, %bb_123e ], [ %min_passthrough_1250, %loc_1250 ], [ %min_next_126b, %bb_126b ]
  %r9_idx = phi i32 [ %r9_init, %bb_123e ], [ %r9_passthrough_1250, %loc_1250 ], [ %r9_next_126b, %bb_126b ]
  %curr_elem = load i32, i32* %rax_ptr, align 4
  %r8_candidate = getelementptr inbounds i32, i32* %rax_ptr, i64 0
  %ge_cur_min = icmp sge i32 %curr_elem, %min_val
  br i1 %ge_cur_min, label %loc_1250, label %bb_126b

loc_1250:
  %min_passthrough_1250 = add i32 %min_val, 0
  %r9_passthrough_1250 = add i32 %r9_idx, 0
  %r9_idx_sext = sext i32 %r9_idx to i64
  %edx_next_1250 = add i32 %edx_j, 1
  %rax_next_1250 = getelementptr inbounds i32, i32* %rax_ptr, i64 1
  %r8_minptr_1250 = getelementptr inbounds i32, i32* %arr, i64 %r9_idx_sext
  %edx_eq_n_1250 = icmp eq i32 %n, %edx_next_1250
  br i1 %edx_eq_n_1250, label %loc_127B, label %loc_1262

bb_126b:
  %r9_next_126b = add i32 %edx_j, 0
  %edx_next_126b = add i32 %edx_j, 1
  %min_next_126b = add i32 %curr_elem, 0
  %rax_next_126b = getelementptr inbounds i32, i32* %rax_ptr, i64 1
  %edx_ne_n_126b = icmp ne i32 %n, %edx_next_126b
  br i1 %edx_ne_n_126b, label %loc_1262, label %loc_127B

loc_127B:
  %min_final = phi i32 [ %min_val, %loc_1250 ], [ %min_next_126b, %bb_126b ]
  %r8_minptr_final = phi i32* [ %r8_minptr_1250, %loc_1250 ], [ %r8_candidate, %bb_126b ]
  store i32 %min_final, i32* %rbx_curr, align 4
  %rbx_next_from_127B = getelementptr inbounds i32, i32* %rbx_curr, i64 1
  store i32 %base_val, i32* %r8_minptr_final, align 4
  %outer_cont_127B = icmp ne i32 %r10_after_inc, %n_minus1
  br i1 %outer_cont_127B, label %loc_1230, label %loc_1288

loc_1290:
  %r8_self = getelementptr inbounds i32, i32* %rbx_curr, i64 0
  %min_self = add i32 %base_val, 0
  %rbx_next_from_1290 = getelementptr inbounds i32, i32* %rbx_curr, i64 1
  store i32 %min_self, i32* %rbx_curr, align 4
  store i32 %base_val, i32* %r8_self, align 4
  %outer_cont_1290 = icmp ne i32 %r10_after_inc, %n_minus1
  br i1 %outer_cont_1290, label %loc_1230, label %loc_1288

loc_1288:
  ret void

locret_12A8:
  ret void
}