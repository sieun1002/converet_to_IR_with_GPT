; ModuleID = 'recovered_main'
source_filename = "recovered_main"
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external constant [16 x i8], align 16
@xmmword_2020 = external constant [16 x i8], align 16
@unk_2004 = external global i8
@unk_2008 = external global i8

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
bb_10c0:
  %stack_guard.slot = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %var_70 = alloca i64, align 8
  %var_7C = alloca i32, align 4
  %var_88 = alloca i64, align 8
  %arr = alloca [10 x i32], align 16
  %r_rax = alloca i64, align 8
  %r_rbx = alloca i64, align 8
  %r_rcx = alloca i64, align 8
  %r_rdx = alloca i64, align 8
  %r_rsi = alloca i64, align 8
  %r_rdi = alloca i64, align 8
  %r_r8 = alloca i64, align 8
  %r_r9 = alloca i64, align 8
  %r_r10 = alloca i64, align 8
  %r_r11 = alloca i64, align 8
  %r_r12 = alloca i64, align 8
  %r_r13 = alloca i64, align 8
  %r_r14 = alloca i64, align 8
  %r_r15 = alloca i64, align 8
  %r_rbp = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %stack_guard.slot, align 8
  store i64 40, i64* %r_rdi, align 8
  %arr.i8 = bitcast [10 x i32]* %arr to i8*
  %arr.vec = bitcast i8* %arr.i8 to <16 x i8>*
  %x0.ptr = bitcast [16 x i8]* @xmmword_2010 to <16 x i8>*
  %x0 = load <16 x i8>, <16 x i8>* %x0.ptr, align 16
  store <16 x i8> %x0, <16 x i8>* %arr.vec, align 16
  %arr.i8.plus16 = getelementptr inbounds i8, i8* %arr.i8, i64 16
  %arr.vec.1 = bitcast i8* %arr.i8.plus16 to <16 x i8>*
  %x1.ptr = bitcast [16 x i8]* @xmmword_2020 to <16 x i8>*
  %x1 = load <16 x i8>, <16 x i8>* %x1.ptr, align 16
  store <16 x i8> %x1, <16 x i8>* %arr.vec.1, align 16
  %arr.i32 = bitcast i8* %arr.i8 to i32*
  %arr.slot8 = getelementptr inbounds i32, i32* %arr.i32, i64 8
  store i32 4, i32* %arr.slot8, align 4
  %call.m = call i8* @malloc(i64 40)
  %rax0 = ptrtoint i8* %call.m to i64
  store i64 %rax0, i64* %r_rax, align 8
  %tst0 = icmp eq i8* %call.m, null
  br i1 %tst0, label %bb_142e, label %bb_1118

bb_1118:
  %rbx.arr.i64 = ptrtoint i8* %arr.i8 to i64
  store i64 %rbx.arr.i64, i64* %r_rbx, align 8
  store i8* %call.m, i8** %ptr, align 8
  %rsi1 = ptrtoint i8* %call.m to i64
  store i64 %rsi1, i64* %r_rsi, align 8
  store i64 1, i64* %r_rdi, align 8
  store i32 4, i32* %var_7C, align 4
  store i64 %rbx.arr.i64, i64* %var_70, align 8
  store i64 %rbx.arr.i64, i64* %r_rcx, align 8
  br label %bb_1140

bb_1140:
  %rdi2 = load i64, i64* %r_rdi, align 8
  store i64 %rdi2, i64* %r_r11, align 8
  %rdi2x2 = add i64 %rdi2, %rdi2
  store i64 %rdi2x2, i64* %r_rdi, align 8
  store i64 0, i64* %r_r8, align 8
  store i64 %rdi2x2, i64* %var_88, align 8
  br label %bb_128a

bb_1158:
  %rcx_b1158 = load i64, i64* %r_rcx, align 8
  %r12_b1158 = load i64, i64* %r_r12, align 8
  %src.ptr1158 = inttoptr i64 %rcx_b1158 to i8*
  %src.i32.base1158 = bitcast i8* %src.ptr1158 to i32*
  %idx1158 = getelementptr inbounds i32, i32* %src.i32.base1158, i64 %r12_b1158
  %val_r9d_1158 = load i32, i32* %idx1158, align 4
  %rax_b1158 = load i64, i64* %r_rax, align 8
  %rsi_b1158 = load i64, i64* %r_rsi, align 8
  %dst.ptr1158 = inttoptr i64 %rsi_b1158 to i8*
  %dst.i32.base1158 = bitcast i8* %dst.ptr1158 to i32*
  %dst.idx1158 = getelementptr inbounds i32, i32* %dst.i32.base1158, i64 %rax_b1158
  store i32 %val_r9d_1158, i32* %dst.idx1158, align 4
  %rdi_next = add i64 %rax_b1158, 1
  %rdx_b1158 = load i64, i64* %r_rdx, align 8
  %cmp_1164 = icmp eq i64 %rdx_b1158, %rdi_next
  br i1 %cmp_1164, label %bb_1280, label %bb_116d

