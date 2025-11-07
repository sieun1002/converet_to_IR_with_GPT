; ModuleID = 'reconstructed_main'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external thread_local global i64

@xmmword_2010 = internal constant [16 x i8] zeroinitializer, align 16
@xmmword_2020 = internal constant [16 x i8] zeroinitializer, align 16

@unk_2004 = internal constant [4 x i8] c"%d \00", align 1
@unk_2008 = internal constant [2 x i8] c"\0A\00", align 1

declare i8* @malloc(i64) nounwind
declare void @free(i8*) nounwind
declare i32 @__printf_chk(i32, i8*, ...) nounwind
declare void @__stack_chk_fail() noreturn nounwind

define i32 @main() {
bb_10c0:
  %RAX = alloca i64, align 8
  %RBX = alloca i64, align 8
  %RCX = alloca i64, align 8
  %RDX = alloca i64, align 8
  %RSI = alloca i64, align 8
  %RDI = alloca i64, align 8
  %R8  = alloca i64, align 8
  %R9  = alloca i64, align 8
  %R10 = alloca i64, align 8
  %R11 = alloca i64, align 8
  %R12 = alloca i64, align 8
  %R13 = alloca i64, align 8
  %R14 = alloca i64, align 8
  %R15 = alloca i64, align 8
  %RBP = alloca i64, align 8

  %canary = alloca i64, align 8
  %var_48 = alloca i32, align 4
  %var_7C = alloca i32, align 4
  %var_70 = alloca i64, align 8
  %var_88 = alloca i64, align 8
  %ptr    = alloca i8*, align 8
  %var_buf = alloca [40 x i8], align 16

  %gcan = load i64, i64* @__stack_chk_guard
  store i64 %gcan, i64* %canary
  store i64 0, i64* %R15
  store i64 0, i64* %R14
  store i64 0, i64* %R13
  store i64 0, i64* %R12
  store i64 0, i64* %RBP
  store i64 0, i64* %RBX
  store i64 0, i64* %RAX

  store i32 4, i32* %var_48

  %buf0 = bitcast [40 x i8]* %var_buf to i8*
  %csrc0 = bitcast [16 x i8]* @xmmword_2010 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %buf0, i8* align 16 %csrc0, i64 16, i1 false)

  %buf16 = getelementptr inbounds [40 x i8], [40 x i8]* %var_buf, i64 0, i64 16
  %csrc1 = bitcast [16 x i8]* @xmmword_2020 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %buf16, i8* align 16 %csrc1, i64 16, i1 false)

  store i64 0, i64* %RAX

  store i64 40, i64* %RDI
  %m = call i8* @malloc(i64 40)
  %isnull = icmp eq i8* %m, null
  br i1 %isnull, label %loc_142E, label %bb_1118

bb_1118:
  %bufptr_i8 = bitcast [40 x i8]* %var_buf to i8*
  %bufptr = ptrtoint i8* %bufptr_i8 to i64
  store i64 %bufptr, i64* %RBX
  store i8* %m, i8** %ptr
  %m_int = ptrtoint i8* %m to i64
  store i64 %m_int, i64* %RSI
  store i64 1, i64* %RDI
  store i64 4, i64* %R10
  store i64 %bufptr, i64* %var_70
  store i64 %bufptr, i64* %RCX
  store i32 4, i32* %var_7C
  store i64 1, i64* %R11
  store i64 2, i64* %RDI
  store i64 0, i64* %R8
  store i64 2, i64* %var_88
  br label %loc_128A

loc_1158:
  %rcx_1158_i = load i64, i64* %RCX
  %r12_1158 = load i64, i64* %R12
  %rcx_1158_p = inttoptr i64 %rcx_1158_i to i32*
  %elem_1158_p = getelementptr inbounds i32, i32* %rcx_1158_p, i64 %r12_1158
  %val_1158_i32 = load i32, i32* %elem_1158_p
  %val_1158_i64 = zext i32 %val_1158_i32 to i64
  store i64 %val_1158_i64, i64* %R9
  %rax_1158 = load i64, i64* %RAX
  %rdi_1158 = add i64 %rax_1158, 1
  store i64 %rdi_1158, i64* %RDI
  %rsi_1158_i = load i64, i64* %RSI
  %rsi_1158_p = inttoptr i64 %rsi_1158_i to i32*
  %out_slot_1158 = getelementptr inbounds i32, i32* %rsi_1158_p, i64 %rax_1158
  %r9_1158_i64 = load i64, i64* %R9
  %r9_1158_i32 = trunc i64 %r9_1158_i64 to i32
  store i32 %r9_1158_i32, i32* %out_slot_1158
  %rdx_1158 = load i64, i64* %RDX
  %cmp_1158 = icmp eq i64 %rdx_1158, %rdi_1158
  br i1 %cmp_1158, label %loc_1280, label %loc_116D

