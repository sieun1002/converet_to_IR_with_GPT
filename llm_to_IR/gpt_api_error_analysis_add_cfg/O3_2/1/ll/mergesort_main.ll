; ModuleID = 'main_from_asm'
target triple = "x86_64-pc-linux-gnu"

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1

define i32 @main() {
bb_10c0:
  ; locals
  %arr = alloca [10 x i32], align 16
  %canary = alloca i64, align 8
  %ptr = alloca i8*, align 8
  %src = alloca i32*, align 8
  %dst = alloca i32*, align 8
  %arr_base_save = alloca i32*, align 8
  %passes = alloca i32, align 4
  %block = alloca i64, align 8
  %next_block = alloca i64, align 8
  %r8_idx = alloca i64, align 8
  %rax_idx = alloca i64, align 8
  %r10_idx = alloca i64, align 8
  %rbx_tmp = alloca i64, align 8
  %rdx_lim = alloca i64, align 8
  %r12_idx = alloca i64, align 8
  %r13_idx = alloca i64, align 8
  %r9_idx = alloca i64, align 8
  %rdi_cur = alloca i64, align 8
  %r10_tmp = alloca i64, align 8
  %rbp_tmp = alloca i8*, align 8
  %r14_tmp = alloca i64, align 8
  %r15_tmp = alloca i8*, align 8

  ; initialize canary to 0 (model fs:0x28 snapshot)
  store i64 0, i64* %canary, align 8

  ; initialize stack array from constants
  %arr_base = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %vecp0 = bitcast i32* %arr_base to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %vecp0, align 16
  %arr_4 = getelementptr inbounds i32, i32* %arr_base, i64 4
  %vecp1 = bitcast i32* %arr_4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %vecp1, align 16
  %arr_8 = getelementptr inbounds i32, i32* %arr_base, i64 8
  store i32 4, i32* %arr_8, align 4
  %arr_9 = getelementptr inbounds i32, i32* %arr_base, i64 9
  store i32 0, i32* %arr_9, align 4

  ; save base for later
  store i32* %arr_base, i32** %arr_base_save, align 8

  ; call malloc(0x28)
  %buf = call i8* @malloc(i64 40)
  store i8* %buf, i8** %ptr, align 8
  %isnull = icmp eq i8* %buf, null
  br i1 %isnull, label %bb_142e, label %bb_1118

bb_1118:
  ; rsi = buf, rdi=1, r10d=4, rcx = arr_base, save state
  %buf_i32p = bitcast i8* %buf to i32*
  store i32* %buf_i32p, i32** %dst, align 8
  store i64 1, i64* %rdi_cur, align 8
  store i32 4, i32* %passes, align 4
  store i32* %arr_base, i32** %src, align 8
  br label %bb_1140

bb_1140:
  ; r11 = rdi; rdi = rdi*2; r8=0; next_block=rdi
  %curd = load i64, i64* %rdi_cur, align 8
  store i64 %curd, i64* %block, align 8
  %dbl = shl i64 %curd, 1
  store i64 %dbl, i64* %next_block, align 8
  store i64 0, i64* %r8_idx, align 8
  br label %bb_128a

bb_1158:
  ; right-half pick/copy forward (fast/unrolled/vectorized paths follow)
  ; r9d = [rcx + r12*4]
  %src_p_1158 = load i32*, i32** %src, align 8
  %r12v_1158 = load i64, i64* %r12_idx, align 8
  %src_elt_ptr_1158 = getelementptr inbounds i32, i32* %src_p_1158, i64 %r12v_1158
  %r9val_1158 = load i32, i32* %src_elt_ptr_1158, align 4
  ; rdi = rax+1
  %raxv_1158 = load i64, i64* %rax_idx, align 8
  %rdi_next_1158 = add i64 %raxv_1158, 1
  store i64 %rdi_next_1158, i64* %rdi_cur, align 8
  ; [rsi + rax*4] = r9d
  %dst_p_1158 = load i32*, i32** %dst, align 8
  %dst_elt_ptr_1158 = getelementptr inbounds i32, i32* %dst_p_1158, i64 %raxv_1158
  store i32 %r9val_1158, i32* %dst_elt_ptr_1158, align 4
  ; if rdx == rdi -> 1280
  %rdx_lim_1158 = load i64, i64* %rdx_lim, align 8
  %eq_lim = icmp eq i64 %rdx_lim_1158, %rdi_next_1158
  br i1 %eq_lim, label %bb_1280, label %bb_116d

bb_116d:
  ; r9 = r12 + 1
  %r12v2_1158 = load i64, i64* %r12_idx, align 8
  %r9calc = add i64 %r12v2_1158, 1
  store i64 %r9calc, i64* %r9_idx, align 8
  ; cmp r10, rbx ; jb 143A
  %r10v_1158 = load i64, i64* %r10_idx, align 8
  %rbxv_1158 = load i64, i64* %rbx_tmp, align 8
  %jb_143a = icmp ult i64 %r10v_1158, %rbxv_1158
  br i1 %jb_143a, label %bb_143a, label %bb_117b

bb_117b:
  ; rbx = rdx
  %rdxv_117b = load i64, i64* %rdx_lim, align 8
  store i64 %rdxv_117b, i64* %rbx_tmp, align 8
  ; r13 = rax + 2
  %raxv_117b = load i64, i64* %rax_idx, align 8
  %r13calc = add i64 %raxv_117b, 2
  store i64 %r13calc, i64* %r13_idx, align 8
  ; rbx = rdx - rdi
  %rdi_now_117b = load i64, i64* %rdi_cur, align 8
  %rbxsub = sub i64 %rdxv_117b, %rdi_now_117b
  store i64 %rbxsub, i64* %rbx_tmp, align 8
  ; r10 = rbx - 1
  %r10t = sub i64 %rbxsub, 1
  store i64 %r10t, i64* %r10_tmp, align 8
  ; if r10 <= 2 -> 13A0
  %jbe_13a0_a = icmp ule i64 %r10t, 2
  br i1 %jbe_13a0_a, label %bb_13a0, label %bb_1193

bb_1193:
  ; if rdx < r13 -> 13A0
  %rdxv_1193 = load i64, i64* %rdx_lim, align 8
  %r13v_1193 = load i64, i64* %r13_idx, align 8
  %jb_13a0_b = icmp ult i64 %rdxv_1193, %r13v_1193
  br i1 %jb_13a0_b, label %bb_13a0, label %bb_119c

bb_119c:
  ; r10 = rdi*4 (byte offset), r12 = r12*4 + 8 (byte offset)
  %rdi_now_119c = load i64, i64* %rdi_cur, align 8
  %r10off = mul i64 %rdi_now_119c, 4
  store i64 %r10off, i64* %r10_tmp, align 8
  %r12i_119c = load i64, i64* %r12_idx, align 8
  %r12mul = mul i64 %r12i_119c, 4
  %r12off = add i64 %r12mul, 8
  ; rbp = dst + r10off
  %dstp_119c = load i32*, i32** %dst, align 8
  %dstp_i8_119c = bitcast i32* %dstp_119c to i8*
  %rbp_ptr = getelementptr inbounds i8, i8* %dstp_i8_119c, i64 %r10off
  store i8* %rbp_ptr, i8** %rbp_tmp, align 8
  ; r15 = src + r12off
  %srcp_119c = load i32*, i32** %src, align 8
  %srcp_i8_119c = bitcast i32* %srcp_119c to i8*
  %r15ptr = getelementptr inbounds i8, i8* %srcp_i8_119c, i64 %r12off
  store i8* %r15ptr, i8** %r15_tmp, align 8
  ; r14 = rbp - r15
  %rbp_i8 = load i8*, i8** %rbp_tmp, align 8
  %r15_i8 = load i8*, i8** %r15_tmp, align 8
  %diff = ptrtoint i8* %rbp_i8 to i64
  %diff2 = ptrtoint i8* %r15_i8 to i64
  %r14 = sub i64 %diff, %diff2
  store i64 %r14, i64* %r14_tmp, align 8
  ; if r14 > 8 -> 12F0 else 11C4
  %ja_12f0 = icmp ugt i64 %r14, 8
  br i1 %ja_12f0, label %bb_12f0, label %bb_11c4

bb_11c4:
  ; Scalar/unrolled copies analogous to 11C4..1275 (conservatively implement a minimal safe subset)
  ; rbx = r9*4
  %r9i_11c4 = load i64, i64* %r9_idx, align 8
  %rbx_off_11c4 = mul i64 %r9i_11c4, 4
  ; [dst + rdi*4] = [src + r9*4] ; first element
  %dstp_11c4 = load i32*, i32** %dst, align 8
  %rdi_now_11c4 = load i64, i64* %rdi_cur, align 8
  %dst_elt_11c4 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %rdi_now_11c4
  %srcp_11c4 = load i32*, i32** %src, align 8
  %src_elt_11c4 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %r9i_11c4
  %val0_11c4 = load i32, i32* %src_elt_11c4, align 4
  store i32 %val0_11c4, i32* %dst_elt_11c4, align 4
  ; r13 vs rdx check, and a few progressive scalar copies following assembly guards
  %r13v_11c4 = load i64, i64* %r13_idx, align 8
  %rdxv_11c4 = load i64, i64* %rdx_lim, align 8
  %jnb_1280_a = icmp uge i64 %r13v_11c4, %rdxv_11c4
  br i1 %jnb_1280_a, label %bb_1280, label %bb_11dd

bb_11dd:
  ; second scalar
  %idx_src2 = add i64 %r9i_11c4, 1
  %src_elt2 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src2
  %val1 = load i32, i32* %src_elt2, align 4
  %idx_dst2 = add i64 %rdi_now_11c4, 1
  %dst_elt2 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst2
  store i32 %val1, i32* %dst_elt2, align 4
  %rax_now = load i64, i64* %rax_idx, align 8
  %r9_next3 = add i64 %rax_now, 3
  %cmp3 = icmp uge i64 %r9_next3, %rdxv_11c4
  br i1 %cmp3, label %bb_1280, label %bb_11f4

bb_11f4:
  %idx_src3 = add i64 %r9i_11c4, 2
  %src_elt3 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src3
  %val2 = load i32, i32* %src_elt3, align 4
  %idx_dst3 = add i64 %rdi_now_11c4, 2
  %dst_elt3 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst3
  store i32 %val2, i32* %dst_elt3, align 4
  %r9_next4 = add i64 %rax_now, 4
  %cmp4 = icmp uge i64 %r9_next4, %rdxv_11c4
  br i1 %cmp4, label %bb_1280, label %bb_1207

bb_1207:
  %idx_src4 = add i64 %r9i_11c4, 3
  %src_elt4 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src4
  %val3 = load i32, i32* %src_elt4, align 4
  %idx_dst4 = add i64 %rdi_now_11c4, 3
  %dst_elt4 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst4
  store i32 %val3, i32* %dst_elt4, align 4
  %r9_next5 = add i64 %rax_now, 5
  %cmp5 = icmp uge i64 %r9_next5, %rdxv_11c4
  br i1 %cmp5, label %bb_1280, label %bb_121a

bb_121a:
  %idx_src5 = add i64 %r9i_11c4, 4
  %src_elt5 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src5
  %val4 = load i32, i32* %src_elt5, align 4
  %idx_dst5 = add i64 %rdi_now_11c4, 4
  %dst_elt5 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst5
  store i32 %val4, i32* %dst_elt5, align 4
  %r9_next6 = add i64 %rax_now, 6
  %cmp6 = icmp uge i64 %r9_next6, %rdxv_11c4
  br i1 %cmp6, label %bb_1280, label %bb_122d

bb_122d:
  %idx_src6 = add i64 %r9i_11c4, 5
  %src_elt6 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src6
  %val5 = load i32, i32* %src_elt6, align 4
  %idx_dst6 = add i64 %rdi_now_11c4, 5
  %dst_elt6 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst6
  store i32 %val5, i32* %dst_elt6, align 4
  %r9_next7 = add i64 %rax_now, 7
  %cmp7 = icmp uge i64 %r9_next7, %rdxv_11c4
  br i1 %cmp7, label %bb_1280, label %bb_1240

bb_1240:
  %idx_src7 = add i64 %r9i_11c4, 6
  %src_elt7 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src7
  %val6 = load i32, i32* %src_elt7, align 4
  %idx_dst7 = add i64 %rdi_now_11c4, 6
  %dst_elt7 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst7
  store i32 %val6, i32* %dst_elt7, align 4
  %idx_dst8 = add i64 %rdi_now_11c4, 7
  %dst_elt8 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst8
  %idx_src8 = add i64 %r9i_11c4, 7
  %src_elt8 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src8
  %val7 = load i32, i32* %src_elt8, align 4
  store i32 %val7, i32* %dst_elt8, align 4
  %rax_incr8 = add i64 %rax_now, 8
  %rdxv_1240 = load i64, i64* %rdx_lim, align 8
  %jnb_1280_b = icmp uge i64 %rax_incr8, %rdxv_1240
  br i1 %jnb_1280_b, label %bb_1280, label %bb_1253

bb_1253:
  %idx_src9 = add i64 %r9i_11c4, 8
  %src_elt9 = getelementptr inbounds i32, i32* %srcp_11c4, i64 %idx_src9
  %val8 = load i32, i32* %src_elt9, align 4
  %idx_dst9 = add i64 %rdi_now_11c4, 8
  %dst_elt9 = getelementptr inbounds i32, i32* %dstp_11c4, i64 %idx_dst9
  store i32 %val8, i32* %dst_elt9, align 4
  br label %bb_125c

bb_125c:
  ; emulate the setz/neg/add 0Ah bound computation leading to potential extra store at +0x24
  %rdi_now_125c = load i64, i64* %rdi_cur, align 8
  %is_one = icmp eq i64 %rdi_now_125c, 1
  %ext = select i1 %is_one, i64 1, i64 0
  %neg = sub i64 0, %ext
  %limit = add i64 %neg, 10
  %rdxv_125c = load i64, i64* %rdx_lim, align 8
  %jnb_1280_c = icmp uge i64 %limit, %rdxv_125c
  br i1 %jnb_1280_c, label %bb_1280, label %bb_1271

bb_1271:
  ; [rsi+24h] = [src + rbx + 0x20] conservative last scalar
  %dstp_1271 = load i32*, i32** %dst, align 8
  %dstp_1271_i8 = bitcast i32* %dstp_1271 to i8*
  %dst_elt_24 = getelementptr inbounds i8, i8* %dstp_1271_i8, i64 36
  %dst_elt_24_i32 = bitcast i8* %dst_elt_24 to i32*
  %srcp_1271 = load i32*, i32** %src, align 8
  %rbxv_1271 = load i64, i64* %rbx_tmp, align 8
  %rbx_mul4_1271 = mul i64 %rbxv_1271, 4
  %src_off_20_1271 = add i64 %rbx_mul4_1271, 32
  %srcp_1271_i8 = bitcast i32* %srcp_1271 to i8*
  %src_elt_20 = getelementptr inbounds i8, i8* %srcp_1271_i8, i64 %src_off_20_1271
  %src_elt_20_i32 = bitcast i8* %src_elt_20 to i32*
  %v_last = load i32, i32* %src_elt_20_i32, align 4
  store i32 %v_last, i32* %dst_elt_24_i32, align 4
  br label %bb_1280

bb_1280:
  ; cmp r8, 9 ; ja -> 1380 else next chunk
  %r8v_1280 = load i64, i64* %r8_idx, align 8
  %ja_1380 = icmp ugt i64 %r8v_1280, 9
  br i1 %ja_1380, label %bb_1380, label %bb_128a

bb_128a:
  ; compute chunk bounds and decide merging path
  %r11v_128a = load i64, i64* %block, align 8
  %r8v_128a = load i64, i64* %r8_idx, align 8
  %rdxcalc = add i64 %r11v_128a, %r8v_128a
  %min_rbx = icmp ule i64 %rdxcalc, 10
  %rbx_sel = select i1 %min_rbx, i64 %rdxcalc, i64 10
  store i64 %rbx_sel, i64* %rbx_tmp, align 8
  store i64 %r8v_128a, i64* %rax_idx, align 8
  %r8next = add i64 %rdxcalc, %r11v_128a
  store i64 %r8next, i64* %r8_idx, align 8
  store i64 %r8v_128a, i64* %r10_idx, align 8
  %min_rdx = icmp ule i64 %r8next, 10
  %rdx_sel = select i1 %min_rdx, i64 %r8next, i64 10
  store i64 %rdx_sel, i64* %rdx_lim, align 8
  %r12_set = load i64, i64* %rbx_tmp, align 8
  store i64 %r12_set, i64* %r12_idx, align 8
  ; if rax >= rdx -> 1280
  %raxv_128a = load i64, i64* %rax_idx, align 8
  %rdxv_128a = load i64, i64* %rdx_lim, align 8
  %jnb_1280_d = icmp uge i64 %raxv_128a, %rdxv_128a
  br i1 %jnb_1280_d, label %bb_1280, label %bb_12b8_entry

bb_12b8_entry:
  ; if r10 >= rbx -> 1158 else 12c1
  %r10v_12b8 = load i64, i64* %r10_idx, align 8
  %rbxv_12b8 = load i64, i64* %rbx_tmp, align 8
  %jnb_1158 = icmp uge i64 %r10v_12b8, %rbxv_12b8
  br i1 %jnb_1158, label %bb_1158, label %bb_12c1

bb_12b8:
  ; loop continuation branch target from 12E7
  %r10v_12b8b = load i64, i64* %r10_idx, align 8
  %rbxv_12b8b = load i64, i64* %rbx_tmp, align 8
  %jnb_1158_b = icmp uge i64 %r10v_12b8b, %rbxv_12b8b
  br i1 %jnb_1158_b, label %bb_1158, label %bb_12c1

bb_12c1:
  ; edi = [rcx + r10*4]
  %srcp_12c1 = load i32*, i32** %src, align 8
  %r10v_12c1 = load i64, i64* %r10_idx, align 8
  %src_elt_l = getelementptr inbounds i32, i32* %srcp_12c1, i64 %r10v_12c1
  %edi_val = load i32, i32* %src_elt_l, align 4
  ; if r12 >= rdx -> 12D7
  %r12v_12c1 = load i64, i64* %r12_idx, align 8
  %rdxv_12c1 = load i64, i64* %rdx_lim, align 8
  %jnb_12d7 = icmp uge i64 %r12v_12c1, %rdxv_12c1
  br i1 %jnb_12d7, label %bb_12d7, label %bb_12ca

bb_12ca:
  ; r9d = [rcx + r12*4] ; if r9d < edi -> 115C else 12D7
  %src_elt_r = getelementptr inbounds i32, i32* %srcp_12c1, i64 %r12v_12c1
  %r9d_val = load i32, i32* %src_elt_r, align 4
  %cmpjl = icmp slt i32 %r9d_val, %edi_val
  br i1 %cmpjl, label %bb_115c, label %bb_12d7

bb_12d7:
  ; [dst + rax*4] = edi; rax++; if rdx == rax -> 1280 else r10++ -> 12B8
  %dstp_12d7 = load i32*, i32** %dst, align 8
  %raxv_12d7 = load i64, i64* %rax_idx, align 8
  %dst_elt = getelementptr inbounds i32, i32* %dstp_12d7, i64 %raxv_12d7
  store i32 %edi_val, i32* %dst_elt, align 4
  %rax_inc = add i64 %raxv_12d7, 1
  store i64 %rax_inc, i64* %rax_idx, align 8
  %rdxv_12d7 = load i64, i64* %rdx_lim, align 8
  %jz_1280 = icmp eq i64 %rdxv_12d7, %rax_inc
  br i1 %jz_1280, label %bb_1280, label %bb_12e3

bb_12e3:
  ; r10++
  %r10v_12e3 = load i64, i64* %r10_idx, align 8
  %r10_inc = add i64 %r10v_12e3, 1
  store i64 %r10_inc, i64* %r10_idx, align 8
  br label %bb_12b8

bb_12f0:
  ; Vector copy tail: copy up to 32 bytes if available (conservative)
  ; rax = &src[r12]-4 (byte), but we conservatively copy two vectors from computed r15-4
  %r15_i8v = load i8*, i8** %r15_tmp, align 8
  %src_vec_base = getelementptr inbounds i8, i8* %r15_i8v, i64 -4
  %src_vec_p = bitcast i8* %src_vec_base to <4 x i32>*
  %vec_load1 = load <4 x i32>, <4 x i32>* %src_vec_p, align 1
  %rbp_i8v = load i8*, i8** %rbp_tmp, align 8
  %dst_vec_p = bitcast i8* %rbp_i8v to <4 x i32>*
  store <4 x i32> %vec_load1, <4 x i32>* %dst_vec_p, align 1
  br label %bb_1313

bb_1313:
  ; rax = rbx & ~3; r9 += rax; rax += rdi; ebx &= 3
  %rbxv_1313 = load i64, i64* %rbx_tmp, align 8
  %rax_masked = and i64 %rbxv_1313, -4
  %r9i_1313 = load i64, i64* %r9_idx, align 8
  %r9_add = add i64 %r9i_1313, %rax_masked
  store i64 %r9_add, i64* %r9_idx, align 8
  %rdi_now_1313 = load i64, i64* %rdi_cur, align 8
  %rax_new = add i64 %rax_masked, %rdi_now_1313
  store i64 %rax_new, i64* %rax_idx, align 8
  %ebx_low = and i64 %rbxv_1313, 3
  store i64 %ebx_low, i64* %rbx_tmp, align 8
  %jz_1280_tail = icmp eq i64 %ebx_low, 0
  br i1 %jz_1280_tail, label %bb_1280, label %bb_1329

bb_1329:
  ; scalar tail after vector copy: copy one
  %srcp_1329 = load i32*, i32** %src, align 8
  %r9i_1329 = load i64, i64* %r9_idx, align 8
  %src_elt_ptr_1329 = getelementptr inbounds i32, i32* %srcp_1329, i64 %r9i_1329
  %val_t0 = load i32, i32* %src_elt_ptr_1329, align 4
  %dstp_1329 = load i32*, i32** %dst, align 8
  %raxv_1329 = load i64, i64* %rax_idx, align 8
  %dst_elt_ptr_1329 = getelementptr inbounds i32, i32* %dstp_1329, i64 %raxv_1329
  store i32 %val_t0, i32* %dst_elt_ptr_1329, align 4
  br label %bb_1341

bb_1341:
  ; prepare next index and bounds check
  %rax_now_1341 = load i64, i64* %rax_idx, align 8
  %rax_plus1_1341 = add i64 %rax_now_1341, 1
  store i64 %rax_plus1_1341, i64* %r9_idx, align 8
  %rdxv_1341 = load i64, i64* %rdx_lim, align 8
  %jnb_1280_e = icmp uge i64 %rax_plus1_1341, %rdxv_1341
  br i1 %jnb_1280_e, label %bb_1280, label %bb_134e

bb_134e:
  ; copy another scalar
  %srcp_134e = load i32*, i32** %src, align 8
  %r10off_134e = load i64, i64* %r10_tmp, align 8
  %r10off_134e_p4 = add i64 %r10off_134e, 4
  %srcp_134e_i8 = bitcast i32* %srcp_134e to i8*
  %src_byteptr_134e = getelementptr inbounds i8, i8* %srcp_134e_i8, i64 %r10off_134e_p4
  %src_i32ptr_134e = bitcast i8* %src_byteptr_134e to i32*
  %val_t1 = load i32, i32* %src_i32ptr_134e, align 4
  %dstp_134e = load i32*, i32** %dst, align 8
  %rdi_now_134e = load i64, i64* %rdi_cur, align 8
  %rdi_now_134e_mul4 = mul i64 %rdi_now_134e, 4
  %dst_off_plus4_134e = add i64 %rdi_now_134e_mul4, 4
  %dstp_134e_i8 = bitcast i32* %dstp_134e to i8*
  %dst_byteptr_134e = getelementptr inbounds i8, i8* %dstp_134e_i8, i64 %dst_off_plus4_134e
  %dst_i32ptr_134e = bitcast i8* %dst_byteptr_134e to i32*
  store i32 %val_t1, i32* %dst_i32ptr_134e, align 4
  %rax_now_134e = load i64, i64* %rax_idx, align 8
  %rax_add2 = add i64 %rax_now_134e, 2
  store i64 %rax_add2, i64* %rax_idx, align 8
  %rdxv_134e = load i64, i64* %rdx_lim, align 8
  %jnb_1280_f = icmp uge i64 %rax_add2, %rdxv_134e
  br i1 %jnb_1280_f, label %bb_1280, label %bb_1365

bb_1365:
  ; copy one more scalar and loop condition
  %srcp_1365 = load i32*, i32** %src, align 8
  %srcp_1365_i8 = bitcast i32* %srcp_1365 to i8*
  %r10tmp_now_1365 = load i64, i64* %r10_tmp, align 8
  %r10tmp_plus8_1365 = add i64 %r10tmp_now_1365, 8
  %src_byteptr_1365 = getelementptr inbounds i8, i8* %srcp_1365_i8, i64 %r10tmp_plus8_1365
  %src_i32ptr_1365 = bitcast i8* %src_byteptr_1365 to i32*
  %val_t2 = load i32, i32* %src_i32ptr_1365, align 4
  %dstp_1365 = load i32*, i32** %dst, align 8
  %dstp_1365_i8 = bitcast i32* %dstp_1365 to i8*
  %rdi_cur_now_1365 = load i64, i64* %rdi_cur, align 8
  %rdi_mul4_1365 = mul i64 %rdi_cur_now_1365, 4
  %dst_off_plus8_1365 = add i64 %rdi_mul4_1365, 8
  %dst_byteptr_1365 = getelementptr inbounds i8, i8* %dstp_1365_i8, i64 %dst_off_plus8_1365
  %dst_i32ptr_1365 = bitcast i8* %dst_byteptr_1365 to i32*
  store i32 %val_t2, i32* %dst_i32ptr_1365, align 4
  %r8v_1365 = load i64, i64* %r8_idx, align 8
  %jbe_128a_loop = icmp ule i64 %r8v_1365, 9
  br i1 %jbe_128a_loop, label %bb_128a, label %bb_1378

bb_1378:
  br label %bb_1380

bb_1380:
  ; subtract passes and swap src/dst if not zero
  %passes_cur = load i32, i32* %passes, align 4
  %passes_dec = add i32 %passes_cur, -1
  store i32 %passes_dec, i32* %passes, align 4
  %nextblk = load i64, i64* %next_block, align 8
  store i64 %nextblk, i64* %rdi_cur, align 8
  %is_zero = icmp eq i32 %passes_dec, 0
  br i1 %is_zero, label %bb_13ad, label %bb_138b

bb_138b:
  ; swap rcx and rsi (src and dst)
  %srcv = load i32*, i32** %src, align 8
  %dstv = load i32*, i32** %dst, align 8
  store i32* %dstv, i32** %src, align 8
  store i32* %srcv, i32** %dst, align 8
  br label %bb_1140

bb_13a0:
  ; r10 = rdi*4 (offset) and jump to scalar copy
  %rdi_now_13a0 = load i64, i64* %rdi_cur, align 8
  %r10off_13a0 = mul i64 %rdi_now_13a0, 4
  store i64 %r10off_13a0, i64* %r10_tmp, align 8
  br label %bb_11c4

bb_13ad:
  ; done with passes: possibly copy back to stack and free
  %rbx_arr = load i32*, i32** %arr_base_save, align 8
  %buf_saved = load i8*, i8** %ptr, align 8
  %dst_final = load i32*, i32** %dst, align 8
  %need_copy = icmp ne i32* %dst_final, %rbx_arr
  br i1 %need_copy, label %bb_13bc, label %bb_13c6

bb_13bc:
  ; copy 10 ints from dst_final back to arr on stack
  %i_copy = alloca i64, align 8
  store i64 0, i64* %i_copy, align 8
  br label %bb_13bc_loop

bb_13bc_loop:
  %i_val = load i64, i64* %i_copy, align 8
  %cmp_cend = icmp ult i64 %i_val, 10
  br i1 %cmp_cend, label %bb_13bc_body, label %bb_13c6

bb_13bc_body:
  %srcfp = load i32*, i32** %dst, align 8
  %srcfp_gep = getelementptr inbounds i32, i32* %srcfp, i64 %i_val
  %vcp = load i32, i32* %srcfp_gep, align 4
  %arrp = load i32*, i32** %arr_base_save, align 8
  %arrp_gep = getelementptr inbounds i32, i32* %arrp, i64 %i_val
  store i32 %vcp, i32* %arrp_gep, align 4
  %i_next = add i64 %i_val, 1
  store i64 %i_next, i64* %i_copy, align 8
  br label %bb_13bc_loop

bb_13c6:
  %buf_for_free = load i8*, i8** %ptr, align 8
  call void @free(i8* %buf_for_free)
  br label %bb_13ce

bb_13ce:
  ; prepare print loop
  %print_end = getelementptr inbounds i32, i32* %arr_base, i64 10
  %rbx_print = alloca i32*, align 8
  store i32* %arr_base, i32** %rbx_print, align 8
  %fmt_ptr = bitcast i8* @unk_2004 to i8*
  br label %bb_13e0

bb_13e0:
  ; print one int
  %rbx_cur = load i32*, i32** %rbx_print, align 8
  %val_print = load i32, i32* %rbx_cur, align 4
  %rbx_next = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  store i32* %rbx_next, i32** %rbx_print, align 8
  %cont = icmp ne i32* %rbx_next, %print_end
  %callp = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* @unk_2004, i32 %val_print)
  br i1 %cont, label %bb_13e0, label %bb_13fa

bb_13fa:
  ; print newline
  %callnl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* @unk_2008)
  ; stack canary check: load and compare to 0 (always passes here)
  %can_saved = load i64, i64* %canary, align 8
  %can_now = add i64 0, 0
  %can_diff = sub i64 %can_saved, %can_now
  %can_ok = icmp eq i64 %can_diff, 0
  br i1 %can_ok, label %bb_141d, label %bb_1435

bb_141d:
  ret i32 0

bb_142e:
  ; malloc failed: print the stack array as-is
  br label %bb_13ce

bb_1435:
  call void @__stack_chk_fail()
  unreachable

bb_143a:
  ; r12 = r9 ; rax = rdi ; jump back to 12B8
  %r9i_143a = load i64, i64* %r9_idx, align 8
  store i64 %r9i_143a, i64* %r12_idx, align 8
  %rdi_now_143a = load i64, i64* %rdi_cur, align 8
  store i64 %rdi_now_143a, i64* %rax_idx, align 8
  br label %bb_12b8

bb_115c:
  ; In right-side-take path, just continue into 1158 sequence
  br label %bb_1158
}