bb_115c:
  %rax_b115c = load i64, i64* %r_rax, align 8
  %rdi_new = add i64 %rax_b115c, 1
  %rcx_b115c = load i64, i64* %r_rcx, align 8
  %r12_b115c = load i64, i64* %r_r12, align 8
  %src.ptr115c = inttoptr i64 %rcx_b115c to i8*
  %src.i32.base115c = bitcast i8* %src.ptr115c to i32*
  %src.idx115c = getelementptr inbounds i32, i32* %src.i32.base115c, i64 %r12_b115c
  %val_r9d_115c = load i32, i32* %src.idx115c, align 4
  %rsi_b115c = load i64, i64* %r_rsi, align 8
  %dst.ptr115c = inttoptr i64 %rsi_b115c to i8*
  %dst.i32.base115c = bitcast i8* %dst.ptr115c to i32*
  %dst.idx115c = getelementptr inbounds i32, i32* %dst.i32.base115c, i64 %rax_b115c
  store i32 %val_r9d_115c, i32* %dst.idx115c, align 4
  %rdx_b115c = load i64, i64* %r_rdx, align 8
  %cmp_1164b = icmp eq i64 %rdx_b115c, %rdi_new
  br i1 %cmp_1164b, label %bb_1280, label %bb_116d_phi

bb_116d:
  %r12_b116d = load i64, i64* %r_r12, align 8
  %r9_next = add i64 %r12_b116d, 1
  store i64 %r9_next, i64* %r_r9, align 8
  %r10_b116d = load i64, i64* %r_r10, align 8
  %rbx_b116d = load i64, i64* %r_rbx, align 8
  %cmp_1172 = icmp ult i64 %r10_b116d, %rbx_b116d
  br i1 %cmp_1172, label %bb_143a, label %bb_117b

bb_116d_phi:
  %r12_b116d_phi = load i64, i64* %r_r12, align 8
  %r9_next_phi = add i64 %r12_b116d_phi, 1
  store i64 %r9_next_phi, i64* %r_r9, align 8
  %r10_b116d_phi = load i64, i64* %r_r10, align 8
  %rbx_b116d_phi = load i64, i64* %r_rbx, align 8
  %cmp_1172_phi = icmp ult i64 %r10_b116d_phi, %rbx_b116d_phi
  br i1 %cmp_1172_phi, label %bb_143a, label %bb_117b

bb_117b:
  %rdx_b117b = load i64, i64* %r_rdx, align 8
  store i64 %rdx_b117b, i64* %r_rbx, align 8
  %rax_b117b = load i64, i64* %r_rax, align 8
  %r13_new = add i64 %rax_b117b, 2
  store i64 %r13_new, i64* %r_r13, align 8
  %rbx_b117b = load i64, i64* %r_rbx, align 8
  %rdi_from = load i64, i64* %r_rdi, align 8
  %rem_b = sub i64 %rbx_b117b, %rdi_from
  %r10_tmp = add i64 %rem_b, -1
  %cmp_1189 = icmp ule i64 %r10_tmp, 2
  br i1 %cmp_1189, label %bb_13a0, label %bb_1193

bb_1193:
  %rdx_b1193 = load i64, i64* %r_rdx, align 8
  %r13_b1193 = load i64, i64* %r_r13, align 8
  %cmp_1196 = icmp ult i64 %rdx_b1193, %r13_b1193
  br i1 %cmp_1196, label %bb_13a0, label %bb_119c

bb_119c:
  %rdi_b119c = load i64, i64* %r_rdi, align 8
  %r10_off = shl i64 %rdi_b119c, 2
  store i64 %r10_off, i64* %r_r10, align 8
  %r12_b119c = load i64, i64* %r_r12, align 8
  %r12_shl = shl i64 %r12_b119c, 2
  %r12_off = add i64 %r12_shl, 8
  store i64 %r12_off, i64* %r_r12, align 8
  %rsi_b119c = load i64, i64* %r_rsi, align 8
  %rbp_ptr = add i64 %rsi_b119c, %r10_off
  store i64 %rbp_ptr, i64* %r_rbp, align 8
  %rcx_b119c = load i64, i64* %r_rcx, align 8
  %r15_ptr = add i64 %rcx_b119c, %r12_off
  store i64 %r15_ptr, i64* %r_r15, align 8
  %r14_diff = sub i64 %rbp_ptr, %r15_ptr
  store i64 %r14_diff, i64* %r_r14, align 8
  %cmp_11ba = icmp ugt i64 %r14_diff, 8
  br i1 %cmp_11ba, label %bb_12f0, label %bb_11c4