loc_116D:
  %r12_116d = load i64, i64* %R12
  %r9_116d = add i64 %r12_116d, 1
  store i64 %r9_116d, i64* %R9
  %r10_116d = load i64, i64* %R10
  %rbx_116d = load i64, i64* %RBX
  %jb_116d = icmp ult i64 %r10_116d, %rbx_116d
  br i1 %jb_116d, label %loc_143A, label %loc_117B

loc_117B:
  %rdx_117b = load i64, i64* %RDX
  store i64 %rdx_117b, i64* %RBX
  %rax_117b = load i64, i64* %RAX
  %r13_117b = add i64 %rax_117b, 2
  store i64 %r13_117b, i64* %R13
  %rdi_117b = load i64, i64* %RDI
  %rbx_sub = sub i64 %rdx_117b, %rdi_117b
  store i64 %rbx_sub, i64* %RBX
  %r10_new = add i64 %rbx_sub, -1
  store i64 %r10_new, i64* %R10
  %jbe_1189 = icmp ule i64 %r10_new, 2
  br i1 %jbe_1189, label %loc_13A0, label %loc_1193

loc_1193:
  %rdx_1193 = load i64, i64* %RDX
  %r13_1193 = load i64, i64* %R13
  %jb_1193 = icmp ult i64 %rdx_1193, %r13_1193
  br i1 %jb_1193, label %loc_13A0, label %loc_119C

loc_119C:
  %rdi_119c = load i64, i64* %RDI
  %r10_scaled = shl i64 %rdi_119c, 2
  store i64 %r10_scaled, i64* %R10
  %r12_119c = load i64, i64* %R12
  %r12_scaled = shl i64 %r12_119c, 2
  %r12_off = add i64 %r12_scaled, 8
  store i64 %r12_off, i64* %R12
  %rsi_119c = load i64, i64* %RSI
  %rbp_calc = add i64 %rsi_119c, %r10_scaled
  store i64 %rbp_calc, i64* %RBP
  %rcx_119c = load i64, i64* %RCX
  %r15_calc = add i64 %rcx_119c, %r12_off
  store i64 %r15_calc, i64* %R15
  %r14_calc = sub i64 %rbp_calc, %r15_calc
  store i64 %r14_calc, i64* %R14
  %ja_11ba = icmp ugt i64 %r14_calc, 8
  br i1 %ja_11ba, label %loc_12F0, label %loc_11C4

loc_11C4:
  %r9_11c4 = load i64, i64* %R9
  %rbx_scaled = shl i64 %r9_11c4, 2
  store i64 %rbx_scaled, i64* %RBX
  %rcx_11c4_i = load i64, i64* %RCX
  %rcx_11c4_p = inttoptr i64 %rcx_11c4_i to i32*
  %elem_11c4_p = getelementptr inbounds i32, i32* %rcx_11c4_p, i64 %r9_11c4
  %val_11c4_i32 = load i32, i32* %elem_11c4_p
  %val_11c4_i64 = zext i32 %val_11c4_i32 to i64
  store i64 %val_11c4_i64, i64* %R9
  %rsi_11c4 = load i64, i64* %RSI
  %r10_11c4 = load i64, i64* %R10
  %sum_11c4 = add i64 %rsi_11c4, %r10_11c4
  %dst_word_p = inttoptr i64 %sum_11c4 to i32*
  %r9_11c4_st = trunc i64 %val_11c4_i64 to i32
  store i32 %r9_11c4_st, i32* %dst_word_p
  %r13_11c4 = load i64, i64* %R13
  %rdx_11c4 = load i64, i64* %RDX
  %jnb_11d4 = icmp uge i64 %r13_11c4, %rdx_11c4
  br i1 %jnb_11d4, label %loc_1280, label %loc_11DD

