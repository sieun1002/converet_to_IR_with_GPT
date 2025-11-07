; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external global [16 x i8], align 16
@xmmword_2020 = external global [16 x i8], align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1

declare noalias i8* @_malloc(i64)
declare void @_free(i8*)
declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main(i32 %argc, i8** %argv) local_unnamed_addr {
loc_10C0:
  %rax64 = alloca i64
  %rbx64 = alloca i64
  %rcx64 = alloca i64
  %rdx64 = alloca i64
  %rsi64 = alloca i64
  %rdi64 = alloca i64
  %r8_64 = alloca i64
  %r9_64 = alloca i64
  %r10_64 = alloca i64
  %r11_64 = alloca i64
  %r12_64 = alloca i64
  %r13_64 = alloca i64
  %r14_64 = alloca i64
  %r15_64 = alloca i64
  %rbp64 = alloca i64
  %var_68 = alloca [16 x i8], align 16
  %var_58 = alloca [16 x i8], align 16
  %var_48 = alloca i32, align 4
  %var_40_canary = alloca i64, align 8
  %var_70 = alloca i8*, align 8
  %ptr = alloca i8*, align 8
  %var_7C = alloca i32, align 4
  %var_88 = alloca i64, align 8
  %tmp_i32 = alloca i32, align 4
  %tmp_i32b = alloca i32, align 4
  %tmp_i32c = alloca i32, align 4
  %tmp_i32d = alloca i32, align 4
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard_now, i64* %var_40_canary, align 8
  store i32 4, i32* %var_48, align 4
  %c1p = getelementptr inbounds [16 x i8], [16 x i8]* %var_68, i64 0, i64 0
  %c1 = bitcast i8* %c1p to <16 x i8>*
  %g1 = bitcast [16 x i8]* @xmmword_2010 to <16 x i8>*
  %v1 = load <16 x i8>, <16 x i8>* %g1, align 16
  store <16 x i8> %v1, <16 x i8>* %c1, align 16
  %c2p = getelementptr inbounds [16 x i8], [16 x i8]* %var_58, i64 0, i64 0
  %c2 = bitcast i8* %c2p to <16 x i8>*
  %g2 = bitcast [16 x i8]* @xmmword_2020 to <16 x i8>*
  %v2 = load <16 x i8>, <16 x i8>* %g2, align 16
  store <16 x i8> %v2, <16 x i8>* %c2, align 16
  %m = call noalias i8* @_malloc(i64 40)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %loc_142E, label %loc_1118

loc_1118:
  %base_stack_i8 = getelementptr inbounds [16 x i8], [16 x i8]* %var_68, i64 0, i64 0
  store i8* %m, i8** %ptr, align 8
  %m64 = ptrtoint i8* %m to i64
  store i64 %m64, i64* %rsi64, align 8
  store i64 1, i64* %rdi64, align 8
  store i64 4, i64* %r10_64, align 8
  %base_stack_i8_gep = ptrtoint i8* %base_stack_i8 to i64
  %rcx_init = add i64 %base_stack_i8_gep, 0
  store i8* %base_stack_i8, i8** %var_70, align 8
  store i64 %rcx_init, i64* %rcx64, align 8
  %r10d4 = trunc i64 4 to i32
  store i32 %r10d4, i32* %var_7C, align 4
  br label %loc_1140

loc_1140:
  %rdi_now = load i64, i64* %rdi64, align 8
  store i64 %rdi_now, i64* %r11_64, align 8
  %rdi_x2 = add i64 %rdi_now, %rdi_now
  store i64 %rdi_x2, i64* %rdi64, align 8
  store i64 0, i64* %r8_64, align 8
  store i64 %rdi_x2, i64* %var_88, align 8
  br label %loc_128A

loc_1158:
  %rcx_v = load i64, i64* %rcx64, align 8
  %r12_v = load i64, i64* %r12_64, align 8
  %off1158 = mul i64 %r12_v, 4
  %rcx_ptr_1158 = inttoptr i64 %rcx_v to i8*
  %addr1158 = getelementptr i8, i8* %rcx_ptr_1158, i64 %off1158
  %addr1158_i32p = bitcast i8* %addr1158 to i32*
  %val1158 = load i32, i32* %addr1158_i32p, align 4
  store i32 %val1158, i32* %tmp_i32, align 4
  br label %loc_115C

loc_115C:
  %rax_v_115c = load i64, i64* %rax64, align 8
  %rdi_new_115c = add i64 %rax_v_115c, 1
  store i64 %rdi_new_115c, i64* %rdi64, align 8
  %rsi_v_115c = load i64, i64* %rsi64, align 8
  %off115c = mul i64 %rax_v_115c, 4
  %rsi_ptr_115c = inttoptr i64 %rsi_v_115c to i8*
  %dst115c = getelementptr i8, i8* %rsi_ptr_115c, i64 %off115c
  %dst115c_i32p = bitcast i8* %dst115c to i32*
  %val_r9d_115c = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_115c, i32* %dst115c_i32p, align 4
  %rdx_v_115c = load i64, i64* %rdx64, align 8
  %cmp1164 = icmp eq i64 %rdx_v_115c, %rdi_new_115c
  br i1 %cmp1164, label %loc_1280, label %loc_116D

loc_116D:
  %r12_v_116d = load i64, i64* %r12_64, align 8
  %r9_new_116d = add i64 %r12_v_116d, 1
  store i64 %r9_new_116d, i64* %r9_64, align 8
  %r10_v_116d = load i64, i64* %r10_64, align 8
  %rbx_v_116d = load i64, i64* %rbx64, align 8
  %jb_1175 = icmp ult i64 %r10_v_116d, %rbx_v_116d
  br i1 %jb_1175, label %loc_143A, label %loc_117B

loc_117B:
  %rdx_v_117b = load i64, i64* %rdx64, align 8
  store i64 %rdx_v_117b, i64* %rbx64, align 8
  %rax_v_117b = load i64, i64* %rax64, align 8
  %r13_new = add i64 %rax_v_117b, 2
  store i64 %r13_new, i64* %r13_64, align 8
  %rdi_v_117b = load i64, i64* %rdi64, align 8
  %rbx_sub = sub i64 %rdx_v_117b, %rdi_v_117b
  store i64 %rbx_sub, i64* %rbx64, align 8
  %r10_new = add i64 %rbx_sub, -1
  store i64 %r10_new, i64* %r10_64, align 8
  %cmp1189 = icmp ule i64 %r10_new, 2
  br i1 %cmp1189, label %loc_13A0, label %loc_1193

loc_1193:
  %rdx_v_1193 = load i64, i64* %rdx64, align 8
  %r13_v_1193 = load i64, i64* %r13_64, align 8
  %jb_1196 = icmp ult i64 %rdx_v_1193, %r13_v_1193
  br i1 %jb_1196, label %loc_13A0, label %loc_119C

loc_119C:
  %rdi_v_119c = load i64, i64* %rdi64, align 8
  %r10_scaled = mul i64 %rdi_v_119c, 4
  store i64 %r10_scaled, i64* %r10_64, align 8
  %r12_v_119c = load i64, i64* %r12_64, align 8
  %r12_scaled = mul i64 %r12_v_119c, 4
  %r12_plus8 = add i64 %r12_scaled, 8
  store i64 %r12_plus8, i64* %r12_64, align 8
  %rsi_v_119c = load i64, i64* %rsi64, align 8
  %rbp_new = add i64 %rsi_v_119c, %r10_scaled
  store i64 %rbp_new, i64* %rbp64, align 8
  %rcx_v_119c = load i64, i64* %rcx64, align 8
  %r15_new = add i64 %rcx_v_119c, %r12_plus8
  store i64 %r15_new, i64* %r15_64, align 8
  %r14_new = sub i64 %rbp_new, %r15_new
  store i64 %r14_new, i64* %r14_64, align 8
  %cmp11ba = icmp ugt i64 %r14_new, 8
  br i1 %cmp11ba, label %loc_12F0, label %loc_11C4

loc_11C4:
  %r9_v_11c4 = load i64, i64* %r9_64, align 8
  %rbx_new_11c4 = mul i64 %r9_v_11c4, 4
  store i64 %rbx_new_11c4, i64* %rbx64, align 8
  %rcx_v_11c4 = load i64, i64* %rcx64, align 8
  %rcx_ptr_11c4 = inttoptr i64 %rcx_v_11c4 to i8*
  %addr11cc = getelementptr i8, i8* %rcx_ptr_11c4, i64 %rbx_new_11c4
  %addr11cc_i32p = bitcast i8* %addr11cc to i32*
  %val11cc = load i32, i32* %addr11cc_i32p, align 4
  store i32 %val11cc, i32* %tmp_i32, align 4
  %rsi_v_11c4 = load i64, i64* %rsi64, align 8
  %r10_v_11c4 = load i64, i64* %r10_64, align 8
  %rsi_ptr_11c4 = inttoptr i64 %rsi_v_11c4 to i8*
  %addr11d0 = getelementptr i8, i8* %rsi_ptr_11c4, i64 %r10_v_11c4
  %addr11d0_i32p = bitcast i8* %addr11d0 to i32*
  %val_r9d_11cc = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_11cc, i32* %addr11d0_i32p, align 4
  %r13_v_11d4 = load i64, i64* %r13_64, align 8
  %rdx_v_11d4 = load i64, i64* %rdx64, align 8
  %jnb_11d7 = icmp uge i64 %r13_v_11d4, %rdx_v_11d4
  br i1 %jnb_11d7, label %loc_1280, label %loc_11DD

loc_11DD:
  %rcx_v_11dd = load i64, i64* %rcx64, align 8
  %rbx_v_11dd = load i64, i64* %rbx64, align 8
  %rcx_ptr_11dd = inttoptr i64 %rcx_v_11dd to i8*
  %off11dd = add i64 %rbx_v_11dd, 4
  %addr11dd = getelementptr i8, i8* %rcx_ptr_11dd, i64 %off11dd
  %addr11dd_i32p = bitcast i8* %addr11dd to i32*
  %val11dd = load i32, i32* %addr11dd_i32p, align 4
  store i32 %val11dd, i32* %tmp_i32, align 4
  %rsi_v_11e2 = load i64, i64* %rsi64, align 8
  %r10_v_11e2 = load i64, i64* %r10_64, align 8
  %addr11e2 = add i64 %r10_v_11e2, 4
  %rsi_ptr_11e2 = inttoptr i64 %rsi_v_11e2 to i8*
  %dst11e2 = getelementptr i8, i8* %rsi_ptr_11e2, i64 %addr11e2
  %dst11e2_i32p = bitcast i8* %dst11e2 to i32*
  %val_r9d_11e2 = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_11e2, i32* %dst11e2_i32p, align 4
  %rax_v_11e7 = load i64, i64* %rax64, align 8
  %r9_new_11e7 = add i64 %rax_v_11e7, 3
  store i64 %r9_new_11e7, i64* %r9_64, align 8
  %rdx_v_11eb = load i64, i64* %rdx64, align 8
  %jnb_11ee = icmp uge i64 %r9_new_11e7, %rdx_v_11eb
  br i1 %jnb_11ee, label %loc_1280, label %loc_11F4

loc_11F4:
  %rcx_v_11f4 = load i64, i64* %rcx64, align 8
  %rbx_v_11f4 = load i64, i64* %rbx64, align 8
  %rcx_ptr_11f4 = inttoptr i64 %rcx_v_11f4 to i8*
  %off11f4 = add i64 %rbx_v_11f4, 8
  %addr11f4 = getelementptr i8, i8* %rcx_ptr_11f4, i64 %off11f4
  %addr11f4_i32p = bitcast i8* %addr11f4 to i32*
  %val11f4 = load i32, i32* %addr11f4_i32p, align 4
  store i32 %val11f4, i32* %tmp_i32, align 4
  %rsi_v_11f9 = load i64, i64* %rsi64, align 8
  %r10_v_11f9 = load i64, i64* %r10_64, align 8
  %addr11f9 = add i64 %r10_v_11f9, 8
  %rsi_ptr_11f9 = inttoptr i64 %rsi_v_11f9 to i8*
  %dst11f9 = getelementptr i8, i8* %rsi_ptr_11f9, i64 %addr11f9
  %dst11f9_i32p = bitcast i8* %dst11f9 to i32*
  %val_r9d_11f9 = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_11f9, i32* %dst11f9_i32p, align 4
  %rax_v_11fe = load i64, i64* %rax64, align 8
  %r9_new_11fe = add i64 %rax_v_11fe, 4
  store i64 %r9_new_11fe, i64* %r9_64, align 8
  %rdx_v_1202 = load i64, i64* %rdx64, align 8
  %jnb_1205 = icmp uge i64 %r9_new_11fe, %rdx_v_1202
  br i1 %jnb_1205, label %loc_1280, label %loc_1207

loc_1207:
  %rcx_v_1207 = load i64, i64* %rcx64, align 8
  %rbx_v_1207 = load i64, i64* %rbx64, align 8
  %rcx_ptr_1207 = inttoptr i64 %rcx_v_1207 to i8*
  %off1207 = add i64 %rbx_v_1207, 12
  %addr1207 = getelementptr i8, i8* %rcx_ptr_1207, i64 %off1207
  %addr1207_i32p = bitcast i8* %addr1207 to i32*
  %val1207 = load i32, i32* %addr1207_i32p, align 4
  store i32 %val1207, i32* %tmp_i32, align 4
  %rsi_v_120c = load i64, i64* %rsi64, align 8
  %r10_v_120c = load i64, i64* %r10_64, align 8
  %addr120c = add i64 %r10_v_120c, 12
  %rsi_ptr_120c = inttoptr i64 %rsi_v_120c to i8*
  %dst120c = getelementptr i8, i8* %rsi_ptr_120c, i64 %addr120c
  %dst120c_i32p = bitcast i8* %dst120c to i32*
  %val_r9d_120c = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_120c, i32* %dst120c_i32p, align 4
  %rax_v_1211 = load i64, i64* %rax64, align 8
  %r9_new_1211 = add i64 %rax_v_1211, 5
  store i64 %r9_new_1211, i64* %r9_64, align 8
  %rdx_v_1215 = load i64, i64* %rdx64, align 8
  %jnb_1218 = icmp uge i64 %r9_new_1211, %rdx_v_1215
  br i1 %jnb_1218, label %loc_1280, label %loc_121A

loc_121A:
  %rcx_v_121a = load i64, i64* %rcx64, align 8
  %rbx_v_121a = load i64, i64* %rbx64, align 8
  %rcx_ptr_121a = inttoptr i64 %rcx_v_121a to i8*
  %off121a = add i64 %rbx_v_121a, 16
  %addr121a = getelementptr i8, i8* %rcx_ptr_121a, i64 %off121a
  %addr121a_i32p = bitcast i8* %addr121a to i32*
  %val121a = load i32, i32* %addr121a_i32p, align 4
  store i32 %val121a, i32* %tmp_i32, align 4
  %rsi_v_121f = load i64, i64* %rsi64, align 8
  %r10_v_121f = load i64, i64* %r10_64, align 8
  %addr121f = add i64 %r10_v_121f, 16
  %rsi_ptr_121f = inttoptr i64 %rsi_v_121f to i8*
  %dst121f = getelementptr i8, i8* %rsi_ptr_121f, i64 %addr121f
  %dst121f_i32p = bitcast i8* %dst121f to i32*
  %val_r9d_121f = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_121f, i32* %dst121f_i32p, align 4
  %rax_v_1224 = load i64, i64* %rax64, align 8
  %r9_new_1224 = add i64 %rax_v_1224, 6
  store i64 %r9_new_1224, i64* %r9_64, align 8
  %rdx_v_1228 = load i64, i64* %rdx64, align 8
  %jnb_122b = icmp uge i64 %r9_new_1224, %rdx_v_1228
  br i1 %jnb_122b, label %loc_1280, label %loc_122D

loc_122D:
  %rcx_v_122d = load i64, i64* %rcx64, align 8
  %rbx_v_122d = load i64, i64* %rbx64, align 8
  %rcx_ptr_122d = inttoptr i64 %rcx_v_122d to i8*
  %off122d = add i64 %rbx_v_122d, 20
  %addr122d = getelementptr i8, i8* %rcx_ptr_122d, i64 %off122d
  %addr122d_i32p = bitcast i8* %addr122d to i32*
  %val122d = load i32, i32* %addr122d_i32p, align 4
  store i32 %val122d, i32* %tmp_i32, align 4
  %rsi_v_1232 = load i64, i64* %rsi64, align 8
  %r10_v_1232 = load i64, i64* %r10_64, align 8
  %addr1232 = add i64 %r10_v_1232, 20
  %rsi_ptr_1232 = inttoptr i64 %rsi_v_1232 to i8*
  %dst1232 = getelementptr i8, i8* %rsi_ptr_1232, i64 %addr1232
  %dst1232_i32p = bitcast i8* %dst1232 to i32*
  %val_r9d_1232 = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_1232, i32* %dst1232_i32p, align 4
  %rax_v_1237 = load i64, i64* %rax64, align 8
  %r9_new_1237 = add i64 %rax_v_1237, 7
  store i64 %r9_new_1237, i64* %r9_64, align 8
  %rdx_v_123b = load i64, i64* %rdx64, align 8
  %jnb_123e = icmp uge i64 %r9_new_1237, %rdx_v_123b
  br i1 %jnb_123e, label %loc_1280, label %loc_1240

loc_1240:
  %rcx_v_1240 = load i64, i64* %rcx64, align 8
  %rbx_v_1240 = load i64, i64* %rbx64, align 8
  %rcx_ptr_1240 = inttoptr i64 %rcx_v_1240 to i8*
  %off1240 = add i64 %rbx_v_1240, 24
  %addr1240 = getelementptr i8, i8* %rcx_ptr_1240, i64 %off1240
  %addr1240_i32p = bitcast i8* %addr1240 to i32*
  %val1240 = load i32, i32* %addr1240_i32p, align 4
  store i32 %val1240, i32* %tmp_i32, align 4
  %rax_v_1245 = load i64, i64* %rax64, align 8
  %rax_new_1245 = add i64 %rax_v_1245, 8
  store i64 %rax_new_1245, i64* %rax64, align 8
  %rsi_v_1249 = load i64, i64* %rsi64, align 8
  %r10_v_1249 = load i64, i64* %r10_64, align 8
  %addr1249 = add i64 %r10_v_1249, 24
  %rsi_ptr_1249 = inttoptr i64 %rsi_v_1249 to i8*
  %dst1249 = getelementptr i8, i8* %rsi_ptr_1249, i64 %addr1249
  %dst1249_i32p = bitcast i8* %dst1249 to i32*
  %val_r9d_1249 = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_1249, i32* %dst1249_i32p, align 4
  %rdx_v_124e = load i64, i64* %rdx64, align 8
  %jnb_1251 = icmp uge i64 %rax_new_1245, %rdx_v_124e
  br i1 %jnb_1251, label %loc_1280, label %loc_1253

loc_1253:
  %rcx_v_1253 = load i64, i64* %rcx64, align 8
  %rbx_v_1253 = load i64, i64* %rbx64, align 8
  %rcx_ptr_1253 = inttoptr i64 %rcx_v_1253 to i8*
  %off1253 = add i64 %rbx_v_1253, 28
  %addr1253 = getelementptr i8, i8* %rcx_ptr_1253, i64 %off1253
  %addr1253_i32p = bitcast i8* %addr1253 to i32*
  %val1253 = load i32, i32* %addr1253_i32p, align 4
  store i32 %val1253, i32* %tmp_i32b, align 4
  %rsi_v_1257 = load i64, i64* %rsi64, align 8
  %r10_v_1257 = load i64, i64* %r10_64, align 8
  %addr1257 = add i64 %r10_v_1257, 28
  %rsi_ptr_1257 = inttoptr i64 %rsi_v_1257 to i8*
  %dst1257 = getelementptr i8, i8* %rsi_ptr_1257, i64 %addr1257
  %dst1257_i32p = bitcast i8* %dst1257 to i32*
  %val_mov_1257 = load i32, i32* %tmp_i32b, align 4
  store i32 %val_mov_1257, i32* %dst1257_i32p, align 4
  store i32 0, i32* %tmp_i32c, align 4
  %rdi_v_125e = load i64, i64* %rdi64, align 8
  %cmp1262 = icmp eq i64 %rdi_v_125e, 1
  %sel_al = select i1 %cmp1262, i64 1, i64 0
  %neg = sub i64 0, %sel_al
  %plus10 = add i64 %neg, 10
  %rdx_v_126c = load i64, i64* %rdx64, align 8
  %jnb_126f = icmp uge i64 %plus10, %rdx_v_126c
  br i1 %jnb_126f, label %loc_1280, label %loc_1271

loc_1271:
  %rcx_v_1271 = load i64, i64* %rcx64, align 8
  %rbx_v_1271 = load i64, i64* %rbx64, align 8
  %rcx_ptr_1271 = inttoptr i64 %rcx_v_1271 to i8*
  %off1271 = add i64 %rbx_v_1271, 32
  %addr1271 = getelementptr i8, i8* %rcx_ptr_1271, i64 %off1271
  %addr1271_i32p = bitcast i8* %addr1271 to i32*
  %val1271 = load i32, i32* %addr1271_i32p, align 4
  store i32 %val1271, i32* %tmp_i32d, align 4
  %rsi_v_1275 = load i64, i64* %rsi64, align 8
  %rsi_ptr_1275 = inttoptr i64 %rsi_v_1275 to i8*
  %dst1275 = getelementptr i8, i8* %rsi_ptr_1275, i64 36
  %dst1275_i32p = bitcast i8* %dst1275 to i32*
  %val_mov_1275 = load i32, i32* %tmp_i32d, align 4
  store i32 %val_mov_1275, i32* %dst1275_i32p, align 4
  br label %loc_1280

loc_1280:
  %r8_v_1280 = load i64, i64* %r8_64, align 8
  %cmp1280 = icmp ugt i64 %r8_v_1280, 9
  br i1 %cmp1280, label %loc_1380, label %loc_128A

loc_128A:
  %r11_v_128a = load i64, i64* %r11_64, align 8
  %r8_v_128a = load i64, i64* %r8_64, align 8
  %rdx_new_128a = add i64 %r11_v_128a, %r8_v_128a
  store i64 %rdx_new_128a, i64* %rdx64, align 8
  store i64 10, i64* %rbx64, align 8
  store i64 %r8_v_128a, i64* %rax64, align 8
  %rdx_v_1296 = load i64, i64* %rdx64, align 8
  %r11_v_1296 = load i64, i64* %r11_64, align 8
  %r8_new_1299 = add i64 %rdx_v_1296, %r11_v_1296
  store i64 %r8_new_1299, i64* %r8_64, align 8
  %rax_v_129d = load i64, i64* %rax64, align 8
  store i64 %rax_v_129d, i64* %r10_64, align 8
  %rbx_v_1296 = load i64, i64* %rbx64, align 8
  %rdx_le_rbx = icmp ule i64 %rdx_v_1296, %rbx_v_1296
  %rbx_min = select i1 %rdx_le_rbx, i64 %rdx_v_1296, i64 %rbx_v_1296
  store i64 %rbx_min, i64* %rbx64, align 8
  %r8_v_12a9 = load i64, i64* %r8_64, align 8
  %r8_le_10 = icmp ule i64 %r8_v_12a9, 10
  %rdx_final = select i1 %r8_le_10, i64 %r8_v_12a9, i64 10
  store i64 %rdx_final, i64* %rdx64, align 8
  store i64 %rbx_min, i64* %r12_64, align 8
  %rax_v_12b3 = load i64, i64* %rax64, align 8
  %rdx_v_12b3 = load i64, i64* %rdx64, align 8
  %cond12b6 = icmp uge i64 %rax_v_12b3, %rdx_v_12b3
  br i1 %cond12b6, label %loc_1280, label %loc_12B8

loc_12B8:
  %r10_v_12b8 = load i64, i64* %r10_64, align 8
  %rbx_v_12b8 = load i64, i64* %rbx64, align 8
  %cond12bb = icmp uge i64 %r10_v_12b8, %rbx_v_12b8
  br i1 %cond12bb, label %loc_1158, label %loc_12C1

loc_12C1:
  %rcx_v_12c1 = load i64, i64* %rcx64, align 8
  %r10_v_12c1 = load i64, i64* %r10_64, align 8
  %off12c1 = mul i64 %r10_v_12c1, 4
  %rcx_ptr_12c1 = inttoptr i64 %rcx_v_12c1 to i8*
  %addr12c1 = getelementptr i8, i8* %rcx_ptr_12c1, i64 %off12c1
  %addr12c1_i32p = bitcast i8* %addr12c1 to i32*
  %val12c1 = load i32, i32* %addr12c1_i32p, align 4
  %val12c1_z = zext i32 %val12c1 to i64
  store i64 %val12c1_z, i64* %rdi64, align 8
  %r12_v_12c5 = load i64, i64* %r12_64, align 8
  %rdx_v_12c5 = load i64, i64* %rdx64, align 8
  %cond12c8 = icmp uge i64 %r12_v_12c5, %rdx_v_12c5
  br i1 %cond12c8, label %loc_12D7, label %loc_12CA

loc_12CA:
  %rcx_v_12ca = load i64, i64* %rcx64, align 8
  %r12_v_12ca = load i64, i64* %r12_64, align 8
  %off12ca = mul i64 %r12_v_12ca, 4
  %rcx_ptr_12ca = inttoptr i64 %rcx_v_12ca to i8*
  %addr12ca = getelementptr i8, i8* %rcx_ptr_12ca, i64 %off12ca
  %addr12ca_i32p = bitcast i8* %addr12ca to i32*
  %val12ca = load i32, i32* %addr12ca_i32p, align 4
  store i32 %val12ca, i32* %tmp_i32, align 4
  %edi_now = load i64, i64* %rdi64, align 8
  %edi_tr = trunc i64 %edi_now to i32
  %r9d_now = load i32, i32* %tmp_i32, align 4
  %cmp12d1 = icmp slt i32 %r9d_now, %edi_tr
  br i1 %cmp12d1, label %loc_115C, label %loc_12D7

loc_12D7:
  %rsi_v_12d7 = load i64, i64* %rsi64, align 8
  %rax_v_12d7 = load i64, i64* %rax64, align 8
  %off12d7 = mul i64 %rax_v_12d7, 4
  %rsi_ptr_12d7 = inttoptr i64 %rsi_v_12d7 to i8*
  %dst12d7 = getelementptr i8, i8* %rsi_ptr_12d7, i64 %off12d7
  %dst12d7_i32p = bitcast i8* %dst12d7 to i32*
  %edi_now_12d7 = load i64, i64* %rdi64, align 8
  %edi_now_32 = trunc i64 %edi_now_12d7 to i32
  store i32 %edi_now_32, i32* %dst12d7_i32p, align 4
  %rax_new_12da = add i64 %rax_v_12d7, 1
  store i64 %rax_new_12da, i64* %rax64, align 8
  %rdx_v_12de = load i64, i64* %rdx64, align 8
  %cond12e1 = icmp eq i64 %rdx_v_12de, %rax_new_12da
  br i1 %cond12e1, label %loc_1280, label %loc_12E3

loc_12E3:
  %r10_v_12e3 = load i64, i64* %r10_64, align 8
  %r10_new_12e3 = add i64 %r10_v_12e3, 1
  store i64 %r10_new_12e3, i64* %r10_64, align 8
  br label %loc_12B8

loc_12F0:
  %rcx_v_12f0 = load i64, i64* %rcx64, align 8
  %r12_v_12f0 = load i64, i64* %r12_64, align 8
  %off12f0 = mul i64 %r12_v_12f0, 4
  %rax_calc_12f0 = add i64 %rcx_v_12f0, %off12f0
  %rax_new_12f0 = add i64 %rax_calc_12f0, -4
  store i64 %rax_new_12f0, i64* %rax64, align 8
  %rbx_v_12f5 = load i64, i64* %rbx64, align 8
  store i64 %rbx_v_12f5, i64* %r10_64, align 8
  %src1 = inttoptr i64 %rax_new_12f0 to <16 x i8>*
  %rbp_cur_12f0 = load i64, i64* %rbp64, align 8
  %dst1 = inttoptr i64 %rbp_cur_12f0 to <16 x i8>*
  %x1 = load <16 x i8>, <16 x i8>* %src1, align 1
  store <16 x i8> %x1, <16 x i8>* %dst1, align 1
  %r10_v_12fc = load i64, i64* %r10_64, align 8
  %r10_shr = lshr i64 %r10_v_12fc, 2
  store i64 %r10_shr, i64* %r10_64, align 8
  %cond1304 = icmp eq i64 %r10_shr, 1
  br i1 %cond1304, label %loc_1313, label %loc_130A

loc_130A:
  %src2_base = inttoptr i64 %rax_new_12f0 to i8*
  %src2 = getelementptr i8, i8* %src2_base, i64 16
  %rbp_cur_130a = load i64, i64* %rbp64, align 8
  %dst2_base = inttoptr i64 %rbp_cur_130a to i8*
  %dst2 = getelementptr i8, i8* %dst2_base, i64 16
  %src2_vecp = bitcast i8* %src2 to <16 x i8>*
  %dst2_vecp = bitcast i8* %dst2 to <16 x i8>*
  %x2 = load <16 x i8>, <16 x i8>* %src2_vecp, align 1
  store <16 x i8> %x2, <16 x i8>* %dst2_vecp, align 1
  br label %loc_1313

loc_1313:
  %rbx_v_1313 = load i64, i64* %rbx64, align 8
  store i64 %rbx_v_1313, i64* %rax64, align 8
  %rax_v_1316 = load i64, i64* %rax64, align 8
  %rax_mask = and i64 %rax_v_1316, -4
  store i64 %rax_mask, i64* %rax64, align 8
  %r9_v_131a = load i64, i64* %r9_64, align 8
  %r9_new_131a = add i64 %r9_v_131a, %rax_mask
  store i64 %r9_new_131a, i64* %r9_64, align 8
  %rdi_v_131d = load i64, i64* %rdi64, align 8
  %rax_plus = add i64 %rax_mask, %rdi_v_131d
  store i64 %rax_plus, i64* %rax64, align 8
  %rbx_v_1320 = load i64, i64* %rbx64, align 8
  %rbx_and3 = and i64 %rbx_v_1320, 3
  store i64 %rbx_and3, i64* %rbx64, align 8
  %cond1323 = icmp eq i64 %rbx_and3, 0
  br i1 %cond1323, label %loc_1280, label %loc_1329

loc_1329:
  %r9_v_1329 = load i64, i64* %r9_64, align 8
  %r10_new_1329 = mul i64 %r9_v_1329, 4
  store i64 %r10_new_1329, i64* %r10_64, align 8
  %rcx_v_1331 = load i64, i64* %rcx64, align 8
  %rcx_ptr_1331 = inttoptr i64 %rcx_v_1331 to i8*
  %addr1331 = getelementptr i8, i8* %rcx_ptr_1331, i64 %r10_new_1329
  %addr1331_i32p = bitcast i8* %addr1331 to i32*
  %val1331 = load i32, i32* %addr1331_i32p, align 4
  store i32 %val1331, i32* %tmp_i32, align 4
  %rax_v_1335 = load i64, i64* %rax64, align 8
  %rdi_scaled = mul i64 %rax_v_1335, 4
  store i64 %rdi_scaled, i64* %rdi64, align 8
  %rsi_v_133d = load i64, i64* %rsi64, align 8
  %rsi_ptr_133d = inttoptr i64 %rsi_v_133d to i8*
  %dst133d = getelementptr i8, i8* %rsi_ptr_133d, i64 %rdi_scaled
  %dst133d_i32p = bitcast i8* %dst133d to i32*
  %val_r9d_133d = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_133d, i32* %dst133d_i32p, align 4
  %rax_v_1341 = load i64, i64* %rax64, align 8
  %r9_new_1341 = add i64 %rax_v_1341, 1
  store i64 %r9_new_1341, i64* %r9_64, align 8
  %rdx_v_1345 = load i64, i64* %rdx64, align 8
  %jnb_1348 = icmp uge i64 %r9_new_1341, %rdx_v_1345
  br i1 %jnb_1348, label %loc_1280, label %loc_134E

loc_134E:
  %rcx_v_134e = load i64, i64* %rcx64, align 8
  %r10_v_134e = load i64, i64* %r10_64, align 8
  %addr134e = add i64 %r10_v_134e, 4
  %rcx_ptr_134e = inttoptr i64 %rcx_v_134e to i8*
  %src134e = getelementptr i8, i8* %rcx_ptr_134e, i64 %addr134e
  %src134e_i32p = bitcast i8* %src134e to i32*
  %val134e = load i32, i32* %src134e_i32p, align 4
  store i32 %val134e, i32* %tmp_i32, align 4
  %rax_v_1353 = load i64, i64* %rax64, align 8
  %rax_new_1353 = add i64 %rax_v_1353, 2
  store i64 %rax_new_1353, i64* %rax64, align 8
  %rsi_v_1357 = load i64, i64* %rsi64, align 8
  %rdi_v_1357 = load i64, i64* %rdi64, align 8
  %addr1357 = add i64 %rdi_v_1357, 4
  %rsi_ptr_1357 = inttoptr i64 %rsi_v_1357 to i8*
  %dst1357 = getelementptr i8, i8* %rsi_ptr_1357, i64 %addr1357
  %dst1357_i32p = bitcast i8* %dst1357 to i32*
  %val_r9d_1357 = load i32, i32* %tmp_i32, align 4
  store i32 %val_r9d_1357, i32* %dst1357_i32p, align 4
  %rdx_v_135c = load i64, i64* %rdx64, align 8
  %jnb_135f = icmp uge i64 %rax_new_1353, %rdx_v_135c
  br i1 %jnb_135f, label %loc_1280, label %loc_1365

loc_1365:
  %rcx_v_1365 = load i64, i64* %rcx64, align 8
  %r10_v_1365 = load i64, i64* %r10_64, align 8
  %addr1365 = add i64 %r10_v_1365, 8
  %rcx_ptr_1365 = inttoptr i64 %rcx_v_1365 to i8*
  %src1365 = getelementptr i8, i8* %rcx_ptr_1365, i64 %addr1365
  %src1365_i32p = bitcast i8* %src1365 to i32*
  %val1365 = load i32, i32* %src1365_i32p, align 4
  %rsi_v_136a = load i64, i64* %rsi64, align 8
  %rdi_v_136a = load i64, i64* %rdi64, align 8
  %addr136a = add i64 %rdi_v_136a, 8
  %rsi_ptr_136a = inttoptr i64 %rsi_v_136a to i8*
  %dst136a = getelementptr i8, i8* %rsi_ptr_136a, i64 %addr136a
  %dst136a_i32p = bitcast i8* %dst136a to i32*
  store i32 %val1365, i32* %dst136a_i32p, align 4
  %r8_v_136e = load i64, i64* %r8_64, align 8
  %cond1372 = icmp ule i64 %r8_v_136e, 9
  br i1 %cond1372, label %loc_128A, label %loc_1380

loc_1380:
  %pass = load i32, i32* %var_7C, align 4
  %passm1 = add i32 %pass, -1
  store i32 %passm1, i32* %var_7C, align 4
  %rdi_next = load i64, i64* %var_88, align 8
  store i64 %rdi_next, i64* %rdi64, align 8
  %is_zero = icmp eq i32 %passm1, 0
  br i1 %is_zero, label %loc_13AD, label %loc_138B

loc_138B:
  %rcx_now = load i64, i64* %rcx64, align 8
  %rsi_now = load i64, i64* %rsi64, align 8
  store i64 %rsi_now, i64* %rcx64, align 8
  store i64 %rcx_now, i64* %rsi64, align 8
  br label %loc_1140

loc_13A0:
  %rdi_v_13a0 = load i64, i64* %rdi64, align 8
  %r10_scaled_13a0 = mul i64 %rdi_v_13a0, 4
  store i64 %r10_scaled_13a0, i64* %r10_64, align 8
  br label %loc_11C4

loc_13AD:
  %stack_base = load i8*, i8** %var_70, align 8
  %stack_base_i64 = ptrtoint i8* %stack_base to i64
  store i64 %stack_base_i64, i64* %rbx64, align 8
  %heap_ptr = load i8*, i8** %ptr, align 8
  %heap_ptr_i64 = ptrtoint i8* %heap_ptr to i64
  store i64 %heap_ptr_i64, i64* %rax64, align 8
  %rsi_end = load i64, i64* %rsi64, align 8
  %cmp13b7 = icmp eq i64 %rsi_end, %stack_base_i64
  br i1 %cmp13b7, label %loc_13C6, label %loc_13BC

loc_13BC:
  %src_copy = inttoptr i64 %rsi_end to i32*
  %dst_copy = inttoptr i64 %stack_base_i64 to i32*
  %i0 = load i32, i32* %src_copy, align 4
  store i32 %i0, i32* %dst_copy, align 4
  %p1 = getelementptr inbounds i32, i32* %src_copy, i64 1
  %q1 = getelementptr inbounds i32, i32* %dst_copy, i64 1
  %i1 = load i32, i32* %p1, align 4
  store i32 %i1, i32* %q1, align 4
  %p2 = getelementptr inbounds i32, i32* %src_copy, i64 2
  %q2 = getelementptr inbounds i32, i32* %dst_copy, i64 2
  %i2 = load i32, i32* %p2, align 4
  store i32 %i2, i32* %q2, align 4
  %p3 = getelementptr inbounds i32, i32* %src_copy, i64 3
  %q3 = getelementptr inbounds i32, i32* %dst_copy, i64 3
  %i3 = load i32, i32* %p3, align 4
  store i32 %i3, i32* %q3, align 4
  %p4 = getelementptr inbounds i32, i32* %src_copy, i64 4
  %q4 = getelementptr inbounds i32, i32* %dst_copy, i64 4
  %i4 = load i32, i32* %p4, align 4
  store i32 %i4, i32* %q4, align 4
  %p5 = getelementptr inbounds i32, i32* %src_copy, i64 5
  %q5 = getelementptr inbounds i32, i32* %dst_copy, i64 5
  %i5 = load i32, i32* %p5, align 4
  store i32 %i5, i32* %q5, align 4
  %p6 = getelementptr inbounds i32, i32* %src_copy, i64 6
  %q6 = getelementptr inbounds i32, i32* %dst_copy, i64 6
  %i6 = load i32, i32* %p6, align 4
  store i32 %i6, i32* %q6, align 4
  %p7 = getelementptr inbounds i32, i32* %src_copy, i64 7
  %q7 = getelementptr inbounds i32, i32* %dst_copy, i64 7
  %i7 = load i32, i32* %p7, align 4
  store i32 %i7, i32* %q7, align 4
  %p8 = getelementptr inbounds i32, i32* %src_copy, i64 8
  %q8 = getelementptr inbounds i32, i32* %dst_copy, i64 8
  %i8 = load i32, i32* %p8, align 4
  store i32 %i8, i32* %q8, align 4
  %p9 = getelementptr inbounds i32, i32* %src_copy, i64 9
  %q9 = getelementptr inbounds i32, i32* %dst_copy, i64 9
  %i9 = load i32, i32* %p9, align 4
  store i32 %i9, i32* %q9, align 4
  br label %loc_13C6

loc_13C6:
  %heap_ptr2 = load i8*, i8** %ptr, align 8
  call void @_free(i8* %heap_ptr2)
  br label %loc_13CE

loc_13CE:
  %canp = getelementptr inbounds i64, i64* %var_40_canary, i64 0
  %canp_i8 = bitcast i64* %canp to i8*
  %canp_i64 = ptrtoint i8* %canp_i8 to i64
  store i64 %canp_i64, i64* %r12_64, align 8
  %fmt1 = getelementptr inbounds i8, i8* @unk_2004, i64 0
  %fmt1_i64 = ptrtoint i8* %fmt1 to i64
  store i64 %fmt1_i64, i64* %rbp64, align 8
  br label %loc_13E0

loc_13E0:
  %rbx_v_13e0 = load i64, i64* %rbx64, align 8
  %rbx_ptr_i8 = inttoptr i64 %rbx_v_13e0 to i8*
  %rbx_ptr_i32 = bitcast i8* %rbx_ptr_i8 to i32*
  %val_out = load i32, i32* %rbx_ptr_i32, align 4
  %fmt1_ptr = inttoptr i64 %fmt1_i64 to i8*
  %edx_sext = sext i32 %val_out to i64
  %edx_i32_pas = trunc i64 %edx_sext to i32
  call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1_ptr, i32 %edx_i32_pas)
  %rbx_new_13ec = add i64 %rbx_v_13e0, 4
  store i64 %rbx_new_13ec, i64* %rbx64, align 8
  %r12_v_13f5 = load i64, i64* %r12_64, align 8
  %cond13f8 = icmp ne i64 %r12_v_13f5, %rbx_new_13ec
  br i1 %cond13f8, label %loc_13E0, label %loc_13FA

loc_13FA:
  %fmt2 = getelementptr inbounds i8, i8* @unk_2008, i64 0
  call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2)
  %can_saved = load i64, i64* %var_40_canary, align 8
  %can_cur = load i64, i64* @__stack_chk_guard, align 8
  %ok = icmp eq i64 %can_saved, %can_cur
  br i1 %ok, label %loc_141D, label %loc_1435

loc_141D:
  ret i32 0

loc_142E:
  %base_stack_i8_fail = getelementptr inbounds [16 x i8], [16 x i8]* %var_68, i64 0, i64 0
  %base_stack_i8_fail_i64 = ptrtoint i8* %base_stack_i8_fail to i64
  store i64 %base_stack_i8_fail_i64, i64* %rbx64, align 8
  br label %loc_13CE

loc_1435:
  call void @___stack_chk_fail()
  unreachable

loc_143A:
  %r9_v_143a = load i64, i64* %r9_64, align 8
  store i64 %r9_v_143a, i64* %r12_64, align 8
  %rdi_v_143a = load i64, i64* %rdi64, align 8
  store i64 %rdi_v_143a, i64* %rax64, align 8
  br label %loc_12B8
}