bb_11c4:
  %rcx_b11c4 = load i64, i64* %r_rcx, align 8
  %r9_loaded_11c4 = load i64, i64* %r_r9, align 8
  %r9_scaled = shl i64 %r9_loaded_11c4, 2
  %r9_off_ptr = add i64 %rcx_b11c4, %r9_scaled
  %r9p = inttoptr i64 %r9_off_ptr to i32*
  %val_r9d_11cc = load i32, i32* %r9p, align 4
  %r10_b11c4 = load i64, i64* %r_r10, align 8
  %rsi_b11c4 = load i64, i64* %r_rsi, align 8
  %dst.base11c4 = inttoptr i64 %rsi_b11c4 to i8*
  %dst.i3211c4 = bitcast i8* %dst.base11c4 to i32*
  %ashr_11c4 = ashr i64 %r10_b11c4, 2
  %dst.elem11d0 = getelementptr inbounds i32, i32* %dst.i3211c4, i64 %ashr_11c4
  store i32 %val_r9d_11cc, i32* %dst.elem11d0, align 4
  %r13_b11c4 = load i64, i64* %r_r13, align 8
  %rdx_b11c4 = load i64, i64* %r_rdx, align 8
  %cmp_11d4 = icmp uge i64 %r13_b11c4, %rdx_b11c4
  br i1 %cmp_11d4, label %bb_1280, label %bb_11dd

bb_11dd:
  %rcx_b11dd = load i64, i64* %r_rcx, align 8
  %src.ptr11dd = inttoptr i64 %rcx_b11dd to i8*
  %r9_load_11dd = load i64, i64* %r_r9, align 8
  %r9_scaled_11dd = shl i64 %r9_load_11dd, 2
  %off_11dd = add i64 %r9_scaled_11dd, 4
  %addr_11dd = getelementptr inbounds i8, i8* %src.ptr11dd, i64 %off_11dd
  %addr_11dd_i32p = bitcast i8* %addr_11dd to i32*
  %val_r9d_11dd = load i32, i32* %addr_11dd_i32p, align 4
  %r10_b11dd = load i64, i64* %r_r10, align 8
  %rsi_b11dd = load i64, i64* %r_rsi, align 8
  %dst.ptr11dd = inttoptr i64 %rsi_b11dd to i8*
  %dst.off11dd = add i64 %r10_b11dd, 4
  %dst.addr11dd = getelementptr inbounds i8, i8* %dst.ptr11dd, i64 %dst.off11dd
  %dst.addr11dd_i32p = bitcast i8* %dst.addr11dd to i32*
  store i32 %val_r9d_11dd, i32* %dst.addr11dd_i32p, align 4
  %rax_b11dd = load i64, i64* %r_rax, align 8
  %r9_new_11dd = add i64 %rax_b11dd, 3
  %rdx_b11dd = load i64, i64* %r_rdx, align 8
  %cmp_11eb = icmp uge i64 %r9_new_11dd, %rdx_b11dd
  br i1 %cmp_11eb, label %bb_1280, label %bb_11f4

bb_11f4:
  %rcx_b11f4 = load i64, i64* %r_rcx, align 8
  %r9_b11f4 = load i64, i64* %r_r9, align 8
  %r9_scaled_11f4 = shl i64 %r9_b11f4, 2
  %src.ptr11f4 = inttoptr i64 %rcx_b11f4 to i8*
  %off_11f4 = add i64 %r9_scaled_11f4, 8
  %addr_11f4 = getelementptr inbounds i8, i8* %src.ptr11f4, i64 %off_11f4
  %addr_11f4_i32p = bitcast i8* %addr_11f4 to i32*
  %val_r9d_11f4 = load i32, i32* %addr_11f4_i32p, align 4
  %r10_b11f4 = load i64, i64* %r_r10, align 8
  %rsi_b11f4 = load i64, i64* %r_rsi, align 8
  %dst.ptr11f4 = inttoptr i64 %rsi_b11f4 to i8*
  %dst.off_11f4 = add i64 %r10_b11f4, 8
  %dst.addr_11f4 = getelementptr inbounds i8, i8* %dst.ptr11f4, i64 %dst.off_11f4
  %dst.addr_11f4_i32p = bitcast i8* %dst.addr_11f4 to i32*
  store i32 %val_r9d_11f4, i32* %dst.addr_11f4_i32p, align 4
  %rax_b11f4 = load i64, i64* %r_rax, align 8
  %r9_next_11f4 = add i64 %rax_b11f4, 4
  %rdx_b11f4 = load i64, i64* %r_rdx, align 8
  %cmp_1202 = icmp uge i64 %r9_next_11f4, %rdx_b11f4
  br i1 %cmp_1202, label %bb_1280, label %bb_1207

