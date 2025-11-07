; ModuleID = 'recovered_main_from_10c0_1445'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external global [16 x i8], align 16
@xmmword_2020 = external global [16 x i8], align 16

@unk_2004 = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@unk_2008 = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail() noreturn

define i32 @main() {
loc_10C0:
  %local_arr = alloca [10 x i32], align 16
  %saved_canary = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %var_70 = alloca i8*, align 8
  %var_7C = alloca i32, align 4
  %var_88 = alloca i64, align 8
  %r_rax = alloca i64, align 8
  %r_rbx = alloca i64, align 8
  %r_rcx = alloca i64, align 8
  %r_rdx = alloca i64, align 8
  %r_rsi = alloca i64, align 8
  %r_rdi = alloca i64, align 8
  %r_r8  = alloca i64, align 8
  %r_r9  = alloca i64, align 8
  %r_r10 = alloca i64, align 8
  %r_r11 = alloca i64, align 8
  %r_r12 = alloca i64, align 8
  %r_r13 = alloca i64, align 8
  %r_r14 = alloca i64, align 8
  %r_r15 = alloca i64, align 8
  %rbp_s = alloca i64, align 8

  %gcan = load i64, i64* @__stack_chk_guard, align 8
  store i64 %gcan, i64* %saved_canary, align 8

  store i64 0, i64* %r_rax, align 8

  %arr_i8 = bitcast [10 x i32]* %local_arr to i8*
  %src1_vec_ptr = bitcast [16 x i8]* @xmmword_2010 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* %src1_vec_ptr, align 16
  %dst_vec0_ptr = bitcast i8* %arr_i8 to <16 x i8>*
  store <16 x i8> %v1, <16 x i8>* %dst_vec0_ptr, align 16
  %src2_vec_ptr = bitcast [16 x i8]* @xmmword_2020 to <16 x i8>*
  %v2 = load <16 x i8>, <16 x i8>* %src2_vec_ptr, align 16
  %arr_i8_off16 = getelementptr inbounds i8, i8* %arr_i8, i64 16
  %dst_vec1_ptr = bitcast i8* %arr_i8_off16 to <16 x i8>*
  store <16 x i8> %v2, <16 x i8>* %dst_vec1_ptr, align 16
  %arr_i32 = bitcast [10 x i32]* %local_arr to i32*
  %idx8 = getelementptr inbounds i32, i32* %arr_i32, i64 8
  store i32 4, i32* %idx8, align 4

  %malloc_sz = add i64 0, 40
  %m = call i8* @malloc(i64 %malloc_sz)
  %m_isnull = icmp eq i8* %m, null
  br i1 %m_isnull, label %loc_142E, label %loc_1118

loc_1118:
  %arr_base_i8 = bitcast [10 x i32]* %local_arr to i8*
  %arr_base_i8_int = ptrtoint i8* %arr_base_i8 to i64
  store i64 %arr_base_i8_int, i64* %r_rbx, align 8
  store i8* %m, i8** %ptr, align 8
  %m_int = ptrtoint i8* %m to i64
  store i64 %m_int, i64* %r_rsi, align 8
  store i64 1, i64* %r_rdi, align 8
  store i64 4, i64* %r_r10, align 8
  store i8* %arr_base_i8, i8** %var_70, align 8
  store i64 %arr_base_i8_int, i64* %r_rcx, align 8
  %r10_lo = trunc i64 4 to i32
  store i32 %r10_lo, i32* %var_7C, align 4
  br label %loc_1140

loc_1140:
  %rdi_1140 = load i64, i64* %r_rdi, align 8
  store i64 %rdi_1140, i64* %r_r11, align 8
  %rdi2 = add i64 %rdi_1140, %rdi_1140
  store i64 %rdi2, i64* %r_rdi, align 8
  store i64 0, i64* %r_r8, align 8
  store i64 %rdi2, i64* %var_88, align 8
  br label %loc_128A

loc_1158:
  %rcx_1158 = load i64, i64* %r_rcx, align 8
  %r12_1158 = load i64, i64* %r_r12, align 8
  %rcx_i32_1158 = inttoptr i64 %rcx_1158 to i32*
  %r9_ptr_1158 = getelementptr inbounds i32, i32* %rcx_i32_1158, i64 %r12_1158
  %r9_val_1158 = load i32, i32* %r9_ptr_1158, align 4
  %r9_zx_1158 = zext i32 %r9_val_1158 to i64
  store i64 %r9_zx_1158, i64* %r_r9, align 8
  br label %loc_115C

loc_115C:
  %rax_115c = load i64, i64* %r_rax, align 8
  %rdi_next_115c = add i64 %rax_115c, 1
  store i64 %rdi_next_115c, i64* %r_rdi, align 8
  %rsi_115c = load i64, i64* %r_rsi, align 8
  %r9_115c = load i64, i64* %r_r9, align 8
  %rsi_i32_115c = inttoptr i64 %rsi_115c to i32*
  %dst_ptr_115c = getelementptr inbounds i32, i32* %rsi_i32_115c, i64 %rax_115c
  %r9_tr_115c = trunc i64 %r9_115c to i32
  store i32 %r9_tr_115c, i32* %dst_ptr_115c, align 4
  %rdx_115c = load i64, i64* %r_rdx, align 8
  %rdi_cur_115c = load i64, i64* %r_rdi, align 8
  %cmp_rdx_rdi_115c = icmp eq i64 %rdx_115c, %rdi_cur_115c
  br i1 %cmp_rdx_rdi_115c, label %loc_1280, label %loc_116D

loc_116D:
  %r12_116d = load i64, i64* %r_r12, align 8
  %r9_new_116d = add i64 %r12_116d, 1
  store i64 %r9_new_116d, i64* %r_r9, align 8
  %r10_116d = load i64, i64* %r_r10, align 8
  %rbx_116d = load i64, i64* %r_rbx, align 8
  %cmp_r10_rbx_jb = icmp ult i64 %r10_116d, %rbx_116d
  br i1 %cmp_r10_rbx_jb, label %loc_143A, label %loc_117B

loc_117B:
  %rdx_117b = load i64, i64* %r_rdx, align 8
  store i64 %rdx_117b, i64* %r_rbx, align 8
  %rax_117b = load i64, i64* %r_rax, align 8
  %r13_new = add i64 %rax_117b, 2
  store i64 %r13_new, i64* %r_r13, align 8
  %rdi_117b = load i64, i64* %r_rdi, align 8
  %rbx_sub = sub i64 %rdx_117b, %rdi_117b
  store i64 %rbx_sub, i64* %r_rbx, align 8
  %r10_new_117b = add i64 %rbx_sub, -1
  store i64 %r10_new_117b, i64* %r_r10, align 8
  %cmp_r10_le2 = icmp ule i64 %r10_new_117b, 2
  br i1 %cmp_r10_le2, label %loc_13A0, label %loc_1193

loc_1193:
  %rdx_1193 = load i64, i64* %r_rdx, align 8
  %r13_1193 = load i64, i64* %r_r13, align 8
  %cmp_rdx_r13_jb = icmp ult i64 %rdx_1193, %r13_1193
  br i1 %cmp_rdx_r13_jb, label %loc_13A0, label %loc_119C

loc_119C:
  %rdi_119c = load i64, i64* %r_rdi, align 8
  %r10_scaled = shl i64 %rdi_119c, 2
  store i64 %r10_scaled, i64* %r_r10, align 8
  %r12_119c = load i64, i64* %r_r12, align 8
  %r12_scaled = shl i64 %r12_119c, 2
  %r12_add8 = add i64 %r12_scaled, 8
  store i64 %r12_add8, i64* %r_r12, align 8
  %rsi_119c = load i64, i64* %r_rsi, align 8
  %rbp_calc = add i64 %rsi_119c, %r10_scaled
  store i64 %rbp_calc, i64* %rbp_s, align 8
  %rcx_119c = load i64, i64* %r_rcx, align 8
  %r15_calc = add i64 %rcx_119c, %r12_add8
  store i64 %r15_calc, i64* %r_r15, align 8
  %r14_calc = sub i64 %rbp_calc, %r15_calc
  store i64 %r14_calc, i64* %r_r14, align 8
  %cmp_r14_gt8 = icmp ugt i64 %r14_calc, 8
  br i1 %cmp_r14_gt8, label %loc_12F0, label %loc_11C4

loc_11C4:
  %r9_11c4 = load i64, i64* %r_r9, align 8
  %rbx_from_r9 = shl i64 %r9_11c4, 2
  store i64 %rbx_from_r9, i64* %r_rbx, align 8
  %rcx_11c4 = load i64, i64* %r_rcx, align 8
  %base_i32_11c4 = inttoptr i64 %rcx_11c4 to i32*
  %src0_ptr_11c4 = getelementptr inbounds i32, i32* %base_i32_11c4, i64 %r9_11c4
  %src0_val_11c4 = load i32, i32* %src0_ptr_11c4, align 4
  %rsi_11c4 = load i64, i64* %r_rsi, align 8
  %r10_11c4 = load i64, i64* %r_r10, align 8
  %dst0_ptr_11c4 = inttoptr i64 %rsi_11c4 to i8*
  %dst0_off_11c4 = getelementptr inbounds i8, i8* %dst0_ptr_11c4, i64 %r10_11c4
  %dst0_i32_11c4 = bitcast i8* %dst0_off_11c4 to i32*
  store i32 %src0_val_11c4, i32* %dst0_i32_11c4, align 4
  %r13_11c4 = load i64, i64* %r_r13, align 8
  %rdx_11c4 = load i64, i64* %r_rdx, align 8
  %cmp_r13_ge_rdx = icmp uge i64 %r13_11c4, %rdx_11c4
  br i1 %cmp_r13_ge_rdx, label %loc_1280, label %loc_11DD

loc_11DD:
  %rcx_11dd = load i64, i64* %r_rcx, align 8
  %rbx_11dd = load i64, i64* %r_rbx, align 8
  %addr1 = add i64 %rcx_11dd, %rbx_11dd
  %addr1_i8 = inttoptr i64 %addr1 to i8*
  %addr1_plus4 = getelementptr inbounds i8, i8* %addr1_i8, i64 4
  %addr1_plus4_i32 = bitcast i8* %addr1_plus4 to i32*
  %val1 = load i32, i32* %addr1_plus4_i32, align 4
  %rsi_11dd = load i64, i64* %r_rsi, align 8
  %r10_11dd = load i64, i64* %r_r10, align 8
  %dst1_i8 = inttoptr i64 %rsi_11dd to i8*
  %dst1_off = getelementptr inbounds i8, i8* %dst1_i8, i64 %r10_11dd
  %dst1_plus4 = getelementptr inbounds i8, i8* %dst1_off, i64 4
  %dst1_plus4_i32 = bitcast i8* %dst1_plus4 to i32*
  store i32 %val1, i32* %dst1_plus4_i32, align 4
  %rax_11dd = load i64, i64* %r_rax, align 8
  %r9_new_11dd = add i64 %rax_11dd, 3
  store i64 %r9_new_11dd, i64* %r_r9, align 8
  %rdx_11dd = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_11dd = icmp uge i64 %r9_new_11dd, %rdx_11dd
  br i1 %cmp_r9_ge_rdx_11dd, label %loc_1280, label %loc_11F4

loc_11F4:
  %rcx_11f4 = load i64, i64* %r_rcx, align 8
  %rbx_11f4 = load i64, i64* %r_rbx, align 8
  %addr2 = add i64 %rcx_11f4, %rbx_11f4
  %addr2_i8 = inttoptr i64 %addr2 to i8*
  %addr2_plus8 = getelementptr inbounds i8, i8* %addr2_i8, i64 8
  %addr2_plus8_i32 = bitcast i8* %addr2_plus8 to i32*
  %val2 = load i32, i32* %addr2_plus8_i32, align 4
  %rsi_11f4 = load i64, i64* %r_rsi, align 8
  %r10_11f4 = load i64, i64* %r_r10, align 8
  %dst2_i8 = inttoptr i64 %rsi_11f4 to i8*
  %dst2_off = getelementptr inbounds i8, i8* %dst2_i8, i64 %r10_11f4
  %dst2_plus8 = getelementptr inbounds i8, i8* %dst2_off, i64 8
  %dst2_plus8_i32 = bitcast i8* %dst2_plus8 to i32*
  store i32 %val2, i32* %dst2_plus8_i32, align 4
  %rax_11f4 = load i64, i64* %r_rax, align 8
  %r9_new2 = add i64 %rax_11f4, 4
  store i64 %r9_new2, i64* %r_r9, align 8
  %rdx_11f4b = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_11f4 = icmp uge i64 %r9_new2, %rdx_11f4b
  br i1 %cmp_r9_ge_rdx_11f4, label %loc_1280, label %loc_1207

loc_1207:
  %rcx_1207 = load i64, i64* %r_rcx, align 8
  %rbx_1207 = load i64, i64* %r_rbx, align 8
  %addr3 = add i64 %rcx_1207, %rbx_1207
  %addr3_i8 = inttoptr i64 %addr3 to i8*
  %addr3_plusC = getelementptr inbounds i8, i8* %addr3_i8, i64 12
  %addr3_plusC_i32 = bitcast i8* %addr3_plusC to i32*
  %val3 = load i32, i32* %addr3_plusC_i32, align 4
  %rsi_1207 = load i64, i64* %r_rsi, align 8
  %r10_1207 = load i64, i64* %r_r10, align 8
  %dst3_i8 = inttoptr i64 %rsi_1207 to i8*
  %dst3_off = getelementptr inbounds i8, i8* %dst3_i8, i64 %r10_1207
  %dst3_plusC = getelementptr inbounds i8, i8* %dst3_off, i64 12
  %dst3_plusC_i32 = bitcast i8* %dst3_plusC to i32*
  store i32 %val3, i32* %dst3_plusC_i32, align 4
  %rax_1207 = load i64, i64* %r_rax, align 8
  %r9_new3 = add i64 %rax_1207, 5
  store i64 %r9_new3, i64* %r_r9, align 8
  %rdx_1207 = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_1207 = icmp uge i64 %r9_new3, %rdx_1207
  br i1 %cmp_r9_ge_rdx_1207, label %loc_1280, label %loc_121A

loc_121A:
  %rcx_121a = load i64, i64* %r_rcx, align 8
  %rbx_121a = load i64, i64* %r_rbx, align 8
  %addr4 = add i64 %rcx_121a, %rbx_121a
  %addr4_i8 = inttoptr i64 %addr4 to i8*
  %addr4_plus10 = getelementptr inbounds i8, i8* %addr4_i8, i64 16
  %addr4_plus10_i32 = bitcast i8* %addr4_plus10 to i32*
  %val4 = load i32, i32* %addr4_plus10_i32, align 4
  %rsi_121a = load i64, i64* %r_rsi, align 8
  %r10_121a = load i64, i64* %r_r10, align 8
  %dst4_i8 = inttoptr i64 %rsi_121a to i8*
  %dst4_off = getelementptr inbounds i8, i8* %dst4_i8, i64 %r10_121a
  %dst4_plus10 = getelementptr inbounds i8, i8* %dst4_off, i64 16
  %dst4_plus10_i32 = bitcast i8* %dst4_plus10 to i32*
  store i32 %val4, i32* %dst4_plus10_i32, align 4
  %rax_121a = load i64, i64* %r_rax, align 8
  %r9_new4 = add i64 %rax_121a, 6
  store i64 %r9_new4, i64* %r_r9, align 8
  %rdx_121a = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_121a = icmp uge i64 %r9_new4, %rdx_121a
  br i1 %cmp_r9_ge_rdx_121a, label %loc_1280, label %loc_122D

loc_122D:
  %rcx_122d = load i64, i64* %r_rcx, align 8
  %rbx_122d = load i64, i64* %r_rbx, align 8
  %addr5 = add i64 %rcx_122d, %rbx_122d
  %addr5_i8 = inttoptr i64 %addr5 to i8*
  %addr5_plus14 = getelementptr inbounds i8, i8* %addr5_i8, i64 20
  %addr5_plus14_i32 = bitcast i8* %addr5_plus14 to i32*
  %val5 = load i32, i32* %addr5_plus14_i32, align 4
  %rsi_122d = load i64, i64* %r_rsi, align 8
  %r10_122d = load i64, i64* %r_r10, align 8
  %dst5_i8 = inttoptr i64 %rsi_122d to i8*
  %dst5_off = getelementptr inbounds i8, i8* %dst5_i8, i64 %r10_122d
  %dst5_plus14 = getelementptr inbounds i8, i8* %dst5_off, i64 20
  %dst5_plus14_i32 = bitcast i8* %dst5_plus14 to i32*
  store i32 %val5, i32* %dst5_plus14_i32, align 4
  %rax_122d = load i64, i64* %r_rax, align 8
  %r9_new5 = add i64 %rax_122d, 7
  store i64 %r9_new5, i64* %r_r9, align 8
  %rdx_122d = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_122d = icmp uge i64 %r9_new5, %rdx_122d
  br i1 %cmp_r9_ge_rdx_122d, label %loc_1280, label %loc_1240

loc_1240:
  %rcx_1240 = load i64, i64* %r_rcx, align 8
  %rbx_1240 = load i64, i64* %r_rbx, align 8
  %addr6 = add i64 %rcx_1240, %rbx_1240
  %addr6_i8 = inttoptr i64 %addr6 to i8*
  %addr6_plus18 = getelementptr inbounds i8, i8* %addr6_i8, i64 24
  %addr6_plus18_i32 = bitcast i8* %addr6_plus18 to i32*
  %val6 = load i32, i32* %addr6_plus18_i32, align 4
  %rax_1240 = load i64, i64* %r_rax, align 8
  %rax_add8 = add i64 %rax_1240, 8
  store i64 %rax_add8, i64* %r_rax, align 8
  %rsi_1240 = load i64, i64* %r_rsi, align 8
  %r10_1240 = load i64, i64* %r_r10, align 8
  %dst6_i8 = inttoptr i64 %rsi_1240 to i8*
  %dst6_off = getelementptr inbounds i8, i8* %dst6_i8, i64 %r10_1240
  %dst6_plus18 = getelementptr inbounds i8, i8* %dst6_off, i64 24
  %dst6_plus18_i32 = bitcast i8* %dst6_plus18 to i32*
  store i32 %val6, i32* %dst6_plus18_i32, align 4
  %rdx_1240 = load i64, i64* %r_rdx, align 8
  %rax_now = load i64, i64* %r_rax, align 8
  %cmp_rax_ge_rdx_1240 = icmp uge i64 %rax_now, %rdx_1240
  br i1 %cmp_rax_ge_rdx_1240, label %loc_1280, label %loc_1253

loc_1253:
  %rcx_1253 = load i64, i64* %r_rcx, align 8
  %rbx_1253 = load i64, i64* %r_rbx, align 8
  %addr7 = add i64 %rcx_1253, %rbx_1253
  %addr7_i8 = inttoptr i64 %addr7 to i8*
  %addr7_plus1c = getelementptr inbounds i8, i8* %addr7_i8, i64 28
  %addr7_plus1c_i32 = bitcast i8* %addr7_plus1c to i32*
  %val7 = load i32, i32* %addr7_plus1c_i32, align 4
  %rsi_1253 = load i64, i64* %r_rsi, align 8
  %r10_1253 = load i64, i64* %r_r10, align 8
  %dst7_i8 = inttoptr i64 %rsi_1253 to i8*
  %dst7_off = getelementptr inbounds i8, i8* %dst7_i8, i64 %r10_1253
  %dst7_plus1c = getelementptr inbounds i8, i8* %dst7_off, i64 28
  %dst7_plus1c_i32 = bitcast i8* %dst7_plus1c to i32*
  store i32 %val7, i32* %dst7_plus1c_i32, align 4
  store i64 0, i64* %r_rax, align 8
  %rdi_125e = load i64, i64* %r_rdi, align 8
  %cmp_rdi_eq1 = icmp eq i64 %rdi_125e, 1
  %al_set = select i1 %cmp_rdi_eq1, i64 1, i64 0
  %neg_al = sub i64 0, %al_set
  %rax_add10 = add i64 %neg_al, 10
  store i64 %rax_add10, i64* %r_rax, align 8
  %rdx_126c = load i64, i64* %r_rdx, align 8
  %cmp_rax_ge_rdx_126c = icmp uge i64 %rax_add10, %rdx_126c
  br i1 %cmp_rax_ge_rdx_126c, label %loc_1280, label %loc_1271

loc_1271:
  %rcx_1271 = load i64, i64* %r_rcx, align 8
  %rbx_1271 = load i64, i64* %r_rbx, align 8
  %addr8 = add i64 %rcx_1271, %rbx_1271
  %addr8_i8 = inttoptr i64 %addr8 to i8*
  %addr8_plus20 = getelementptr inbounds i8, i8* %addr8_i8, i64 32
  %addr8_plus20_i32 = bitcast i8* %addr8_plus20 to i32*
  %val8 = load i32, i32* %addr8_plus20_i32, align 4
  %rsi_1271 = load i64, i64* %r_rsi, align 8
  %rsi_ptr_1271 = inttoptr i64 %rsi_1271 to i8*
  %dst_plus24 = getelementptr inbounds i8, i8* %rsi_ptr_1271, i64 36
  %dst_plus24_i32 = bitcast i8* %dst_plus24 to i32*
  store i32 %val8, i32* %dst_plus24_i32, align 4
  br label %loc_1280

loc_1280:
  %r8_1280 = load i64, i64* %r_r8, align 8
  %cmp_r8_gt9 = icmp ugt i64 %r8_1280, 9
  br i1 %cmp_r8_gt9, label %loc_1380, label %loc_128A

loc_128A:
  %r11_128a = load i64, i64* %r_r11, align 8
  %r8_128a = load i64, i64* %r_r8, align 8
  %rdx_sum = add i64 %r11_128a, %r8_128a
  store i64 %rdx_sum, i64* %r_rdx, align 8
  store i64 10, i64* %r_rbx, align 8
  store i64 %r8_128a, i64* %r_rax, align 8
  %rbx_128a = load i64, i64* %r_rbx, align 8
  %cmp_rdx_rbx = icmp ule i64 %rdx_sum, %rbx_128a
  %r8_next = add i64 %rdx_sum, %r11_128a
  store i64 %r8_next, i64* %r_r8, align 8
  %rax_now_128a = load i64, i64* %r_rax, align 8
  store i64 %rax_now_128a, i64* %r_r10, align 8
  %rbx_sel = select i1 %cmp_rdx_rbx, i64 %rdx_sum, i64 %rbx_128a
  store i64 %rbx_sel, i64* %r_rbx, align 8
  store i64 10, i64* %r_rdx, align 8
  %r8_after = load i64, i64* %r_r8, align 8
  %rdx_now = load i64, i64* %r_rdx, align 8
  %cmp_r8_rdx = icmp ule i64 %r8_after, %rdx_now
  %rdx_sel = select i1 %cmp_r8_rdx, i64 %r8_after, i64 %rdx_now
  store i64 %rdx_sel, i64* %r_rdx, align 8
  store i64 %rbx_sel, i64* %r_r12, align 8
  %rax_128a2 = load i64, i64* %r_rax, align 8
  %rdx_128a2 = load i64, i64* %r_rdx, align 8
  %cmp_rax_ge_rdx_128a = icmp uge i64 %rax_128a2, %rdx_128a2
  br i1 %cmp_rax_ge_rdx_128a, label %loc_1280, label %loc_12B8

loc_12B8:
  %r10_12b8 = load i64, i64* %r_r10, align 8
  %rbx_12b8 = load i64, i64* %r_rbx, align 8
  %cmp_r10_ge_rbx = icmp uge i64 %r10_12b8, %rbx_12b8
  br i1 %cmp_r10_ge_rbx, label %loc_1158, label %loc_12C1

loc_12C1:
  %rcx_12c1 = load i64, i64* %r_rcx, align 8
  %r10_12c1 = load i64, i64* %r_r10, align 8
  %base_i32_12c1 = inttoptr i64 %rcx_12c1 to i32*
  %src_ptr_12c1 = getelementptr inbounds i32, i32* %base_i32_12c1, i64 %r10_12c1
  %src_val_12c1 = load i32, i32* %src_ptr_12c1, align 4
  %src_val_zx_12c1 = zext i32 %src_val_12c1 to i64
  store i64 %src_val_zx_12c1, i64* %r_rdi, align 8
  %r12_12c1 = load i64, i64* %r_r12, align 8
  %rdx_12c1 = load i64, i64* %r_rdx, align 8
  %cmp_r12_ge_rdx = icmp uge i64 %r12_12c1, %rdx_12c1
  br i1 %cmp_r12_ge_rdx, label %loc_12D7, label %loc_12CA

loc_12CA:
  %rcx_12ca = load i64, i64* %r_rcx, align 8
  %r12_12ca = load i64, i64* %r_r12, align 8
  %base_i32_12ca = inttoptr i64 %rcx_12ca to i32*
  %r9_src_12ca = getelementptr inbounds i32, i32* %base_i32_12ca, i64 %r12_12ca
  %r9_val_12ca = load i32, i32* %r9_src_12ca, align 4
  %r9_zx_12ca = zext i32 %r9_val_12ca to i64
  store i64 %r9_zx_12ca, i64* %r_r9, align 8
  %rdi_val_12ca = load i64, i64* %r_rdi, align 8
  %rdi_tr_12ca = trunc i64 %rdi_val_12ca to i32
  %cmp_r9_lt_edi = icmp slt i32 %r9_val_12ca, %rdi_tr_12ca
  br i1 %cmp_r9_lt_edi, label %loc_115C, label %loc_12D7

loc_12D7:
  %rsi_12d7 = load i64, i64* %r_rsi, align 8
  %rax_12d7 = load i64, i64* %r_rax, align 8
  %rsi_i32_12d7 = inttoptr i64 %rsi_12d7 to i32*
  %dst_ptr_12d7 = getelementptr inbounds i32, i32* %rsi_i32_12d7, i64 %rax_12d7
  %edi_12d7 = load i64, i64* %r_rdi, align 8
  %edi_tr_12d7 = trunc i64 %edi_12d7 to i32
  store i32 %edi_tr_12d7, i32* %dst_ptr_12d7, align 4
  %rax_inc_12d7 = add i64 %rax_12d7, 1
  store i64 %rax_inc_12d7, i64* %r_rax, align 8
  %rdx_12d7 = load i64, i64* %r_rdx, align 8
  %cmp_rdx_eq_rax = icmp eq i64 %rdx_12d7, %rax_inc_12d7
  br i1 %cmp_rdx_eq_rax, label %loc_1280, label %loc_12E3

loc_12E3:
  %r10_12e3 = load i64, i64* %r_r10, align 8
  %r10_inc_12e3 = add i64 %r10_12e3, 1
  store i64 %r10_inc_12e3, i64* %r_r10, align 8
  br label %loc_12B8

loc_12F0:
  %rcx_12f0 = load i64, i64* %r_rcx, align 8
  %r12_12f0 = load i64, i64* %r_r12, align 8
  %tmp_add = add i64 %rcx_12f0, %r12_12f0
  %rax_vec = add i64 %tmp_add, -4
  store i64 %rax_vec, i64* %r_rax, align 8
  %rbx_12f0 = load i64, i64* %r_rbx, align 8
  store i64 %rbx_12f0, i64* %r_r10, align 8
  %src_vec_i8 = inttoptr i64 %rax_vec to i8*
  %src_vec_v = bitcast i8* %src_vec_i8 to <16 x i8>*
  %xmm1 = load <16 x i8>, <16 x i8>* %src_vec_v, align 1
  %rsi_12f0 = load i64, i64* %r_rsi, align 8
  %r10_off_12f0 = load i64, i64* %r_r10, align 8
  %dst_vec_i8 = inttoptr i64 %rsi_12f0 to i8*
  %dst_vec_off = getelementptr inbounds i8, i8* %dst_vec_i8, i64 %r10_off_12f0
  %dst_vec_v = bitcast i8* %dst_vec_off to <16 x i8>*
  store <16 x i8> %xmm1, <16 x i8>* %dst_vec_v, align 1
  %r10_now_12f0 = load i64, i64* %r_r10, align 8
  %r10_shr2 = lshr i64 %r10_now_12f0, 2
  store i64 %r10_shr2, i64* %r_r10, align 8
  %cmp_r10_eq1 = icmp eq i64 %r10_shr2, 1
  br i1 %cmp_r10_eq1, label %loc_1313, label %loc_130A

loc_130A:
  %rax_130a = load i64, i64* %r_rax, align 8
  %rax_plus16 = add i64 %rax_130a, 16
  %src2_i8_130a = inttoptr i64 %rax_plus16 to i8*
  %src2_v_ptr = bitcast i8* %src2_i8_130a to <16 x i8>*
  %xmm2 = load <16 x i8>, <16 x i8>* %src2_v_ptr, align 1
  %rsi_130a = load i64, i64* %r_rsi, align 8
  %dst2_i8_130a = inttoptr i64 %rsi_130a to i8*
  %r10_bytes = load i64, i64* %r_rbx, align 8
  %dst2_off_130a = getelementptr inbounds i8, i8* %dst2_i8_130a, i64 %r10_bytes
  %dst2_v = bitcast i8* %dst2_off_130a to <16 x i8>*
  store <16 x i8> %xmm2, <16 x i8>* %dst2_v, align 1
  br label %loc_1313

loc_1313:
  %rbx_1313 = load i64, i64* %r_rbx, align 8
  %rax_from_rbx = add i64 %rbx_1313, 0
  %rax_mask = and i64 %rax_from_rbx, -4
  store i64 %rax_mask, i64* %r_rax, align 8
  %r9_1313 = load i64, i64* %r_r9, align 8
  %r9_add_rax = add i64 %r9_1313, %rax_mask
  store i64 %r9_add_rax, i64* %r_r9, align 8
  %rdi_1313 = load i64, i64* %r_rdi, align 8
  %rax_plus_rdi = add i64 %rax_mask, %rdi_1313
  store i64 %rax_plus_rdi, i64* %r_rax, align 8
  %ebx_low3 = and i64 %rbx_1313, 3
  store i64 %ebx_low3, i64* %r_rbx, align 8
  %cmp_ebx_zero = icmp eq i64 %ebx_low3, 0
  br i1 %cmp_ebx_zero, label %loc_1280, label %loc_1329

loc_1329:
  %r9_1329 = load i64, i64* %r_r9, align 8
  %r10_scaled_1329 = shl i64 %r9_1329, 2
  store i64 %r10_scaled_1329, i64* %r_r10, align 8
  %rcx_1329 = load i64, i64* %r_rcx, align 8
  %base_i32_1329 = inttoptr i64 %rcx_1329 to i32*
  %src_ptr_1329 = getelementptr inbounds i32, i32* %base_i32_1329, i64 %r9_1329
  %src_val_1329 = load i32, i32* %src_ptr_1329, align 4
  %rax_1329 = load i64, i64* %r_rax, align 8
  %rdi_scaled_1329 = shl i64 %rax_1329, 2
  store i64 %rdi_scaled_1329, i64* %r_rdi, align 8
  %rsi_1329 = load i64, i64* %r_rsi, align 8
  %dst_ptr_i8_1329 = inttoptr i64 %rsi_1329 to i8*
  %dst_off_i8_1329 = getelementptr inbounds i8, i8* %dst_ptr_i8_1329, i64 %rdi_scaled_1329
  %dst_i32_1329 = bitcast i8* %dst_off_i8_1329 to i32*
  store i32 %src_val_1329, i32* %dst_i32_1329, align 4
  %rax_1341 = load i64, i64* %r_rax, align 8
  %r9_new_1341 = add i64 %rax_1341, 1
  store i64 %r9_new_1341, i64* %r_r9, align 8
  %rdx_1341 = load i64, i64* %r_rdx, align 8
  %cmp_r9_ge_rdx_1341 = icmp uge i64 %r9_new_1341, %rdx_1341
  br i1 %cmp_r9_ge_rdx_1341, label %loc_1280, label %loc_134E

loc_134E:
  %rcx_134e = load i64, i64* %r_rcx, align 8
  %r10_134e = load i64, i64* %r_r10, align 8
  %addr9 = add i64 %rcx_134e, %r10_134e
  %addr9_i8 = inttoptr i64 %addr9 to i8*
  %addr9_plus4 = getelementptr inbounds i8, i8* %addr9_i8, i64 4
  %addr9_plus4_i32 = bitcast i8* %addr9_plus4 to i32*
  %val9 = load i32, i32* %addr9_plus4_i32, align 4
  %rax_1353 = load i64, i64* %r_rax, align 8
  %rax_add2 = add i64 %rax_1353, 2
  store i64 %rax_add2, i64* %r_rax, align 8
  %rsi_1353 = load i64, i64* %r_rsi, align 8
  %rdi_1353 = load i64, i64* %r_rdi, align 8
  %dst10_i8 = inttoptr i64 %rsi_1353 to i8*
  %dst10_off = getelementptr inbounds i8, i8* %dst10_i8, i64 %rdi_1353
  %dst10_plus4 = getelementptr inbounds i8, i8* %dst10_off, i64 4
  %dst10_plus4_i32 = bitcast i8* %dst10_plus4 to i32*
  store i32 %val9, i32* %dst10_plus4_i32, align 4
  %rdx_135c = load i64, i64* %r_rdx, align 8
  %cmp_rax_ge_rdx_135c = icmp uge i64 %rax_add2, %rdx_135c
  br i1 %cmp_rax_ge_rdx_135c, label %loc_1280, label %loc_1365

loc_1365:
  %rcx_1365 = load i64, i64* %r_rcx, align 8
  %r10_1365 = load i64, i64* %r_r10, align 8
  %addr10 = add i64 %rcx_1365, %r10_1365
  %addr10_i8 = inttoptr i64 %addr10 to i8*
  %addr10_plus8 = getelementptr inbounds i8, i8* %addr10_i8, i64 8
  %addr10_plus8_i32 = bitcast i8* %addr10_plus8 to i32*
  %val10 = load i32, i32* %addr10_plus8_i32, align 4
  %rsi_1365 = load i64, i64* %r_rsi, align 8
  %rdi_1365 = load i64, i64* %r_rdi, align 8
  %dst11_i8 = inttoptr i64 %rsi_1365 to i8*
  %dst11_off = getelementptr inbounds i8, i8* %dst11_i8, i64 %rdi_1365
  %dst11_plus8 = getelementptr inbounds i8, i8* %dst11_off, i64 8
  %dst11_plus8_i32 = bitcast i8* %dst11_plus8 to i32*
  store i32 %val10, i32* %dst11_plus8_i32, align 4
  %r8_136e = load i64, i64* %r_r8, align 8
  %cmp_r8_le9 = icmp ule i64 %r8_136e, 9
  br i1 %cmp_r8_le9, label %loc_128A, label %loc_1380

loc_1380:
  %outer_cnt = load i32, i32* %var_7C, align 4
  %outer_dec = add i32 %outer_cnt, -1
  store i32 %outer_dec, i32* %var_7C, align 4
  %saved_d = load i64, i64* %var_88, align 8
  store i64 %saved_d, i64* %r_rdi, align 8
  %is_zero = icmp eq i32 %outer_dec, 0
  br i1 %is_zero, label %loc_13AD, label %loc_138B

loc_138B:
  %rsi_138b = load i64, i64* %r_rsi, align 8
  %rcx_138b = load i64, i64* %r_rcx, align 8
  store i64 %rcx_138b, i64* %r_rsi, align 8
  store i64 %rsi_138b, i64* %r_rcx, align 8
  br label %loc_1140

loc_13A0:
  %rdi_13a0 = load i64, i64* %r_rdi, align 8
  %r10_scaled_13a0 = shl i64 %rdi_13a0, 2
  store i64 %r10_scaled_13a0, i64* %r_r10, align 8
  br label %loc_11C4

loc_13AD:
  %base_ptr = load i8*, i8** %var_70, align 8
  %heap_ptr = load i8*, i8** %ptr, align 8
  %base_ptr_int = ptrtoint i8* %base_ptr to i64
  store i64 %base_ptr_int, i64* %r_rbx, align 8
  %heap_ptr_int = ptrtoint i8* %heap_ptr to i64
  store i64 %heap_ptr_int, i64* %r_rax, align 8
  %rsi_13ad = load i64, i64* %r_rsi, align 8
  %rbx_13ad = load i64, i64* %r_rbx, align 8
  %cmp_eq_buf = icmp eq i64 %rsi_13ad, %rbx_13ad
  br i1 %cmp_eq_buf, label %loc_13C6, label %loc_13BC

loc_13BC:
  %dst_13bc = inttoptr i64 %rbx_13ad to i8*
  %src_13bc = inttoptr i64 %rsi_13ad to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %dst_13bc, i8* %src_13bc, i64 40, i1 false)
  br label %loc_13C6

