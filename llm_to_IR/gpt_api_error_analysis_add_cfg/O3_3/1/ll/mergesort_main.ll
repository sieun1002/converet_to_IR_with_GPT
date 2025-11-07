; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant [16 x i8], align 16
@xmmword_2020 = external constant [16 x i8], align 16
@unk_2004 = external constant [0 x i8], align 1
@unk_2008 = external constant [0 x i8], align 1
@__stack_chk_guard = external thread_local global i64, align 8

declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
L10c0:
  %rax = alloca i64, align 8
  %rbx = alloca i64, align 8
  %rcx = alloca i64, align 8
  %rdx = alloca i64, align 8
  %rsi = alloca i64, align 8
  %rdi = alloca i64, align 8
  %r8 = alloca i64, align 8
  %r9 = alloca i64, align 8
  %r10 = alloca i64, align 8
  %r11 = alloca i64, align 8
  %r12 = alloca i64, align 8
  %r13 = alloca i64, align 8
  %r14 = alloca i64, align 8
  %r15 = alloca i64, align 8
  %rbp = alloca i64, align 8

  %canary_save = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %var70 = alloca i8*, align 8
  %var7C = alloca i32, align 4
  %var88 = alloca i64, align 8
  %var48 = alloca i32, align 4

  %buf = alloca [40 x i8], align 16

  store i64 0, i64* %rax, align 8
  store i64 0, i64* %rbx, align 8
  store i64 0, i64* %rcx, align 8
  store i64 0, i64* %rdx, align 8
  store i64 0, i64* %rsi, align 8
  store i64 0, i64* %rdi, align 8
  store i64 0, i64* %r8, align 8
  store i64 0, i64* %r9, align 8
  store i64 0, i64* %r10, align 8
  store i64 0, i64* %r11, align 8
  store i64 0, i64* %r12, align 8
  store i64 0, i64* %r13, align 8
  store i64 0, i64* %r14, align 8
  store i64 0, i64* %r15, align 8
  store i64 0, i64* %rbp, align 8

  %guard = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard, i64* %canary_save, align 8

  store i32 4, i32* %var48, align 4
  store i32 4, i32* %var7C, align 4

  %buf0 = getelementptr inbounds [40 x i8], [40 x i8]* %buf, i64 0, i64 0
  %src2010 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2010, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %buf0, i8* align 16 %src2010, i64 16, i1 false)

  %buf16 = getelementptr inbounds [40 x i8], [40 x i8]* %buf, i64 0, i64 16
  %src2020 = getelementptr inbounds [16 x i8], [16 x i8]* @xmmword_2020, i64 0, i64 0
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* align 16 %buf16, i8* align 16 %src2020, i64 16, i1 false)

  %m = call noalias i8* @malloc(i64 40)
  store i8* %m, i8** %ptr, align 8
  %m_i = ptrtoint i8* %m to i64
  store i64 %m_i, i64* %rax, align 8
  %tst_rax = icmp eq i64 %m_i, 0
  br i1 %tst_rax, label %L142E, label %L1118

L1118:
  %bufptr = bitcast [40 x i8]* %buf to i8*
  %bufptr_i = ptrtoint i8* %bufptr to i64
  store i64 %bufptr_i, i64* %rbx, align 8
  store i8* %bufptr, i8** %var70, align 8

  %m2 = load i8*, i8** %ptr, align 8
  %m2_i = ptrtoint i8* %m2 to i64
  store i64 %m2_i, i64* %rsi, align 8

  store i64 1, i64* %rdi, align 8
  store i64 4, i64* %r10, align 8
  store i64 %bufptr_i, i64* %rcx, align 8
  store i32 4, i32* %var7C, align 4
  br label %L1140

L1140:
  %rdi_v = load i64, i64* %rdi, align 8
  store i64 %rdi_v, i64* %r11, align 8
  %rdi2 = add i64 %rdi_v, %rdi_v
  store i64 %rdi2, i64* %rdi, align 8
  store i64 0, i64* %r8, align 8
  store i64 %rdi2, i64* %var88, align 8
  br label %L128A

L1158:
  %rax_v_1158 = load i64, i64* %rax, align 8
  %rdi_next = add i64 %rax_v_1158, 1
  store i64 %rdi_next, i64* %rdi, align 8
  %rdx_v_1158 = load i64, i64* %rdx, align 8
  %cmp_1164 = icmp eq i64 %rdx_v_1158, %rdi_next
  br i1 %cmp_1164, label %L1280, label %L116D_fall

L116D_fall:
  %r10_v_1172 = load i64, i64* %r10, align 8
  %rbx_v_1172 = load i64, i64* %rbx, align 8
  %jb_1175 = icmp ult i64 %r10_v_1172, %rbx_v_1172
  br i1 %jb_1175, label %L143A, label %L117B_fall

