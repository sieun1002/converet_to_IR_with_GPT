; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@__stack_chk_guard = external global i64, align 8
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@unk_2004 = constant [4 x i8] c"%d \00"
@unk_2008 = constant [2 x i8] c"\0A\00"

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() local_unnamed_addr {
L1080:
  %stack = alloca [64 x i8], align 16
  %rbp = alloca i8*, align 8
  %rbx = alloca i8*, align 8
  %rsi = alloca i8*, align 8
  %rdi = alloca i8*, align 8
  %raxv = alloca i8*, align 8
  %rcx = alloca i64, align 8
  %edx = alloca i32, align 4
  %r8d = alloca i32, align 4
  %r12 = alloca i8*, align 8
  %base0 = getelementptr inbounds [64 x i8], [64 x i8]* %stack, i64 0, i64 0
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %ptr_var48 = bitcast i8* %base0 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %ptr_var48, align 16
  %can = load i64, i64* @__stack_chk_guard, align 8
  %canptr = getelementptr inbounds i8, i8* %base0, i64 40
  %canptr_i64 = bitcast i8* %canptr to i64*
  store i64 %can, i64* %canptr_i64, align 8
  store i64 0, i64* %rcx, align 8
  store i8* %base0, i8** %rbp, align 8
  %ptr_var28 = getelementptr inbounds i8, i8* %base0, i64 32
  %ptr_var28_i32 = bitcast i8* %ptr_var28 to i32*
  store i32 4, i32* %ptr_var28_i32, align 4
  %v2 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %ptr_var38 = getelementptr inbounds i8, i8* %base0, i64 16
  %ptr_var38_vec = bitcast i8* %ptr_var38 to <4 x i32>*
  store <4 x i32> %v2, <4 x i32>* %ptr_var38_vec, align 16
  store i8* %base0, i8** %rbx, align 8
  store i8* %base0, i8** %rsi, align 8
  br label %L10D0

L10D0:
  %rsi1 = load i8*, i8** %rsi, align 8
  %p_rsi_plus4 = getelementptr inbounds i8, i8* %rsi1, i64 4
  %p32_rsi_plus4 = bitcast i8* %p_rsi_plus4 to i32*
  %edx_val = load i32, i32* %p32_rsi_plus4, align 4
  store i32 %edx_val, i32* %edx, align 4
  %p32_rsi = bitcast i8* %rsi1 to i32*
  %r8d_val = load i32, i32* %p32_rsi, align 4
  store i32 %r8d_val, i32* %r8d, align 4
  store i8* %p_rsi_plus4, i8** %rdi, align 8
  store i8* %rsi1, i8** %raxv, align 8
  %edx2 = load i32, i32* %edx, align 4
  %r8d2 = load i32, i32* %r8d, align 4
  %cmp108d0 = icmp sle i32 %r8d2, %edx2
  br i1 %cmp108d0, label %L12C3, label %L10E6

L10E6:
  %rsi2 = load i8*, i8** %rsi, align 8
  %p_rsi_plus4_b = getelementptr inbounds i8, i8* %rsi2, i64 4
  %r8d3 = load i32, i32* %r8d, align 4
  %p32_rsi_plus4_b = bitcast i8* %p_rsi_plus4_b to i32*
  store i32 %r8d3, i32* %p32_rsi_plus4_b, align 4
  %rcx0 = load i64, i64* %rcx, align 8
  %is_zero = icmp eq i64 %rcx0, 0
  br i1 %is_zero, label %L1234, label %L10F3

L10F3:
  %rax1 = load i8*, i8** %raxv, align 8
  %p_rax_minus4 = getelementptr inbounds i8, i8* %rax1, i64 -4
  %p32_rax_minus4 = bitcast i8* %p_rax_minus4 to i32*
  %r8d4 = load i32, i32* %p32_rax_minus4, align 4
  store i32 %r8d4, i32* %r8d, align 4
  %edx3 = load i32, i32* %edx, align 4
  %r8d5 = load i32, i32* %r8d, align 4
  %cmp10f3 = icmp sle i32 %r8d5, %edx3
  br i1 %cmp10f3, label %L125B, label %L1100

L1100:
  %rax2 = load i8*, i8** %raxv, align 8
  %p32_rax = bitcast i8* %rax2 to i32*
  %r8d6 = load i32, i32* %r8d, align 4
  store i32 %r8d6, i32* %p32_rax, align 4
  %rcx1 = load i64, i64* %rcx, align 8
  %cmp_rcx1 = icmp eq i64 %rcx1, 1
  br i1 %cmp_rcx1, label %L1263, label %L110D

L110D:
  %rax3 = load i8*, i8** %raxv, align 8
  %p_rax_minus8 = getelementptr inbounds i8, i8* %rax3, i64 -8
  %p32_rax_minus8 = bitcast i8* %p_rax_minus8 to i32*
  %r8d7 = load i32, i32* %p32_rax_minus8, align 4
  store i32 %r8d7, i32* %r8d, align 4
  %edx4 = load i32, i32* %edx, align 4
  %r8d8 = load i32, i32* %r8d, align 4
  %cmp110d = icmp sle i32 %r8d8, %edx4
  br i1 %cmp110d, label %L1296, label %L111A

L111A:
  %rax4 = load i8*, i8** %raxv, align 8
  %p_rax_minus4_b = getelementptr inbounds i8, i8* %rax4, i64 -4
  %p32_rax_minus4_b = bitcast i8* %p_rax_minus4_b to i32*
  %r8d9 = load i32, i32* %r8d, align 4
  store i32 %r8d9, i32* %p32_rax_minus4_b, align 4
  %rcx2 = load i64, i64* %rcx, align 8
  %cmp_rcx2 = icmp eq i64 %rcx2, 2
  br i1 %cmp_rcx2, label %L12A2, label %L1128

L1128:
  %rax5 = load i8*, i8** %raxv, align 8
  %p_rax_minus12 = getelementptr inbounds i8, i8* %rax5, i64 -12
  %p32_rax_minus12 = bitcast i8* %p_rax_minus12 to i32*
  %r8d10 = load i32, i32* %p32_rax_minus12, align 4
  store i32 %r8d10, i32* %r8d, align 4
  %edx5 = load i32, i32* %edx, align 4
  %r8d11 = load i32, i32* %r8d, align 4
  %cmp1128 = icmp sle i32 %r8d11, %edx5
  br i1 %cmp1128, label %L12CE, label %L1135

L1135:
  %rax6 = load i8*, i8** %raxv, align 8
  %p_rax_minus8_b = getelementptr inbounds i8, i8* %rax6, i64 -8
  %p32_rax_minus8_b = bitcast i8* %p_rax_minus8_b to i32*
  %r8d12 = load i32, i32* %r8d, align 4
  store i32 %r8d12, i32* %p32_rax_minus8_b, align 4
  %rcx3 = load i64, i64* %rcx, align 8
  %cmp_rcx3 = icmp eq i64 %rcx3, 3
  br i1 %cmp_rcx3, label %L12DA, label %L113D

L113D:
  %rax7 = load i8*, i8** %raxv, align 8
  %p_rax_minus16 = getelementptr inbounds i8, i8* %rax7, i64 -16
  %p32_rax_minus16 = bitcast i8* %p_rax_minus16 to i32*
  %r8d13 = load i32, i32* %p32_rax_minus16, align 4
  store i32 %r8d13, i32* %r8d, align 4
  %edx6 = load i32, i32* %edx, align 4
  %r8d14 = load i32, i32* %r8d, align 4
  %cmp113d = icmp sle i32 %r8d14, %edx6
  br i1 %cmp113d, label %L12FB, label %L1143

L1143:
  %rax8 = load i8*, i8** %raxv, align 8
  %p_rax_minus12_b = getelementptr inbounds i8, i8* %rax8, i64 -12
  %p32_rax_minus12_b = bitcast i8* %p_rax_minus12_b to i32*
  %r8d15 = load i32, i32* %r8d, align 4
  store i32 %r8d15, i32* %p32_rax_minus12_b, align 4
  %rcx4 = load i64, i64* %rcx, align 8
  %cmp_rcx4 = icmp eq i64 %rcx4, 4
  br i1 %cmp_rcx4, label %L1307, label %L1150

L1150:
  %rax9 = load i8*, i8** %raxv, align 8
  %p_rax_minus20 = getelementptr inbounds i8, i8* %rax9, i64 -20
  %p32_rax_minus20 = bitcast i8* %p_rax_minus20 to i32*
  %r8d16 = load i32, i32* %p32_rax_minus20, align 4
  store i32 %r8d16, i32* %r8d, align 4
  %edx7 = load i32, i32* %edx, align 4
  %r8d17 = load i32, i32* %r8d, align 4
  %cmp1150 = icmp sle i32 %r8d17, %edx7
  br i1 %cmp1150, label %L132B, label %L1154

L1154:
  %rax10 = load i8*, i8** %raxv, align 8
  %p_rax_minus12_c = getelementptr inbounds i8, i8* %rax10, i64 -12
  %p32_rax_minus12_c = bitcast i8* %p_rax_minus12_c to i32*
  %r8d18 = load i32, i32* %r8d, align 4
  store i32 %r8d18, i32* %p32_rax_minus12_c, align 4
  %rcx5 = load i64, i64* %rcx, align 8
  %cmp_rcx5 = icmp eq i64 %rcx5, 5
  br i1 %cmp_rcx5, label %L1337, label %L115E

L115E:
  %rax11 = load i8*, i8** %raxv, align 8
  %p_rax_minus20_b = getelementptr inbounds i8, i8* %rax11, i64 -20
  %p32_rax_minus20_b = bitcast i8* %p_rax_minus20_b to i32*
  %r8d19 = load i32, i32* %p32_rax_minus20_b, align 4
  store i32 %r8d19, i32* %r8d, align 4
  %edx8 = load i32, i32* %edx, align 4
  %r8d20 = load i32, i32* %r8d, align 4
  %cmp115e = icmp sle i32 %r8d20, %edx8
  br i1 %cmp115e, label %L135B, label %L116B

L116B:
  %rax12 = load i8*, i8** %raxv, align 8
  %p_rax_minus16_b = getelementptr inbounds i8, i8* %rax12, i64 -16
  %p32_rax_minus16_b = bitcast i8* %p_rax_minus16_b to i32*
  %r8d21 = load i32, i32* %r8d, align 4
  store i32 %r8d21, i32* %p32_rax_minus16_b, align 4
  %rcx6 = load i64, i64* %rcx, align 8
  %cmp_rcx6 = icmp eq i64 %rcx6, 6
  br i1 %cmp_rcx6, label %L1367, label %L1179

L1179:
  %rax13 = load i8*, i8** %raxv, align 8
  %p_rax_minus24 = getelementptr inbounds i8, i8* %rax13, i64 -24
  %p32_rax_minus24 = bitcast i8* %p_rax_minus24 to i32*
  %r8d22 = load i32, i32* %p32_rax_minus24, align 4
  store i32 %r8d22, i32* %r8d, align 4
  %edx9 = load i32, i32* %edx, align 4
  %r8d23 = load i32, i32* %r8d, align 4
  %cmp1179 = icmp sle i32 %r8d23, %edx9
  br i1 %cmp1179, label %L1387, label %L1186

L1186:
  %rax14 = load i8*, i8** %raxv, align 8
  %p_rax_minus20_c = getelementptr inbounds i8, i8* %rax14, i64 -20
  %p32_rax_minus20_c = bitcast i8* %p_rax_minus20_c to i32*
  %r8d24 = load i32, i32* %r8d, align 4
  store i32 %r8d24, i32* %p32_rax_minus20_c, align 4
  %rcx7 = load i64, i64* %rcx, align 8
  %cmp_rcx7 = icmp eq i64 %rcx7, 7
  br i1 %cmp_rcx7, label %L1393, label %L1194

L1194:
  %rax15 = load i8*, i8** %raxv, align 8
  %p_rax_minus28 = getelementptr inbounds i8, i8* %rax15, i64 -28
  %p32_rax_minus28 = bitcast i8* %p_rax_minus28 to i32*
  %r8d25 = load i32, i32* %p32_rax_minus28, align 4
  store i32 %r8d25, i32* %r8d, align 4
  %edx10 = load i32, i32* %edx, align 4
  %r8d26 = load i32, i32* %r8d, align 4
  %cmp1194 = icmp sle i32 %r8d26, %edx10
  br i1 %cmp1194, label %L13B3, label %L11A1

L11A1:
  %rax16 = load i8*, i8** %raxv, align 8
  %p_rax_minus24_b = getelementptr inbounds i8, i8* %rax16, i64 -24
  %p32_rax_minus24_b = bitcast i8* %p_rax_minus24_b to i32*
  %r8d27 = load i32, i32* %r8d, align 4
  store i32 %r8d27, i32* %p32_rax_minus24_b, align 4
  %rcx8 = load i64, i64* %rcx, align 8
  %cmp_rcx7b = icmp eq i64 %rcx8, 7
  br i1 %cmp_rcx7b, label %L1393, label %L11AF

L11AF:
  %rax17 = load i8*, i8** %raxv, align 8
  %p_rax_minus32 = getelementptr inbounds i8, i8* %rax17, i64 -32
  %p32_rax_minus32 = bitcast i8* %p_rax_minus32 to i32*
  %r8d28 = load i32, i32* %p32_rax_minus32, align 4
  store i32 %r8d28, i32* %r8d, align 4
  %edx11 = load i32, i32* %edx, align 4
  %r8d29 = load i32, i32* %r8d, align 4
  %cmp11af = icmp sle i32 %r8d29, %edx11
  br i1 %cmp11af, label %L11B3, label %L11BC

L11B3:
  br label %L13B3

L11BC:
  %rax18 = load i8*, i8** %raxv, align 8
  %p_rax_minus28_b = getelementptr inbounds i8, i8* %rax18, i64 -28
  %p32_rax_minus28_b = bitcast i8* %p_rax_minus28_b to i32*
  %r8d30 = load i32, i32* %r8d, align 4
  store i32 %r8d30, i32* %p32_rax_minus28_b, align 4
  %rdi_now = load i8*, i8** %rdi, align 8
  store i8* %rdi_now, i8** %rsi, align 8
  %rbp_now = load i8*, i8** %rbp, align 8
  store i8* %rbp_now, i8** %raxv, align 8
  br label %L11C6

L11C6:
  %rcx9 = load i64, i64* %rcx, align 8
  %rcx_inc = add i64 %rcx9, 1
  store i64 %rcx_inc, i64* %rcx, align 8
  %rax19 = load i8*, i8** %raxv, align 8
  %p32_rax19 = bitcast i8* %rax19 to i32*
  %edx12 = load i32, i32* %edx, align 4
  store i32 %edx12, i32* %p32_rax19, align 4
  %rcx10 = load i64, i64* %rcx, align 8
  %cmp9 = icmp ne i64 %rcx10, 9
  br i1 %cmp9, label %L10D0, label %L11D6

L11D6:
  %rbp0 = load i8*, i8** %rbp, align 8
  %rbp_inc = getelementptr inbounds i8, i8* %rbp0, i64 40
  store i8* %rbp_inc, i8** %rbp, align 8
  %fmt1 = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  store i8* %fmt1, i8** %r12, align 8
  br label %L11E8

L11E8:
  %rbx0 = load i8*, i8** %rbx, align 8
  %p32_rbx = bitcast i8* %rbx0 to i32*
  %val = load i32, i32* %p32_rbx, align 4
  store i32 %val, i32* %edx, align 4
  %fmt_ptr = load i8*, i8** %r12, align 8
  store i8* %fmt_ptr, i8** %rsi, align 8
  %rbx1 = getelementptr inbounds i8, i8* %rbx0, i64 4
  store i8* %rbx1, i8** %rbx, align 8
  %rsi_print = load i8*, i8** %rsi, align 8
  %edx_print = load i32, i32* %edx, align 4
  %call = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %rsi_print, i32 %edx_print)
  %rbp1 = load i8*, i8** %rbp, align 8
  %rbx2 = load i8*, i8** %rbx, align 8
  %cmp_loop = icmp ne i8* %rbp1, %rbx2
  br i1 %cmp_loop, label %L11E8, label %L1202

