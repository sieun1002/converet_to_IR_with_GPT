; ModuleID = 'selection_sort_module'
target triple = "x86_64-pc-linux-gnu"

define dso_local void @selection_sort(i32* nocapture %arr, i32 %n) {
loc_1210:
  %cmp_entry = icmp sle i32 %n, 1
  br i1 %cmp_entry, label %locret_12A8, label %loc_121D

loc_121D:                                            ; preds = %loc_1210
  %r11_base = ptrtoint i32* %arr to i64
  %r13_n_minus_1 = add i32 %n, -1
  %r10_i_init = add i32 0, 0
  br label %loc_1230

loc_1230:                                            ; preds = %loc_121D, %loc_127B, %loc_1290
  %r10_i = phi i32 [ %r10_i_init, %loc_121D ], [ %r10_ip1, %loc_127B ], [ %r10_ip1, %loc_1290 ]
  %rbx_ptr = phi i32* [ %arr, %loc_121D ], [ %r12_ptr, %loc_127B ], [ %r12_ptr_1290, %loc_1290 ]
  %r10_ip1 = add i32 %r10_i, 1
  %ebp_val = load i32, i32* %rbx_ptr, align 4
  %cmp_1239_jle = icmp sle i32 %n, %r10_ip1
  br i1 %cmp_1239_jle, label %loc_1290, label %loc_123E

loc_123E:                                            ; preds = %loc_1230
  %r12_ptr = getelementptr inbounds i32, i32* %rbx_ptr, i64 1
  br label %loc_1262

loc_1262:                                            ; preds = %loc_123E, %loc_1250, %loc_126B
  %rax_scan_ptr = phi i32* [ %r12_ptr, %loc_123E ], [ %rax_advanced_1250, %loc_1250 ], [ %rax_advanced_126B, %loc_126B ]
  %edx_j = phi i32 [ %r10_ip1, %loc_123E ], [ %edx_plus1_1250, %loc_1250 ], [ %edx_plus1_126B, %loc_126B ]
  %r9_minidx = phi i32 [ %r10_i, %loc_123E ], [ %r9_min_keep_1250, %loc_1250 ], [ %r9_min_after_126B, %loc_126B ]
  %edi_min = phi i32 [ %ebp_val, %loc_123E ], [ %edi_min_keep_1250, %loc_1250 ], [ %edi_min_after_126B, %loc_126B ]
  %ecx_curr = load i32, i32* %rax_scan_ptr, align 4
  %r8_candidate_ptr = getelementptr inbounds i32, i32* %rax_scan_ptr, i64 0
  %cmp_1267_jge = icmp sge i32 %ecx_curr, %edi_min
  br i1 %cmp_1267_jge, label %loc_1250, label %loc_126B

loc_1250:                                            ; preds = %loc_1262
  %r9_sext = sext i32 %r9_minidx to i64
  %r11_ptr = inttoptr i64 %r11_base to i32*
  %r8_min_ptr = getelementptr inbounds i32, i32* %r11_ptr, i64 %r9_sext
  %edx_plus1_1250 = add i32 %edx_j, 1
  %rax_advanced_1250 = getelementptr inbounds i32, i32* %rax_scan_ptr, i64 1
  %cmp_125e_jz = icmp eq i32 %n, %edx_plus1_1250
  %r9_min_keep_1250 = add i32 %r9_minidx, 0
  %edi_min_keep_1250 = add i32 %edi_min, 0
  br i1 %cmp_125e_jz, label %loc_127B, label %loc_1262

loc_126B:                                            ; preds = %loc_1262
  %r9_min_after_126B = add i32 %edx_j, 0
  %edx_plus1_126B = add i32 %edx_j, 1
  %edi_min_after_126B = add i32 %ecx_curr, 0
  %rax_advanced_126B = getelementptr inbounds i32, i32* %rax_scan_ptr, i64 1
  %cmp_1279_jnz = icmp ne i32 %n, %edx_plus1_126B
  br i1 %cmp_1279_jnz, label %loc_1262, label %loc_127B

loc_127B:                                            ; preds = %loc_1250, %loc_126B
  %r8_ptr_final = phi i32* [ %r8_min_ptr, %loc_1250 ], [ %r8_candidate_ptr, %loc_126B ]
  %edi_min_final = phi i32 [ %edi_min, %loc_1250 ], [ %edi_min_after_126B, %loc_126B ]
  store i32 %edi_min_final, i32* %rbx_ptr, align 4
  store i32 %ebp_val, i32* %r8_ptr_final, align 4
  %cmp_1286_jnz = icmp ne i32 %r10_ip1, %r13_n_minus_1
  br i1 %cmp_1286_jnz, label %loc_1230, label %loc_1288

loc_1290:                                            ; preds = %loc_1230
  %r12_ptr_1290 = getelementptr inbounds i32, i32* %rbx_ptr, i64 1
  store i32 %ebp_val, i32* %rbx_ptr, align 4
  %cmp_12a4_jnz = icmp ne i32 %r10_ip1, %r13_n_minus_1
  br i1 %cmp_12a4_jnz, label %loc_1230, label %loc_1288

loc_1288:                                            ; preds = %loc_127B, %loc_1290
  ret void

locret_12A8:                                         ; preds = %loc_1210
  ret void
}