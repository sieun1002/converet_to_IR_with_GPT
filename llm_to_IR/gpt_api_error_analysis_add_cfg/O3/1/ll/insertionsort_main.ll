; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = external constant <4 x i32>, align 16
@xmmword_2020 = external constant <4 x i32>, align 16

@unk_2004 = private constant [4 x i8] c"%d \00", align 1
@unk_2008 = private constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external global i64

declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() local_unnamed_addr {
bb_1080:
  %arr = alloca [10 x i32], align 16
  %rcx = alloca i64, align 8
  %rbp.p = alloca i32*, align 8
  %rbx.p = alloca i32*, align 8
  %rsi.p = alloca i32*, align 8
  %rdi.p = alloca i32*, align 8
  %rax.p = alloca i32*, align 8
  %r8ptr = alloca i32*, align 8
  %edx.s = alloca i32, align 4
  %r8d.s = alloca i32, align 4
  %ecx32.s = alloca i32, align 4
  %canary = alloca i64, align 8
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary, align 8
  store i64 0, i64* %rcx, align 8
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %arr0.v = bitcast i32* %arr0 to <4 x i32>*
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  store <4 x i32> %v0, <4 x i32>* %arr0.v, align 16
  %arr4 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %arr4.v = bitcast i32* %arr4 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %arr4.v, align 16
  %arr8 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %arr8, align 4
  store i32* %arr0, i32** %rbp.p, align 8
  store i32* %arr0, i32** %rbx.p, align 8
  store i32* %arr0, i32** %rsi.p, align 8
  br label %loc_10D0

loc_10D0:                                            ; 0x10d0
  %rsi_10d0 = load i32*, i32** %rsi.p, align 8
  %rsi_plus1_10d0 = getelementptr inbounds i32, i32* %rsi_10d0, i64 1
  %edx_10d0 = load i32, i32* %rsi_plus1_10d0, align 4
  store i32 %edx_10d0, i32* %edx.s, align 4
  %r8d_10d0 = load i32, i32* %rsi_10d0, align 4
  store i32 %r8d_10d0, i32* %r8d.s, align 4
  store i32* %rsi_plus1_10d0, i32** %rdi.p, align 8
  store i32* %rsi_10d0, i32** %rax.p, align 8
  %cmp_10e0 = icmp sle i32 %r8d_10d0, %edx_10d0
  br i1 %cmp_10e0, label %loc_12C3, label %blk_10e6

blk_10e6:                                            ; 0x10e6 fallthrough
  %r8d_after = load i32, i32* %r8d.s, align 4
  %rsi_after = load i32*, i32** %rsi.p, align 8
  %rsi_plus1_after = getelementptr inbounds i32, i32* %rsi_after, i64 1
  store i32 %r8d_after, i32* %rsi_plus1_after, align 4
  %rcx_val = load i64, i64* %rcx, align 8
  %is_zero = icmp eq i64 %rcx_val, 0
  br i1 %is_zero, label %loc_1234, label %loc_10F3

loc_1234:                                            ; 0x1234
  %edx_1234 = load i32, i32* %edx.s, align 4
  %arr0_1234 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1234, i32* %arr0_1234, align 4
  %rdi_1234 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_1234 = getelementptr inbounds i32, i32* %rdi_1234, i64 2
  %edx_next_1234 = load i32, i32* %rdi_plus2_1234, align 4
  store i32 %edx_next_1234, i32* %edx.s, align 4
  %rsi_1234 = load i32*, i32** %rsi.p, align 8
  %rsi_add2_1234 = getelementptr inbounds i32, i32* %rsi_1234, i64 2
  store i32* %rsi_add2_1234, i32** %rsi.p, align 8
  store i32* %rdi_1234, i32** %rax.p, align 8
  %ecx_load_1234 = load i32, i32* %rdi_1234, align 4
  store i32 %ecx_load_1234, i32* %ecx32.s, align 4
  %cmp_1243 = icmp sle i32 %ecx_load_1234, %edx_next_1234
  br i1 %cmp_1243, label %loc_13CC, label %blk_124b

blk_124b:                                            ; 0x124b fallthrough
  %ecx_load2_124b = load i32, i32* %ecx32.s, align 4
  %rdi_124b = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_124b = getelementptr inbounds i32, i32* %rdi_124b, i64 1
  store i32 %ecx_load2_124b, i32* %rdi_plus1_124b, align 4
  %rsi_tmp_124b = load i32*, i32** %rsi.p, align 8
  store i32* %rdi_124b, i32** %rsi.p, align 8
  store i32* %rsi_tmp_124b, i32** %rdi.p, align 8
  store i32 1, i32* %ecx32.s, align 4
  br label %loc_10F3

loc_13CC:                                            ; 0x13cc
  %rsi_13cc = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_13cc, i32** %rax.p, align 8
  store i64 1, i64* %rcx, align 8
  br label %loc_11C6

loc_10F3:                                            ; 0x10f3
  %rax_10f3 = load i32*, i32** %rax.p, align 8
  %ptr_m1_10f3 = getelementptr inbounds i32, i32* %rax_10f3, i64 -1
  %r8d_m1_10f3 = load i32, i32* %ptr_m1_10f3, align 4
  store i32 %r8d_m1_10f3, i32* %r8d.s, align 4
  %edx_now_10f3 = load i32, i32* %edx.s, align 4
  %cmp_10f7 = icmp sle i32 %r8d_m1_10f3, %edx_now_10f3
  br i1 %cmp_10f7, label %loc_125B, label %blk_1100

blk_1100:                                            ; 0x1100
  %rax_1100 = load i32*, i32** %rax.p, align 8
  %r8d_store_1100 = load i32, i32* %r8d.s, align 4
  store i32 %r8d_store_1100, i32* %rax_1100, align 4
  %rcx_1103 = load i64, i64* %rcx, align 8
  %cmp_1107 = icmp eq i64 %rcx_1103, 1
  br i1 %cmp_1107, label %loc_1263, label %blk_110d

loc_125B:                                            ; 0x125b
  %rdi_125b = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_125b, i32** %rsi.p, align 8
  %rax_125b_in = load i32*, i32** %rax.p, align 8
  br label %loc_11C6

loc_1263:                                            ; 0x1263
  %edx_1263 = load i32, i32* %edx.s, align 4
  %arr0_1263 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1263, i32* %arr0_1263, align 4
  %rdi_1263 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_1263 = getelementptr inbounds i32, i32* %rdi_1263, i64 2
  %edx_next_1266 = load i32, i32* %rdi_plus2_1263, align 4
  store i32 %edx_next_1266, i32* %edx.s, align 4
  %rdi_plus1_1269 = getelementptr inbounds i32, i32* %rdi_1263, i64 1
  store i32* %rdi_plus1_1269, i32** %rsi.p, align 8
  store i32* %rdi_1263, i32** %rax.p, align 8
  %ecx_load_1270 = load i32, i32* %rdi_1263, align 4
  store i32 %ecx_load_1270, i32* %ecx32.s, align 4
  %cmp_1274 = icmp sge i32 %edx_next_1266, %ecx_load_1270
  br i1 %cmp_1274, label %loc_13BF, label %blk_127a

blk_127a:                                            ; 0x127a..1282..1288
  %ecx_st_127a = load i32, i32* %ecx32.s, align 4
  %rdi_127a = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_127a = getelementptr inbounds i32, i32* %rdi_127a, i64 1
  store i32 %ecx_st_127a, i32* %rdi_plus1_127a, align 4
  store i32 2, i32* %ecx32.s, align 4
  br label %loc_1288

loc_1288:                                            ; 0x1288
  %rsi_1288 = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_1288, i32** %r8ptr, align 8
  %rdi_128b = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_128b, i32** %rsi.p, align 8
  %r8tmp_128e = load i32*, i32** %r8ptr, align 8
  store i32* %r8tmp_128e, i32** %rdi.p, align 8
  br label %loc_10F3

loc_13BF:                                            ; 0x13bf
  %rsi_13bf = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_13bf, i32** %rax.p, align 8
  store i64 2, i64* %rcx, align 8
  br label %loc_11C6

blk_110d:                                            ; 0x110d
  %rax_110d = load i32*, i32** %rax.p, align 8
  %ptr_m2_110d = getelementptr inbounds i32, i32* %rax_110d, i64 -2
  %r8d_m2_110d = load i32, i32* %ptr_m2_110d, align 4
  store i32 %r8d_m2_110d, i32* %r8d.s, align 4
  %edx_now_1111 = load i32, i32* %edx.s, align 4
  %cmp_1114 = icmp sle i32 %r8d_m2_110d, %edx_now_1111
  br i1 %cmp_1114, label %loc_1296, label %blk_111a

loc_1296:                                            ; 0x1296
  %rsi_1296 = load i32*, i32** %rsi.p, align 8
  %rax_new_1296 = getelementptr inbounds i32, i32* %rsi_1296, i64 -1
  store i32* %rax_new_1296, i32** %rax.p, align 8
  %rdi_129a = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_129a, i32** %rsi.p, align 8
  br label %loc_11C6

blk_111a:                                            ; 0x111a
  %r8d_st_111a = load i32, i32* %r8d.s, align 4
  %rax_111a = load i32*, i32** %rax.p, align 8
  %ptr_m1_111a = getelementptr inbounds i32, i32* %rax_111a, i64 -1
  store i32 %r8d_st_111a, i32* %ptr_m1_111a, align 4
  %rcx_111e = load i64, i64* %rcx, align 8
  %cmp_1122 = icmp eq i64 %rcx_111e, 2
  br i1 %cmp_1122, label %loc_12A2, label %blk_1128

loc_12A2:                                            ; 0x12a2
  %edx_12a2 = load i32, i32* %edx.s, align 4
  %arr0_12a2 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_12a2, i32* %arr0_12a2, align 4
  %rdi_12a2 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_12a5 = getelementptr inbounds i32, i32* %rdi_12a2, i64 2
  %edx_next_12a5 = load i32, i32* %rdi_plus2_12a5, align 4
  store i32 %edx_next_12a5, i32* %edx.s, align 4
  %rdi_plus1_12a8 = getelementptr inbounds i32, i32* %rdi_12a2, i64 1
  store i32* %rdi_plus1_12a8, i32** %rsi.p, align 8
  store i32* %rdi_12a2, i32** %rax.p, align 8
  %ecx_load_12af = load i32, i32* %rdi_12a2, align 4
  store i32 %ecx_load_12af, i32* %ecx32.s, align 4
  %cmp_12b3 = icmp sle i32 %ecx_load_12af, %edx_next_12a5
  br i1 %cmp_12b3, label %loc_1400, label %blk_12b9

blk_12b9:                                            ; 0x12b9..12bc..12c1
  %ecx_st_12b9 = load i32, i32* %ecx32.s, align 4
  %rdi_12b9 = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_12b9 = getelementptr inbounds i32, i32* %rdi_12b9, i64 1
  store i32 %ecx_st_12b9, i32* %rdi_plus1_12b9, align 4
  store i32 3, i32* %ecx32.s, align 4
  br label %loc_1288

loc_1400:                                            ; 0x1400
  %rsi_1400 = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_1400, i32** %rax.p, align 8
  store i64 3, i64* %rcx, align 8
  br label %loc_11C6

blk_1128:                                            ; 0x1128
  %rax_1128 = load i32*, i32** %rax.p, align 8
  %ptr_m3_1128 = getelementptr inbounds i32, i32* %rax_1128, i64 -3
  %r8d_m3_1128 = load i32, i32* %ptr_m3_1128, align 4
  store i32 %r8d_m3_1128, i32* %r8d.s, align 4
  %edx_now_112c = load i32, i32* %edx.s, align 4
  %cmp_112f = icmp sle i32 %r8d_m3_1128, %edx_now_112c
  br i1 %cmp_112f, label %loc_12CE, label %blk_1135

loc_12CE:                                            ; 0x12ce
  %rsi_12ce = load i32*, i32** %rsi.p, align 8
  %rax_new_12ce = getelementptr inbounds i32, i32* %rsi_12ce, i64 -2
  store i32* %rax_new_12ce, i32** %rax.p, align 8
  %rdi_12d2 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_12d2, i32** %rsi.p, align 8
  br label %loc_11C6

blk_1135:                                            ; 0x1135
  %r8d_st_1135 = load i32, i32* %r8d.s, align 4
  %rax_1135 = load i32*, i32** %rax.p, align 8
  %ptr_m2_1135 = getelementptr inbounds i32, i32* %rax_1135, i64 -2
  store i32 %r8d_st_1135, i32* %ptr_m2_1135, align 4
  %rcx_1139 = load i64, i64* %rcx, align 8
  %cmp_113d = icmp eq i64 %rcx_1139, 3
  br i1 %cmp_113d, label %loc_12DA, label %blk_1143

loc_12DA:                                            ; 0x12da
  %edx_12da = load i32, i32* %edx.s, align 4
  %arr0_12da = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_12da, i32* %arr0_12da, align 4
  %rdi_12da = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_12dd = getelementptr inbounds i32, i32* %rdi_12da, i64 2
  %edx_next_12dd = load i32, i32* %rdi_plus2_12dd, align 4
  store i32 %edx_next_12dd, i32* %edx.s, align 4
  %rdi_plus1_12e0 = getelementptr inbounds i32, i32* %rdi_12da, i64 1
  store i32* %rdi_plus1_12e0, i32** %rsi.p, align 8
  store i32* %rdi_12da, i32** %rax.p, align 8
  %ecx_load_12e7 = load i32, i32* %rdi_12da, align 4
  store i32 %ecx_load_12e7, i32* %ecx32.s, align 4
  %cmp_12eb = icmp sge i32 %edx_next_12dd, %ecx_load_12e7
  br i1 %cmp_12eb, label %loc_140D, label %blk_12f1

blk_12f1:                                            ; 0x12f1..12f9
  %ecx_st_12f1 = load i32, i32* %ecx32.s, align 4
  %rdi_12f1 = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_12f1 = getelementptr inbounds i32, i32* %rdi_12f1, i64 1
  store i32 %ecx_st_12f1, i32* %rdi_plus1_12f1, align 4
  store i32 4, i32* %ecx32.s, align 4
  br label %loc_1288

loc_140D:                                            ; 0x140d
  %rsi_140d = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_140d, i32** %rax.p, align 8
  store i64 4, i64* %rcx, align 8
  br label %loc_11C6

blk_1143:                                            ; 0x1143
  %rax_1143 = load i32*, i32** %rax.p, align 8
  %ptr_m4_1143 = getelementptr inbounds i32, i32* %rax_1143, i64 -4
  %r8d_m4_1143 = load i32, i32* %ptr_m4_1143, align 4
  store i32 %r8d_m4_1143, i32* %r8d.s, align 4
  %edx_now_1147 = load i32, i32* %edx.s, align 4
  %cmp_114a = icmp sle i32 %r8d_m4_1143, %edx_now_1147
  br i1 %cmp_114a, label %loc_12FB, label %blk_1150

loc_12FB:                                            ; 0x12fb
  %rsi_12fb = load i32*, i32** %rsi.p, align 8
  %rax_new_12fb = getelementptr inbounds i32, i32* %rsi_12fb, i64 -3
  store i32* %rax_new_12fb, i32** %rax.p, align 8
  %rdi_1302 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_1302, i32** %rsi.p, align 8
  br label %loc_11C6

blk_1150:                                            ; 0x1150
  %r8d_st_1150 = load i32, i32* %r8d.s, align 4
  %rax_1150 = load i32*, i32** %rax.p, align 8
  %ptr_m3_1150 = getelementptr inbounds i32, i32* %rax_1150, i64 -3
  store i32 %r8d_st_1150, i32* %ptr_m3_1150, align 4
  %rcx_1154 = load i64, i64* %rcx, align 8
  %cmp_1158 = icmp eq i64 %rcx_1154, 4
  br i1 %cmp_1158, label %loc_1307, label %blk_115e

loc_1307:                                            ; 0x1307
  %edx_1307 = load i32, i32* %edx.s, align 4
  %arr0_1307 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1307, i32* %arr0_1307, align 4
  %rdi_1307 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_130a = getelementptr inbounds i32, i32* %rdi_1307, i64 2
  %edx_next_130a = load i32, i32* %rdi_plus2_130a, align 4
  store i32 %edx_next_130a, i32* %edx.s, align 4
  %rdi_plus1_130d = getelementptr inbounds i32, i32* %rdi_1307, i64 1
  store i32* %rdi_plus1_130d, i32** %rsi.p, align 8
  store i32* %rdi_1307, i32** %rax.p, align 8
  %ecx_load_1314 = load i32, i32* %rdi_1307, align 4
  store i32 %ecx_load_1314, i32* %ecx32.s, align 4
  %cmp_1318 = icmp sge i32 %edx_next_130a, %ecx_load_1314
  br i1 %cmp_1318, label %loc_13E6, label %blk_131e

blk_131e:                                            ; 0x131e..1326
  %ecx_st_131e = load i32, i32* %ecx32.s, align 4
  %rdi_131e = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_131e = getelementptr inbounds i32, i32* %rdi_131e, i64 1
  store i32 %ecx_st_131e, i32* %rdi_plus1_131e, align 4
  store i32 5, i32* %ecx32.s, align 4
  br label %loc_1288

loc_13E6:                                            ; 0x13e6
  %rsi_13e6 = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_13e6, i32** %rax.p, align 8
  store i64 5, i64* %rcx, align 8
  br label %loc_11C6

blk_115e:                                            ; 0x115e
  %rax_115e = load i32*, i32** %rax.p, align 8
  %ptr_m5_115e = getelementptr inbounds i32, i32* %rax_115e, i64 -5
  %r8d_m5_115e = load i32, i32* %ptr_m5_115e, align 4
  store i32 %r8d_m5_115e, i32* %r8d.s, align 4
  %edx_now_1162 = load i32, i32* %edx.s, align 4
  %cmp_1165 = icmp sle i32 %r8d_m5_115e, %edx_now_1162
  br i1 %cmp_1165, label %loc_132B, label %blk_116b

loc_132B:                                            ; 0x132b
  %rsi_132b = load i32*, i32** %rsi.p, align 8
  %rax_new_132b = getelementptr inbounds i32, i32* %rsi_132b, i64 -4
  store i32* %rax_new_132b, i32** %rax.p, align 8
  %rdi_1332 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_1332, i32** %rsi.p, align 8
  br label %loc_11C6

blk_116b:                                            ; 0x116b
  %r8d_st_116b = load i32, i32* %r8d.s, align 4
  %rax_116b = load i32*, i32** %rax.p, align 8
  %ptr_m4_116b = getelementptr inbounds i32, i32* %rax_116b, i64 -4
  store i32 %r8d_st_116b, i32* %ptr_m4_116b, align 4
  %rcx_116f = load i64, i64* %rcx, align 8
  %cmp_1173 = icmp eq i64 %rcx_116f, 5
  br i1 %cmp_1173, label %loc_1337, label %blk_1179

loc_1337:                                            ; 0x1337
  %edx_1337 = load i32, i32* %edx.s, align 4
  %arr0_1337 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1337, i32* %arr0_1337, align 4
  %rdi_1337 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_133a = getelementptr inbounds i32, i32* %rdi_1337, i64 2
  %edx_next_133a = load i32, i32* %rdi_plus2_133a, align 4
  store i32 %edx_next_133a, i32* %edx.s, align 4
  %rdi_plus1_133d = getelementptr inbounds i32, i32* %rdi_1337, i64 1
  store i32* %rdi_plus1_133d, i32** %rsi.p, align 8
  store i32* %rdi_1337, i32** %rax.p, align 8
  %ecx_load_1344 = load i32, i32* %rdi_1337, align 4
  store i32 %ecx_load_1344, i32* %ecx32.s, align 4
  %cmp_1348 = icmp sge i32 %edx_next_133a, %ecx_load_1344
  br i1 %cmp_1348, label %loc_13F3, label %blk_134e

blk_134e:                                            ; 0x134e..1356
  %ecx_st_134e = load i32, i32* %ecx32.s, align 4
  %rdi_134e = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_134e = getelementptr inbounds i32, i32* %rdi_134e, i64 1
  store i32 %ecx_st_134e, i32* %rdi_plus1_134e, align 4
  store i32 6, i32* %ecx32.s, align 4
  br label %loc_1288

loc_13F3:                                            ; 0x13f3
  %rsi_13f3 = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_13f3, i32** %rax.p, align 8
  store i64 6, i64* %rcx, align 8
  br label %loc_11C6

blk_1179:                                            ; 0x1179
  %rax_1179 = load i32*, i32** %rax.p, align 8
  %ptr_m6_1179 = getelementptr inbounds i32, i32* %rax_1179, i64 -6
  %r8d_m6_1179 = load i32, i32* %ptr_m6_1179, align 4
  store i32 %r8d_m6_1179, i32* %r8d.s, align 4
  %edx_now_117d = load i32, i32* %edx.s, align 4
  %cmp_1180 = icmp sle i32 %r8d_m6_1179, %edx_now_117d
  br i1 %cmp_1180, label %loc_135B, label %blk_1186

loc_135B:                                            ; 0x135b
  %rsi_135b = load i32*, i32** %rsi.p, align 8
  %rax_new_135b = getelementptr inbounds i32, i32* %rsi_135b, i64 -5
  store i32* %rax_new_135b, i32** %rax.p, align 8
  %rdi_1362 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_1362, i32** %rsi.p, align 8
  br label %loc_11C6

blk_1186:                                            ; 0x1186
  %r8d_st_1186 = load i32, i32* %r8d.s, align 4
  %rax_1186 = load i32*, i32** %rax.p, align 8
  %ptr_m5_1186 = getelementptr inbounds i32, i32* %rax_1186, i64 -5
  store i32 %r8d_st_1186, i32* %ptr_m5_1186, align 4
  %rcx_118a = load i64, i64* %rcx, align 8
  %cmp_118e = icmp eq i64 %rcx_118a, 6
  br i1 %cmp_118e, label %loc_1367, label %blk_1194

loc_1367:                                            ; 0x1367
  %edx_1367 = load i32, i32* %edx.s, align 4
  %arr0_1367 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1367, i32* %arr0_1367, align 4
  %rdi_1367 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_136a = getelementptr inbounds i32, i32* %rdi_1367, i64 2
  %edx_next_136a = load i32, i32* %rdi_plus2_136a, align 4
  store i32 %edx_next_136a, i32* %edx.s, align 4
  %rdi_plus1_136d = getelementptr inbounds i32, i32* %rdi_1367, i64 1
  store i32* %rdi_plus1_136d, i32** %rsi.p, align 8
  store i32* %rdi_1367, i32** %rax.p, align 8
  %ecx_load_1374 = load i32, i32* %rdi_1367, align 4
  store i32 %ecx_load_1374, i32* %ecx32.s, align 4
  %cmp_1378 = icmp sge i32 %edx_next_136a, %ecx_load_1374
  br i1 %cmp_1378, label %loc_13D9, label %blk_137a

blk_137a:                                            ; 0x137a..1382
  %ecx_st_137a = load i32, i32* %ecx32.s, align 4
  %rdi_137a = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_137a = getelementptr inbounds i32, i32* %rdi_137a, i64 1
  store i32 %ecx_st_137a, i32* %rdi_plus1_137a, align 4
  store i32 7, i32* %ecx32.s, align 4
  br label %loc_1288

loc_13D9:                                            ; 0x13d9
  %rsi_13d9 = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_13d9, i32** %rax.p, align 8
  store i64 7, i64* %rcx, align 8
  br label %loc_11C6

blk_1194:                                            ; 0x1194
  %rax_1194 = load i32*, i32** %rax.p, align 8
  %ptr_m7_1194 = getelementptr inbounds i32, i32* %rax_1194, i64 -7
  %r8d_m7_1194 = load i32, i32* %ptr_m7_1194, align 4
  store i32 %r8d_m7_1194, i32* %r8d.s, align 4
  %edx_now_1198 = load i32, i32* %edx.s, align 4
  %cmp_119b = icmp sle i32 %r8d_m7_1194, %edx_now_1198
  br i1 %cmp_119b, label %loc_1387, label %blk_11a1

loc_1387:                                            ; 0x1387
  %rsi_1387 = load i32*, i32** %rsi.p, align 8
  %rax_new_1387 = getelementptr inbounds i32, i32* %rsi_1387, i64 -6
  store i32* %rax_new_1387, i32** %rax.p, align 8
  %rdi_138e = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_138e, i32** %rsi.p, align 8
  br label %loc_11C6

blk_11a1:                                            ; 0x11a1
  %r8d_st_11a1 = load i32, i32* %r8d.s, align 4
  %rax_11a1 = load i32*, i32** %rax.p, align 8
  %ptr_m6_11a1 = getelementptr inbounds i32, i32* %rax_11a1, i64 -6
  store i32 %r8d_st_11a1, i32* %ptr_m6_11a1, align 4
  %rcx_11a5 = load i64, i64* %rcx, align 8
  %cmp_11a9 = icmp eq i64 %rcx_11a5, 7
  br i1 %cmp_11a9, label %loc_1393, label %blk_11af

loc_1393:                                            ; 0x1393
  %edx_1393 = load i32, i32* %edx.s, align 4
  %arr0_1393 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32 %edx_1393, i32* %arr0_1393, align 4
  %rdi_1393 = load i32*, i32** %rdi.p, align 8
  %rdi_plus2_1396 = getelementptr inbounds i32, i32* %rdi_1393, i64 2
  %edx_next_1396 = load i32, i32* %rdi_plus2_1396, align 4
  store i32 %edx_next_1396, i32* %edx.s, align 4
  %rdi_plus1_1399 = getelementptr inbounds i32, i32* %rdi_1393, i64 1
  store i32* %rdi_plus1_1399, i32** %rsi.p, align 8
  store i32* %rdi_1393, i32** %rax.p, align 8
  %ecx_load_13a0 = load i32, i32* %rdi_1393, align 4
  store i32 %ecx_load_13a0, i32* %ecx32.s, align 4
  %cmp_13a4 = icmp sge i32 %edx_next_1396, %ecx_load_13a0
  br i1 %cmp_13a4, label %loc_141A, label %blk_13a6

blk_13a6:                                            ; 0x13a6..13ae
  %ecx_st_13a6 = load i32, i32* %ecx32.s, align 4
  %rdi_13a6 = load i32*, i32** %rdi.p, align 8
  %rdi_plus1_13a6 = getelementptr inbounds i32, i32* %rdi_13a6, i64 1
  store i32 %ecx_st_13a6, i32* %rdi_plus1_13a6, align 4
  store i32 8, i32* %ecx32.s, align 4
  br label %loc_1288

loc_141A:                                            ; 0x141a
  %rsi_141a = load i32*, i32** %rsi.p, align 8
  store i32* %rsi_141a, i32** %rax.p, align 8
  store i64 8, i64* %rcx, align 8
  br label %loc_11C6

blk_11af:                                            ; 0x11af..11bc..11c3 then into 11C6
  %rax_11af = load i32*, i32** %rax.p, align 8
  %ptr_m8_11af = getelementptr inbounds i32, i32* %rax_11af, i64 -8
  %r8d_m8_11af = load i32, i32* %ptr_m8_11af, align 4
  store i32 %r8d_m8_11af, i32* %r8d.s, align 4
  %edx_now_11b3 = load i32, i32* %edx.s, align 4
  %cmp_11b6 = icmp sle i32 %r8d_m8_11af, %edx_now_11b3
  br i1 %cmp_11b6, label %loc_13B3, label %blk_11bc

loc_13B3:                                            ; 0x13b3
  %rsi_13b3 = load i32*, i32** %rsi.p, align 8
  %rax_new_13b3 = getelementptr inbounds i32, i32* %rsi_13b3, i64 -7
  store i32* %rax_new_13b3, i32** %rax.p, align 8
  %rdi_13ba = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_13ba, i32** %rsi.p, align 8
  br label %loc_11C6

blk_11bc:                                            ; 0x11bc..11c0..11c3 (fall-through work before 11C6)
  %r8d_st_11bc = load i32, i32* %r8d.s, align 4
  %rax_11bc = load i32*, i32** %rax.p, align 8
  %ptr_m7_11bc = getelementptr inbounds i32, i32* %rax_11bc, i64 -7
  store i32 %r8d_st_11bc, i32* %ptr_m7_11bc, align 4
  %rdi_11c0 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_11c0, i32** %rsi.p, align 8
  %rbp_11c3 = load i32*, i32** %rbp.p, align 8
  store i32* %rbp_11c3, i32** %rax.p, align 8
  br label %loc_11C6

loc_12C3:                                            ; 0x12c3
  %rdi_12c3 = load i32*, i32** %rdi.p, align 8
  store i32* %rdi_12c3, i32** %rsi.p, align 8
  store i32* %rdi_12c3, i32** %rax.p, align 8
  br label %loc_11C6

loc_11C6:                                            ; 0x11c6
  %rax_in = phi i32* [ %rdi_12c3, %loc_12C3 ], [ %rbp_11c3, %blk_11bc ], [ %rax_125b_in, %loc_125B ], [ %rax_new_1296, %loc_1296 ], [ %rax_new_12ce, %loc_12CE ], [ %rax_new_12fb, %loc_12FB ], [ %rax_new_132b, %loc_132B ], [ %rax_new_135b, %loc_135B ], [ %rax_new_1387, %loc_1387 ], [ %rax_new_13b3, %loc_13B3 ], [ %rsi_13bf, %loc_13BF ], [ %rsi_13cc, %loc_13CC ], [ %rsi_13d9, %loc_13D9 ], [ %rsi_13e6, %loc_13E6 ], [ %rsi_13f3, %loc_13F3 ], [ %rsi_1400, %loc_1400 ], [ %rsi_140d, %loc_140D ], [ %rsi_141a, %loc_141A ]
  %rcx_prev = load i64, i64* %rcx, align 8
  %rcx_inc = add i64 %rcx_prev, 1
  store i64 %rcx_inc, i64* %rcx, align 8
  %edx_store = load i32, i32* %edx.s, align 4
  store i32 %edx_store, i32* %rax_in, align 4
  %cmp_11cc = icmp ne i64 %rcx_inc, 9
  br i1 %cmp_11cc, label %loc_10D0, label %blk_11d6

blk_11d6:                                            ; 0x11d6..11da then jump to print loop loc_11E8
  %rbp_base = load i32*, i32** %rbp.p, align 8
  %rbp_end = getelementptr inbounds i32, i32* %rbp_base, i64 10
  store i32* %rbp_end, i32** %rbp.p, align 8
  br label %loc_11E8.prep

loc_11E8.prep:                                       ; prepare r12(fmt) and loop vars
  %fmt_ptr = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  br label %loc_11E8

loc_11E8:                                            ; 0x11e8
  %rbx_cur = load i32*, i32** %rbx.p, align 8
  %val = load i32, i32* %rbx_cur, align 4
  %fmt = getelementptr inbounds [4 x i8], [4 x i8]* @unk_2004, i64 0, i64 0
  %rbx_next = getelementptr inbounds i32, i32* %rbx_cur, i64 1
  store i32* %rbx_next, i32** %rbx.p, align 8
  %call = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt, i32 %val)
  %rbp_end2 = load i32*, i32** %rbp.p, align 8
  %rbx_after = load i32*, i32** %rbx.p, align 8
  %cmp_1200 = icmp ne i32* %rbp_end2, %rbx_after
  br i1 %cmp_1200, label %loc_11E8, label %blk_1202

blk_1202:                                            ; 0x1202..1215
  %fmt_nl = getelementptr inbounds [2 x i8], [2 x i8]* @unk_2008, i64 0, i64 0
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_nl)
  %saved = load i64, i64* %canary, align 8
  %guard1 = load i64, i64* @__stack_chk_guard, align 8
  %cmp_canary = icmp ne i64 %saved, %guard1
  br i1 %cmp_canary, label %loc_1427, label %blk_1229

blk_1229:                                            ; 0x1229..1233
  ret i32 0

loc_1427:                                            ; 0x1427
  call void @__stack_chk_fail()
  unreachable
}