L1202:
  %fmt2 = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  store i8* %fmt2, i8** %rsi, align 8
  %rsi_line = load i8*, i8** %rsi, align 8
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %rsi_line)
  br label %L1215

L1215:
  %can_saved = load i64, i64* %canptr_i64, align 8
  %can_now = load i64, i64* @__stack_chk_guard, align 8
  %cmp_can = icmp ne i64 %can_saved, %can_now
  br i1 %cmp_can, label %L1427, label %L1229

L1229:
  ret i32 0

L1234:
  %edx0 = load i32, i32* %edx, align 4
  %p0x = bitcast i8* %base0 to i32*
  store i32 %edx0, i32* %p0x, align 4
  %rdi0 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4x = getelementptr inbounds i8, i8* %rdi0, i64 4
  %p32_rdi_plus4x = bitcast i8* %p_rdi_plus4x to i32*
  %edxnew = load i32, i32* %p32_rdi_plus4x, align 4
  store i32 %edxnew, i32* %edx, align 4
  %rsi0 = load i8*, i8** %rsi, align 8
  %rsi_added = getelementptr inbounds i8, i8* %rsi0, i64 8
  store i8* %rsi_added, i8** %rsi, align 8
  store i8* %rdi0, i8** %raxv, align 8
  %p32_rdi0 = bitcast i8* %rdi0 to i32*
  %ecxval = load i32, i32* %p32_rdi0, align 4
  %ecx64 = zext i32 %ecxval to i64
  store i64 %ecx64, i64* %rcx, align 8
  %edxC = load i32, i32* %edx, align 4
  %ecxtr = trunc i64 %ecx64 to i32
  %cmp1234 = icmp sle i32 %ecxtr, %edxC
  br i1 %cmp1234, label %L13CC, label %L124B