bb_1207:
  %rcx_b1207 = load i64, i64* %r_rcx, align 8
  %r9_b1207 = load i64, i64* %r_r9, align 8
  %r9_shl_1207 = shl i64 %r9_b1207, 2
  %off_1207 = add i64 %r9_shl_1207, 12
  %src.ptr1207 = inttoptr i64 %rcx_b1207 to i8*
  %addr_1207 = getelementptr inbounds i8, i8* %src.ptr1207, i64 %off_1207
  %addr_1207_i32p = bitcast i8* %addr_1207 to i32*
  %val_r9d_1207 = load i32, i32* %addr_1207_i32p, align 4
  %r10_b1207 = load i64, i64* %r_r10, align 8
  %rsi_b1207 = load i64, i64* %r_rsi, align 8
  %dst.ptr1207 = inttoptr i64 %rsi_b1207 to i8*
  %dst.off_1207 = add i64 %r10_b1207, 12
  %dst_1207 = getelementptr inbounds i8, i8* %dst.ptr1207, i64 %dst.off_1207
  %dst_1207_i32p = bitcast i8* %dst_1207 to i32*
  store i32 %val_r9d_1207, i32* %dst_1207_i32p, align 4
  %rax_b1207 = load i64, i64* %r_rax, align 8
  %r9_next_1211 = add i64 %rax_b1207, 5
  %rdx_b1207 = load i64, i64* %r_rdx, align 8
  %cmp_1215 = icmp uge i64 %r9_next_1211, %rdx_b1207
  br i1 %cmp_1215, label %bb_1280, label %bb_121a

bb_121a:
  %rcx_b121a = load i64, i64* %r_rcx, align 8
  %r9_b121a = load i64, i64* %r_r9, align 8
  %r9_shl_121a = shl i64 %r9_b121a, 2
  %off_121a = add i64 %r9_shl_121a, 16
  %src.ptr121a = inttoptr i64 %rcx_b121a to i8*
  %addr_121a = getelementptr inbounds i8, i8* %src.ptr121a, i64 %off_121a
  %addr_121a_i32p = bitcast i8* %addr_121a to i32*
  %val_r9d_121a = load i32, i32* %addr_121a_i32p, align 4
  %r10_b121a = load i64, i64* %r_r10, align 8
  %rsi_b121a = load i64, i64* %r_rsi, align 8
  %dst.ptr121a = inttoptr i64 %rsi_b121a to i8*
  %dst.off_121a = add i64 %r10_b121a, 16
  %dst_121a = getelementptr inbounds i8, i8* %dst.ptr121a, i64 %dst.off_121a
  %dst_121a_i32p = bitcast i8* %dst_121a to i32*
  store i32 %val_r9d_121a, i32* %dst_121a_i32p, align 4
  %rax_b121a = load i64, i64* %r_rax, align 8
  %r9_next_1224 = add i64 %rax_b121a, 6
  %rdx_b121a = load i64, i64* %r_rdx, align 8
  %cmp_1228 = icmp uge i64 %r9_next_1224, %rdx_b121a
  br i1 %cmp_1228, label %bb_1280, label %bb_122d

bb_122d:
  %rcx_b122d = load i64, i64* %r_rcx, align 8
  %r9_b122d = load i64, i64* %r_r9, align 8
  %r9_shl_122d = shl i64 %r9_b122d, 2
  %off_122d = add i64 %r9_shl_122d, 20
  %src.ptr122d = inttoptr i64 %rcx_b122d to i8*
  %addr_122d = getelementptr inbounds i8, i8* %src.ptr122d, i64 %off_122d
  %addr_122d_i32p = bitcast i8* %addr_122d to i32*
  %val_r9d_122d = load i32, i32* %addr_122d_i32p, align 4
  %r10_b122d = load i64, i64* %r_r10, align 8
  %rsi_b122d = load i64, i64* %r_rsi, align 8
  %dst.ptr122d = inttoptr i64 %rsi_b122d to i8*
  %dst.off_122d = add i64 %r10_b122d, 20
  %dst_122d = getelementptr inbounds i8, i8* %dst.ptr122d, i64 %dst.off_122d
  %dst_122d_i32p = bitcast i8* %dst_122d to i32*
  store i32 %val_r9d_122d, i32* %dst_122d_i32p, align 4
  %rax_b122d = load i64, i64* %r_rax, align 8
  %r9_next_1237 = add i64 %rax_b122d, 7
  %rdx_b122d = load i64, i64* %r_rdx, align 8
  %cmp_123b = icmp uge i64 %r9_next_1237, %rdx_b122d
  br i1 %cmp_123b, label %bb_1280, label %bb_1240

bb_1240:
  %rcx_b1240 = load i64, i64* %r_rcx, align 8
  %r9_b1240 = load i64, i64* %r_r9, align 8
  %r9_shl_1240 = shl i64 %r9_b1240, 2
  %off_1240 = add i64 %r9_shl_1240, 24
  %src.ptr1240 = inttoptr i64 %rcx_b1240 to i8*
  %addr_1240 = getelementptr inbounds i8, i8* %src.ptr1240, i64 %off_1240
  %addr_1240_i32p = bitcast i8* %addr_1240 to i32*
  %val_r9d_1240 = load i32, i32* %addr_1240_i32p, align 4
  %r10_b1240 = load i64, i64* %r_r10, align 8
  %rsi_b1240 = load i64, i64* %r_rsi, align 8
  %dst.ptr1240 = inttoptr i64 %rsi_b1240 to i8*
  %dst.off_1240 = add i64 %r10_b1240, 24
  %dst_1240 = getelementptr inbounds i8, i8* %dst.ptr1240, i64 %dst.off_1240
  %dst_1240_i32p = bitcast i8* %dst_1240 to i32*
  store i32 %val_r9d_1240, i32* %dst_1240_i32p, align 4
  %rax_old1240 = load i64, i64* %r_rax, align 8
  %rax_inc8 = add i64 %rax_old1240, 8
  store i64 %rax_inc8, i64* %r_rax, align 8
  %rdx_b124e = load i64, i64* %r_rdx, align 8
  %cmp_124e = icmp uge i64 %rax_inc8, %rdx_b124e
  br i1 %cmp_124e, label %bb_1280, label %bb_1253

