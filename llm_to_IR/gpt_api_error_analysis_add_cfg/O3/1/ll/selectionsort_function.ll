; ModuleID = 'selection_sort'
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

define void @selection_sort(i32* %arr, i32 %n) local_unnamed_addr {
entry_1210:
  %cmp_le_1 = icmp sle i32 %n, 1
  br i1 %cmp_le_1, label %locret_12A8, label %init_121d

init_121d:
  %r13d_init = add i32 %n, -1
  %rbx0 = getelementptr i32, i32* %arr, i64 0
  %r10d0 = add i32 0, 0
  %r9d0 = add i32 %r10d0, 0
  %r10d1 = add i32 %r10d0, 1
  %ebp0 = load i32, i32* %rbx0, align 4
  %cmp_1239_init = icmp sle i32 %n, %r10d1
  br i1 %cmp_1239_init, label %loc_1290, label %to_loc_1262_from_entry

to_loc_1262_from_entry:
  %r12_0 = getelementptr i32, i32* %rbx0, i64 1
  %edi0 = add i32 %ebp0, 0
  %edx0 = add i32 %r10d1, 0
  %rax0 = getelementptr i32, i32* %r12_0, i64 0
  br label %loc_1262

loc_1262:
  %phi_rax = phi i32* [ %rax0, %to_loc_1262_from_entry ], [ %rax_inc_1250, %loc_1250 ], [ %rax_inc_upd, %loc_1262_update ], [ %rax_init_1230, %to_loc_1262_from_1230 ]
  %phi_edx = phi i32 [ %edx0, %to_loc_1262_from_entry ], [ %edx_inc_1250, %loc_1250 ], [ %edx_inc_upd, %loc_1262_update ], [ %edx_init_1230, %to_loc_1262_from_1230 ]
  %phi_edi = phi i32 [ %edi0, %to_loc_1262_from_entry ], [ %edi_through_1250, %loc_1250 ], [ %edi_new, %loc_1262_update ], [ %edi_init_1230, %to_loc_1262_from_1230 ]
  %phi_r9d = phi i32 [ %r9d0, %to_loc_1262_from_entry ], [ %r9d_through_1250, %loc_1250 ], [ %r9d_new, %loc_1262_update ], [ %r9d_init_1230, %to_loc_1262_from_1230 ]
  %phi_r12 = phi i32* [ %r12_0, %to_loc_1262_from_entry ], [ %r12_through_1250, %loc_1250 ], [ %r12_through_update, %loc_1262_update ], [ %r12_init_1230, %to_loc_1262_from_1230 ]
  %phi_rbx = phi i32* [ %rbx0, %to_loc_1262_from_entry ], [ %rbx_through_1250, %loc_1250 ], [ %rbx_through_update, %loc_1262_update ], [ %rbx_1230, %to_loc_1262_from_1230 ]
  %phi_ebp = phi i32 [ %ebp0, %to_loc_1262_from_entry ], [ %ebp_through_1250, %loc_1250 ], [ %ebp_through_update, %loc_1262_update ], [ %ebp_1230, %to_loc_1262_from_1230 ]
  %phi_r10d = phi i32 [ %r10d1, %to_loc_1262_from_entry ], [ %r10d_through_1250, %loc_1250 ], [ %r10d_through_update, %loc_1262_update ], [ %r10d_inc_1230, %to_loc_1262_from_1230 ]
  %phi_r13d = phi i32 [ %r13d_init, %to_loc_1262_from_entry ], [ %r13d_through_1250, %loc_1250 ], [ %r13d_through_update, %loc_1262_update ], [ %r13d_1230, %to_loc_1262_from_1230 ]
  %val_cur = load i32, i32* %phi_rax, align 4
  %r8_tmp = getelementptr i32, i32* %phi_rax, i64 0
  %cmp_ge = icmp sge i32 %val_cur, %phi_edi
  br i1 %cmp_ge, label %loc_1250, label %loc_1262_update

loc_1250:
  %r9d_through_1250 = add i32 %phi_r9d, 0
  %edi_through_1250 = add i32 %phi_edi, 0
  %rbx_through_1250 = getelementptr i32, i32* %phi_rbx, i64 0
  %r12_through_1250 = getelementptr i32, i32* %phi_r12, i64 0
  %r10d_through_1250 = add i32 %phi_r10d, 0
  %r13d_through_1250 = add i32 %phi_r13d, 0
  %ebp_through_1250 = add i32 %phi_ebp, 0
  %edx_inc_1250 = add i32 %phi_edx, 1
  %rax_inc_1250 = getelementptr i32, i32* %phi_rax, i64 1
  %rcx64 = sext i32 %r9d_through_1250 to i64
  %r8_from_r9d = getelementptr i32, i32* %arr, i64 %rcx64
  %cmp_jz_1260 = icmp eq i32 %n, %edx_inc_1250
  br i1 %cmp_jz_1260, label %loc_127B, label %loc_1262

loc_1262_update:
  %r9d_new = add i32 %phi_edx, 0
  %edx_inc_upd = add i32 %phi_edx, 1
  %edi_new = add i32 %val_cur, 0
  %rax_inc_upd = getelementptr i32, i32* %phi_rax, i64 1
  %rbx_through_update = getelementptr i32, i32* %phi_rbx, i64 0
  %r12_through_update = getelementptr i32, i32* %phi_r12, i64 0
  %r10d_through_update = add i32 %phi_r10d, 0
  %r13d_through_update = add i32 %phi_r13d, 0
  %ebp_through_update = add i32 %phi_ebp, 0
  %r8_copy = getelementptr i32, i32* %r8_tmp, i64 0
  %cmp_jnz_1279 = icmp ne i32 %n, %edx_inc_upd
  br i1 %cmp_jnz_1279, label %loc_1262, label %loc_127B

loc_127B:
  %phi_r8_127B = phi i32* [ %r8_from_r9d, %loc_1250 ], [ %r8_copy, %loc_1262_update ]
  %phi_edi_127B = phi i32 [ %edi_through_1250, %loc_1250 ], [ %edi_new, %loc_1262_update ]
  %phi_rbx_127B = phi i32* [ %rbx_through_1250, %loc_1250 ], [ %rbx_through_update, %loc_1262_update ]
  %phi_r12_127B = phi i32* [ %r12_through_1250, %loc_1250 ], [ %r12_through_update, %loc_1262_update ]
  %phi_ebp_127B = phi i32 [ %ebp_through_1250, %loc_1250 ], [ %ebp_through_update, %loc_1262_update ]
  %phi_r10d_127B = phi i32 [ %r10d_through_1250, %loc_1250 ], [ %r10d_through_update, %loc_1262_update ]
  %phi_r13d_127B = phi i32 [ %r13d_through_1250, %loc_1250 ], [ %r13d_through_update, %loc_1262_update ]
  store i32 %phi_edi_127B, i32* %phi_rbx_127B, align 4
  %rbx_after_127b = getelementptr i32, i32* %phi_r12_127B, i64 0
  store i32 %phi_ebp_127B, i32* %phi_r8_127B, align 4
  %cmp_jnz_1286 = icmp ne i32 %phi_r10d_127B, %phi_r13d_127B
  br i1 %cmp_jnz_1286, label %loc_1230, label %loc_1288

loc_1230:
  %rbx_1230 = phi i32* [ %rbx_after_127b, %loc_127B ], [ %rbx_after_1290, %loc_1290 ]
  %r10d_1230 = phi i32 [ %phi_r10d_127B, %loc_127B ], [ %r10d_1290, %loc_1290 ]
  %r13d_1230 = phi i32 [ %phi_r13d_127B, %loc_127B ], [ %r13d_1290, %loc_1290 ]
  %r9d_init_1230 = add i32 %r10d_1230, 0
  %r10d_inc_1230 = add i32 %r10d_1230, 1
  %ebp_1230 = load i32, i32* %rbx_1230, align 4
  %cmp_jle_1239 = icmp sle i32 %n, %r10d_inc_1230
  br i1 %cmp_jle_1239, label %loc_1290, label %to_loc_1262_from_1230

to_loc_1262_from_1230:
  %r12_init_1230 = getelementptr i32, i32* %rbx_1230, i64 1
  %edi_init_1230 = add i32 %ebp_1230, 0
  %edx_init_1230 = add i32 %r10d_inc_1230, 0
  %rax_init_1230 = getelementptr i32, i32* %r12_init_1230, i64 0
  br label %loc_1262

loc_1290:
  %rbx_1290 = phi i32* [ %rbx0, %init_121d ], [ %rbx_1230, %loc_1230 ]
  %ebp_1290 = phi i32 [ %ebp0, %init_121d ], [ %ebp_1230, %loc_1230 ]
  %r10d_1290 = phi i32 [ %r10d1, %init_121d ], [ %r10d_inc_1230, %loc_1230 ]
  %r13d_1290 = phi i32 [ %r13d_init, %init_121d ], [ %r13d_1230, %loc_1230 ]
  %r8ptr_1290 = getelementptr i32, i32* %rbx_1290, i64 0
  %edi_1290 = add i32 %ebp_1290, 0
  %r12_1290 = getelementptr i32, i32* %rbx_1290, i64 1
  store i32 %edi_1290, i32* %rbx_1290, align 4
  %rbx_after_1290 = getelementptr i32, i32* %r12_1290, i64 0
  store i32 %ebp_1290, i32* %r8ptr_1290, align 4
  %cmp_jnz_12a4 = icmp ne i32 %r10d_1290, %r13d_1290
  br i1 %cmp_jnz_12a4, label %loc_1230, label %loc_1288

loc_1288:
  ret void

locret_12A8:
  ret void
}