L124B:
  %ecx32l = trunc i64 %ecx64 to i32
  store i32 %ecx32l, i32* %p32_rdi_plus4x, align 4
  %rsiA = load i8*, i8** %rsi, align 8
  store i8* %rsiA, i8** %rdi, align 8
  store i8* %rdi0, i8** %rsi, align 8
  store i64 1, i64* %rcx, align 8
  br label %L10F3

L125B:
  %rdi1 = load i8*, i8** %rdi, align 8
  store i8* %rdi1, i8** %rsi, align 8
  br label %L11C6

L1263:
  %edx13 = load i32, i32* %edx, align 4
  %p0 = bitcast i8* %base0 to i32*
  store i32 %edx13, i32* %p0, align 4
  %rdi2 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4 = getelementptr inbounds i8, i8* %rdi2, i64 4
  %p32_rdi_plus4 = bitcast i8* %p_rdi_plus4 to i32*
  %edx14 = load i32, i32* %p32_rdi_plus4, align 4
  store i32 %edx14, i32* %edx, align 4
  store i8* %p_rdi_plus4, i8** %rsi, align 8
  store i8* %rdi2, i8** %raxv, align 8
  %p32_rdi = bitcast i8* %rdi2 to i32*
  %ecx_i32 = load i32, i32* %p32_rdi, align 4
  %ecx_z = zext i32 %ecx_i32 to i64
  store i64 %ecx_z, i64* %rcx, align 8
  %edx15 = load i32, i32* %edx, align 4
  %ecx_trunc_forcmp = trunc i64 %ecx_z to i32
  %cmp1263 = icmp sge i32 %edx15, %ecx_trunc_forcmp
  br i1 %cmp1263, label %L13BF, label %L127A