L117B_fall:
  store i64 %rdx_v_1158, i64* %rbx, align 8
  %r13_new = add i64 %rax_v_1158, 2
  store i64 %r13_new, i64* %r13, align 8
  %rbx_sub = sub i64 %rdx_v_1158, %rdi_next
  store i64 %rbx_sub, i64* %rbx, align 8
  %r10_new = sub i64 %rbx_sub, 1
  store i64 %r10_new, i64* %r10, align 8
  %jbe_1189 = icmp ule i64 %r10_new, 2
  br i1 %jbe_1189, label %L13A0, label %L1193_fall

L1193_fall:
  %rdx_v_1193 = load i64, i64* %rdx, align 8
  %r13_v_1193 = load i64, i64* %r13, align 8
  %jb_1196 = icmp ult i64 %rdx_v_1193, %r13_v_1193
  br i1 %jb_1196, label %L13A0, label %L119C_fall

L119C_fall:
  %rdi_v119c = load i64, i64* %rdi, align 8
  %r10_scaled = shl i64 %rdi_v119c, 2
  store i64 %r10_scaled, i64* %r10, align 8
  %r12_v = load i64, i64* %r12, align 8
  %r12_shl_119c = shl i64 %r12_v, 2
  %r12_scaled = add i64 8, %r12_shl_119c
  store i64 %r12_scaled, i64* %r12, align 8
  %rsi_v = load i64, i64* %rsi, align 8
  %rbp_new = add i64 %rsi_v, %r10_scaled
  store i64 %rbp_new, i64* %rbp, align 8
  %rcx_v = load i64, i64* %rcx, align 8
  %r15_new = add i64 %rcx_v, %r12_scaled
  store i64 %r15_new, i64* %r15, align 8
  %r14_new = sub i64 %rbp_new, %r15_new
  store i64 %r14_new, i64* %r14, align 8
  %ja_11be = icmp ugt i64 %r14_new, 8
  br i1 %ja_11be, label %L12F0, label %L11C4

L11C4:
  br label %L1280

L115C:
  br label %L1280

L1280:
  %r8_v_1280 = load i64, i64* %r8, align 8
  %ja_1284 = icmp ugt i64 %r8_v_1280, 9
  br i1 %ja_1284, label %L1380, label %L128A

L128A:
  %r11_v_128a = load i64, i64* %r11, align 8
  %r8_v_128a = load i64, i64* %r8, align 8
  %rdx_new = add i64 %r11_v_128a, %r8_v_128a
  store i64 %rdx_new, i64* %rdx, align 8
  store i64 %r8_v_128a, i64* %rax, align 8
  %r8_next = add i64 %rdx_new, %r11_v_128a
  store i64 %r8_next, i64* %r8, align 8
  store i64 %r8_v_128a, i64* %r10, align 8
  %cmp_rdx10 = icmp ule i64 %rdx_new, 10
  %rbx_sel = select i1 %cmp_rdx10, i64 %rdx_new, i64 10
  store i64 %rbx_sel, i64* %rbx, align 8
  %cmp_r810 = icmp ule i64 %r8_next, 10
  %rdx_sel = select i1 %cmp_r810, i64 %r8_next, i64 10
  store i64 %rdx_sel, i64* %rdx, align 8
  store i64 %rbx_sel, i64* %r12, align 8
  %rax_v_12b3 = load i64, i64* %rax, align 8
  %rdx_v_12b3 = load i64, i64* %rdx, align 8
  %jnb_12b6 = icmp uge i64 %rax_v_12b3, %rdx_v_12b3
  br i1 %jnb_12b6, label %L1280, label %L12B8

L12B8:
  %r10_v_12b8 = load i64, i64* %r10, align 8
  %rbx_v_12b8 = load i64, i64* %rbx, align 8
  %jnb_12bb = icmp uge i64 %r10_v_12b8, %rbx_v_12b8
  br i1 %jnb_12bb, label %L1158, label %L12C1

L12C1:
  %r12_v_12c5 = load i64, i64* %r12, align 8
  %rdx_v_12c5 = load i64, i64* %rdx, align 8
  %jnb_12c8 = icmp uge i64 %r12_v_12c5, %rdx_v_12c5
  br i1 %jnb_12c8, label %L12D7, label %L12CA

L12CA:
  br label %L12CE

L12CE:
  %cmp_dummy_12d1 = icmp slt i32 0, 1
  br i1 %cmp_dummy_12d1, label %L115C, label %L12D7

L12D7:
  %rax_v_12da = load i64, i64* %rax, align 8
  %rax_inc = add i64 %rax_v_12da, 1
  store i64 %rax_inc, i64* %rax, align 8
  %rdx_v_12de = load i64, i64* %rdx, align 8
  %jz_12e1 = icmp eq i64 %rdx_v_12de, %rax_inc
  br i1 %jz_12e1, label %L1280, label %L12E3

