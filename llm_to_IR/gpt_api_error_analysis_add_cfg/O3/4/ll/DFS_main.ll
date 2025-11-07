; ModuleID = 'recovered_main'
target triple = "x86_64-pc-linux-gnu"

@qword_2028 = external global i64

@.str_dfs = private constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_nl  = private constant [2 x i8] c"\0A\00"
@.str_fmt = private constant [6 x i8] c"%zu%s\00"

declare noalias i8* @calloc(i64, i64)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define dso_local i32 @main() {
bb_10e0:
  ; allocas for "registers" and locals
  %rbx_mem = alloca i8*, align 8
  %r12_mem = alloca i8*, align 8
  %r13_mem = alloca i8*, align 8
  %rdi_reg = alloca i64, align 8
  %rbp_reg = alloca i64, align 8
  %rax_reg = alloca i64, align 8
  %rdx_reg = alloca i64, align 8
  %rcx_reg = alloca i64, align 8
  %r8_ptr  = alloca i64*, align 8
  %rsi_ptr = alloca i32*, align 8
  %stack_guard_saved = alloca i64, align 8
  %varF4 = alloca i64, align 8
  %varD0 = alloca i64, align 8
  %var_DC = alloca i32, align 4
  %var_C0 = alloca i32, align 4
  %var_A0 = alloca i32, align 4
  %var_84 = alloca i32, align 4
  %var_AC = alloca i32, align 4
  %var_64 = alloca i32, align 4
  %var_74 = alloca i32, align 4
  %var_5C = alloca i32, align 4
  %var_54 = alloca i32, align 4
  %var_3C = alloca i32, align 4
  %arrF8 = alloca [256 x i32], align 16
  %arrE0 = alloca [256 x i32], align 16
  %arr138 = alloca [128 x i64], align 16
  ; emulate stack guard save (value arbitrary but consistent)
  store i64 0, i64* %stack_guard_saved, align 8
  ; zero first 192 bytes of arrF8 (24 qwords)
  %arrF8_i8 = bitcast [256 x i32]* %arrF8 to i8*
  call void @llvm.memset.p0i8.i64(i8* %arrF8_i8, i8 0, i64 192, i1 false)
  ; arrF8[0] = 0
  %arrF8_0 = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 0
  store i32 0, i32* %arrF8_0, align 4
  ; load external qword and store into two locals
  %qg = load i64, i64* @qword_2028, align 8
  store i64 %qg, i64* %varF4, align 8
  store i64 %qg, i64* %varD0, align 8
  ; initialize various local flags used by original code
  store i32 1, i32* %var_DC, align 4
  store i32 1, i32* %var_C0, align 4
  store i32 1, i32* %var_A0, align 4
  store i32 1, i32* %var_84, align 4
  store i32 1, i32* %var_AC, align 4
  store i32 1, i32* %var_64, align 4
  store i32 1, i32* %var_74, align 4
  store i32 1, i32* %var_5C, align 4
  store i32 1, i32* %var_54, align 4
  store i32 1, i32* %var_3C, align 4
  ; calloc(0x1c, 1)
  %p1 = call i8* @calloc(i64 28, i64 1)
  store i8* %p1, i8** %rbx_mem, align 8
  ; calloc(0x38, 1)
  %p2 = call i8* @calloc(i64 56, i64 1)
  store i8* %p2, i8** %r13_mem, align 8
  ; malloc(0x38)
  %p3 = call i8* @malloc(i64 56)
  store i8* %p3, i8** %r12_mem, align 8
  ; null checks -> loc_1455 if any null
  %rbx_ld = load i8*, i8** %rbx_mem, align 8
  %isnull_rbx = icmp eq i8* %rbx_ld, null
  %r13_ld = load i8*, i8** %r13_mem, align 8
  %isnull_r13 = icmp eq i8* %r13_ld, null
  %null_or = or i1 %isnull_rbx, %isnull_r13
  br i1 %null_or, label %bb_1455, label %bb_11d7

bb_11d7:
  %r12_ld0 = load i8*, i8** %r12_mem, align 8
  %isnull_r12 = icmp eq i8* %r12_ld0, null
  br i1 %isnull_r12, label %bb_1455, label %bb_11e0

bb_11e0:
  ; [r12] = 0 (qword)
  %r12_i64p = bitcast i8* %r12_ld0 to i64*
  store i64 0, i64* %r12_i64p, align 8
  ; edx = 0
  store i64 0, i64* %rdx_reg, align 8
  ; ebp = 1
  store i64 1, i64* %rbp_reg, align 8
  ; edi = 1
  store i64 1, i64* %rdi_reg, align 8
  ; dword [rbx] = 1
  %rbx_i32p = bitcast i8* %rbx_ld to i32*
  store i32 1, i32* %rbx_i32p, align 4
  ; var_138[0] = 0
  %arr138_0 = getelementptr inbounds [128 x i64], [128 x i64]* %arr138, i64 0, i64 0
  store i64 0, i64* %arr138_0, align 8
  br label %bb_120d

bb_1208:
  ; rdx = [r12 + rdi*8 - 8]
  %r12_ld1 = load i8*, i8** %r12_mem, align 8
  %r12_i64p2 = bitcast i8* %r12_ld1 to i64*
  %rdi_cur0 = load i64, i64* %rdi_reg, align 8
  %rdi_minus1 = add i64 %rdi_cur0, -1
  %stack_val_ptr = getelementptr inbounds i64, i64* %r12_i64p2, i64 %rdi_minus1
  %stack_val = load i64, i64* %stack_val_ptr, align 8
  store i64 %stack_val, i64* %rdx_reg, align 8
  br label %bb_120d

bb_120d:
  ; rcx = rdx*8
  %rdx0 = load i64, i64* %rdx_reg, align 8
  %rcx0 = mul i64 %rdx0, 8
  store i64 %rcx0, i64* %rcx_reg, align 8
  ; r8 = r13 + rcx (as i64* pointer to element rdx)
  %r13_ld0 = load i8*, i8** %r13_mem, align 8
  %r13_i64p = bitcast i8* %r13_ld0 to i64*
  %adj_ptr = getelementptr inbounds i64, i64* %r13_i64p, i64 %rdx0
  store i64* %adj_ptr, i64** %r8_ptr, align 8
  ; rax = [r8]
  %adj_val = load i64, i64* %adj_ptr, align 8
  store i64 %adj_val, i64* %rax_reg, align 8
  ; cmp rax, 6 ; ja -> bb_1412
  %cmp_ja = icmp ugt i64 %adj_val, 6
  br i1 %cmp_ja, label %bb_1412, label %bb_1227

bb_1227:
  ; rcx = rcx - rdx
  %rcx1 = load i64, i64* %rcx_reg, align 8
  %rdx1 = load i64, i64* %rdx_reg, align 8
  %rcx_minus = sub i64 %rcx1, %rdx1
  store i64 %rcx_minus, i64* %rcx_reg, align 8
  ; rdx = rax + rcx
  %rax1 = load i64, i64* %rax_reg, align 8
  %rdx_new = add i64 %rax1, %rcx_minus
  store i64 %rdx_new, i64* %rdx_reg, align 8
  ; r14d = arrF8[rdx]
  %arrF8_i32p = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %rdx_new
  %val_r14d = load i32, i32* %arrF8_i32p, align 4
  %tst_r14 = icmp eq i32 %val_r14d, 0
  br i1 %tst_r14, label %bb_1248, label %bb_1238

bb_1238:
  ; rsi = &visited[rax]
  %rbx_ld1 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p1 = bitcast i8* %rbx_ld1 to i32*
  %rax2 = load i64, i64* %rax_reg, align 8
  %vis_ptr0 = getelementptr inbounds i32, i32* %rbx_i32p1, i64 %rax2
  store i32* %vis_ptr0, i32** %rsi_ptr, align 8
  ; r11d = *rsi ; test -> jz bb_13ea
  %vis_val0 = load i32, i32* %vis_ptr0, align 4
  %tst_r11 = icmp eq i32 %vis_val0, 0
  br i1 %tst_r11, label %bb_13ea, label %bb_1248

bb_1248:
  ; rdx = rax + 1
  %rax3 = load i64, i64* %rax_reg, align 8
  %rdx_a1 = add i64 %rax3, 1
  store i64 %rdx_a1, i64* %rdx_reg, align 8
  ; cmp rax, 6 ; jz bb_133d
  %is_rax_6 = icmp eq i64 %rax3, 6
  br i1 %is_rax_6, label %bb_133d, label %bb_1256

bb_1256:
  ; r10d = arrF8[rcx + rdx]
  %rcx2 = load i64, i64* %rcx_reg, align 8
  %idx1256 = add i64 %rcx2, %rdx_a1
  %arrF8_idx1256 = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %idx1256
  %val_r10d = load i32, i32* %arrF8_idx1256, align 4
  %tst_r10 = icmp eq i32 %val_r10d, 0
  br i1 %tst_r10, label %bb_1274, label %bb_1264

bb_1264:
  ; rsi = &visited[rdx]
  %rbx_ld2 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p2 = bitcast i8* %rbx_ld2 to i32*
  %rdx_a1_b = load i64, i64* %rdx_reg, align 8
  %vis_ptr1 = getelementptr inbounds i32, i32* %rbx_i32p2, i64 %rdx_a1_b
  store i32* %vis_ptr1, i32** %rsi_ptr, align 8
  ; r9d = *rsi ; test -> jz bb_13f0
  %vis_val1 = load i32, i32* %vis_ptr1, align 4
  %tst_r9 = icmp eq i32 %vis_val1, 0
  br i1 %tst_r9, label %bb_13f0, label %bb_1274

bb_1274:
  ; rdx = rax + 2
  %rax4 = load i64, i64* %rax_reg, align 8
  %rdx_a2 = add i64 %rax4, 2
  store i64 %rdx_a2, i64* %rdx_reg, align 8
  ; cmp rax, 5 ; jz bb_133d
  %is_rax_5 = icmp eq i64 %rax4, 5
  br i1 %is_rax_5, label %bb_133d, label %bb_1282

bb_1282:
  ; r14d = arrF8[rcx + rdx]
  %rcx3 = load i64, i64* %rcx_reg, align 8
  %idx1282 = add i64 %rcx3, %rdx_a2
  %arrF8_idx1282 = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %idx1282
  %val_r14d_b = load i32, i32* %arrF8_idx1282, align 4
  %tst_r14_b = icmp eq i32 %val_r14d_b, 0
  br i1 %tst_r14_b, label %bb_12a0, label %bb_1290

bb_1290:
  ; rsi = &visited[rdx]
  %rbx_ld3 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p3 = bitcast i8* %rbx_ld3 to i32*
  %rdx_a2_b = load i64, i64* %rdx_reg, align 8
  %vis_ptr2 = getelementptr inbounds i32, i32* %rbx_i32p3, i64 %rdx_a2_b
  store i32* %vis_ptr2, i32** %rsi_ptr, align 8
  %vis_val2 = load i32, i32* %vis_ptr2, align 4
  %tst_r11_b = icmp eq i32 %vis_val2, 0
  br i1 %tst_r11_b, label %bb_13f0, label %bb_12a0

bb_12a0:
  ; rdx = rax + 3
  %rax5 = load i64, i64* %rax_reg, align 8
  %rdx_a3 = add i64 %rax5, 3
  store i64 %rdx_a3, i64* %rdx_reg, align 8
  ; cmp rax, 4 ; jz bb_133d
  %is_rax_4 = icmp eq i64 %rax5, 4
  br i1 %is_rax_4, label %bb_133d, label %bb_12ae

bb_12ae:
  ; r10d = arrF8[rcx + rdx]
  %rcx4 = load i64, i64* %rcx_reg, align 8
  %idx12ae = add i64 %rcx4, %rdx_a3
  %arrF8_idx12ae = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %idx12ae
  %val_r10d_b = load i32, i32* %arrF8_idx12ae, align 4
  %tst_r10_b = icmp eq i32 %val_r10d_b, 0
  br i1 %tst_r10_b, label %bb_12cc, label %bb_12bc

bb_12bc:
  ; rsi = &visited[rdx]
  %rbx_ld4 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p4 = bitcast i8* %rbx_ld4 to i32*
  %rdx_a3_b = load i64, i64* %rdx_reg, align 8
  %vis_ptr3 = getelementptr inbounds i32, i32* %rbx_i32p4, i64 %rdx_a3_b
  store i32* %vis_ptr3, i32** %rsi_ptr, align 8
  %vis_val3 = load i32, i32* %vis_ptr3, align 4
  %tst_r9_b = icmp eq i32 %vis_val3, 0
  br i1 %tst_r9_b, label %bb_13f0, label %bb_12cc

bb_12cc:
  ; rdx = rax + 4
  %rax6 = load i64, i64* %rax_reg, align 8
  %rdx_a4 = add i64 %rax6, 4
  store i64 %rdx_a4, i64* %rdx_reg, align 8
  ; cmp rax, 3 ; jz bb_133d
  %is_rax_3 = icmp eq i64 %rax6, 3
  br i1 %is_rax_3, label %bb_133d, label %bb_12d6

bb_12d6:
  ; r14d = arrF8[rcx + rdx]
  %rcx5 = load i64, i64* %rcx_reg, align 8
  %idx12d6 = add i64 %rcx5, %rdx_a4
  %arrF8_idx12d6 = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %idx12d6
  %val_r14d_c = load i32, i32* %arrF8_idx12d6, align 4
  %tst_r14_c = icmp eq i32 %val_r14d_c, 0
  br i1 %tst_r14_c, label %bb_12f4, label %bb_12e4

bb_12e4:
  ; rsi = &visited[rdx]
  %rbx_ld5 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p5 = bitcast i8* %rbx_ld5 to i32*
  %rdx_a4_b = load i64, i64* %rdx_reg, align 8
  %vis_ptr4 = getelementptr inbounds i32, i32* %rbx_i32p5, i64 %rdx_a4_b
  store i32* %vis_ptr4, i32** %rsi_ptr, align 8
  %vis_val4 = load i32, i32* %vis_ptr4, align 4
  %tst_r11_c = icmp eq i32 %vis_val4, 0
  br i1 %tst_r11_c, label %bb_13f0, label %bb_12f4

bb_12f4:
  ; rdx = rax + 5
  %rax7 = load i64, i64* %rax_reg, align 8
  %rdx_a5 = add i64 %rax7, 5
  store i64 %rdx_a5, i64* %rdx_reg, align 8
  ; cmp rax, 2 ; jz bb_133d
  %is_rax_2 = icmp eq i64 %rax7, 2
  br i1 %is_rax_2, label %bb_133d, label %bb_12fe

bb_12fe:
  ; r10d = arrF8[rcx + rdx]
  %rcx6 = load i64, i64* %rcx_reg, align 8
  %idx12fe = add i64 %rcx6, %rdx_a5
  %arrF8_idx12fe = getelementptr inbounds [256 x i32], [256 x i32]* %arrF8, i64 0, i64 %idx12fe
  %val_r10d_c = load i32, i32* %arrF8_idx12fe, align 4
  %tst_r10_c = icmp eq i32 %val_r10d_c, 0
  br i1 %tst_r10_c, label %bb_131c, label %bb_130c

bb_130c:
  ; rsi = &visited[rdx]
  %rbx_ld6 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p6 = bitcast i8* %rbx_ld6 to i32*
  %rdx_a5_b = load i64, i64* %rdx_reg, align 8
  %vis_ptr5 = getelementptr inbounds i32, i32* %rbx_i32p6, i64 %rdx_a5_b
  store i32* %vis_ptr5, i32** %rsi_ptr, align 8
  %vis_val5 = load i32, i32* %vis_ptr5, align 4
  %tst_r9_c = icmp eq i32 %vis_val5, 0
  br i1 %tst_r9_c, label %bb_13f0, label %bb_131c

bb_131c:
  ; test rax ; jnz bb_133d
  %rax8 = load i64, i64* %rax_reg, align 8
  %is_rax_nonzero = icmp ne i64 %rax8, 0
  br i1 %is_rax_nonzero, label %bb_133d, label %bb_1321

bb_1321:
  ; edx = arrE0[rcx] ; test ; jz bb_133d
  %rcx7 = load i64, i64* %rcx_reg, align 8
  %arrE0_idx = getelementptr inbounds [256 x i32], [256 x i32]* %arrE0, i64 0, i64 %rcx7
  %edx_from_E0 = load i32, i32* %arrE0_idx, align 4
  %is_edx_zero = icmp eq i32 %edx_from_E0, 0
  br i1 %is_edx_zero, label %bb_133d, label %bb_1329

bb_1329:
  ; eax = [rbx+0x18]; rsi = &visited[6]; edx = 6; test eax ; jz bb_13f0
  %rbx_ld7 = load i8*, i8** %rbx_mem, align 8
  %rbx_i32p7 = bitcast i8* %rbx_ld7 to i32*
  %vis6_ptr = getelementptr inbounds i32, i32* %rbx_i32p7, i64 6
  %eax_val = load i32, i32* %vis6_ptr, align 4
  store i32* %vis6_ptr, i32** %rsi_ptr, align 8
  store i64 6, i64* %rdx_reg, align 8
  %is_eax_zero = icmp eq i32 %eax_val, 0
  br i1 %is_eax_zero, label %bb_13f0, label %bb_133d

bb_133d:
  ; sub rdi, 1
  %rdi_cur1 = load i64, i64* %rdi_reg, align 8
  %rdi_dec = add i64 %rdi_cur1, -1
  store i64 %rdi_dec, i64* %rdi_reg, align 8
  br label %bb_1341

bb_1341:
  ; test rdi ; jnz bb_1208
  %rdi_cur2 = load i64, i64* %rdi_reg, align 8
  %rdi_nz = icmp ne i64 %rdi_cur2, 0
  br i1 %rdi_nz, label %bb_1208, label %bb_134a

bb_134a:
  ; free rbx, r13, r12
  %rbx_ld8 = load i8*, i8** %rbx_mem, align 8
  call void @free(i8* %rbx_ld8)
  %r13_ld1 = load i8*, i8** %r13_mem, align 8
  call void @free(i8* %r13_ld1)
  %r12_ld2 = load i8*, i8** %r12_mem, align 8
  call void @free(i8* %r12_ld2)
  ; printf("DFS preorder from %zu: ", 0)
  %fmt_dfs_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %zero_i64 = add i64 0, 0
  %call_printf1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dfs_ptr, i64 %zero_i64)
  ; test rbp ; jz bb_13ae
  %rbp_cur0 = load i64, i64* %rbp_reg, align 8
  %rbp_zero = icmp eq i64 %rbp_cur0, 0
  br i1 %rbp_zero, label %bb_13ae, label %bb_137c