L127A:
  %ecx32 = trunc i64 %ecx_z to i32
  store i32 %ecx32, i32* %p32_rdi_plus4, align 4
  store i64 2, i64* %rcx, align 8
  br label %L1288

L1288:
  %rsi_curr = load i8*, i8** %rsi, align 8
  %rdi_curr = load i8*, i8** %rdi, align 8
  store i8* %rsi_curr, i8** %rdi, align 8
  store i8* %rdi_curr, i8** %rsi, align 8
  br label %L10F3

L1296:
  %rsi3 = load i8*, i8** %rsi, align 8
  %rax_new = getelementptr inbounds i8, i8* %rsi3, i64 -4
  store i8* %rax_new, i8** %raxv, align 8
  %rdi3 = load i8*, i8** %rdi, align 8
  store i8* %rdi3, i8** %rsi, align 8
  br label %L11C6

L12A2:
  %edx16 = load i32, i32* %edx, align 4
  %p0b = bitcast i8* %base0 to i32*
  store i32 %edx16, i32* %p0b, align 4
  %rdi4 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_b = getelementptr inbounds i8, i8* %rdi4, i64 4
  %p32_rdi_plus4_b = bitcast i8* %p_rdi_plus4_b to i32*
  %edx17 = load i32, i32* %p32_rdi_plus4_b, align 4
  store i32 %edx17, i32* %edx, align 4
  store i8* %p_rdi_plus4_b, i8** %rsi, align 8
  store i8* %rdi4, i8** %raxv, align 8
  %p32_rdi_b = bitcast i8* %rdi4 to i32*
  %ecx_i32_b = load i32, i32* %p32_rdi_b, align 4
  %ecx_z_b = zext i32 %ecx_i32_b to i64
  store i64 %ecx_z_b, i64* %rcx, align 8
  %edx18 = load i32, i32* %edx, align 4
  %ecx_trunc_b = trunc i64 %ecx_z_b to i32
  %cmp12a2 = icmp sle i32 %ecx_trunc_b, %edx18
  br i1 %cmp12a2, label %L1400, label %L12B9

