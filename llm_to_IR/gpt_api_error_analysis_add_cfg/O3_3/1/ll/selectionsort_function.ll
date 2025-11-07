; ModuleID = 'selection_sort'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) local_unnamed_addr {
addr_1210:
  %cmp_n_le_1 = icmp sle i32 %n, 1
  %r13d = add i32 %n, -1
  br i1 %cmp_n_le_1, label %locret_12A8, label %loc_1230

loc_1230:                                            ; preds = %addr_1210, %loc_127B, %loc_1290
  %rbx_cur = phi i32* [ %arr, %addr_1210 ], [ %r12_ptr, %loc_127B ], [ %r12_ptr_1290, %loc_1290 ]
  %r10_cur = phi i32 [ 0, %addr_1210 ], [ %r10_next_127B, %loc_127B ], [ %r10_next_1290, %loc_1290 ]
  %r10_inc = add i32 %r10_cur, 1
  %ebp_val = load i32, i32* %rbx_cur, align 4
  %r12_ptr = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  %rax_init = getelementptr inbounds i32, i32* %r12_ptr, i64 0
  %edx_init = add i32 %r10_inc, 0
  %cmp_n_le_r10inc = icmp sle i32 %n, %r10_inc
  br i1 %cmp_n_le_r10inc, label %loc_1290, label %loc_1262

loc_1262:                                            ; preds = %loc_1230, %loc_1250, %loc_1262_update
  %rax_phi = phi i32* [ %rax_init, %loc_1230 ], [ %rax_inc_1250, %loc_1250 ], [ %rax_next, %loc_1262_update ]
  %edx_phi = phi i32 [ %edx_init, %loc_1230 ], [ %edx_inc_1250, %loc_1250 ], [ %edx_next, %loc_1262_update ]
  %edi_phi = phi i32 [ %ebp_val, %loc_1230 ], [ %edi_passthru_1250, %loc_1250 ], [ %edi_next, %loc_1262_update ]
  %r9_phi  = phi i32 [ %r10_cur, %loc_1230 ], [ %r9_passthru_1250, %loc_1250 ], [ %r9_next, %loc_1262_update ]
  %ecx_val = load i32, i32* %rax_phi, align 4
  %cmp_ecx_ge_edi = icmp sge i32 %ecx_val, %edi_phi
  br i1 %cmp_ecx_ge_edi, label %loc_1250, label %loc_1262_update

loc_1250:                                            ; preds = %loc_1262
  %edx_inc_1250 = add i32 %edx_phi, 1
  %rax_inc_1250 = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %r9_sext = sext i32 %r9_phi to i64
  %r8_from_r9 = getelementptr inbounds i32, i32* %arr, i64 %r9_sext
  %edi_passthru_1250 = add i32 %edi_phi, 0
  %r9_passthru_1250 = add i32 %r9_phi, 0
  %cmp_n_eq_edxinc = icmp eq i32 %n, %edx_inc_1250
  br i1 %cmp_n_eq_edxinc, label %loc_127B, label %loc_1262

loc_1262_update:                                     ; preds = %loc_1262
  %r9_next = add i32 %edx_phi, 0
  %edx_next = add i32 %edx_phi, 1
  %edi_next = add i32 %ecx_val, 0
  %rax_next = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %cmp_n_ne_edxnext = icmp ne i32 %n, %edx_next
  br i1 %cmp_n_ne_edxnext, label %loc_1262, label %loc_127B

loc_127B:                                            ; preds = %loc_1250, %loc_1262_update
  %r8_phi127B = phi i32* [ %r8_from_r9, %loc_1250 ], [ %rax_phi, %loc_1262_update ]
  %edi_end    = phi i32  [ %edi_phi,    %loc_1250 ], [ %edi_next, %loc_1262_update ]
  store i32 %edi_end, i32* %rbx_cur, align 4
  store i32 %ebp_val, i32* %r8_phi127B, align 4
  %cmp_r10_ne_r13 = icmp ne i32 %r10_cur, %r13d
  %r10_next_127B = add i32 %r10_cur, 1
  br i1 %cmp_r10_ne_r13, label %loc_1230, label %loc_1288

loc_1288:                                            ; preds = %loc_127B, %loc_1290
  ret void

loc_1290:                                            ; preds = %loc_1230
  store i32 %ebp_val, i32* %rbx_cur, align 4
  %r12_ptr_1290 = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  store i32 %ebp_val, i32* %rbx_cur, align 4
  %cmp_r10_ne_r13_1290 = icmp ne i32 %r10_cur, %r13d
  %r10_next_1290 = add i32 %r10_cur, 1
  br i1 %cmp_r10_ne_r13_1290, label %loc_1230, label %loc_1288

locret_12A8:                                         ; preds = %addr_1210
  ret void
}