bb_137c:
  ; rdx = arr138[0]
  %arr138_base0 = getelementptr inbounds [128 x i64], [128 x i64]* %arr138, i64 0, i64 0
  %first_elem = load i64, i64* %arr138_base0, align 8
  ; r12 = "%zu%s"
  ; cmp rbp, 1 ; jnz bb_1421
  %is_rbp_one = icmp ne i64 %rbp_cur0, 1
  br i1 %is_rbp_one, label %bb_1421, label %bb_1398

bb_1398:
  ; rcx = asc_2022+1 (empty string), rsi = "%zu%s"
  %fmt_pair_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  %nl_base = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %empty_str = getelementptr inbounds i8, i8* %nl_base, i64 1
  %call_printf_pair_last = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_pair_ptr, i64 %first_elem, i8* %empty_str)
  br label %bb_13ae

bb_13ae:
  ; print newline
  %nl_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_printf_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl_ptr)
  ; stack guard check
  %sg_saved = load i64, i64* %stack_guard_saved, align 8
  %sg_current = load i64, i64* %stack_guard_saved, align 8
  %sg_diff = icmp ne i64 %sg_saved, %sg_current
  br i1 %sg_diff, label %bb_1487, label %bb_13e9

bb_13e9:
  ret i32 0

bb_13ea:
  ; rdx = rax
  %rax_for_13ea = load i64, i64* %rax_reg, align 8
  store i64 %rax_for_13ea, i64* %rdx_reg, align 8
  br label %bb_13f0