L12B9:
  %ecx32_b = trunc i64 %ecx_z_b to i32
  store i32 %ecx32_b, i32* %p32_rdi_plus4_b, align 4
  store i64 3, i64* %rcx, align 8
  br label %L1288

L12C3:
  %rdi_c = load i8*, i8** %rdi, align 8
  store i8* %rdi_c, i8** %rsi, align 8
  store i8* %rdi_c, i8** %raxv, align 8
  br label %L11C6

L12CE:
  %rsi4 = load i8*, i8** %rsi, align 8
  %rax_lea = getelementptr inbounds i8, i8* %rsi4, i64 -8
  store i8* %rax_lea, i8** %raxv, align 8
  %rdi5 = load i8*, i8** %rdi, align 8
  store i8* %rdi5, i8** %rsi, align 8
  br label %L11C6

L12DA:
  %edx19 = load i32, i32* %edx, align 4
  %p0c = bitcast i8* %base0 to i32*
  store i32 %edx19, i32* %p0c, align 4
  %rdi6 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_c = getelementptr inbounds i8, i8* %rdi6, i64 4
  %p32_rdi_plus4_c = bitcast i8* %p_rdi_plus4_c to i32*
  %edx20 = load i32, i32* %p32_rdi_plus4_c, align 4
  store i32 %edx20, i32* %edx, align 4
  store i8* %p_rdi_plus4_c, i8** %rsi, align 8
  store i8* %rdi6, i8** %raxv, align 8
  %p32_rdi_c = bitcast i8* %rdi6 to i32*
  %ecx_i32_c = load i32, i32* %p32_rdi_c, align 4
  %ecx_z_c = zext i32 %ecx_i32_c to i64
  store i64 %ecx_z_c, i64* %rcx, align 8
  %edx21 = load i32, i32* %edx, align 4
  %ecx_trunc_c = trunc i64 %ecx_z_c to i32
  %cmp12da = icmp sge i32 %edx21, %ecx_trunc_c
  br i1 %cmp12da, label %L140D, label %L12F1