bb_1253:
  %rcx_b1253 = load i64, i64* %r_rcx, align 8
  %r9_b1253 = load i64, i64* %r_r9, align 8
  %r9_shl_1253 = shl i64 %r9_b1253, 2
  %off_1253 = add i64 %r9_shl_1253, 28
  %src.ptr1253 = inttoptr i64 %rcx_b1253 to i8*
  %addr_1253 = getelementptr inbounds i8, i8* %src.ptr1253, i64 %off_1253
  %addr_1253_i32p = bitcast i8* %addr_1253 to i32*
  %val_eax_1253 = load i32, i32* %addr_1253_i32p, align 4
  %r10_b1253 = load i64, i64* %r_r10, align 8
  %rsi_b1253 = load i64, i64* %r_rsi, align 8
  %dst.ptr1253 = inttoptr i64 %rsi_b1253 to i8*
  %dst.off_1253 = add i64 %r10_b1253, 28
  %dst_1253 = getelementptr inbounds i8, i8* %dst.ptr1253, i64 %dst.off_1253
  %dst_1253_i32p = bitcast i8* %dst_1253 to i32*
  store i32 %val_eax_1253, i32* %dst_1253_i32p, align 4
  %rdi_b125e = load i64, i64* %r_rdi, align 8
  %is_d1 = icmp eq i64 %rdi_b125e, 1
  %al125e = zext i1 %is_d1 to i8
  %negext = sub i8 0, %al125e
  %neg64 = sext i8 %negext to i64
  %axe = add i64 %neg64, 10
  %rdx_b126c = load i64, i64* %r_rdx, align 8
  %cmp_126c = icmp uge i64 %axe, %rdx_b126c
  br i1 %cmp_126c, label %bb_1280, label %bb_1271

bb_1271:
  %rcx_b1271 = load i64, i64* %r_rcx, align 8
  %r9_b1271 = load i64, i64* %r_r9, align 8
  %r9_shl_1271 = shl i64 %r9_b1271, 2
  %off_1271 = add i64 %r9_shl_1271, 32
  %src.ptr1271 = inttoptr i64 %rcx_b1271 to i8*
  %addr_1271 = getelementptr inbounds i8, i8* %src.ptr1271, i64 %off_1271
  %addr_1271_i32p = bitcast i8* %addr_1271 to i32*
  %val_eax_1271 = load i32, i32* %addr_1271_i32p, align 4
  %rsi_b1271 = load i64, i64* %r_rsi, align 8
  %dst.ptr1271 = inttoptr i64 %rsi_b1271 to i8*
  %dst_1271 = getelementptr inbounds i8, i8* %dst.ptr1271, i64 36
  %dst_1271_i32p = bitcast i8* %dst_1271 to i32*
  store i32 %val_eax_1271, i32* %dst_1271_i32p, align 4
  br label %bb_1280

bb_1280:
  %r8_b1280 = load i64, i64* %r_r8, align 8
  %cmp_1280 = icmp ugt i64 %r8_b1280, 9
  br i1 %cmp_1280, label %bb_1380, label %bb_128a

bb_128a:
  %r11_b128a = load i64, i64* %r_r11, align 8
  %r8_b128a = load i64, i64* %r_r8, align 8
  %rdx_sum = add i64 %r11_b128a, %r8_b128a
  store i64 %rdx_sum, i64* %r_rdx, align 8
  store i64 10, i64* %r_rbx, align 8
  store i64 %r8_b128a, i64* %r_rax, align 8
  %rbx_b1296 = load i64, i64* %r_rbx, align 8
  %cmp1296 = icmp ule i64 %rdx_sum, %rbx_b1296
  %rbx_min = select i1 %cmp1296, i64 %rdx_sum, i64 %rbx_b1296
  store i64 %rbx_min, i64* %r_rbx, align 8
  store i64 10, i64* %r_rdx, align 8
  %r8_next = add i64 %rdx_sum, %r11_b128a
  store i64 %r8_next, i64* %r_r8, align 8
  %rdx_b12a9 = load i64, i64* %r_rdx, align 8
  %cmp12a9 = icmp ule i64 %r8_next, %rdx_b12a9
  %rdx_min = select i1 %cmp12a9, i64 %r8_next, i64 %rdx_b12a9
  store i64 %rdx_min, i64* %r_rdx, align 8
  %rbx_b12b0 = load i64, i64* %r_rbx, align 8
  store i64 %rbx_b12b0, i64* %r_r12, align 8
  %rax_b12b3 = load i64, i64* %r_rax, align 8
  %rdx_b12b3 = load i64, i64* %r_rdx, align 8
  %cmp12b3 = icmp uge i64 %rax_b12b3, %rdx_b12b3
  br i1 %cmp12b3, label %bb_1280, label %bb_12b8