loc_11DD:
  %rcx_11dd = load i64, i64* %RCX
  %rbx_11dd = load i64, i64* %RBX
  %addr_11dd = add i64 %rcx_11dd, %rbx_11dd
  %addr_11dd_plus4 = add i64 %addr_11dd, 4
  %addr_11dd_i32p = inttoptr i64 %addr_11dd_plus4 to i32*
  %val_11dd_i32 = load i32, i32* %addr_11dd_i32p
  %val_11dd_i64 = zext i32 %val_11dd_i32 to i64
  store i64 %val_11dd_i64, i64* %R9
  %rsi_11dd = load i64, i64* %RSI
  %r10_11dd = load i64, i64* %R10
  %sum1_11dd = add i64 %rsi_11dd, %r10_11dd
  %sum2_11dd = add i64 %sum1_11dd, 4
  %dst_11dd = inttoptr i64 %sum2_11dd to i32*
  %r9_11dd_i32 = trunc i64 %val_11dd_i64 to i32
  store i32 %r9_11dd_i32, i32* %dst_11dd
  %rax_11e7 = load i64, i64* %RAX
  %r9_11e7 = add i64 %rax_11e7, 3
  store i64 %r9_11e7, i64* %R9
  %rdx_11eb = load i64, i64* %RDX
  %jnb_11ee = icmp uge i64 %r9_11e7, %rdx_11eb
  br i1 %jnb_11ee, label %loc_1280, label %loc_11F4

loc_11F4:
  %rcx_11f4 = load i64, i64* %RCX
  %rbx_11f4 = load i64, i64* %RBX
  %addr_11f4 = add i64 %rcx_11f4, %rbx_11f4
  %addr_11f4_plus8 = add i64 %addr_11f4, 8
  %addr_11f4_i32p = inttoptr i64 %addr_11f4_plus8 to i32*
  %val_11f4_i32 = load i32, i32* %addr_11f4_i32p
  %val_11f4_i64 = zext i32 %val_11f4_i32 to i64
  store i64 %val_11f4_i64, i64* %R9
  %rsi_11f4 = load i64, i64* %RSI
  %r10_11f4 = load i64, i64* %R10
  %sum1_11f4 = add i64 %rsi_11f4, %r10_11f4
  %sum2_11f4 = add i64 %sum1_11f4, 8
  %dst_11f4 = inttoptr i64 %sum2_11f4 to i32*
  %r9_11f4_i32 = trunc i64 %val_11f4_i64 to i32
  store i32 %r9_11f4_i32, i32* %dst_11f4
  %rax_11fe = load i64, i64* %RAX
  %r9_11fe = add i64 %rax_11fe, 4
  store i64 %r9_11fe, i64* %R9
  %rdx_1202 = load i64, i64* %RDX
  %jnb_1205 = icmp uge i64 %r9_11fe, %rdx_1202
  br i1 %jnb_1205, label %loc_1280, label %loc_1207

loc_1207:
  %rcx_1207 = load i64, i64* %RCX
  %rbx_1207 = load i64, i64* %RBX
  %addr_1207 = add i64 %rcx_1207, %rbx_1207
  %addr_1207_plus12 = add i64 %addr_1207, 12
  %addr_1207_i32p = inttoptr i64 %addr_1207_plus12 to i32*
  %val_1207_i32 = load i32, i32* %addr_1207_i32p
  %val_1207_i64 = zext i32 %val_1207_i32 to i64
  store i64 %val_1207_i64, i64* %R9
  %rsi_1207 = load i64, i64* %RSI
  %r10_1207 = load i64, i64* %R10
  %sum1_1207 = add i64 %rsi_1207, %r10_1207
  %sum2_1207 = add i64 %sum1_1207, 12
  %dst_1207 = inttoptr i64 %sum2_1207 to i32*
  %r9_1207_i32 = trunc i64 %val_1207_i64 to i32
  store i32 %r9_1207_i32, i32* %dst_1207
  %rax_1211 = load i64, i64* %RAX
  %r9_1211 = add i64 %rax_1211, 5
  store i64 %r9_1211, i64* %R9
  %rdx_1215 = load i64, i64* %RDX
  %jnb_1218 = icmp uge i64 %r9_1211, %rdx_1215
  br i1 %jnb_1218, label %loc_1280, label %loc_121A

loc_121A:
  %rcx_121a = load i64, i64* %RCX
  %rbx_121a = load i64, i64* %RBX
  %addr_121a = add i64 %rcx_121a, %rbx_121a
  %addr_121a_plus16 = add i64 %addr_121a, 16
  %addr_121a_i32p = inttoptr i64 %addr_121a_plus16 to i32*
  %val_121a_i32 = load i32, i32* %addr_121a_i32p
  %val_121a_i64 = zext i32 %val_121a_i32 to i64
  store i64 %val_121a_i64, i64* %R9
  %rsi_121a = load i64, i64* %RSI
  %r10_121a = load i64, i64* %R10
  %sum1_121a = add i64 %rsi_121a, %r10_121a
  %sum2_121a = add i64 %sum1_121a, 16
  %dst_121a = inttoptr i64 %sum2_121a to i32*
  %r9_121a_i32 = trunc i64 %val_121a_i64 to i32
  store i32 %r9_121a_i32, i32* %dst_121a
  %rax_1224 = load i64, i64* %RAX
  %r9_1224 = add i64 %rax_1224, 6
  store i64 %r9_1224, i64* %R9
  %rdx_1228 = load i64, i64* %RDX
  %jnb_122b = icmp uge i64 %r9_1224, %rdx_1228
  br i1 %jnb_122b, label %loc_1280, label %loc_122D