bb_13f0:
  ; rax = rdx + 1
  %rdx2 = load i64, i64* %rdx_reg, align 8
  %rax_plus1 = add i64 %rdx2, 1
  ; [arr138 + rbp*8] = rdx
  %rbp_cur1 = load i64, i64* %rbp_reg, align 8
  %arr138_slot = getelementptr inbounds [128 x i64], [128 x i64]* %arr138, i64 0, i64 %rbp_cur1
  store i64 %rdx2, i64* %arr138_slot, align 8
  ; rbp += 1
  %rbp_inc = add i64 %rbp_cur1, 1
  store i64 %rbp_inc, i64* %rbp_reg, align 8
  ; [r12 + rdi*8] = rdx ; rdi += 1
  %r12_ld3 = load i8*, i8** %r12_mem, align 8
  %r12_i64p3 = bitcast i8* %r12_ld3 to i64*
  %rdi_cur3 = load i64, i64* %rdi_reg, align 8
  %stack_slot_next = getelementptr inbounds i64, i64* %r12_i64p3, i64 %rdi_cur3
  store i64 %rdx2, i64* %stack_slot_next, align 8
  %rdi_inc = add i64 %rdi_cur3, 1
  store i64 %rdi_inc, i64* %rdi_reg, align 8
  ; [r8] = rax
  %r8p = load i64*, i64** %r8_ptr, align 8
  store i64 %rax_plus1, i64* %r8p, align 8
  ; dword ptr [rsi] = 1
  %rsip = load i32*, i32** %rsi_ptr, align 8
  store i32 1, i32* %rsip, align 4
  ; jmp bb_1341
  br label %bb_1341