L12F1:
  %ecx32_c = trunc i64 %ecx_z_c to i32
  store i32 %ecx32_c, i32* %p32_rdi_plus4_c, align 4
  store i64 4, i64* %rcx, align 8
  br label %L1288

L12FB:
  %rsi5 = load i8*, i8** %rsi, align 8
  %rax_lea2 = getelementptr inbounds i8, i8* %rsi5, i64 -12
  store i8* %rax_lea2, i8** %raxv, align 8
  %rdi7 = load i8*, i8** %rdi, align 8
  store i8* %rdi7, i8** %rsi, align 8
  br label %L11C6

L1307:
  %edx22 = load i32, i32* %edx, align 4
  %p0d = bitcast i8* %base0 to i32*
  store i32 %edx22, i32* %p0d, align 4
  %rdi8 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_d = getelementptr inbounds i8, i8* %rdi8, i64 4
  %p32_rdi_plus4_d = bitcast i8* %p_rdi_plus4_d to i32*
  %edx23 = load i32, i32* %p32_rdi_plus4_d, align 4
  store i32 %edx23, i32* %edx, align 4
  store i8* %p_rdi_plus4_d, i8** %rsi, align 8
  store i8* %rdi8, i8** %raxv, align 8
  %p32_rdi_d = bitcast i8* %rdi8 to i32*
  %ecx_i32_d = load i32, i32* %p32_rdi_d, align 4
  %ecx_z_d = zext i32 %ecx_i32_d to i64
  store i64 %ecx_z_d, i64* %rcx, align 8
  %edx24 = load i32, i32* %edx, align 4
  %ecx_trunc_d = trunc i64 %ecx_z_d to i32
  %cmp1307 = icmp sge i32 %edx24, %ecx_trunc_d
  br i1 %cmp1307, label %L13E6, label %L131E