loc_122D:
  %rcx_122d = load i64, i64* %RCX
  %rbx_122d = load i64, i64* %RBX
  %addr_122d = add i64 %rcx_122d, %rbx_122d
  %addr_122d_plus20 = add i64 %addr_122d, 20
  %addr_122d_i32p = inttoptr i64 %addr_122d_plus20 to i32*
  %val_122d_i32 = load i32, i32* %addr_122d_i32p
  %val_122d_i64 = zext i32 %val_122d_i32 to i64
  store i64 %val_122d_i64, i64* %R9
  %rsi_122d = load i64, i64* %RSI
  %r10_122d = load i64, i64* %R10
  %sum1_122d = add i64 %rsi_122d, %r10_122d
  %sum2_122d = add i64 %sum1_122d, 20
  %dst_122d = inttoptr i64 %sum2_122d to i32*
  %r9_122d_i32 = trunc i64 %val_122d_i64 to i32
  store i32 %r9_122d_i32, i32* %dst_122d
  %rax_1237 = load i64, i64* %RAX
  %r9_1237 = add i64 %rax_1237, 7
  store i64 %r9_1237, i64* %R9
  %rdx_123b = load i64, i64* %RDX
  %jnb_123e = icmp uge i64 %r9_1237, %rdx_123b
  br i1 %jnb_123e, label %loc_1280, label %loc_1240

loc_1240:
  %rcx_1240 = load i64, i64* %RCX
  %rbx_1240 = load i64, i64* %RBX
  %addr_1240 = add i64 %rcx_1240, %rbx_1240
  %addr_1240_plus24 = add i64 %addr_1240, 24
  %addr_1240_i32p = inttoptr i64 %addr_1240_plus24 to i32*
  %val_1240_i32 = load i32, i32* %addr_1240_i32p
  %val_1240_i64 = zext i32 %val_1240_i32 to i64
  store i64 %val_1240_i64, i64* %R9
  %rax_1245 = load i64, i64* %RAX
  %rax_1245n = add i64 %rax_1245, 8
  store i64 %rax_1245n, i64* %RAX
  %rsi_1249 = load i64, i64* %RSI
  %r10_1249 = load i64, i64* %R10
  %sum1_1249 = add i64 %rsi_1249, %r10_1249
  %sum2_1249 = add i64 %sum1_1249, 24
  %dst_1249 = inttoptr i64 %sum2_1249 to i32*
  %r9_1249_i32 = trunc i64 %val_1240_i64 to i32
  store i32 %r9_1249_i32, i32* %dst_1249
  %rdx_124e = load i64, i64* %RDX
  %jnb_1251 = icmp uge i64 %rax_1245n, %rdx_124e
  br i1 %jnb_1251, label %loc_1280, label %loc_1253

loc_1253:
  %rcx_1253 = load i64, i64* %RCX
  %rbx_1253 = load i64, i64* %RBX
  %addr_1253 = add i64 %rcx_1253, %rbx_1253
  %addr_1253_plus28 = add i64 %addr_1253, 28
  %addr_1253_i32p = inttoptr i64 %addr_1253_plus28 to i32*
  %val_1253_i32 = load i32, i32* %addr_1253_i32p
  %val_1253_i64 = zext i32 %val_1253_i32 to i64
  store i64 %val_1253_i64, i64* %RAX
  %rsi_1257 = load i64, i64* %RSI
  %r10_1257 = load i64, i64* %R10
  %sum1_1257 = add i64 %rsi_1257, %r10_1257
  %sum2_1257 = add i64 %sum1_1257, 28
  %dst_1257 = inttoptr i64 %sum2_1257 to i32*
  %eax_1257 = trunc i64 %val_1253_i64 to i32
  store i32 %eax_1257, i32* %dst_1257
  store i64 0, i64* %RAX
  %rdi_125e = load i64, i64* %RDI
  %cmp_1262 = icmp eq i64 %rdi_125e, 1
  %al_1265 = select i1 %cmp_1262, i64 1, i64 0
  %neg_1265 = sub i64 0, %al_1265
  %rax_1268 = add i64 %neg_1265, 10
  store i64 %rax_1268, i64* %RAX
  %rdx_126c = load i64, i64* %RDX
  %jnb_126f = icmp uge i64 %rax_1268, %rdx_126c
  br i1 %jnb_126f, label %loc_1280, label %loc_1271