bb_1412:
  ; cmp rax, 7 ; jnz bb_1208 ; jmp bb_133d
  %rax9 = load i64, i64* %rax_reg, align 8
  %is_rax_7 = icmp ne i64 %rax9, 7
  br i1 %is_rax_7, label %bb_1208, label %bb_133d

bb_1421:
  ; ebx = 1 ; r14 = &" " (aDfsPreorderFro+0x16) ; r13 = base of arr138
  %one64 = add i64 0, 1
  %fmt_dfs_base = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %space_ptr = getelementptr inbounds i8, i8* %fmt_dfs_base, i64 22
  %fmt_pair_base = getelementptr inbounds [6 x i8], [6 x i8]* @.str_fmt, i64 0, i64 0
  ; loop init: ebx = 1
  br label %bb_1430

bb_1430:
  ; print element [rbx-1] with trailing " "
  ; maintain loop index in a phi
  %idx_phi = phi i64 [ %one64, %bb_1421 ], [ %idx_next, %bb_1442 ]
  %elem_ptr = getelementptr inbounds [128 x i64], [128 x i64]* %arr138, i64 0, i64 -1
  %idx_minus1 = add i64 %idx_phi, -1
  %elem_gep = getelementptr inbounds [128 x i64], [128 x i64]* %arr138, i64 0, i64 %idx_minus1
  %elem_val = load i64, i64* %elem_gep, align 8
  %call_printf_loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_pair_base, i64 %elem_val, i8* %space_ptr)
  ; rbx += 1
  br label %bb_1442

bb_1442:
  %idx_next = add i64 %idx_phi, 1
  ; rdx = [r13+rbx*8-8] would be next element; we recompute in loop head
  ; cmp rbx, rbp ; jnz bb_1430 else jump bb_1398
  %rbp_cur2 = load i64, i64* %rbp_reg, align 8
  %cmp_loop = icmp ne i64 %idx_next, %rbp_cur2
  br i1 %cmp_loop, label %bb_1430, label %bb_1398

bb_1455:
  ; free on failure path
  %rbx_fail = load i8*, i8** %rbx_mem, align 8
  call void @free(i8* %rbx_fail)
  %r13_fail = load i8*, i8** %r13_mem, align 8
  call void @free(i8* %r13_fail)
  %r12_fail = load i8*, i8** %r12_mem, align 8
  call void @free(i8* %r12_fail)
  ; printf("DFS preorder from %zu: ", 0)
  %fmt_dfs_ptr2 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %zero_i64_b = add i64 0, 0
  %call_printf_fail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dfs_ptr2, i64 %zero_i64_b)
  br label %bb_13ae

bb_1487:
  call void @__stack_chk_fail()
  unreachable
}

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)