loc_13C6:
  %heap_ptr2 = load i8*, i8** %ptr, align 8
  call void @free(i8* %heap_ptr2)
  br label %loc_13CE

loc_13CE:
  %end_ptr = getelementptr inbounds i8, i8* %arr_i8, i64 40
  %end_ptr_int = ptrtoint i8* %end_ptr to i64
  store i64 %end_ptr_int, i64* %r_r12, align 8
  store i64 ptrtoint ([4 x i8]* @unk_2004 to i64), i64* %rbp_s, align 8
  br label %loc_13E0

loc_13E0:
  %rbx_13e0 = load i64, i64* %r_rbx, align 8
  %rbx_i32ptr = inttoptr i64 %rbx_13e0 to i32*
  %val_print = load i32, i32* %rbx_i32ptr, align 4
  %rbp_val = load i64, i64* %rbp_s, align 8
  %fmt_ptr = inttoptr i64 %rbp_val to i8*
  %val_print_i32 = add i32 %val_print, 0
  %chk_res = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i32 %val_print_i32)
  %rbx_add4 = add i64 %rbx_13e0, 4
  store i64 %rbx_add4, i64* %r_rbx, align 8
  %r12_13e0 = load i64, i64* %r_r12, align 8
  %cmp_r12_ne_rbx = icmp ne i64 %r12_13e0, %rbx_add4
  br i1 %cmp_r12_ne_rbx, label %loc_13E0, label %loc_13FA

loc_13FA:
  %fmt_nl = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_nl)
  %saved = load i64, i64* %saved_canary, align 8
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %cmp_can = icmp ne i64 %saved, %cur
  br i1 %cmp_can, label %loc_1435, label %loc_141D

loc_141D:
  ret i32 0

loc_142E:
  %arr_base_fail = bitcast [10 x i32]* %local_arr to i8*
  %arr_base_fail_int = ptrtoint i8* %arr_base_fail to i64
  store i64 %arr_base_fail_int, i64* %r_rbx, align 8
  br label %loc_13CE

loc_1435:
  call void @__stack_chk_fail()
  unreachable

loc_143A:
  %r9_143a = load i64, i64* %r_r9, align 8
  store i64 %r9_143a, i64* %r_r12, align 8
  %rdi_143a = load i64, i64* %r_rdi, align 8
  store i64 %rdi_143a, i64* %r_rax, align 8
  br label %loc_12B8
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8*, i8*, i64, i1) #0

attributes #0 = { nobuiltin }