loc_1271:
  %rcx_1271 = load i64, i64* %RCX
  %rbx_1271 = load i64, i64* %RBX
  %addr_1271 = add i64 %rcx_1271, %rbx_1271
  %addr_1271_plus32 = add i64 %addr_1271, 32
  %addr_1271_i32p = inttoptr i64 %addr_1271_plus32 to i32*
  %val_1271_i32 = load i32, i32* %addr_1271_i32p
  %val_1271_i64 = zext i32 %val_1271_i32 to i64
  store i64 %val_1271_i64, i64* %RAX
  %rsi_1275 = load i64, i64* %RSI
  %rsi_1275_plus36 = add i64 %rsi_1275, 36
  %dst_1275 = inttoptr i64 %rsi_1275_plus36 to i32*
  %eax_1275 = trunc i64 %val_1271_i64 to i32
  store i32 %eax_1275, i32* %dst_1275
  br label %loc_1280

loc_1280:
  %r8_1280 = load i64, i64* %R8
  %cmp_1280 = icmp ugt i64 %r8_1280, 9
  br i1 %cmp_1280, label %loc_1380, label %loc_128A

loc_128A:
  %r11_128a = load i64, i64* %R11
  %r8_128a = load i64, i64* %R8
  %rdx_128a = add i64 %r11_128a, %r8_128a
  store i64 %rdx_128a, i64* %RDX
  store i64 10, i64* %RBX
  store i64 %r8_128a, i64* %RAX
  %rbx_1296 = load i64, i64* %RBX
  %cmp_1296 = icmp ule i64 %rdx_128a, %rbx_1296
  %r8_new = add i64 %rdx_128a, %r11_128a
  store i64 %r8_new, i64* %R8
  %rax_129d = load i64, i64* %RAX
  store i64 %rax_129d, i64* %R10
  %rbx_sel = select i1 %cmp_1296, i64 %rdx_128a, i64 %rbx_1296
  store i64 %rbx_sel, i64* %RBX
  store i64 10, i64* %RDX
  %r8_12a9 = load i64, i64* %R8
  %rdx_12a9 = load i64, i64* %RDX
  %cmp_12ac = icmp ule i64 %r8_12a9, %rdx_12a9
  %rdx_sel = select i1 %cmp_12ac, i64 %r8_12a9, i64 %rdx_12a9
  store i64 %rdx_sel, i64* %RDX
  store i64 %rbx_sel, i64* %R12
  %rax_12b3 = load i64, i64* %RAX
  %rdx_12b3 = load i64, i64* %RDX
  %jnb_12b6 = icmp uge i64 %rax_12b3, %rdx_12b3
  br i1 %jnb_12b6, label %loc_1280, label %loc_12B8

loc_12B8:
  %r10_12b8 = load i64, i64* %R10
  %rbx_12b8 = load i64, i64* %RBX
  %jnb_12bb = icmp uge i64 %r10_12b8, %rbx_12b8
  br i1 %jnb_12bb, label %loc_1158, label %loc_12C1

loc_12C1:
  %rcx_12c1 = load i64, i64* %RCX
  %r10_12c1 = load i64, i64* %R10
  %rcx_12c1_p = inttoptr i64 %rcx_12c1 to i32*
  %in_12c1_p = getelementptr inbounds i32, i32* %rcx_12c1_p, i64 %r10_12c1
  %val_12c1_i32 = load i32, i32* %in_12c1_p
  %val_12c1_i64 = zext i32 %val_12c1_i32 to i64
  store i64 %val_12c1_i64, i64* %RDI
  %r12_12c5 = load i64, i64* %R12
  %rdx_12c5 = load i64, i64* %RDX
  %jnb_12c8 = icmp uge i64 %r12_12c5, %rdx_12c5
  br i1 %jnb_12c8, label %loc_12D7, label %loc_12CA

loc_12CA:
  %rcx_12ca = load i64, i64* %RCX
  %r12_12ca = load i64, i64* %R12
  %rcx_12ca_p = inttoptr i64 %rcx_12ca to i32*
  %in_12ca_p = getelementptr inbounds i32, i32* %rcx_12ca_p, i64 %r12_12ca
  %val_12ca_i32 = load i32, i32* %in_12ca_p
  %val_12ca_i64 = zext i32 %val_12ca_i32 to i64
  store i64 %val_12ca_i64, i64* %R9
  %r9_12ce_i32 = trunc i64 %val_12ca_i64 to i32
  %edi_12ce_i64 = load i64, i64* %RDI
  %edi_12ce_i32 = trunc i64 %edi_12ce_i64 to i32
  %cmp_12d1 = icmp slt i32 %r9_12ce_i32, %edi_12ce_i32
  br i1 %cmp_12d1, label %loc_115C, label %loc_12D7