L131E:
  %ecx32_d = trunc i64 %ecx_z_d to i32
  store i32 %ecx32_d, i32* %p32_rdi_plus4_d, align 4
  store i64 5, i64* %rcx, align 8
  br label %L1288

L132B:
  %rsi6 = load i8*, i8** %rsi, align 8
  %rax_lea3 = getelementptr inbounds i8, i8* %rsi6, i64 -16
  store i8* %rax_lea3, i8** %raxv, align 8
  %rdi9 = load i8*, i8** %rdi, align 8
  store i8* %rdi9, i8** %rsi, align 8
  br label %L11C6

L1337:
  %edx25 = load i32, i32* %edx, align 4
  %p0e = bitcast i8* %base0 to i32*
  store i32 %edx25, i32* %p0e, align 4
  %rdi10 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_e = getelementptr inbounds i8, i8* %rdi10, i64 4
  %p32_rdi_plus4_e = bitcast i8* %p_rdi_plus4_e to i32*
  %edx26 = load i32, i32* %p32_rdi_plus4_e, align 4
  store i32 %edx26, i32* %edx, align 4
  store i8* %p_rdi_plus4_e, i8** %rsi, align 8
  store i8* %rdi10, i8** %raxv, align 8
  %p32_rdi_e = bitcast i8* %rdi10 to i32*
  %ecx_i32_e = load i32, i32* %p32_rdi_e, align 4
  %ecx_z_e = zext i32 %ecx_i32_e to i64
  store i64 %ecx_z_e, i64* %rcx, align 8
  %edx27 = load i32, i32* %edx, align 4
  %ecx_trunc_e = trunc i64 %ecx_z_e to i32
  %cmp1337 = icmp sge i32 %edx27, %ecx_trunc_e
  br i1 %cmp1337, label %L13F3, label %L134E

L134E:
  %ecx32_e = trunc i64 %ecx_z_e to i32
  store i32 %ecx32_e, i32* %p32_rdi_plus4_e, align 4
  store i64 6, i64* %rcx, align 8
  br label %L1288

L135B:
  %rsi7 = load i8*, i8** %rsi, align 8
  %rax_lea4 = getelementptr inbounds i8, i8* %rsi7, i64 -20
  store i8* %rax_lea4, i8** %raxv, align 8
  %rdi11 = load i8*, i8** %rdi, align 8
  store i8* %rdi11, i8** %rsi, align 8
  br label %L11C6

L1367:
  %edx28 = load i32, i32* %edx, align 4
  %p0f = bitcast i8* %base0 to i32*
  store i32 %edx28, i32* %p0f, align 4
  %rdi12 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_f = getelementptr inbounds i8, i8* %rdi12, i64 4
  %p32_rdi_plus4_f = bitcast i8* %p_rdi_plus4_f to i32*
  %edx29 = load i32, i32* %p32_rdi_plus4_f, align 4
  store i32 %edx29, i32* %edx, align 4
  store i8* %p_rdi_plus4_f, i8** %rsi, align 8
  store i8* %rdi12, i8** %raxv, align 8
  %p32_rdi_f = bitcast i8* %rdi12 to i32*
  %ecx_i32_f = load i32, i32* %p32_rdi_f, align 4
  %ecx_z_f = zext i32 %ecx_i32_f to i64
  store i64 %ecx_z_f, i64* %rcx, align 8
  %edx30 = load i32, i32* %edx, align 4
  %ecx_trunc_f = trunc i64 %ecx_z_f to i32
  %cmp1367 = icmp sge i32 %edx30, %ecx_trunc_f
  br i1 %cmp1367, label %L13D9, label %L137A

