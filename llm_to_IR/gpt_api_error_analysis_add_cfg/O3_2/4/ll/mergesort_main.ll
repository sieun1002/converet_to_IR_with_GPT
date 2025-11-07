; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external thread_local global i64
declare void @___stack_chk_fail() noreturn cold
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @___printf_chk(i32, i8*, ...)

@unk_2004 = external global [0 x i8], align 1
@unk_2008 = external global [0 x i8], align 1
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16

define i32 @main() local_unnamed_addr {
entry_10c0:
  ; locals and “register” slots
  %stack_buf = alloca [10 x i32], align 16
  %var_48 = alloca i32, align 4
  %canary = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %var_70 = alloca i32*, align 8
  %var_7C = alloca i32, align 4
  %var_88 = alloca i64, align 8

  ; callee-saved pseudo-registers
  %r_rax = alloca i64, align 8
  %r_rbx = alloca i64, align 8
  %r_rcx = alloca i32*, align 8
  %r_rdx = alloca i64, align 8
  %r_rsi = alloca i32*, align 8
  %r_rdi = alloca i64, align 8
  %r_r8  = alloca i64, align 8
  %r_r9  = alloca i64, align 8
  %r_r10 = alloca i64, align 8
  %r_r11 = alloca i64, align 8
  %r_r12 = alloca i64, align 8
  %r_r13 = alloca i64, align 8
  %r_r14 = alloca i64, align 8
  %r_r15 = alloca i64, align 8
  %r_rbp = alloca i64, align 8

  ; helpers for loops
  %copy_idx0 = alloca i64, align 8

  ; stack protector setup
  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary, align 8

  ; init buffer from globals
  %buf0 = getelementptr inbounds [10 x i32], [10 x i32]* %stack_buf, i64 0, i64 0
  %vecp0 = bitcast i32* %buf0 to <4 x i32>*
  %vinit0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %vinit0, <4 x i32>* %vecp0, align 16

  %buf4 = getelementptr inbounds [10 x i32], [10 x i32]* %stack_buf, i64 0, i64 4
  %vecp1 = bitcast i32* %buf4 to <4 x i32>*
  %vinit1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %vinit1, <4 x i32>* %vecp1, align 16

  store i32 4, i32* %var_48, align 4

  %m = call noalias i8* @malloc(i64 40)
  store i8* %m, i8** %ptr, align 8
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %bb_142e, label %bb_after_malloc

bb_after_malloc:
  store i64 0, i64* %r_rbx, align 8
  %rbx_ptr = bitcast i32* %buf0 to i32*
  store i32* %rbx_ptr, i32** %var_70, align 8

  %m_i32p = bitcast i8* %m to i32*
  store i32* %m_i32p, i32** %r_rsi, align 8

  store i32* %rbx_ptr, i32** %r_rcx, align 8

  store i64 1, i64* %r_rdi, align 8
  store i64 4, i64* %r_r10, align 8
  store i32 4, i32* %var_7C, align 4

  %rdi0 = load i64, i64* %r_rdi, align 8
  store i64 %rdi0, i64* %r_r11, align 8
  %rdi2 = add i64 %rdi0, %rdi0
  store i64 %rdi2, i64* %r_rdi, align 8
  store i64 0, i64* %r_r8, align 8
  store i64 %rdi2, i64* %var_88, align 8
  br label %bb_128a

bb_1158:
  %rcx_i32p_1158 = load i32*, i32** %r_rcx, align 8
  %r12_1158 = load i64, i64* %r_r12, align 8
  %elt_r12_ptr_1158 = getelementptr inbounds i32, i32* %rcx_i32p_1158, i64 %r12_1158
  %val_r12_32_1158 = load i32, i32* %elt_r12_ptr_1158, align 4
  %val_r12_64_1158 = zext i32 %val_r12_32_1158 to i64
  store i64 %val_r12_64_1158, i64* %r_r9, align 8

  %rax_1158 = load i64, i64* %r_rax, align 8
  %rdi_1158 = add i64 %rax_1158, 1
  store i64 %rdi_1158, i64* %r_rdi, align 8

  %rsi_p_1158 = load i32*, i32** %r_rsi, align 8
  %out_ptr_rax_1158 = getelementptr inbounds i32, i32* %rsi_p_1158, i64 %rax_1158
  %r9_1158 = load i64, i64* %r_r9, align 8
  %r9_32_1158 = trunc i64 %r9_1158 to i32
  store i32 %r9_32_1158, i32* %out_ptr_rax_1158, align 4

  %rdx_1158 = load i64, i64* %r_rdx, align 8
  %cmp_d_eq = icmp eq i64 %rdx_1158, %rdi_1158
  br i1 %cmp_d_eq, label %bb_1280, label %bb_116d

bb_116d:
  %r12_now = load i64, i64* %r_r12, align 8
  %r9_next = add i64 %r12_now, 1
  store i64 %r9_next, i64* %r_r9, align 8

  %r10_val = load i64, i64* %r_r10, align 8
  %rbx_val = load i64, i64* %r_rbx, align 8
  %jb_143a = icmp ult i64 %r10_val, %rbx_val
  br i1 %jb_143a, label %bb_143a, label %bb_117b

bb_117b:
  %rdx_now_117b = load i64, i64* %r_rdx, align 8
  store i64 %rdx_now_117b, i64* %r_rbx, align 8

  %rax_now_117b = load i64, i64* %r_rax, align 8
  %r13_new = add i64 %rax_now_117b, 2
  store i64 %r13_new, i64* %r_r13, align 8

  %rdi_now_117b = load i64, i64* %r_rdi, align 8
  %rbx_sub = sub i64 %rdx_now_117b, %rdi_now_117b
  store i64 %rbx_sub, i64* %r_rbx, align 8

  %r10_lenm1 = add i64 %rbx_sub, -1
  store i64 %r10_lenm1, i64* %r_r10, align 8

  %cmp_jbe_13a0 = icmp ule i64 %r10_lenm1, 2
  br i1 %cmp_jbe_13a0, label %bb_13a0, label %bb_1193

bb_1193:
  %rdx_1193 = load i64, i64* %r_rdx, align 8
  %r13_1193 = load i64, i64* %r_r13, align 8
  %jb_13a0_b = icmp ult i64 %rdx_1193, %r13_1193
  br i1 %jb_13a0_b, label %bb_13a0, label %bb_119c

bb_119c:
  %rdi_119c = load i64, i64* %r_rdi, align 8
  %r10_bytes = shl i64 %rdi_119c, 2
  store i64 %r10_bytes, i64* %r_r10, align 8

  %r12_idx = load i64, i64* %r_r12, align 8
  %r12_shl = shl i64 %r12_idx, 2
  %r12_off = add i64 %r12_shl, 8
  store i64 %r12_off, i64* %r_r12, align 8

  %rsi_base_119c = load i32*, i32** %r_rsi, align 8
  %rsi_b_i8 = bitcast i32* %rsi_base_119c to i8*
  %rbp_ptr = getelementptr inbounds i8, i8* %rsi_b_i8, i64 %r10_bytes
  %rbp_ptr_i64 = ptrtoint i8* %rbp_ptr to i64
  store i64 %rbp_ptr_i64, i64* %r_rbp, align 8

  %rcx_base_119c = load i32*, i32** %r_rcx, align 8
  %rcx_b_i8 = bitcast i32* %rcx_base_119c to i8*
  %r12_off_now = load i64, i64* %r_r12, align 8
  %r15_ptr = getelementptr inbounds i8, i8* %rcx_b_i8, i64 %r12_off_now
  %r15_ptr_i64 = ptrtoint i8* %r15_ptr to i64
  store i64 %r15_ptr_i64, i64* %r_r15, align 8

  %rbp_i64 = load i64, i64* %r_rbp, align 8
  %r15_i64 = load i64, i64* %r_r15, align 8
  %r14_diff = sub i64 %rbp_i64, %r15_i64
  store i64 %r14_diff, i64* %r_r14, align 8

  %cmp_ja_12f0 = icmp ugt i64 %r14_diff, 8
  br i1 %cmp_ja_12f0, label %bb_12f0, label %bb_11c4

bb_11c4:
  %r9_now = load i64, i64* %r_r9, align 8
  %rbx_11c4 = shl i64 %r9_now, 2
  store i64 %rbx_11c4, i64* %r_rbx, align 8

  %rcx_base_11c4 = load i32*, i32** %r_rcx, align 8
  %rcx_base_11c4_i8 = bitcast i32* %rcx_base_11c4 to i8*
  %src_ptr0_i8 = getelementptr inbounds i8, i8* %rcx_base_11c4_i8, i64 %rbx_11c4
  %src_ptr0_i32 = bitcast i8* %src_ptr0_i8 to i32*
  %v0_32 = load i32, i32* %src_ptr0_i32, align 4
  %rsi_base_11c4 = load i32*, i32** %r_rsi, align 8
  %rsi_base_11c4_i8 = bitcast i32* %rsi_base_11c4 to i8*
  %r10_bytes_now = load i64, i64* %r_r10, align 8
  %dst_ptr0_i8 = getelementptr inbounds i8, i8* %rsi_base_11c4_i8, i64 %r10_bytes_now
  %dst_ptr0_i32 = bitcast i8* %dst_ptr0_i8 to i32*
  store i32 %v0_32, i32* %dst_ptr0_i32, align 4

  %r13_now = load i64, i64* %r_r13, align 8
  %rdx_now = load i64, i64* %r_rdx, align 8
  %jnb_1280 = icmp uge i64 %r13_now, %rdx_now
  br i1 %jnb_1280, label %bb_1280, label %bb_11dd

bb_11dd:
  %src_ptr1_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 4
  %src_ptr1_i32 = bitcast i8* %src_ptr1_i8 to i32*
  %v1_32 = load i32, i32* %src_ptr1_i32, align 4
  %dst_ptr1_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 4
  %dst_ptr1_i32 = bitcast i8* %dst_ptr1_i8 to i32*
  store i32 %v1_32, i32* %dst_ptr1_i32, align 4

  %rax_now_11dd = load i64, i64* %r_rax, align 8
  %r9_tmp = add i64 %rax_now_11dd, 3
  store i64 %r9_tmp, i64* %r_r9, align 8
  %cmp_r9_ge_d = icmp uge i64 %r9_tmp, %rdx_now
  br i1 %cmp_r9_ge_d, label %bb_1280, label %bb_11f4

bb_11f4:
  %src_ptr2_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 8
  %src_ptr2_i32 = bitcast i8* %src_ptr2_i8 to i32*
  %v2_32 = load i32, i32* %src_ptr2_i32, align 4
  %dst_ptr2_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 8
  %dst_ptr2_i32 = bitcast i8* %dst_ptr2_i8 to i32*
  store i32 %v2_32, i32* %dst_ptr2_i32, align 4

  %r9_ax4 = add i64 %rax_now_11dd, 4
  store i64 %r9_ax4, i64* %r_r9, align 8
  %cmp_r9_ge_d2 = icmp uge i64 %r9_ax4, %rdx_now
  br i1 %cmp_r9_ge_d2, label %bb_1280, label %bb_1207

bb_1207:
  %src_ptr3_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 12
  %src_ptr3_i32 = bitcast i8* %src_ptr3_i8 to i32*
  %v3_32 = load i32, i32* %src_ptr3_i32, align 4
  %dst_ptr3_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 12
  %dst_ptr3_i32 = bitcast i8* %dst_ptr3_i8 to i32*
  store i32 %v3_32, i32* %dst_ptr3_i32, align 4

  %r9_ax5 = add i64 %rax_now_11dd, 5
  store i64 %r9_ax5, i64* %r_r9, align 8
  %cmp_r9_ge_d3 = icmp uge i64 %r9_ax5, %rdx_now
  br i1 %cmp_r9_ge_d3, label %bb_1280, label %bb_121a

bb_121a:
  %src_ptr4_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 16
  %src_ptr4_i32 = bitcast i8* %src_ptr4_i8 to i32*
  %v4_32 = load i32, i32* %src_ptr4_i32, align 4
  %dst_ptr4_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 16
  %dst_ptr4_i32 = bitcast i8* %dst_ptr4_i8 to i32*
  store i32 %v4_32, i32* %dst_ptr4_i32, align 4

  %r9_ax6 = add i64 %rax_now_11dd, 6
  store i64 %r9_ax6, i64* %r_r9, align 8
  %cmp_r9_ge_d4 = icmp uge i64 %r9_ax6, %rdx_now
  br i1 %cmp_r9_ge_d4, label %bb_1280, label %bb_122d

bb_122d:
  %src_ptr5_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 20
  %src_ptr5_i32 = bitcast i8* %src_ptr5_i8 to i32*
  %v5_32 = load i32, i32* %src_ptr5_i32, align 4
  %dst_ptr5_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 20
  %dst_ptr5_i32 = bitcast i8* %dst_ptr5_i8 to i32*
  store i32 %v5_32, i32* %dst_ptr5_i32, align 4

  %r9_ax7 = add i64 %rax_now_11dd, 7
  store i64 %r9_ax7, i64* %r_r9, align 8
  %cmp_r9_ge_d5 = icmp uge i64 %r9_ax7, %rdx_now
  br i1 %cmp_r9_ge_d5, label %bb_1280, label %bb_1240

bb_1240:
  %src_ptr6_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 24
  %src_ptr6_i32 = bitcast i8* %src_ptr6_i8 to i32*
  %v6_32 = load i32, i32* %src_ptr6_i32, align 4
  %rax_add8 = add i64 %rax_now_11dd, 8
  store i64 %rax_add8, i64* %r_rax, align 8
  %dst_ptr6_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 24
  %dst_ptr6_i32 = bitcast i8* %dst_ptr6_i8 to i32*
  store i32 %v6_32, i32* %dst_ptr6_i32, align 4

  %rdx_now2 = load i64, i64* %r_rdx, align 8
  %cmp_ax_ge_d = icmp uge i64 %rax_add8, %rdx_now2
  br i1 %cmp_ax_ge_d, label %bb_1280, label %bb_1253

bb_1253:
  %src_ptr7_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 28
  %src_ptr7_i32 = bitcast i8* %src_ptr7_i8 to i32*
  %v7_32 = load i32, i32* %src_ptr7_i32, align 4
  %dst_ptr7_i8 = getelementptr inbounds i8, i8* %dst_ptr0_i8, i64 28
  %dst_ptr7_i32 = bitcast i8* %dst_ptr7_i8 to i32*
  store i32 %v7_32, i32* %dst_ptr7_i32, align 4

  %rdi_now125c = load i64, i64* %r_rdi, align 8
  %is_one = icmp eq i64 %rdi_now125c, 1
  %al = select i1 %is_one, i64 1, i64 0
  %neg = sub i64 0, %al
  %sum = add i64 %neg, 10
  store i64 %sum, i64* %r_rax, align 8
  %cmp_sum_ge_d = icmp uge i64 %sum, %rdx_now2
  br i1 %cmp_sum_ge_d, label %bb_1280, label %bb_1271

bb_1271:
  %src_ptr8_i8 = getelementptr inbounds i8, i8* %src_ptr0_i8, i64 32
  %src_ptr8_i32 = bitcast i8* %src_ptr8_i8 to i32*
  %v8_32 = load i32, i32* %src_ptr8_i32, align 4
  %rsi_base_1271 = load i32*, i32** %r_rsi, align 8
  %rsi_base_1271_i8 = bitcast i32* %rsi_base_1271 to i8*
  %dst_ptr_24 = getelementptr inbounds i8, i8* %rsi_base_1271_i8, i64 36
  %dst_ptr_24_i32 = bitcast i8* %dst_ptr_24 to i32*
  store i32 %v8_32, i32* %dst_ptr_24_i32, align 4
  br label %bb_1280

bb_1280:
  %r8_now = load i64, i64* %r_r8, align 8
  %cmp_r8_gt9 = icmp ugt i64 %r8_now, 9
  br i1 %cmp_r8_gt9, label %bb_1380, label %bb_128a

bb_128a:
  %r11_now = load i64, i64* %r_r11, align 8
  %r8_now2 = load i64, i64* %r_r8, align 8
  %rdx_new = add i64 %r11_now, %r8_now2
  store i64 %rdx_new, i64* %r_rdx, align 8

  store i64 10, i64* %r_rbx, align 8
  store i64 %r8_now2, i64* %r_rax, align 8

  %rbx_nowA = load i64, i64* %r_rbx, align 8
  %cmp_cmov1 = icmp ule i64 %rdx_new, %rbx_nowA
  %rbx_sel = select i1 %cmp_cmov1, i64 %rdx_new, i64 %rbx_nowA
  store i64 %rbx_sel, i64* %r_rbx, align 8

  %r8_next = add i64 %rdx_new, %r11_now
  store i64 %r8_next, i64* %r_r8, align 8

  %rax_nowA = load i64, i64* %r_rax, align 8
  store i64 %rax_nowA, i64* %r_r10, align 8

  %cmp_cmov2 = icmp ule i64 %r8_next, 10
  %rdx_final = select i1 %cmp_cmov2, i64 %r8_next, i64 10
  store i64 %rdx_final, i64* %r_rdx, align 8

  %rbx_nowB = load i64, i64* %r_rbx, align 8
  store i64 %rbx_nowB, i64* %r_r12, align 8

  %cmp_ax_ge_rd = icmp uge i64 %rax_nowA, %rdx_final
  br i1 %cmp_ax_ge_rd, label %bb_1280, label %bb_12b8

bb_12b8:
  %r10_nowB = load i64, i64* %r_r10, align 8
  %rbx_nowC = load i64, i64* %r_rbx, align 8
  %cmp_jnb_1158 = icmp uge i64 %r10_nowB, %rbx_nowC
  br i1 %cmp_jnb_1158, label %bb_1158, label %bb_12c1

bb_12c1:
  %rcx_base_12c1 = load i32*, i32** %r_rcx, align 8
  %elt_r10_ptr = getelementptr inbounds i32, i32* %rcx_base_12c1, i64 %r10_nowB
  %edi32 = load i32, i32* %elt_r10_ptr, align 4
  %edi64 = zext i32 %edi32 to i64
  store i64 %edi64, i64* %r_rdi, align 8

  %r12_nowC = load i64, i64* %r_r12, align 8
  %rdx_nowC = load i64, i64* %r_rdx, align 8
  %cmp_jnb_12d7 = icmp uge i64 %r12_nowC, %rdx_nowC
  br i1 %cmp_jnb_12d7, label %bb_12d7, label %bb_12ca

bb_12ca:
  %rcx_base_12ca = load i32*, i32** %r_rcx, align 8
  %elt_r12_ptr = getelementptr inbounds i32, i32* %rcx_base_12ca, i64 %r12_nowC
  %r9d_32 = load i32, i32* %elt_r12_ptr, align 4
  %r9d_64 = zext i32 %r9d_32 to i64
  store i64 %r9d_64, i64* %r_r9, align 8

  %edi_now64 = load i64, i64* %r_rdi, align 8
  %edi_now32_tr = trunc i64 %edi_now64 to i32
  %cmp_jl_115c = icmp slt i32 %r9d_32, %edi_now32_tr
  br i1 %cmp_jl_115c, label %bb_115c, label %bb_12d7

bb_12d7:
  %rsi_base_12d7 = load i32*, i32** %r_rsi, align 8
  %rax_nowD = load i64, i64* %r_rax, align 8
  %dst_ptr_edi = getelementptr inbounds i32, i32* %rsi_base_12d7, i64 %rax_nowD
  %edi_now = load i64, i64* %r_rdi, align 8
  %edi_now32 = trunc i64 %edi_now to i32
  store i32 %edi_now32, i32* %dst_ptr_edi, align 4

  %rax_inc = add i64 %rax_nowD, 1
  store i64 %rax_inc, i64* %r_rax, align 8

  %rdx_nowD = load i64, i64* %r_rdx, align 8
  %eq_d_ax = icmp eq i64 %rdx_nowD, %rax_inc
  br i1 %eq_d_ax, label %bb_1280, label %bb_12e3

bb_12e3:
  %r10_nowD = load i64, i64* %r_r10, align 8
  %r10_inc = add i64 %r10_nowD, 1
  store i64 %r10_inc, i64* %r_r10, align 8
  br label %bb_12b8

bb_12f0:
  %rcx_base_12f0 = load i32*, i32** %r_rcx, align 8
  %rcx_b_i8_12f0 = bitcast i32* %rcx_base_12f0 to i8*
  %r12_off_12f0 = load i64, i64* %r_r12, align 8
  %base_plus_r12 = getelementptr inbounds i8, i8* %rcx_b_i8_12f0, i64 %r12_off_12f0
  %rax_src = getelementptr inbounds i8, i8* %base_plus_r12, i64 -4
  %rax_src_i64 = ptrtoint i8* %rax_src to i64
  store i64 %rax_src_i64, i64* %r_rax, align 8

  %rbx_12f0 = load i64, i64* %r_rbx, align 8
  %r10_new = lshr i64 %rbx_12f0, 2
  store i64 %r10_new, i64* %r_r10, align 8

  %rbp_ptr_i64_12f0 = load i64, i64* %r_rbp, align 8
  %rbp_ptr_12f0 = inttoptr i64 %rbp_ptr_i64_12f0 to <4 x i32>*
  %rax_src_vec = bitcast i8* %rax_src to <4 x i32>*
  %xmm1 = load <4 x i32>, <4 x i32>* %rax_src_vec, align 1
  store <4 x i32> %xmm1, <4 x i32>* %rbp_ptr_12f0, align 1

  %cmp_r10_eq1 = icmp eq i64 %r10_new, 1
  br i1 %cmp_r10_eq1, label %bb_1313, label %bb_130a

bb_130a:
  %rax_src_next = getelementptr inbounds i8, i8* %rax_src, i64 16
  %rbp_base_i8 = inttoptr i64 %rbp_ptr_i64_12f0 to i8*
  %rbp_dst_next_i8 = getelementptr inbounds i8, i8* %rbp_base_i8, i64 16
  %src_vec2 = bitcast i8* %rax_src_next to <4 x i32>*
  %dst_vec2 = bitcast i8* %rbp_dst_next_i8 to <4 x i32>*
  %xmm2 = load <4 x i32>, <4 x i32>* %src_vec2, align 1
  store <4 x i32> %xmm2, <4 x i32>* %dst_vec2, align 1
  br label %bb_1313

bb_1313:
  %rbx_1313 = load i64, i64* %r_rbx, align 8
  %rax_masked = and i64 %rbx_1313, -4
  store i64 %rax_masked, i64* %r_rax, align 8

  %r9_now_1313 = load i64, i64* %r_r9, align 8
  %r9_add = add i64 %r9_now_1313, %rax_masked
  store i64 %r9_add, i64* %r_r9, align 8

  %rdi_now_1313 = load i64, i64* %r_rdi, align 8
  %rax_add = add i64 %rax_masked, %rdi_now_1313
  store i64 %rax_add, i64* %r_rax, align 8

  %ebx_low = and i64 %rbx_1313, 3
  store i64 %ebx_low, i64* %r_rbx, align 8
  %is_zero_tail = icmp eq i64 %ebx_low, 0
  br i1 %is_zero_tail, label %bb_1280, label %bb_1329

bb_1329:
  %r9_now_1329 = load i64, i64* %r_r9, align 8
  %r10_tail = shl i64 %r9_now_1329, 2
  store i64 %r10_tail, i64* %r_r10, align 8

  %rcx_base_1329 = load i32*, i32** %r_rcx, align 8
  %src_tail0 = getelementptr inbounds i32, i32* %rcx_base_1329, i64 %r9_now_1329
  %val_tail0 = load i32, i32* %src_tail0, align 4

  %rsi_base_1329 = load i32*, i32** %r_rsi, align 8
  %rax_now_1329 = load i64, i64* %r_rax, align 8
  %dst_tail0 = getelementptr inbounds i32, i32* %rsi_base_1329, i64 %rax_now_1329
  store i32 %val_tail0, i32* %dst_tail0, align 4

  %r9_next_1 = add i64 %rax_now_1329, 1
  store i64 %r9_next_1, i64* %r_r9, align 8
  %rdx_now_1329 = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge = icmp uge i64 %r9_next_1, %rdx_now_1329
  br i1 %cmp_r9_ge, label %bb_1280, label %bb_134e

bb_134e:
  %rcx_base_1329_i8 = bitcast i32* %rcx_base_1329 to i8*
  %off1 = add i64 %r10_tail, 4
  %src_tail1_i8 = getelementptr inbounds i8, i8* %rcx_base_1329_i8, i64 %off1
  %src_tail1 = bitcast i8* %src_tail1_i8 to i32*
  %val_tail1 = load i32, i32* %src_tail1, align 4

  %rax_add2 = add i64 %rax_now_1329, 2
  store i64 %rax_add2, i64* %r_rax, align 8

  %rsi_base_1329_i8 = bitcast i32* %rsi_base_1329 to i8*
  %rax_shl = shl i64 %rax_now_1329, 2
  %off_dst1 = add i64 %rax_shl, 4
  %dst_tail1_i8 = getelementptr inbounds i8, i8* %rsi_base_1329_i8, i64 %off_dst1
  %dst_tail1 = bitcast i8* %dst_tail1_i8 to i32*
  store i32 %val_tail1, i32* %dst_tail1, align 4

  %rdx_now_134e = load i64, i64* %r_rdx, align 8
  %cmp_ax_ge = icmp uge i64 %rax_add2, %rdx_now_134e
  br i1 %cmp_ax_ge, label %bb_1280, label %bb_1365

bb_1365:
  %off2 = add i64 %r10_tail, 8
  %src_tail2_i8 = getelementptr inbounds i8, i8* %rcx_base_1329_i8, i64 %off2
  %src_tail2 = bitcast i8* %src_tail2_i8 to i32*
  %val_tail2 = load i32, i32* %src_tail2, align 4

  %dst_tail2_i8 = getelementptr inbounds i8, i8* %dst_tail1_i8, i64 4
  %dst_tail2 = bitcast i8* %dst_tail2_i8 to i32*
  store i32 %val_tail2, i32* %dst_tail2, align 4

  %r8_now_136e = load i64, i64* %r_r8, align 8
  %cmp_r8_jbe = icmp ule i64 %r8_now_136e, 9
  br i1 %cmp_r8_jbe, label %bb_128a, label %bb_128a

bb_115c:
  %rax_115c = load i64, i64* %r_rax, align 8
  %rdi_115c = add i64 %rax_115c, 1
  store i64 %rdi_115c, i64* %r_rdi, align 8

  %rsi_p_115c = load i32*, i32** %r_rsi, align 8
  %dst_115c = getelementptr inbounds i32, i32* %rsi_p_115c, i64 %rax_115c
  %r9_val_115c = load i64, i64* %r_r9, align 8
  %r9_val_32_115c = trunc i64 %r9_val_115c to i32
  store i32 %r9_val_32_115c, i32* %dst_115c, align 4

  %rdx_115c = load i64, i64* %r_rdx, align 8
  %eq_d_rdi = icmp eq i64 %rdx_115c, %rdi_115c
  br i1 %eq_d_rdi, label %bb_1280, label %bb_116d

bb_13a0:
  %rdi_13a0 = load i64, i64* %r_rdi, align 8
  %r10_13a0 = shl i64 %rdi_13a0, 2
  store i64 %r10_13a0, i64* %r_r10, align 8
  br label %bb_11c4

bb_1380:
  %cnt = load i32, i32* %var_7C, align 4
  %cnt_dec = add i32 %cnt, -1
  store i32 %cnt_dec, i32* %var_7C, align 4

  %rdi_nextpass = load i64, i64* %var_88, align 8
  store i64 %rdi_nextpass, i64* %r_rdi, align 8

  %is_zero_pass = icmp eq i32 %cnt_dec, 0
  br i1 %is_zero_pass, label %bb_13ad, label %bb_138b

bb_138b:
  %rcx_old = load i32*, i32** %r_rcx, align 8
  %rsi_old = load i32*, i32** %r_rsi, align 8
  store i32* %rsi_old, i32** %r_rcx, align 8
  store i32* %rcx_old, i32** %r_rsi, align 8

  %rdi_now_1394 = load i64, i64* %r_rdi, align 8
  store i64 %rdi_now_1394, i64* %r_r11, align 8
  %rdi_dbl_1394 = add i64 %rdi_now_1394, %rdi_now_1394
  store i64 %rdi_dbl_1394, i64* %r_rdi, align 8
  store i64 0, i64* %r_r8, align 8
  store i64 %rdi_dbl_1394, i64* %var_88, align 8
  br label %bb_128a

bb_13ad:
  %stackbuf_ptr = load i32*, i32** %var_70, align 8
  %rbx_as_i64 = ptrtoint i32* %stackbuf_ptr to i64
  store i64 %rbx_as_i64, i64* %r_rbx, align 8
  %ptr_val = load i8*, i8** %ptr, align 8

  %rsi_final = load i32*, i32** %r_rsi, align 8
  %rsi_final_i64 = ptrtoint i32* %rsi_final to i64
  %eq_rsi_rbx = icmp eq i64 %rsi_final_i64, %rbx_as_i64
  br i1 %eq_rsi_rbx, label %bb_13c6, label %bb_13bc

bb_13bc:
  %dst_stack_i32p = inttoptr i64 %rbx_as_i64 to i32*
  store i64 0, i64* %copy_idx0, align 8
  br label %bb_copy_loop

bb_copy_loop:
  %i = load i64, i64* %copy_idx0, align 8
  %cond = icmp ult i64 %i, 10
  br i1 %cond, label %bb_copy_iter, label %bb_copy_done

bb_copy_iter:
  %src_i_ptr = getelementptr inbounds i32, i32* %rsi_final, i64 %i
  %v_i = load i32, i32* %src_i_ptr, align 4
  %dst_i_ptr = getelementptr inbounds i32, i32* %dst_stack_i32p, i64 %i
  store i32 %v_i, i32* %dst_i_ptr, align 4
  %i_next = add i64 %i, 1
  store i64 %i_next, i64* %copy_idx0, align 8
  br label %bb_copy_loop

bb_copy_done:
  br label %bb_13c6

bb_13c6:
  call void @free(i8* %ptr_val)
  br label %bb_13ce

bb_13ce:
  %buf_end_ptr = getelementptr inbounds [10 x i32], [10 x i32]* %stack_buf, i64 0, i64 10
  %r12_print = bitcast i32* %buf_end_ptr to i8*
  %r12_print_i64 = ptrtoint i8* %r12_print to i64
  store i64 %r12_print_i64, i64* %r_r12, align 8

  %fmt_ptr = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  %fmt_ptr_i64 = ptrtoint i8* %fmt_ptr to i64
  store i64 %fmt_ptr_i64, i64* %r_rbp, align 8

  %rbx_print_i64 = load i64, i64* %r_rbx, align 8
  br label %bb_13e0

bb_13e0:
  %rbx_cur = phi i64 [ %rbx_print_i64, %bb_13ce ], [ %rbx_print_i64_next, %bb_13e0 ]
  %rbx_i8 = inttoptr i64 %rbx_cur to i8*
  %rbx_i32p = bitcast i8* %rbx_i8 to i32*
  %val_to_print = load i32, i32* %rbx_i32p, align 4
  %fmt_i8 = inttoptr i64 %fmt_ptr_i64 to i8*
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_i8, i32 %val_to_print)
  %rbx_print_i64_next = add i64 %rbx_cur, 4

  %r12_print_i64_now = load i64, i64* %r_r12, align 8
  %cont = icmp ne i64 %r12_print_i64_now, %rbx_print_i64_next
  br i1 %cont, label %bb_13e0, label %bb_13fa

bb_13fa:
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)

  %guard_end = load i64, i64* @__stack_chk_guard, align 8
  %guard_saved = load i64, i64* %canary, align 8
  %canary_ok = icmp eq i64 %guard_end, %guard_saved
  br i1 %canary_ok, label %bb_141d, label %bb_1435

bb_141d:
  ret i32 0

bb_142e:
  %rbx_fail = ptrtoint i32* %buf0 to i64
  store i64 %rbx_fail, i64* %r_rbx, align 8
  br label %bb_13ce

bb_1435:
  call void @___stack_chk_fail()
  unreachable

bb_143a:
  %r9_now_143a = load i64, i64* %r_r9, align 8
  store i64 %r9_now_143a, i64* %r_r12, align 8
  %rdi_now_143a = load i64, i64* %r_rdi, align 8
  store i64 %rdi_now_143a, i64* %r_rax, align 8
  br label %bb_12b8
}