loc_12D7:
  br label %loc_12D7_cont

loc_12D7_cont:
  %rax_12d7b = load i64, i64* %RAX
  %off_12d7b = shl i64 %rax_12d7b, 2
  %rsi_12d7b = load i64, i64* %RSI
  %addr_12d7b = add i64 %rsi_12d7b, %off_12d7b
  %dst_12d7b = inttoptr i64 %addr_12d7b to i32*
  %edi_12d7b_i64 = load i64, i64* %RDI
  %edi_12d7b_i32 = trunc i64 %edi_12d7b_i64 to i32
  store i32 %edi_12d7b_i32, i32* %dst_12d7b
  %rax_12da = add i64 %rax_12d7b, 1
  store i64 %rax_12da, i64* %RAX
  %rdx_12de = load i64, i64* %RDX
  %cmp_12e1 = icmp eq i64 %rdx_12de, %rax_12da
  br i1 %cmp_12e1, label %loc_1280, label %loc_12E3

loc_12E3:
  %r10_12e3 = load i64, i64* %R10
  %r10_12e7 = add i64 %r10_12e3, 1
  store i64 %r10_12e7, i64* %R10
  br label %loc_12B8

loc_12F0:
  %rcx_12f0 = load i64, i64* %RCX
  %r12_12f0 = load i64, i64* %R12
  %sum_12f0 = add i64 %rcx_12f0, %r12_12f0
  %rax_12f0 = add i64 %sum_12f0, -4
  store i64 %rax_12f0, i64* %RAX
  %rbx_12f5 = load i64, i64* %RBX
  store i64 %rbx_12f5, i64* %R10
  %rbp_1300 = load i64, i64* %RBP
  %src128 = inttoptr i64 %rax_12f0 to i8*
  %dst128 = inttoptr i64 %rbp_1300 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dst128, i8* align 1 %src128, i64 16, i1 false)
  %r10_12fc = load i64, i64* %R10
  %r10_1304 = lshr i64 %r10_12fc, 2
  store i64 %r10_1304, i64* %R10
  %jz_1308 = icmp eq i64 %r10_1304, 1
  br i1 %jz_1308, label %loc_1313, label %loc_130A

loc_130A:
  %rax_130a = load i64, i64* %RAX
  %rbp_130a = load i64, i64* %RBP
  %rax_130a_plus16 = add i64 %rax_130a, 16
  %rbp_130a_plus16 = add i64 %rbp_130a, 16
  %src2 = inttoptr i64 %rax_130a_plus16 to i8*
  %dst2 = inttoptr i64 %rbp_130a_plus16 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 1 %dst2, i8* align 1 %src2, i64 16, i1 false)
  br label %loc_1313

loc_1313:
  %rbx_1313 = load i64, i64* %RBX
  store i64 %rbx_1313, i64* %RAX
  %rax_1316 = and i64 %rbx_1313, -4
  store i64 %rax_1316, i64* %RAX
  %r9_131a = load i64, i64* %R9
  %r9_131d = add i64 %r9_131a, %rax_1316
  store i64 %r9_131d, i64* %R9
  %rdi_131d = load i64, i64* %RDI
  %rax_1320 = add i64 %rax_1316, %rdi_131d
  store i64 %rax_1320, i64* %RAX
  %rbx_1320 = load i64, i64* %RBX
  %ebx_mask = and i64 %rbx_1320, 3
  store i64 %ebx_mask, i64* %RBX
  %jz_1323 = icmp eq i64 %ebx_mask, 0
  br i1 %jz_1323, label %loc_1280, label %loc_1329