bb_12b8:
  %r10_set = load i64, i64* %r_rax, align 8
  store i64 %r10_set, i64* %r_r10, align 8
  %rbx_b12b8 = load i64, i64* %r_rbx, align 8
  %cmp12b8 = icmp uge i64 %r10_set, %rbx_b12b8
  br i1 %cmp12b8, label %bb_1158, label %bb_12c1

bb_12c1:
  %rcx_b12c1 = load i64, i64* %r_rcx, align 8
  %src.ptr12c1 = inttoptr i64 %rcx_b12c1 to i8*
  %r10_b12c1 = load i64, i64* %r_r10, align 8
  %src.i32.base12c1 = bitcast i8* %src.ptr12c1 to i32*
  %src.idx12c1 = getelementptr inbounds i32, i32* %src.i32.base12c1, i64 %r10_b12c1
  %val_edi_12c1 = load i32, i32* %src.idx12c1, align 4
  %r12_b12c5 = load i64, i64* %r_r12, align 8
  %rdx_b12c5 = load i64, i64* %r_rdx, align 8
  %cmp12c5 = icmp uge i64 %r12_b12c5, %rdx_b12c5
  br i1 %cmp12c5, label %bb_12d7, label %bb_12ca

bb_12ca:
  %rcx_b12ca = load i64, i64* %r_rcx, align 8
  %r12_b12ca = load i64, i64* %r_r12, align 8
  %src.ptr12ca = inttoptr i64 %rcx_b12ca to i8*
  %src.i32.base12ca = bitcast i8* %src.ptr12ca to i32*
  %src.idx12ca = getelementptr inbounds i32, i32* %src.i32.base12ca, i64 %r12_b12ca
  %val_r9d_12ca = load i32, i32* %src.idx12ca, align 4
  %cmp12ce = icmp slt i32 %val_r9d_12ca, %val_edi_12c1
  br i1 %cmp12ce, label %bb_115c, label %bb_12d7

bb_12d7:
  %rsi_b12d7 = load i64, i64* %r_rsi, align 8
  %dst.ptr12d7 = inttoptr i64 %rsi_b12d7 to i8*
  %rax_b12d7 = load i64, i64* %r_rax, align 8
  %dst.i32.base12d7 = bitcast i8* %dst.ptr12d7 to i32*
  %dst.idx12d7 = getelementptr inbounds i32, i32* %dst.i32.base12d7, i64 %rax_b12d7
  store i32 %val_edi_12c1, i32* %dst.idx12d7, align 4
  %rax_inc = add i64 %rax_b12d7, 1
  store i64 %rax_inc, i64* %r_rax, align 8
  %rdx_b12de = load i64, i64* %r_rdx, align 8
  %cmp12de = icmp eq i64 %rdx_b12de, %rax_inc
  br i1 %cmp12de, label %bb_1280, label %bb_12e3

bb_12e3:
  %r10_b12e3 = load i64, i64* %r_r10, align 8
  %r10_inc = add i64 %r10_b12e3, 1
  store i64 %r10_inc, i64* %r_r10, align 8
  br label %bb_12b8

bb_12f0:
  %rcx_b12f0 = load i64, i64* %r_rcx, align 8
  %r12_b12f0 = load i64, i64* %r_r12, align 8
  %addr_12f0 = add i64 %rcx_b12f0, %r12_b12f0
  %addr_minus4 = add i64 %addr_12f0, -4
  %ptr_12f0 = inttoptr i64 %addr_minus4 to <16 x i8>*
  %xmm1 = load <16 x i8>, <16 x i8>* %ptr_12f0, align 1
  %rbx_b12f5 = load i64, i64* %r_rbx, align 8
  %r10_b12f5 = lshr i64 %rbx_b12f5, 2
  %rbp_b12f5 = load i64, i64* %r_rbp, align 8
  %dst.vec.ptr0 = inttoptr i64 %rbp_b12f5 to <16 x i8>*
  store <16 x i8> %xmm1, <16 x i8>* %dst.vec.ptr0, align 1
  %cmp_1304 = icmp eq i64 %r10_b12f5, 1
  br i1 %cmp_1304, label %bb_1313, label %bb_130a

