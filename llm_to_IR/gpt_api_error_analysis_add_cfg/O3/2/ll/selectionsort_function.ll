; ModuleID = 'selection_sort'
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry:
  %cmp_n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_n_le_1, label %locret_12A8, label %prologue

prologue:
  %r11 = bitcast i32* %arr to i32*
  %r13 = add i32 %n, -1
  %r10_0 = add i32 0, 0
  br label %loc_1230

loc_1230:
  %rbx_phi = phi i32* [ %arr, %prologue ], [ %rbx_next, %loc_127B ], [ %rbx_next_1290, %loc_1290 ]
  %r10_phi = phi i32 [ %r10_0, %prologue ], [ %r10_out, %loc_127B ], [ %r10_out_1290, %loc_1290 ]
  %r9_init = add i32 %r10_phi, 0
  %r10_inc = add i32 %r10_phi, 1
  %val_at_rbx = load i32, i32* %rbx_phi, align 4
  %cmp_n_le_r10inc = icmp sle i32 %n, %r10_inc
  br i1 %cmp_n_le_r10inc, label %loc_1290, label %cont_123e

cont_123e:
  %r12ptr = getelementptr inbounds i32, i32* %rbx_phi, i64 1
  %edi_init = add i32 %val_at_rbx, 0
  %edx_init = add i32 %r10_inc, 0
  %rax_init = bitcast i32* %r12ptr to i32*
  br label %loc_1262

loc_1262:
  %rax_phi = phi i32* [ %rax_init, %cont_123e ], [ %rax_next_from_1250, %loc_1250 ], [ %rax_next_from_126b, %cont_126b ]
  %edx_phi = phi i32 [ %edx_init, %cont_123e ], [ %edx_inc_from_1250, %loc_1250 ], [ %edx_inc_from_126b, %cont_126b ]
  %r9_phi = phi i32 [ %r9_init, %cont_123e ], [ %r9_phi, %loc_1250 ], [ %r9_updated, %cont_126b ]
  %edi_phi = phi i32 [ %edi_init, %cont_123e ], [ %edi_phi, %loc_1250 ], [ %edi_updated, %cont_126b ]
  %ecx_val = load i32, i32* %rax_phi, align 4
  %r8_from_1262 = bitcast i32* %rax_phi to i32*
  %cmp_ecx_ge_edi = icmp sge i32 %ecx_val, %edi_phi
  br i1 %cmp_ecx_ge_edi, label %loc_1250, label %cont_126b

loc_1250:
  %r9_sext = sext i32 %r9_phi to i64
  %edx_inc_from_1250 = add i32 %edx_phi, 1
  %rax_next_from_1250 = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %r8_from_1250 = getelementptr inbounds i32, i32* %r11, i64 %r9_sext
  %cmp_n_eq_edx_after1250 = icmp eq i32 %n, %edx_inc_from_1250
  br i1 %cmp_n_eq_edx_after1250, label %loc_127B, label %loc_1262

cont_126b:
  %r9_updated = add i32 %edx_phi, 0
  %edx_inc_from_126b = add i32 %edx_phi, 1
  %edi_updated = add i32 %ecx_val, 0
  %rax_next_from_126b = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %cmp_n_ne_edx_after126b = icmp ne i32 %n, %edx_inc_from_126b
  br i1 %cmp_n_ne_edx_after126b, label %loc_1262, label %loc_127B

loc_127B:
  %r8_phi = phi i32* [ %r8_from_1250, %loc_1250 ], [ %r8_from_1262, %cont_126b ]
  %edi_at_127b = phi i32 [ %edi_phi, %loc_1250 ], [ %edi_updated, %cont_126b ]
  store i32 %edi_at_127b, i32* %rbx_phi, align 4
  %rbx_next = bitcast i32* %r12ptr to i32*
  store i32 %val_at_rbx, i32* %r8_phi, align 4
  %cmp_r10_ne_r13 = icmp ne i32 %r10_inc, %r13
  %r10_out = add i32 %r10_inc, 0
  br i1 %cmp_r10_ne_r13, label %loc_1230, label %loc_1288

loc_1288:
  ret void

loc_1290:
  %r8_1290 = bitcast i32* %rbx_phi to i32*
  %edi_1290 = add i32 %val_at_rbx, 0
  %r12_1290 = getelementptr inbounds i32, i32* %rbx_phi, i64 1
  store i32 %edi_1290, i32* %rbx_phi, align 4
  %rbx_next_1290 = bitcast i32* %r12_1290 to i32*
  store i32 %val_at_rbx, i32* %r8_1290, align 4
  %cmp_r10_ne_r13_1290 = icmp ne i32 %r10_inc, %r13
  %r10_out_1290 = add i32 %r10_inc, 0
  br i1 %cmp_r10_ne_r13_1290, label %loc_1230, label %loc_1288

locret_12A8:
  ret void
}