loc_1329:
  %r9_1329 = load i64, i64* %R9
  %r10_1329 = shl i64 %r9_1329, 2
  store i64 %r10_1329, i64* %R10
  %rcx_1329 = load i64, i64* %RCX
  %rcx_1329_p = inttoptr i64 %rcx_1329 to i32*
  %in_1331_p = getelementptr inbounds i32, i32* %rcx_1329_p, i64 %r9_1329
  %val_1331_i32 = load i32, i32* %in_1331_p
  %val_1331_i64 = zext i32 %val_1331_i32 to i64
  store i64 %val_1331_i64, i64* %R9
  %rax_1335 = load i64, i64* %RAX
  %rdi_1335 = shl i64 %rax_1335, 2
  store i64 %rdi_1335, i64* %RDI
  %rsi_133d = load i64, i64* %RSI
  %addr_133d = add i64 %rsi_133d, %rdi_1335
  %dst_133d = inttoptr i64 %addr_133d to i32*
  %r9_133d_i64 = load i64, i64* %R9
  %r9_133d_i32 = trunc i64 %r9_133d_i64 to i32
  store i32 %r9_133d_i32, i32* %dst_133d
  %rax_1341 = load i64, i64* %RAX
  %r9_1341 = add i64 %rax_1341, 1
  store i64 %r9_1341, i64* %R9
  %rdx_1345 = load i64, i64* %RDX
  %jnb_1348 = icmp uge i64 %r9_1341, %rdx_1345
  br i1 %jnb_1348, label %loc_1280, label %loc_134E

loc_134E:
  %rcx_134e = load i64, i64* %RCX
  %r10_134e = load i64, i64* %R10
  %addr_134e = add i64 %rcx_134e, %r10_134e
  %addr_134e_plus4 = add i64 %addr_134e, 4
  %addr_134e_i32p = inttoptr i64 %addr_134e_plus4 to i32*
  %val_134e_i32 = load i32, i32* %addr_134e_i32p
  %val_134e_i64 = zext i32 %val_134e_i32 to i64
  store i64 %val_134e_i64, i64* %R9
  %rax_1353 = load i64, i64* %RAX
  %rax_1353n = add i64 %rax_1353, 2
  store i64 %rax_1353n, i64* %RAX
  %rsi_1357 = load i64, i64* %RSI
  %rdi_1357 = load i64, i64* %RDI
  %sum1_1357 = add i64 %rsi_1357, %rdi_1357
  %sum2_1357 = add i64 %sum1_1357, 4
  %dst_1357 = inttoptr i64 %sum2_1357 to i32*
  %r9_1357_i32 = trunc i64 %val_134e_i64 to i32
  store i32 %r9_1357_i32, i32* %dst_1357
  %rdx_135c = load i64, i64* %RDX
  %jnb_135f = icmp uge i64 %rax_1353n, %rdx_135c
  br i1 %jnb_135f, label %loc_1280, label %loc_1365

loc_1365:
  %rcx_1365 = load i64, i64* %RCX
  %r10_1365 = load i64, i64* %R10
  %addr_1365 = add i64 %rcx_1365, %r10_1365
  %addr_1365_plus8 = add i64 %addr_1365, 8
  %addr_1365_i32p = inttoptr i64 %addr_1365_plus8 to i32*
  %val_1365_i32 = load i32, i32* %addr_1365_i32p
  %val_1365_i64 = zext i32 %val_1365_i32 to i64
  store i64 %val_1365_i64, i64* %RAX
  %rsi_136a = load i64, i64* %RSI
  %rdi_136a = load i64, i64* %RDI
  %sum1_136a = add i64 %rsi_136a, %rdi_136a
  %sum2_136a = add i64 %sum1_136a, 8
  %dst_136a = inttoptr i64 %sum2_136a to i32*
  %eax_136a = trunc i64 %val_1365_i64 to i32
  store i32 %eax_136a, i32* %dst_136a
  %r8_136e = load i64, i64* %R8
  %jbe_1372 = icmp ule i64 %r8_136e, 9
  br i1 %jbe_1372, label %loc_128A, label %loc_1380

loc_1380:
  %v7c_1380 = load i32, i32* %var_7C
  %v7c_1380n = add i32 %v7c_1380, -1
  store i32 %v7c_1380n, i32* %var_7C
  %v88_1380 = load i64, i64* %var_88
  store i64 %v88_1380, i64* %RDI
  %jz_1389 = icmp eq i32 %v7c_1380n, 0
  br i1 %jz_1389, label %loc_13AD, label %loc_138B

loc_138B:
  %rcx_138b = load i64, i64* %RCX
  %rsi_138b = load i64, i64* %RSI
  store i64 %rcx_138b, i64* %RDX
  store i64 %rsi_138b, i64* %RCX
  %rdx_138e = load i64, i64* %RDX
  store i64 %rdx_138e, i64* %RSI
  br label %loc_1140

loc_1140:
  %rdi_1140 = load i64, i64* %RDI
  store i64 %rdi_1140, i64* %R11
  %rdi_1143 = add i64 %rdi_1140, %rdi_1140
  store i64 %rdi_1143, i64* %RDI
  store i64 0, i64* %R8
  store i64 %rdi_1143, i64* %var_88
  br label %loc_128A