bb_130a:
  %base_130a = inttoptr i64 %addr_minus4 to i8*
  %ptr_130a = getelementptr inbounds i8, i8* %base_130a, i64 16
  %ptr_130a.cast = bitcast i8* %ptr_130a to <16 x i8>*
  %xmm2 = load <16 x i8>, <16 x i8>* %ptr_130a.cast, align 1
  %dst.base130a = inttoptr i64 %rbp_b12f5 to i8*
  %dst.vec.ptr1 = getelementptr inbounds i8, i8* %dst.base130a, i64 16
  %dst.vec.ptr1.cast = bitcast i8* %dst.vec.ptr1 to <16 x i8>*
  store <16 x i8> %xmm2, <16 x i8>* %dst.vec.ptr1.cast, align 1
  br label %bb_1313

bb_1313:
  %rbx_b1313 = load i64, i64* %r_rbx, align 8
  %rax_mask = and i64 %rbx_b1313, -4
  %r9_b131a = load i64, i64* %r_r9, align 8
  %r9_add = add i64 %r9_b131a, %rax_mask
  store i64 %r9_add, i64* %r_r9, align 8
  %rdi_b131d = load i64, i64* %r_rdi, align 8
  %rax_add_d = add i64 %rax_mask, %rdi_b131d
  store i64 %rax_add_d, i64* %r_rax, align 8
  %ebx_tail = and i64 %rbx_b1313, 3
  %is_zero_tail = icmp eq i64 %ebx_tail, 0
  br i1 %is_zero_tail, label %bb_1280, label %bb_1329

bb_1329:
  %rcx_b1329 = load i64, i64* %r_rcx, align 8
  %r9_b1329 = load i64, i64* %r_r9, align 8
  %r10_scaled1329 = shl i64 %r9_b1329, 2
  %sum_1329 = add i64 %rcx_b1329, %r10_scaled1329
  %src.ptr1329 = inttoptr i64 %sum_1329 to i32*
  %val_r9d_1331 = load i32, i32* %src.ptr1329, align 4
  %rsi_b1335 = load i64, i64* %r_rsi, align 8
  %rax_b1335 = load i64, i64* %r_rax, align 8
  %dst.ptr1335 = inttoptr i64 %rsi_b1335 to i8*
  %dst.i32.base1335 = bitcast i8* %dst.ptr1335 to i32*
  %dst.idx1335 = getelementptr inbounds i32, i32* %dst.i32.base1335, i64 %rax_b1335
  store i32 %val_r9d_1331, i32* %dst.idx1335, align 4
  %rax_b1341 = add i64 %rax_b1335, 1
  %rdx_b1345 = load i64, i64* %r_rdx, align 8
  %cmp_1345 = icmp uge i64 %rax_b1341, %rdx_b1345
  br i1 %cmp_1345, label %bb_1280, label %bb_134e

bb_134e:
  %rcx_b134e = load i64, i64* %r_rcx, align 8
  %r9_b134e = load i64, i64* %r_r9, align 8
  %r9_shl_134e = shl i64 %r9_b134e, 2
  %off_134e = add i64 %r9_shl_134e, 4
  %src.ptr134e = inttoptr i64 %rcx_b134e to i8*
  %addr_134e = getelementptr inbounds i8, i8* %src.ptr134e, i64 %off_134e
  %addr_134e_i32p = bitcast i8* %addr_134e to i32*
  %val_r9d_134e = load i32, i32* %addr_134e_i32p, align 4
  %rsi_b134e = load i64, i64* %r_rsi, align 8
  %rax_add2 = add i64 %rax_b1341, 1
  %dst.base134e = inttoptr i64 %rsi_b134e to i8*
  %dst.off134e = shl i64 %rax_b1341, 2
  %dst_134e_base = getelementptr inbounds i8, i8* %dst.base134e, i64 %dst.off134e
  %dst_134e_plus4 = getelementptr inbounds i8, i8* %dst_134e_base, i64 4
  %dst_134e_i32p = bitcast i8* %dst_134e_plus4 to i32*
  store i32 %val_r9d_134e, i32* %dst_134e_i32p, align 4
  %rdx_b135c = load i64, i64* %r_rdx, align 8
  %cmp_135c = icmp uge i64 %rax_add2, %rdx_b135c
  br i1 %cmp_135c, label %bb_1280, label %bb_1365

bb_1365:
  %rcx_b1365 = load i64, i64* %r_rcx, align 8
  %r9_b1365 = load i64, i64* %r_r9, align 8
  %r9_shl_1365 = shl i64 %r9_b1365, 2
  %off_1365 = add i64 %r9_shl_1365, 8
  %src.ptr1365 = inttoptr i64 %rcx_b1365 to i8*
  %addr_1365 = getelementptr inbounds i8, i8* %src.ptr1365, i64 %off_1365
  %addr_1365_i32p = bitcast i8* %addr_1365 to i32*
  %val_eax_1365 = load i32, i32* %addr_1365_i32p, align 4
  %rsi_b1365 = load i64, i64* %r_rsi, align 8
  %rdi_b1365 = load i64, i64* %r_rax, align 8
  %dst.base1365 = inttoptr i64 %rsi_b1365 to i8*
  %dst.off1365 = shl i64 %rdi_b1365, 2
  %dst_1365_base = getelementptr inbounds i8, i8* %dst.base1365, i64 %dst.off1365
  %dst_1365_plus8 = getelementptr inbounds i8, i8* %dst_1365_base, i64 8
  %dst_1365_i32p = bitcast i8* %dst_1365_plus8 to i32*
  store i32 %val_eax_1365, i32* %dst_1365_i32p, align 4
  %r8_b136e = load i64, i64* %r_r8, align 8
  %cmp_136e = icmp ule i64 %r8_b136e, 9
  br i1 %cmp_136e, label %bb_128a, label %bb_1380

