; Target
target triple = "x86_64-pc-linux-gnu"

; void selection_sort(int32_t* arr, int32_t n)
define void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
loc_1210:
  ; setup invariants (side-effect free)
  %r11_base = bitcast i32* %arr to i32*
  %n_minus1 = add nsw i32 %n, -1
  %rbx_init = bitcast i32* %arr to i32*
  ; early exit if n <= 1
  %cmp_n_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_n_le_1, label %locret_12A8, label %loc_1230

loc_1230:                                           ; preds = %loc_1210, %loc_127B, %loc_1290
  %rbx_phi = phi i32* [ %rbx_init, %loc_1210 ], [ %rbx_next, %loc_127B ], [ %rbx_next2, %loc_1290 ]
  %r10_phi = phi i32 [ 0, %loc_1210 ], [ %r10_work, %loc_127B ], [ %r10_work, %loc_1290 ]
  %r9_init = add nsw i32 %r10_phi, 0
  %r10_work = add nsw i32 %r10_phi, 1
  %ebp_val = load i32, i32* %rbx_phi, align 4
  %cond_jle_1290 = icmp sle i32 %n, %r10_work
  br i1 %cond_jle_1290, label %loc_1290, label %loc_1230_cont

loc_1230_cont:                                      ; fall-through after jle not taken
  %r12_next = getelementptr inbounds i32, i32* %rbx_phi, i64 1
  %edi_init = add nsw i32 %ebp_val, 0
  %edx_init = add nsw i32 %r10_work, 0
  %rax_init = bitcast i32* %r12_next to i32*
  br label %loc_1262

loc_1262:                                           ; preds = %loc_1230_cont, %loc_1250, %loc_1262_newmin
  %edx_phi = phi i32 [ %edx_init, %loc_1230_cont ], [ %edx_plus1, %loc_1250 ], [ %edx_plus1_nm, %loc_1262_newmin ]
  %rax_phi = phi i32* [ %rax_init, %loc_1230_cont ], [ %rax_inc, %loc_1250 ], [ %rax_inc_nm, %loc_1262_newmin ]
  %edi_phi = phi i32 [ %edi_init, %loc_1230_cont ], [ %edi_phi, %loc_1250 ], [ %edi_new, %loc_1262_newmin ]
  %r9_phi = phi i32 [ %r9_init, %loc_1230_cont ], [ %r9_phi, %loc_1250 ], [ %r9_updated, %loc_1262_newmin ]
  %ecx_val = load i32, i32* %rax_phi, align 4
  %r8_cand = bitcast i32* %rax_phi to i32*
  %cmp_ge = icmp sge i32 %ecx_val, %edi_phi
  br i1 %cmp_ge, label %loc_1250, label %loc_1262_newmin

loc_1250:                                           ; jge path
  %r9_sext = sext i32 %r9_phi to i64
  %r8_from_r9 = getelementptr inbounds i32, i32* %r11_base, i64 %r9_sext
  %edx_plus1 = add nsw i32 %edx_phi, 1
  %rax_inc = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %cmp_jz_127B = icmp eq i32 %n, %edx_plus1
  br i1 %cmp_jz_127B, label %loc_127B, label %loc_1262

loc_1262_newmin:                                    ; ecx < edi path (new min found)
  %r9_updated = add nsw i32 %edx_phi, 0
  %edx_plus1_nm = add nsw i32 %edx_phi, 1
  %edi_new = add nsw i32 %ecx_val, 0
  %rax_inc_nm = getelementptr inbounds i32, i32* %rax_phi, i64 1
  %r8_min_nm = bitcast i32* %r8_cand to i32*
  %cmp_jnz_back = icmp ne i32 %n, %edx_plus1_nm
  br i1 %cmp_jnz_back, label %loc_1262, label %loc_127B

loc_127B:                                           ; store swap with found minimum
  %r8_phi = phi i32* [ %r8_from_r9, %loc_1250 ], [ %r8_min_nm, %loc_1262_newmin ]
  %edi_final = phi i32 [ %edi_phi, %loc_1250 ], [ %edi_new, %loc_1262_newmin ]
  store i32 %edi_final, i32* %rbx_phi, align 4
  %rbx_next = bitcast i32* %r12_next to i32*
  store i32 %ebp_val, i32* %r8_phi, align 4
  %cmp_outer_jnz = icmp ne i32 %r10_work, %n_minus1
  br i1 %cmp_outer_jnz, label %loc_1230, label %loc_1288

loc_1290:                                           ; inner loop skipped
  %r8_self = bitcast i32* %rbx_phi to i32*
  %edi_self = add nsw i32 %ebp_val, 0
  %r12_self = getelementptr inbounds i32, i32* %rbx_phi, i64 1
  store i32 %edi_self, i32* %rbx_phi, align 4
  %rbx_next2 = bitcast i32* %r12_self to i32*
  store i32 %ebp_val, i32* %r8_self, align 4
  %cmp_outer2 = icmp ne i32 %r10_work, %n_minus1
  br i1 %cmp_outer2, label %loc_1230, label %loc_1288

loc_1288:
  ret void

locret_12A8:
  ret void
}