loc_13A0:
  %rdi_13a0 = load i64, i64* %RDI
  %r10_13a0 = shl i64 %rdi_13a0, 2
  store i64 %r10_13a0, i64* %R10
  br label %loc_11C4

loc_115C:
  br label %loc_115C_cont

loc_115C_cont:
  %rsi_115c1 = load i64, i64* %RSI
  %rax_115c1 = load i64, i64* %RAX
  %off_115c1 = shl i64 %rax_115c1, 2
  %addr_115c1 = add i64 %rsi_115c1, %off_115c1
  %dst_115c1 = inttoptr i64 %addr_115c1 to i32*
  %r9_115c_i64 = load i64, i64* %R9
  %r9_115c_i32 = trunc i64 %r9_115c_i64 to i32
  store i32 %r9_115c_i32, i32* %dst_115c1
  %rax_115c2 = add i64 %rax_115c1, 1
  store i64 %rax_115c2, i64* %RAX
  %rdx_115c2 = load i64, i64* %RDX
  %jz_115c2 = icmp eq i64 %rdx_115c2, %rax_115c2
  br i1 %jz_115c2, label %loc_1280, label %loc_12E3

loc_13AD:
  %v70 = load i64, i64* %var_70
  store i64 %v70, i64* %RBX
  %p_13b2 = load i8*, i8** %ptr
  %p_13b2_i = ptrtoint i8* %p_13b2 to i64
  store i64 %p_13b2_i, i64* %RAX
  %rsi_13b7 = load i64, i64* %RSI
  %rbx_13b7 = load i64, i64* %RBX
  %jz_13ba = icmp eq i64 %rsi_13b7, %rbx_13b7
  br i1 %jz_13ba, label %loc_13C6, label %loc_13BC

loc_13BC:
  %rsi_13bc = inttoptr i64 %rsi_13b7 to i8*
  %rbx_13bc = inttoptr i64 %rbx_13b7 to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 4 %rbx_13bc, i8* align 4 %rsi_13bc, i64 40, i1 false)
  br label %loc_13C6

loc_13C6:
  %rax_13c6 = load i64, i64* %RAX
  %p_13c6 = inttoptr i64 %rax_13c6 to i8*
  call void @free(i8* %p_13c6)
  br label %loc_13CE

loc_13CE:
  %r12_ptr = ptrtoint i64* %canary to i64
  store i64 %r12_ptr, i64* %R12
  %fmt_p = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %fmt_p_i = ptrtoint i8* %fmt_p to i64
  store i64 %fmt_p_i, i64* %RBP
  br label %loc_13E0

loc_13E0:
  %rbx_13e0 = load i64, i64* %RBX
  %rbx_13e0_i32p = inttoptr i64 %rbx_13e0 to i32*
  %val_13e0_i32 = load i32, i32* %rbx_13e0_i32p
  %rbp_13e0 = load i64, i64* %RBP
  %rbp_13e0_p = inttoptr i64 %rbp_13e0 to i8*
  %val_13e0_i32_se = sext i32 %val_13e0_i32 to i64
  %rbx_13ec = add i64 %rbx_13e0, 4
  store i64 %rbx_13ec, i64* %RBX
  %call_13f0 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %rbp_13e0_p, i32 %val_13e0_i32)
  %r12_13f5 = load i64, i64* %R12
  %rbx_13f5 = load i64, i64* %RBX
  %jnz_13f8 = icmp ne i64 %r12_13f5, %rbx_13f5
  br i1 %jnz_13f8, label %loc_13E0, label %loc_13FA

loc_13FA:
  %nl_p = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call_1408 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl_p)
  %saved_can = load i64, i64* %canary
  %cur_can = load i64, i64* @__stack_chk_guard
  %ok_can = icmp eq i64 %saved_can, %cur_can
  br i1 %ok_can, label %loc_141D, label %loc_1435

loc_141D:
  ret i32 0

loc_142E:
  %bufptr_i8_142e = bitcast [40 x i8]* %var_buf to i8*
  %bufptr_142e = ptrtoint i8* %bufptr_i8_142e to i64
  store i64 %bufptr_142e, i64* %RBX
  br label %loc_13CE

loc_1435:
  call void @__stack_chk_fail()
  unreachable

loc_143A:
  %r9_143a = load i64, i64* %R9
  store i64 %r9_143a, i64* %R12
  %rdi_143a = load i64, i64* %RDI
  store i64 %rdi_143a, i64* %RAX
  br label %loc_12B8
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)