bb_1380:
  %v7c = load i32, i32* %var_7C, align 4
  %v7c.dec = add i32 %v7c, -1
  store i32 %v7c.dec, i32* %var_7C, align 4
  %v88 = load i64, i64* %var_88, align 8
  store i64 %v88, i64* %r_rdi, align 8
  %is_zero_1389 = icmp eq i32 %v7c.dec, 0
  br i1 %is_zero_1389, label %bb_13ad, label %bb_138b

bb_138b:
  %rdx_b138b = load i64, i64* %r_rcx, align 8
  %rsi_b138b = load i64, i64* %r_rsi, align 8
  store i64 %rsi_b138b, i64* %r_rcx, align 8
  store i64 %rdx_b138b, i64* %r_rsi, align 8
  br label %bb_1140

bb_13a0:
  %rdi_b13a0 = load i64, i64* %r_rdi, align 8
  %r10_off_13a0 = shl i64 %rdi_b13a0, 2
  store i64 %r10_off_13a0, i64* %r_r10, align 8
  br label %bb_11c4

bb_13ad:
  %rbx_saved = load i64, i64* %var_70, align 8
  store i64 %rbx_saved, i64* %r_rbx, align 8
  %ptr_m = load i8*, i8** %ptr, align 8
  %rsi_cur = load i64, i64* %r_rsi, align 8
  %cmp_moved = icmp eq i64 %rsi_cur, %rbx_saved
  br i1 %cmp_moved, label %bb_13c6, label %bb_13bc

bb_13bc:
  %tmp.ptr.13bc = inttoptr i64 %rbx_saved to i8*
  %fmtcnt = bitcast i8* %tmp.ptr.13bc to i32*
  %rdi_dst = inttoptr i64 %rbx_saved to i8*
  %rsi_src = inttoptr i64 %rsi_cur to i8*
  call void @llvm.memmove.p0i8.p0i8.i64(i8* %rdi_dst, i8* %rsi_src, i64 40, i1 false)
  br label %bb_13c6

bb_13c6:
  call void @free(i8* %ptr_m)
  br label %bb_13ce

bb_13ce:
  %rbx_b13ce = load i64, i64* %r_rbx, align 8
  %r12_limit = getelementptr inbounds i8, i8* %arr.i8, i64 64
  %r12_lim_i64 = ptrtoint i8* %r12_limit to i64
  %rbp_fmt = ptrtoint i8* bitcast (i8* getelementptr (i8, i8* @unk_2004, i64 0) to i8*) to i64
  br label %bb_13e0

bb_13e0:
  %rbx_ptr_i8 = inttoptr i64 %rbx_b13ce to i8*
  %rbx_ptr_i32 = bitcast i8* %rbx_ptr_i8 to i32*
  %edx_val = load i32, i32* %rbx_ptr_i32, align 4
  %fmt_ptr = getelementptr i8, i8* @unk_2004, i64 0
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr, i32 %edx_val)
  %rbx_b13ec = add i64 %rbx_b13ce, 4
  %cmp_13f5 = icmp ne i64 %r12_lim_i64, %rbx_b13ec
  br i1 %cmp_13f5, label %bb_13e0, label %bb_13fa

bb_13fa:
  %fmt2_ptr = getelementptr i8, i8* @unk_2008, i64 0
  %callp2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt2_ptr)
  br label %bb_140d

bb_140d:
  %guard_saved = load i64, i64* %stack_guard.slot, align 8
  %guard_now = load i64, i64* @__stack_chk_guard, align 8
  %guard_diff = icmp ne i64 %guard_saved, %guard_now
  br i1 %guard_diff, label %bb_1435, label %bb_141d

bb_141d:
  %ret0 = add i64 0, 0
  ret i32 0

bb_142e:
  %rbx_set = ptrtoint i8* %arr.i8 to i64
  store i64 %rbx_set, i64* %r_rbx, align 8
  br label %bb_13ce

bb_1435:
  call void @__stack_chk_fail()
  unreachable

bb_143a:
  %r9_cur_143a = load i64, i64* %r_r9, align 8
  store i64 %r9_cur_143a, i64* %r_r12, align 8
  %rax_cur_143a = load i64, i64* %r_rax, align 8
  %rax_next_143a = add i64 %rax_cur_143a, 1
  store i64 %rax_next_143a, i64* %r_rax, align 8
  br label %bb_12b8
}

declare void @llvm.memmove.p0i8.p0i8.i64(i8* nocapture writeonly, i8* nocapture readonly, i64, i1 immarg)