L12E3:
  %r10_v_12e3 = load i64, i64* %r10, align 8
  %r10_inc = add i64 %r10_v_12e3, 1
  store i64 %r10_inc, i64* %r10, align 8
  br label %L12B8

L12F0:
  br label %L1313

L1313:
  %r8_v_136e = load i64, i64* %r8, align 8
  %jbe_1372 = icmp ule i64 %r8_v_136e, 9
  br i1 %jbe_1372, label %L128A, label %L128A

L1380:
  %c1380 = load i32, i32* %var7C, align 4
  %c1380_dec = sub i32 %c1380, 1
  store i32 %c1380_dec, i32* %var7C, align 4
  %v88 = load i64, i64* %var88, align 8
  store i64 %v88, i64* %rdi, align 8
  %is_zero_1389 = icmp eq i32 %c1380_dec, 0
  br i1 %is_zero_1389, label %L13AD, label %L138B

L138B:
  %rdx_tmp = load i64, i64* %rcx, align 8
  %rsi_tmp = load i64, i64* %rsi, align 8
  store i64 %rsi_tmp, i64* %rcx, align 8
  store i64 %rdx_tmp, i64* %rsi, align 8
  br label %L1140

L13A0:
  %rdi_v_13a0 = load i64, i64* %rdi, align 8
  %r10_scaled_13a0 = shl i64 %rdi_v_13a0, 2
  store i64 %r10_scaled_13a0, i64* %r10, align 8
  br label %L11C4

L13AD:
  %vb = load i8*, i8** %var70, align 8
  %m3 = load i8*, i8** %ptr, align 8
  %rsi_v_13b7 = load i64, i64* %rsi, align 8
  %rbx_i = ptrtoint i8* %vb to i64
  store i64 %rbx_i, i64* %rbx, align 8
  %m3_i = ptrtoint i8* %m3 to i64
  store i64 %m3_i, i64* %rax, align 8
  %jz_13ba = icmp eq i64 %rsi_v_13b7, %rbx_i
  br i1 %jz_13ba, label %L13C6, label %L13BC

L13BC:
  %rsi_p = inttoptr i64 %rsi_v_13b7 to i8*
  %rbx_p = inttoptr i64 %rbx_i to i8*
  call void @llvm.memcpy.p0i8.p0i8.i64(i8* %rbx_p, i8* %rsi_p, i64 40, i1 false)
  br label %L13C6

L13C6:
  %tofree = inttoptr i64 %m3_i to i8*
  call void @free(i8* %tofree)
  br label %L13CE

L13CE:
  %cans_ptr = bitcast i64* %canary_save to i8*
  %cans_i = ptrtoint i8* %cans_ptr to i64
  store i64 %cans_i, i64* %r12, align 8
  %fmt1 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2004, i64 0, i64 0
  %fmt1_i = ptrtoint i8* %fmt1 to i64
  store i64 %fmt1_i, i64* %rbp, align 8
  br label %L13E0

L13E0:
  %rbx_cur = load i64, i64* %rbx, align 8
  %rbx_cur_p = inttoptr i64 %rbx_cur to i32*
  %val = load i32, i32* %rbx_cur_p, align 4
  %rbp_fmt = load i64, i64* %rbp, align 8
  %fmt_ptr = inttoptr i64 %rbp_fmt to i8*
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i32 %val)
  %rbx_next = add i64 %rbx_cur, 4
  store i64 %rbx_next, i64* %rbx, align 8
  %r12_end = load i64, i64* %r12, align 8
  %jnz_13f8 = icmp ne i64 %r12_end, %rbx_next
  br i1 %jnz_13f8, label %L13E0, label %L13FA

L13FA:
  %fmt2 = getelementptr inbounds [0 x i8], [0 x i8]* @unk_2008, i64 0, i64 0
  %_ = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2)
  %saved = load i64, i64* %canary_save, align 8
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %canary_ok = icmp eq i64 %saved, %guard2
  br i1 %canary_ok, label %L141D, label %L1435

L141D:
  ret i32 0

L142E:
  %bufptr2 = bitcast [40 x i8]* %buf to i8*
  %bufptr2_i = ptrtoint i8* %bufptr2 to i64
  store i64 %bufptr2_i, i64* %rbx, align 8
  br label %L13CE

L1435:
  call void @__stack_chk_fail()
  unreachable

L143A:
  %r9_v_143a = load i64, i64* %r9, align 8
  store i64 %r9_v_143a, i64* %r12, align 8
  %rdi_v_143a = load i64, i64* %rdi, align 8
  store i64 %rdi_v_143a, i64* %rax, align 8
  br label %L12B8
}

declare void @llvm.memcpy.p0i8.p0i8.i64(i8* noalias nocapture writeonly, i8* noalias nocapture readonly, i64, i1)