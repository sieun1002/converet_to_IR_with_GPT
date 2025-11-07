; ModuleID = 'main_translation'
source_filename = "main_translation.ll"
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16
@unk_2004 = external global i8, align 1
@unk_2008 = external global i8, align 1
@__stack_chk_guard = external global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() local_unnamed_addr {
entry:
  %arr = alloca [10 x i32], align 16
  %rbp = alloca i32*, align 8
  %rbx = alloca i32*, align 8
  %rsi = alloca i32*, align 8
  %rdi = alloca i32*, align 8
  %rax = alloca i32*, align 8
  %rcx = alloca i64, align 8
  %edx = alloca i32, align 4
  %r8d = alloca i32, align 4
  %r12 = alloca i8*, align 8
  %canary = alloca i64, align 8
  %arr.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %guard.init = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard.init, i64* %canary, align 8
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %p0v = bitcast i32* %arr.i32 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %p0v, align 16
  %p4 = getelementptr inbounds i32, i32* %arr.i32, i64 4
  %p4v = bitcast i32* %p4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %p4v, align 16
  %p8 = getelementptr inbounds i32, i32* %arr.i32, i64 8
  store i32 4, i32* %p8, align 4
  store i32* %arr.i32, i32** %rbp, align 8
  store i32* %arr.i32, i32** %rbx, align 8
  store i32* %arr.i32, i32** %rsi, align 8
  store i64 0, i64* %rcx, align 8
  br label %loc_10D0

loc_10D0:                                         ; preds = %loc_11C6, %entry
  %rsi0 = load i32*, i32** %rsi, align 8
  %p_next = getelementptr inbounds i32, i32* %rsi0, i64 1
  %edx0 = load i32, i32* %p_next, align 4
  store i32 %edx0, i32* %edx, align 4
  %r8_0 = load i32, i32* %rsi0, align 4
  store i32 %r8_0, i32* %r8d, align 4
  store i32* %p_next, i32** %rdi, align 8
  store i32* %rsi0, i32** %rax, align 8
  %cmp10 = icmp sle i32 %r8_0, %edx0
  br i1 %cmp10, label %loc_12C3, label %loc_10E6

loc_12C3:                                         ; preds = %loc_10D0
  %rdi1 = load i32*, i32** %rdi, align 8
  store i32* %rdi1, i32** %rsi, align 8
  store i32* %rdi1, i32** %rax, align 8
  br label %loc_11C6

loc_10E6:                                         ; preds = %loc_10D0
  %r8e = load i32, i32* %r8d, align 4
  store i32 %r8e, i32* %p_next, align 4
  %rcxv = load i64, i64* %rcx, align 8
  %is_zero = icmp eq i64 %rcxv, 0
  br i1 %is_zero, label %loc_1234, label %loc_10F3

loc_1234:                                         ; preds = %loc_10E6
  %rbp0 = load i32*, i32** %rbp, align 8
  %edxv = load i32, i32* %edx, align 4
  store i32 %edxv, i32* %rbp0, align 4
  %rdi0 = load i32*, i32** %rdi, align 8
  %rdi_plus1 = getelementptr inbounds i32, i32* %rdi0, i64 1
  %edx1 = load i32, i32* %rdi_plus1, align 4
  store i32 %edx1, i32* %edx, align 4
  %rsi_cur = load i32*, i32** %rsi, align 8
  %rsi_plus2 = getelementptr inbounds i32, i32* %rsi_cur, i64 2
  store i32* %rsi_plus2, i32** %rsi, align 8
  store i32* %rdi0, i32** %rax, align 8
  %ecx_load = load i32, i32* %rdi0, align 4
  %edx2 = load i32, i32* %edx, align 4
  %cmp1234 = icmp sle i32 %ecx_load, %edx2
  br i1 %cmp1234, label %loc_13CC, label %loc_124B_then

loc_124B_then:                                    ; preds = %loc_1234
  store i32 %ecx_load, i32* %rdi_plus1, align 4
  %rsi_new = load i32*, i32** %rsi, align 8
  store i32* %rsi_new, i32** %rdi, align 8
  store i32* %rdi0, i32** %rsi, align 8
  store i64 1, i64* %rcx, align 8
  br label %loc_10F3

loc_13CC:                                         ; preds = %loc_1234
  %rsi_now = load i32*, i32** %rsi, align 8
  store i32* %rsi_now, i32** %rax, align 8
  store i64 1, i64* %rcx, align 8
  br label %loc_11C6

loc_10F3:                                         ; preds = %loc_1288, %loc_124B_then, %loc_10E6
  %rax0 = load i32*, i32** %rax, align 8
  %rax_minus1 = getelementptr inbounds i32, i32* %rax0, i64 -1
  %r8_from = load i32, i32* %rax_minus1, align 4
  store i32 %r8_from, i32* %r8d, align 4
  %edx3 = load i32, i32* %edx, align 4
  %cmp10F3 = icmp sle i32 %r8_from, %edx3
  br i1 %cmp10F3, label %loc_125B, label %loc_1100_then

loc_1100_then:                                    ; preds = %loc_10F3
  store i32 %r8_from, i32* %rax0, align 4
  %rcx1 = load i64, i64* %rcx, align 8
  %eq1 = icmp eq i64 %rcx1, 1
  br i1 %eq1, label %loc_1263, label %loc_110D

loc_125B:                                         ; preds = %loc_10F3
  %rdi2 = load i32*, i32** %rdi, align 8
  store i32* %rdi2, i32** %rsi, align 8
  br label %loc_11C6

loc_1263:                                         ; preds = %loc_1100_then
  %rbp1 = load i32*, i32** %rbp, align 8
  %edx4 = load i32, i32* %edx, align 4
  store i32 %edx4, i32* %rbp1, align 4
  %rdi3 = load i32*, i32** %rdi, align 8
  %rdi3_plus1 = getelementptr inbounds i32, i32* %rdi3, i64 1
  %edx5 = load i32, i32* %rdi3_plus1, align 4
  store i32 %edx5, i32* %edx, align 4
  store i32* %rdi3_plus1, i32** %rsi, align 8
  store i32* %rdi3, i32** %rax, align 8
  %ecx2 = load i32, i32* %rdi3, align 4
  %cmp1263 = icmp sge i32 %edx5, %ecx2
  br i1 %cmp1263, label %loc_13BF, label %loc_127A_then

loc_127A_then:                                    ; preds = %loc_1263
  store i32 %ecx2, i32* %rdi3_plus1, align 4
  store i64 2, i64* %rcx, align 8
  br label %loc_1288

loc_13BF:                                         ; preds = %loc_1263
  %rsi2 = load i32*, i32** %rsi, align 8
  store i32* %rsi2, i32** %rax, align 8
  store i64 2, i64* %rcx, align 8
  br label %loc_11C6

loc_1288:                                         ; preds = %loc_137A_then, %loc_134E_then, %loc_131E_then, %loc_12F1_then, %loc_12B9_then, %loc_127A_then
  %rsi3 = load i32*, i32** %rsi, align 8
  %rdi4 = load i32*, i32** %rdi, align 8
  store i32* %rdi4, i32** %rsi, align 8
  store i32* %rsi3, i32** %rdi, align 8
  br label %loc_10F3

loc_110D:                                         ; preds = %loc_1100_then
  %rax1 = load i32*, i32** %rax, align 8
  %ptr_m2 = getelementptr inbounds i32, i32* %rax1, i64 -2
  %r8v2 = load i32, i32* %ptr_m2, align 4
  store i32 %r8v2, i32* %r8d, align 4
  %edx6 = load i32, i32* %edx, align 4
  %cmp110D = icmp sle i32 %r8v2, %edx6
  br i1 %cmp110D, label %loc_1296, label %loc_111A_then

loc_111A_then:                                    ; preds = %loc_110D
  store i32 %r8v2, i32* %rax_minus1, align 4
  %rcx2 = load i64, i64* %rcx, align 8
  %eq2 = icmp eq i64 %rcx2, 2
  br i1 %eq2, label %loc_12A2, label %loc_1128

loc_1296:                                         ; preds = %loc_110D
  %rsi4 = load i32*, i32** %rsi, align 8
  %rax_new = getelementptr inbounds i32, i32* %rsi4, i64 -1
  store i32* %rax_new, i32** %rax, align 8
  %rdi5 = load i32*, i32** %rdi, align 8
  store i32* %rdi5, i32** %rsi, align 8
  br label %loc_11C6

loc_12A2:                                         ; preds = %loc_111A_then
  %rbp2 = load i32*, i32** %rbp, align 8
  %edx7 = load i32, i32* %edx, align 4
  store i32 %edx7, i32* %rbp2, align 4
  %rdi6 = load i32*, i32** %rdi, align 8
  %rdi6_plus1 = getelementptr inbounds i32, i32* %rdi6, i64 1
  %edx8 = load i32, i32* %rdi6_plus1, align 4
  store i32 %edx8, i32* %edx, align 4
  store i32* %rdi6_plus1, i32** %rsi, align 8
  store i32* %rdi6, i32** %rax, align 8
  %ecx3 = load i32, i32* %rdi6, align 4
  %cmp12A2 = icmp sle i32 %ecx3, %edx8
  br i1 %cmp12A2, label %loc_1400, label %loc_12B9_then

loc_12B9_then:                                    ; preds = %loc_12A2
  store i32 %ecx3, i32* %rdi6_plus1, align 4
  store i64 3, i64* %rcx, align 8
  br label %loc_1288

loc_1400:                                         ; preds = %loc_12A2
  %rsi5 = load i32*, i32** %rsi, align 8
  store i32* %rsi5, i32** %rax, align 8
  store i64 3, i64* %rcx, align 8
  br label %loc_11C6

loc_1128:                                         ; preds = %loc_111A_then
  %rax2 = load i32*, i32** %rax, align 8
  %ptr_m3 = getelementptr inbounds i32, i32* %rax2, i64 -3
  %r8v3 = load i32, i32* %ptr_m3, align 4
  store i32 %r8v3, i32* %r8d, align 4
  %edx9 = load i32, i32* %edx, align 4
  %cmp1128 = icmp sle i32 %r8v3, %edx9
  br i1 %cmp1128, label %loc_12CE, label %loc_1135_then

loc_1135_then:                                    ; preds = %loc_1128
  store i32 %r8v3, i32* %ptr_m2, align 4
  %rcx3 = load i64, i64* %rcx, align 8
  %eq3 = icmp eq i64 %rcx3, 3
  br i1 %eq3, label %loc_12DA, label %loc_1143

loc_12CE:                                         ; preds = %loc_1128
  %rsi6 = load i32*, i32** %rsi, align 8
  %rax_new2 = getelementptr inbounds i32, i32* %rsi6, i64 -2
  store i32* %rax_new2, i32** %rax, align 8
  %rdi7 = load i32*, i32** %rdi, align 8
  store i32* %rdi7, i32** %rsi, align 8
  br label %loc_11C6

loc_12DA:                                         ; preds = %loc_1135_then
  %rbp3 = load i32*, i32** %rbp, align 8
  %edx10 = load i32, i32* %edx, align 4
  store i32 %edx10, i32* %rbp3, align 4
  %rdi8 = load i32*, i32** %rdi, align 8
  %rdi8_plus1 = getelementptr inbounds i32, i32* %rdi8, i64 1
  %edx11 = load i32, i32* %rdi8_plus1, align 4
  store i32 %edx11, i32* %edx, align 4
  store i32* %rdi8_plus1, i32** %rsi, align 8
  store i32* %rdi8, i32** %rax, align 8
  %ecx4 = load i32, i32* %rdi8, align 4
  %cmp12DA = icmp sge i32 %edx11, %ecx4
  br i1 %cmp12DA, label %loc_140D, label %loc_12F1_then

loc_12F1_then:                                    ; preds = %loc_12DA
  store i32 %ecx4, i32* %rdi8_plus1, align 4
  store i64 4, i64* %rcx, align 8
  br label %loc_1288

loc_140D:                                         ; preds = %loc_12DA
  %rsi7 = load i32*, i32** %rsi, align 8
  store i32* %rsi7, i32** %rax, align 8
  store i64 4, i64* %rcx, align 8
  br label %loc_11C6

loc_1143:                                         ; preds = %loc_1135_then
  %rax3 = load i32*, i32** %rax, align 8
  %ptr_m4 = getelementptr inbounds i32, i32* %rax3, i64 -4
  %r8v4 = load i32, i32* %ptr_m4, align 4
  store i32 %r8v4, i32* %r8d, align 4
  %edx12 = load i32, i32* %edx, align 4
  %cmp1143 = icmp sle i32 %r8v4, %edx12
  br i1 %cmp1143, label %loc_12FB, label %loc_1150_then

loc_1150_then:                                    ; preds = %loc_1143
  store i32 %r8v4, i32* %ptr_m3, align 4
  %rcx4 = load i64, i64* %rcx, align 8
  %eq4 = icmp eq i64 %rcx4, 4
  br i1 %eq4, label %loc_1307, label %loc_115E

loc_12FB:                                         ; preds = %loc_1143
  %rsi8 = load i32*, i32** %rsi, align 8
  %rax_new3 = getelementptr inbounds i32, i32* %rsi8, i64 -3
  store i32* %rax_new3, i32** %rax, align 8
  %rdi9 = load i32*, i32** %rdi, align 8
  store i32* %rdi9, i32** %rsi, align 8
  br label %loc_11C6

loc_1307:                                         ; preds = %loc_1150_then
  %rbp4 = load i32*, i32** %rbp, align 8
  %edx13 = load i32, i32* %edx, align 4
  store i32 %edx13, i32* %rbp4, align 4
  %rdi10 = load i32*, i32** %rdi, align 8
  %rdi10_plus1 = getelementptr inbounds i32, i32* %rdi10, i64 1
  %edx14 = load i32, i32* %rdi10_plus1, align 4
  store i32 %edx14, i32* %edx, align 4
  store i32* %rdi10_plus1, i32** %rsi, align 8
  store i32* %rdi10, i32** %rax, align 8
  %ecx5 = load i32, i32* %rdi10, align 4
  %cmp1307 = icmp sge i32 %edx14, %ecx5
  br i1 %cmp1307, label %loc_13E6, label %loc_131E_then

loc_131E_then:                                    ; preds = %loc_1307
  store i32 %ecx5, i32* %rdi10_plus1, align 4
  store i64 5, i64* %rcx, align 8
  br label %loc_1288

loc_13E6:                                         ; preds = %loc_1307
  %rsi9 = load i32*, i32** %rsi, align 8
  store i32* %rsi9, i32** %rax, align 8
  store i64 5, i64* %rcx, align 8
  br label %loc_11C6

loc_115E:                                         ; preds = %loc_1150_then
  %rax4 = load i32*, i32** %rax, align 8
  %ptr_m5 = getelementptr inbounds i32, i32* %rax4, i64 -5
  %r8v5 = load i32, i32* %ptr_m5, align 4
  store i32 %r8v5, i32* %r8d, align 4
  %edx15 = load i32, i32* %edx, align 4
  %cmp115E = icmp sle i32 %r8v5, %edx15
  br i1 %cmp115E, label %loc_132B, label %loc_116B_then

loc_116B_then:                                    ; preds = %loc_115E
  store i32 %r8v5, i32* %ptr_m4, align 4
  %rcx5 = load i64, i64* %rcx, align 8
  %eq5 = icmp eq i64 %rcx5, 5
  br i1 %eq5, label %loc_1337, label %loc_1179

loc_132B:                                         ; preds = %loc_115E
  %rsi10 = load i32*, i32** %rsi, align 8
  %rax_new4 = getelementptr inbounds i32, i32* %rsi10, i64 -4
  store i32* %rax_new4, i32** %rax, align 8
  %rdi11 = load i32*, i32** %rdi, align 8
  store i32* %rdi11, i32** %rsi, align 8
  br label %loc_11C6

loc_1337:                                         ; preds = %loc_116B_then
  %rbp5 = load i32*, i32** %rbp, align 8
  %edx16 = load i32, i32* %edx, align 4
  store i32 %edx16, i32* %rbp5, align 4
  %rdi12 = load i32*, i32** %rdi, align 8
  %rdi12_plus1 = getelementptr inbounds i32, i32* %rdi12, i64 1
  %edx17 = load i32, i32* %rdi12_plus1, align 4
  store i32 %edx17, i32* %edx, align 4
  store i32* %rdi12_plus1, i32** %rsi, align 8
  store i32* %rdi12, i32** %rax, align 8
  %ecx6 = load i32, i32* %rdi12, align 4
  %cmp1337 = icmp sge i32 %edx17, %ecx6
  br i1 %cmp1337, label %loc_13F3, label %loc_134E_then

loc_134E_then:                                    ; preds = %loc_1337
  store i32 %ecx6, i32* %rdi12_plus1, align 4
  store i64 6, i64* %rcx, align 8
  br label %loc_1288

loc_13F3:                                         ; preds = %loc_1337
  %rsi11 = load i32*, i32** %rsi, align 8
  store i32* %rsi11, i32** %rax, align 8
  store i64 6, i64* %rcx, align 8
  br label %loc_11C6

loc_1179:                                         ; preds = %loc_116B_then
  %rax5 = load i32*, i32** %rax, align 8
  %ptr_m6 = getelementptr inbounds i32, i32* %rax5, i64 -6
  %r8v6 = load i32, i32* %ptr_m6, align 4
  store i32 %r8v6, i32* %r8d, align 4
  %edx18 = load i32, i32* %edx, align 4
  %cmp1179 = icmp sle i32 %r8v6, %edx18
  br i1 %cmp1179, label %loc_135B, label %loc_1186_then

loc_1186_then:                                    ; preds = %loc_1179
  store i32 %r8v6, i32* %ptr_m5, align 4
  %rcx6 = load i64, i64* %rcx, align 8
  %eq6 = icmp eq i64 %rcx6, 6
  br i1 %eq6, label %loc_1367, label %loc_1194

loc_135B:                                         ; preds = %loc_1179
  %rsi12 = load i32*, i32** %rsi, align 8
  %rax_new5 = getelementptr inbounds i32, i32* %rsi12, i64 -5
  store i32* %rax_new5, i32** %rax, align 8
  %rdi13 = load i32*, i32** %rdi, align 8
  store i32* %rdi13, i32** %rsi, align 8
  br label %loc_11C6

loc_1367:                                         ; preds = %loc_1186_then
  %rbp6 = load i32*, i32** %rbp, align 8
  %edx19 = load i32, i32* %edx, align 4
  store i32 %edx19, i32* %rbp6, align 4
  %rdi14 = load i32*, i32** %rdi, align 8
  %rdi14_plus1 = getelementptr inbounds i32, i32* %rdi14, i64 1
  %edx20 = load i32, i32* %rdi14_plus1, align 4
  store i32 %edx20, i32* %edx, align 4
  store i32* %rdi14_plus1, i32** %rsi, align 8
  store i32* %rdi14, i32** %rax, align 8
  %ecx7 = load i32, i32* %rdi14, align 4
  %cmp1367 = icmp sge i32 %edx20, %ecx7
  br i1 %cmp1367, label %loc_13D9, label %loc_137A_then

loc_137A_then:                                    ; preds = %loc_1367
  store i32 %ecx7, i32* %rdi14_plus1, align 4
  store i64 7, i64* %rcx, align 8
  br label %loc_1288

loc_13D9:                                         ; preds = %loc_1367
  %rsi13 = load i32*, i32** %rsi, align 8
  store i32* %rsi13, i32** %rax, align 8
  store i64 7, i64* %rcx, align 8
  br label %loc_11C6

loc_1194:                                         ; preds = %loc_1186_then
  %rax6 = load i32*, i32** %rax, align 8
  %ptr_m7 = getelementptr inbounds i32, i32* %rax6, i64 -7
  %r8v7 = load i32, i32* %ptr_m7, align 4
  store i32 %r8v7, i32* %r8d, align 4
  %edx21 = load i32, i32* %edx, align 4
  %cmp1194 = icmp sle i32 %r8v7, %edx21
  br i1 %cmp1194, label %loc_1387, label %loc_11A1_then

loc_11A1_then:                                    ; preds = %loc_1194
  store i32 %r8v7, i32* %ptr_m6, align 4
  %rcx7 = load i64, i64* %rcx, align 8
  %eq7 = icmp eq i64 %rcx7, 7
  br i1 %eq7, label %loc_1393, label %loc_11AF

loc_1387:                                         ; preds = %loc_1194
  %rsi14 = load i32*, i32** %rsi, align 8
  %rax_new6 = getelementptr inbounds i32, i32* %rsi14, i64 -6
  store i32* %rax_new6, i32** %rax, align 8
  %rdi15 = load i32*, i32** %rdi, align 8
  store i32* %rdi15, i32** %rsi, align 8
  br label %loc_11C6

loc_1393:                                         ; preds = %loc_11A1_then
  %rbp7 = load i32*, i32** %rbp, align 8
  %edx22 = load i32, i32* %edx, align 4
  store i32 %edx22, i32* %rbp7, align 4
  %rdi16 = load i32*, i32** %rdi, align 8
  %rdi16_plus1 = getelementptr inbounds i32, i32* %rdi16, i64 1
  %edx23 = load i32, i32* %rdi16_plus1, align 4
  store i32 %edx23, i32* %edx, align 4
  store i32* %rdi16_plus1, i32** %rsi, align 8
  store i32* %rdi16, i32** %rax, align 8
  %ecx8 = load i32, i32* %rdi16, align 4
  %cmp1393 = icmp sge i32 %edx23, %ecx8
  br i1 %cmp1393, label %loc_141A, label %loc_13A6_then

loc_13A6_then:                                    ; preds = %loc_1393
  store i32 %ecx8, i32* %rdi16_plus1, align 4
  store i64 8, i64* %rcx, align 8
  br label %loc_1288

loc_141A:                                         ; preds = %loc_1393
  %rsi15 = load i32*, i32** %rsi, align 8
  store i32* %rsi15, i32** %rax, align 8
  store i64 8, i64* %rcx, align 8
  br label %loc_11C6

loc_11AF:                                         ; preds = %loc_11A1_then
  %rax7 = load i32*, i32** %rax, align 8
  %ptr_m8 = getelementptr inbounds i32, i32* %rax7, i64 -8
  %r8v8 = load i32, i32* %ptr_m8, align 4
  store i32 %r8v8, i32* %r8d, align 4
  %edx24 = load i32, i32* %edx, align 4
  %cmp11AF = icmp sle i32 %r8v8, %edx24
  br i1 %cmp11AF, label %loc_13B3, label %loc_11BC

loc_13B3:                                         ; preds = %loc_11AF
  %rsi16 = load i32*, i32** %rsi, align 8
  %rax_new7 = getelementptr inbounds i32, i32* %rsi16, i64 -7
  store i32* %rax_new7, i32** %rax, align 8
  %rdi17 = load i32*, i32** %rdi, align 8
  store i32* %rdi17, i32** %rsi, align 8
  br label %loc_11C6

loc_11BC:                                         ; preds = %loc_11AF
  store i32 %r8v8, i32* %ptr_m7, align 4
  %rdi18 = load i32*, i32** %rdi, align 8
  store i32* %rdi18, i32** %rsi, align 8
  %rbp_now = load i32*, i32** %rbp, align 8
  store i32* %rbp_now, i32** %rax, align 8
  br label %loc_11C6

loc_11C6:                                         ; preds = %loc_11BC, %loc_13B3, %loc_141A, %loc_1387, %loc_135B, %loc_132B, %loc_12FB, %loc_13E6, %loc_140D, %loc_12CE, %loc_1400, %loc_1296, %loc_13F3, %loc_13D9, %loc_13BF, %loc_13CC, %loc_12C3, %loc_125B
  %rcx_cur = load i64, i64* %rcx, align 8
  %rcx_inc = add i64 %rcx_cur, 1
  store i64 %rcx_inc, i64* %rcx, align 8
  %raxp = load i32*, i32** %rax, align 8
  %edx_cur = load i32, i32* %edx, align 4
  store i32 %edx_cur, i32* %raxp, align 4
  %cmp_end = icmp ne i64 %rcx_inc, 9
  br i1 %cmp_end, label %loc_10D0, label %loc_11D6

loc_11D6:                                         ; preds = %loc_11C6
  %rbp_base = load i32*, i32** %rbp, align 8
  %rbp_end = getelementptr inbounds i32, i32* %rbp_base, i64 10
  store i32* %rbp_end, i32** %rbp, align 8
  store i8* @unk_2004, i8** %r12, align 8
  br label %loc_11E8

loc_11E8:                                         ; preds = %loc_11E8, %loc_11D6
  %rbx_ptr = load i32*, i32** %rbx, align 8
  %val = load i32, i32* %rbx_ptr, align 4
  store i32 %val, i32* %edx, align 4
  %fmt = load i8*, i8** %r12, align 8
  %rbx_next = getelementptr inbounds i32, i32* %rbx_ptr, i64 1
  store i32* %rbx_next, i32** %rbx, align 8
  %edx_for_call = load i32, i32* %edx, align 4
  %call1 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt, i32 %edx_for_call)
  %rbp_end2 = load i32*, i32** %rbp, align 8
  %rbx_now = load i32*, i32** %rbx, align 8
  %neq = icmp ne i32* %rbp_end2, %rbx_now
  br i1 %neq, label %loc_11E8, label %loc_1202

loc_1202:                                         ; preds = %loc_11E8
  %call2 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* @unk_2008)
  %guard2 = load i64, i64* @__stack_chk_guard, align 8
  %saved = load i64, i64* %canary, align 8
  %ok2 = icmp eq i64 %guard2, %saved
  br i1 %ok2, label %loc_ret, label %loc_1427

loc_1427:                                         ; preds = %loc_1202
  call void @___stack_chk_fail()
  unreachable

loc_ret:                                          ; preds = %loc_1202
  ret i32 0
}