; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
addr_1210:
  %cmp_le1 = icmp sle i32 %n, 1
  %n_minus1 = add i32 %n, -1
  br i1 %cmp_le1, label %locret_12A8, label %loc_1230

loc_1230:
  %rbx_cur = phi i32* [ %arr, %addr_1210 ], [ %rbx_next_from127B, %loc_127B ], [ %rbx_next_from1290, %loc_1290 ]
  %i_plus1_cur = phi i32 [ 0, %addr_1210 ], [ %i_plus1_next, %loc_127B ], [ %i_plus1_next, %loc_1290 ]
  %r13 = phi i32 [ %n_minus1, %addr_1210 ], [ %r13, %loc_127B ], [ %r13, %loc_1290 ]
  %r9_init = add i32 %i_plus1_cur, 0
  %i_plus1_next = add i32 %i_plus1_cur, 1
  %orig = load i32, i32* %rbx_cur
  %cmp_jle_1239 = icmp sle i32 %n, %i_plus1_next
  br i1 %cmp_jle_1239, label %loc_1290, label %loc_1230_setup

loc_1230_setup:
  %r12_ptr = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  %edi_init = add i32 %orig, 0
  %edx_init = add i32 %i_plus1_next, 0
  %rax_init = getelementptr inbounds i32, i32* %r12_ptr, i64 0
  %r9_fwd = add i32 %r9_init, 0
  br label %loc_1262

loc_1250:
  %rcx64 = sext i32 %r9_cur to i64
  %edx_next1 = add i32 %edx_cur, 1
  %rax_next1 = getelementptr inbounds i32, i32* %rax_cur, i64 1
  %r8_minptr_1250 = getelementptr inbounds i32, i32* %arr, i64 %rcx64
  %edi_through = add i32 %edi_min_cur, 0
  %r9_through = add i32 %r9_cur, 0
  %cmp_jz_1260 = icmp eq i32 %n, %edx_next1
  br i1 %cmp_jz_1260, label %loc_127B, label %loc_1262

loc_1262:
  %rax_cur = phi i32* [ %rax_init, %loc_1230_setup ], [ %rax_next1, %loc_1250 ], [ %rax_next2, %loc_1262_update ]
  %edx_cur = phi i32 [ %edx_init, %loc_1230_setup ], [ %edx_next1, %loc_1250 ], [ %edx_next2, %loc_1262_update ]
  %edi_min_cur = phi i32 [ %edi_init, %loc_1230_setup ], [ %edi_through, %loc_1250 ], [ %edi_new, %loc_1262_update ]
  %r9_cur = phi i32 [ %r9_fwd, %loc_1230_setup ], [ %r9_through, %loc_1250 ], [ %r9_new, %loc_1262_update ]
  %val_ecx = load i32, i32* %rax_cur
  %r8_candidate = getelementptr inbounds i32, i32* %rax_cur, i64 0
  %cmp_jge_1269 = icmp sge i32 %val_ecx, %edi_min_cur
  br i1 %cmp_jge_1269, label %loc_1250, label %loc_1262_update

loc_1262_update:
  %r9_new = add i32 %edx_cur, 0
  %edx_next2 = add i32 %edx_cur, 1
  %edi_new = add i32 %val_ecx, 0
  %rax_next2 = getelementptr inbounds i32, i32* %rax_cur, i64 1
  %r8_minptr_upd = getelementptr inbounds i32, i32* %r8_candidate, i64 0
  %cmp_jnz_1279 = icmp ne i32 %n, %edx_next2
  br i1 %cmp_jnz_1279, label %loc_1262, label %loc_127B

loc_127B:
  %r8_minptr_phi = phi i32* [ %r8_minptr_1250, %loc_1250 ], [ %r8_minptr_upd, %loc_1262_update ]
  %edi_min_final = phi i32 [ %edi_through, %loc_1250 ], [ %edi_new, %loc_1262_update ]
  store i32 %edi_min_final, i32* %rbx_cur
  %rbx_next_from127B = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  store i32 %orig, i32* %r8_minptr_phi
  %cmp_jnz_1286 = icmp ne i32 %i_plus1_next, %r13
  br i1 %cmp_jnz_1286, label %loc_1230, label %loc_1288

loc_1290:
  %r8_self = getelementptr inbounds i32, i32* %rbx_cur, i64 0
  %store_val = add i32 %orig, 0
  store i32 %store_val, i32* %rbx_cur
  %rbx_next_from1290 = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  store i32 %orig, i32* %r8_self
  %cmp_jnz_12a4 = icmp ne i32 %i_plus1_next, %r13
  br i1 %cmp_jnz_12a4, label %loc_1230, label %loc_1288

loc_1288:
  ret void

locret_12A8:
  ret void
}