L137A:
  %ecx32_f = trunc i64 %ecx_z_f to i32
  store i32 %ecx32_f, i32* %p32_rdi_plus4_f, align 4
  store i64 7, i64* %rcx, align 8
  br label %L1288

L1387:
  %rsi8 = load i8*, i8** %rsi, align 8
  %rax_lea5 = getelementptr inbounds i8, i8* %rsi8, i64 -24
  store i8* %rax_lea5, i8** %raxv, align 8
  %rdi13 = load i8*, i8** %rdi, align 8
  store i8* %rdi13, i8** %rsi, align 8
  br label %L11C6

L1393:
  %edx31 = load i32, i32* %edx, align 4
  %p0g = bitcast i8* %base0 to i32*
  store i32 %edx31, i32* %p0g, align 4
  %rdi14 = load i8*, i8** %rdi, align 8
  %p_rdi_plus4_g = getelementptr inbounds i8, i8* %rdi14, i64 4
  %p32_rdi_plus4_g = bitcast i8* %p_rdi_plus4_g to i32*
  %edx32 = load i32, i32* %p32_rdi_plus4_g, align 4
  store i32 %edx32, i32* %edx, align 4
  store i8* %p_rdi_plus4_g, i8** %rsi, align 8
  store i8* %rdi14, i8** %raxv, align 8
  %p32_rdi_g = bitcast i8* %rdi14 to i32*
  %ecx_i32_g = load i32, i32* %p32_rdi_g, align 4
  %ecx_z_g = zext i32 %ecx_i32_g to i64
  store i64 %ecx_z_g, i64* %rcx, align 8
  %edx33 = load i32, i32* %edx, align 4
  %ecx_trunc_g = trunc i64 %ecx_z_g to i32
  %cmp1393 = icmp sge i32 %edx33, %ecx_trunc_g
  br i1 %cmp1393, label %L141A, label %L13A6

L13A6:
  %ecx32_g = trunc i64 %ecx_z_g to i32
  store i32 %ecx32_g, i32* %p32_rdi_plus4_g, align 4
  store i64 8, i64* %rcx, align 8
  br label %L1288

L13B3:
  %rsi9 = load i8*, i8** %rsi, align 8
  %rax_lea6 = getelementptr inbounds i8, i8* %rsi9, i64 -28
  store i8* %rax_lea6, i8** %raxv, align 8
  %rdi15 = load i8*, i8** %rdi, align 8
  store i8* %rdi15, i8** %rsi, align 8
  br label %L11C6

L13BF:
  %rsi10 = load i8*, i8** %rsi, align 8
  store i8* %rsi10, i8** %raxv, align 8
  store i64 2, i64* %rcx, align 8
  br label %L11C6

L13CC:
  %rsi11 = load i8*, i8** %rsi, align 8
  store i8* %rsi11, i8** %raxv, align 8
  store i64 1, i64* %rcx, align 8
  br label %L11C6

L13D9:
  %rsi12 = load i8*, i8** %rsi, align 8
  store i8* %rsi12, i8** %raxv, align 8
  store i64 7, i64* %rcx, align 8
  br label %L11C6

L13E6:
  %rsi13 = load i8*, i8** %rsi, align 8
  store i8* %rsi13, i8** %raxv, align 8
  store i64 5, i64* %rcx, align 8
  br label %L11C6

L13F3:
  %rsi14 = load i8*, i8** %rsi, align 8
  store i8* %rsi14, i8** %raxv, align 8
  store i64 6, i64* %rcx, align 8
  br label %L11C6

L1400:
  %rsi15 = load i8*, i8** %rsi, align 8
  store i8* %rsi15, i8** %raxv, align 8
  store i64 3, i64* %rcx, align 8
  br label %L11C6

L140D:
  %rsi16 = load i8*, i8** %rsi, align 8
  store i8* %rsi16, i8** %raxv, align 8
  store i64 4, i64* %rcx, align 8
  br label %L11C6

L141A:
  %rsi17 = load i8*, i8** %rsi, align 8
  store i8* %rsi17, i8** %raxv, align 8
  store i64 8, i64* %rcx, align 8
  br label %L11C6

L1427:
  call void @___stack_chk_fail()
  unreachable
}