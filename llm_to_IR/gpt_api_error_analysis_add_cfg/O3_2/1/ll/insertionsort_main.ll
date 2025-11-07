; ModuleID = 'main_from_asm_0x1080_0x142c'
target triple = "x86_64-unknown-linux-gnu"

@__stack_chk_guard = external global i64
@xmmword_2010 = external global <4 x i32>, align 16
@xmmword_2020 = external global <4 x i32>, align 16
@unk_2004 = external constant [1 x i8], align 1
@unk_2008 = external constant [1 x i8], align 1

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail()

define i32 @main() {
loc_1080:
  %arr = alloca [10 x i32], align 16
  %guard.slot = alloca i64, align 8
  %var_rsi = alloca i8*, align 8
  %var_rdi = alloca i8*, align 8
  %var_rax = alloca i8*, align 8
  %var_rbx = alloca i8*, align 8
  %var_rbp = alloca i8*, align 8
  %var_rcx = alloca i64, align 8
  %var_edx = alloca i32, align 4
  %var_r8d = alloca i32, align 4
  %var_r12 = alloca i8*, align 8
  ; canary
  %can0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %can0, i64* %guard.slot, align 8
  ; base pointers
  %base.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  %base = bitcast i32* %base.i32 to i8*
  store i8* %base, i8** %var_rbp, align 8
  store i8* %base, i8** %var_rbx, align 8
  store i8* %base, i8** %var_rsi, align 8
  store i64 0, i64* %var_rcx, align 8
  ; init 8 ints from XMM constants
  %v0 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %p0v = bitcast i32* %base.i32 to <4 x i32>*
  store <4 x i32> %v0, <4 x i32>* %p0v, align 16
  %p4.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 4
  %p4v = bitcast i32* %p4.i32 to <4 x i32>*
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  store <4 x i32> %v1, <4 x i32>* %p4v, align 16
  ; arr[8] = 4
  %p8.i32 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 8
  store i32 4, i32* %p8.i32, align 4
  br label %loc_10D0

loc_10D0:                                           ; 0x10D0
  %rsi_10d0 = load i8*, i8** %var_rsi, align 8
  %rsi_p4_10d0 = getelementptr inbounds i8, i8* %rsi_10d0, i64 4
  %edx.ptr_10d0 = bitcast i8* %rsi_p4_10d0 to i32*
  %edx_10d0 = load i32, i32* %edx.ptr_10d0, align 4
  store i32 %edx_10d0, i32* %var_edx, align 4
  %r8.ptr_10d0 = bitcast i8* %rsi_10d0 to i32*
  %r8_10d0 = load i32, i32* %r8.ptr_10d0, align 4
  store i32 %r8_10d0, i32* %var_r8d, align 4
  store i8* %rsi_p4_10d0, i8** %var_rdi, align 8
  store i8* %rsi_10d0, i8** %var_rax, align 8
  ; cmp r8d, edx ; jle loc_12C3
  %cmp_10e0 = icmp sle i32 %r8_10d0, %edx_10d0
  br i1 %cmp_10e0, label %loc_12C3, label %bb_10e6

bb_10e6:                                            ; 0x10E6
  ; [rsi+4] = r8d
  store i32 %r8_10d0, i32* %edx.ptr_10d0, align 4
  ; test rcx,rcx ; jz loc_1234
  %rcx_10e6 = load i64, i64* %var_rcx, align 8
  %is_zero_10e6 = icmp eq i64 %rcx_10e6, 0
  br i1 %is_zero_10e6, label %loc_1234, label %loc_10F3

loc_12C3:                                           ; 0x12C3
  ; rsi = rdi ; rax = rdi
  %rdi_12c3 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_12c3, i8** %var_rsi, align 8
  store i8* %rdi_12c3, i8** %var_rax, align 8
  br label %loc_11C6

loc_1234:                                           ; 0x1234
  ; [base] = edx
  %edx_1234 = load i32, i32* %var_edx, align 4
  store i32 %edx_1234, i32* %base.i32, align 4
  ; edx = [rdi+4]
  %rdi_1234 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1234 = getelementptr inbounds i8, i8* %rdi_1234, i64 4
  %edx.ptr_1234 = bitcast i8* %rdi_p4_1234 to i32*
  %edx2_1234 = load i32, i32* %edx.ptr_1234, align 4
  store i32 %edx2_1234, i32* %var_edx, align 4
  ; rsi += 8
  %rsi_1234 = load i8*, i8** %var_rsi, align 8
  %rsi_plus8_1234 = getelementptr inbounds i8, i8* %rsi_1234, i64 8
  store i8* %rsi_plus8_1234, i8** %var_rsi, align 8
  ; rax = rdi
  store i8* %rdi_1234, i8** %var_rax, align 8
  ; ecx = [rdi]
  %rdi_i32ptr_1234 = bitcast i8* %rdi_1234 to i32*
  %ecx_1234 = load i32, i32* %rdi_i32ptr_1234, align 4
  ; cmp ecx, edx2 ; jle loc_13CC
  %cmp_1243 = icmp sle i32 %ecx_1234, %edx2_1234
  br i1 %cmp_1243, label %loc_13CC, label %bb_124b

bb_124b:                                            ; 0x124B
  ; [rdi+4] = ecx
  store i32 %ecx_1234, i32* %edx.ptr_1234, align 4
  ; xchg rdi, rsi
  %rsi_cur_124b = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_cur_124b, i8** %var_rdi, align 8
  store i8* %rdi_1234, i8** %var_rsi, align 8
  ; ecx = 1
  store i64 1, i64* %var_rcx, align 8
  br label %loc_10F3

loc_125B:                                           ; 0x125B
  ; rsi = rdi
  %rdi_125b = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_125b, i8** %var_rsi, align 8
  br label %loc_11C6

loc_1263:                                           ; 0x1263
  ; [base] = edx
  %edx_1263 = load i32, i32* %var_edx, align 4
  store i32 %edx_1263, i32* %base.i32, align 4
  ; edx = [rdi+4]
  %rdi_1263 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1263 = getelementptr inbounds i8, i8* %rdi_1263, i64 4
  %edx.ptr_1263 = bitcast i8* %rdi_p4_1263 to i32*
  %edx2_1263 = load i32, i32* %edx.ptr_1263, align 4
  store i32 %edx2_1263, i32* %var_edx, align 4
  ; rsi = rdi+4
  store i8* %rdi_p4_1263, i8** %var_rsi, align 8
  ; rax = rdi
  store i8* %rdi_1263, i8** %var_rax, align 8
  ; ecx = [rdi]
  %rdi_i32ptr_1263 = bitcast i8* %rdi_1263 to i32*
  %ecx_1263 = load i32, i32* %rdi_i32ptr_1263, align 4
  ; cmp edx2, ecx ; jge loc_13BF
  %cmp_1272 = icmp sge i32 %edx2_1263, %ecx_1263
  br i1 %cmp_1272, label %loc_13BF, label %bb_127a

bb_127a:                                            ; 0x127A
  ; [rdi+4] = ecx
  store i32 %ecx_1263, i32* %edx.ptr_1263, align 4
  ; ecx = 2
  store i64 2, i64* %var_rcx, align 8
  br label %loc_1288

loc_1288:                                           ; 0x1288
  ; r8 = rsi ; rsi = rdi ; rdi = r8
  %rsi_1288 = load i8*, i8** %var_rsi, align 8
  %rdi_1288 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_1288, i8** %var_rsi, align 8
  store i8* %rsi_1288, i8** %var_rdi, align 8
  br label %loc_10F3

loc_1296:                                           ; 0x1296
  ; rax = rsi-4 ; rsi = rdi
  %rsi_1296 = load i8*, i8** %var_rsi, align 8
  %rax_new_1296 = getelementptr inbounds i8, i8* %rsi_1296, i64 -4
  store i8* %rax_new_1296, i8** %var_rax, align 8
  %rdi_1296 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_1296, i8** %var_rsi, align 8
  br label %loc_11C6

loc_12A2:                                           ; 0x12A2
  ; [base] = edx
  %edx_12a2 = load i32, i32* %var_edx, align 4
  store i32 %edx_12a2, i32* %base.i32, align 4
  ; edx = [rdi+4]
  %rdi_12a2 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_12a2 = getelementptr inbounds i8, i8* %rdi_12a2, i64 4
  %edx.ptr_12a2 = bitcast i8* %rdi_p4_12a2 to i32*
  %edx2_12a2 = load i32, i32* %edx.ptr_12a2, align 4
  store i32 %edx2_12a2, i32* %var_edx, align 4
  ; rsi = rdi+4 ; rax = rdi
  store i8* %rdi_p4_12a2, i8** %var_rsi, align 8
  store i8* %rdi_12a2, i8** %var_rax, align 8
  ; ecx = [rdi]
  %rdi_i32ptr_12a2 = bitcast i8* %rdi_12a2 to i32*
  %ecx_12a2 = load i32, i32* %rdi_i32ptr_12a2, align 4
  ; cmp ecx, edx2 ; jle loc_1400
  %cmp_12b1 = icmp sle i32 %ecx_12a2, %edx2_12a2
  br i1 %cmp_12b1, label %loc_1400, label %bb_12b9

bb_12b9:                                            ; 0x12B9
  ; [rdi+4] = ecx ; ecx = 3 ; swap and go 10F3
  store i32 %ecx_12a2, i32* %edx.ptr_12a2, align 4
  store i64 3, i64* %var_rcx, align 8
  br label %loc_1288

loc_12CE:                                           ; 0x12CE
  ; rax = rsi-8 ; rsi = rdi
  %rsi_12ce = load i8*, i8** %var_rsi, align 8
  %rax_new_12ce = getelementptr inbounds i8, i8* %rsi_12ce, i64 -8
  store i8* %rax_new_12ce, i8** %var_rax, align 8
  %rdi_12ce = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_12ce, i8** %var_rsi, align 8
  br label %loc_11C6

loc_12DA:                                           ; 0x12DA
  ; [base] = edx
  %edx_12da = load i32, i32* %var_edx, align 4
  store i32 %edx_12da, i32* %base.i32, align 4
  ; edx = [rdi+4]
  %rdi_12da = load i8*, i8** %var_rdi, align 8
  %rdi_p4_12da = getelementptr inbounds i8, i8* %rdi_12da, i64 4
  %edx.ptr_12da = bitcast i8* %rdi_p4_12da to i32*
  %edx2_12da = load i32, i32* %edx.ptr_12da, align 4
  store i32 %edx2_12da, i32* %var_edx, align 4
  ; rsi = rdi+4 ; rax = rdi
  store i8* %rdi_p4_12da, i8** %var_rsi, align 8
  store i8* %rdi_12da, i8** %var_rax, align 8
  ; ecx = [rdi]
  %rdi_i32ptr_12da = bitcast i8* %rdi_12da to i32*
  %ecx_12da = load i32, i32* %rdi_i32ptr_12da, align 4
  ; cmp edx2, ecx ; jge loc_140D
  %cmp_12e9 = icmp sge i32 %edx2_12da, %ecx_12da
  br i1 %cmp_12e9, label %loc_140D, label %bb_12f1

bb_12f1:                                            ; 0x12F1
  store i32 %ecx_12da, i32* %edx.ptr_12da, align 4
  store i64 4, i64* %var_rcx, align 8
  br label %loc_1288

loc_12FB:                                           ; 0x12FB
  ; rax = rsi-0xc ; rsi = rdi
  %rsi_12fb = load i8*, i8** %var_rsi, align 8
  %rax_new_12fb = getelementptr inbounds i8, i8* %rsi_12fb, i64 -12
  store i8* %rax_new_12fb, i8** %var_rax, align 8
  %rdi_12fb = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_12fb, i8** %var_rsi, align 8
  br label %loc_11C6

loc_1307:                                           ; 0x1307
  %edx_1307 = load i32, i32* %var_edx, align 4
  store i32 %edx_1307, i32* %base.i32, align 4
  %rdi_1307 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1307 = getelementptr inbounds i8, i8* %rdi_1307, i64 4
  %edx.ptr_1307 = bitcast i8* %rdi_p4_1307 to i32*
  %edx2_1307 = load i32, i32* %edx.ptr_1307, align 4
  store i32 %edx2_1307, i32* %var_edx, align 4
  store i8* %rdi_p4_1307, i8** %var_rsi, align 8
  store i8* %rdi_1307, i8** %var_rax, align 8
  %rdi_i32ptr_1307 = bitcast i8* %rdi_1307 to i32*
  %ecx_1307 = load i32, i32* %rdi_i32ptr_1307, align 4
  ; cmp edx2, ecx ; jge loc_13E6
  %cmp_1316 = icmp sge i32 %edx2_1307, %ecx_1307
  br i1 %cmp_1316, label %loc_13E6, label %bb_131e

bb_131e:                                            ; 0x131E
  store i32 %ecx_1307, i32* %edx.ptr_1307, align 4
  store i64 5, i64* %var_rcx, align 8
  br label %loc_1288

loc_132B:                                           ; 0x132B
  %rsi_132b = load i8*, i8** %var_rsi, align 8
  %rax_new_132b = getelementptr inbounds i8, i8* %rsi_132b, i64 -16
  store i8* %rax_new_132b, i8** %var_rax, align 8
  %rdi_132b = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_132b, i8** %var_rsi, align 8
  br label %loc_11C6

loc_1337:                                           ; 0x1337
  %edx_1337 = load i32, i32* %var_edx, align 4
  store i32 %edx_1337, i32* %base.i32, align 4
  %rdi_1337 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1337 = getelementptr inbounds i8, i8* %rdi_1337, i64 4
  %edx.ptr_1337 = bitcast i8* %rdi_p4_1337 to i32*
  %edx2_1337 = load i32, i32* %edx.ptr_1337, align 4
  store i32 %edx2_1337, i32* %var_edx, align 4
  store i8* %rdi_p4_1337, i8** %var_rsi, align 8
  store i8* %rdi_1337, i8** %var_rax, align 8
  %rdi_i32ptr_1337 = bitcast i8* %rdi_1337 to i32*
  %ecx_1337 = load i32, i32* %rdi_i32ptr_1337, align 4
  ; cmp edx2, ecx ; jge loc_13F3
  %cmp_1346 = icmp sge i32 %edx2_1337, %ecx_1337
  br i1 %cmp_1346, label %loc_13F3, label %bb_134e

bb_134e:                                            ; 0x134E
  store i32 %ecx_1337, i32* %edx.ptr_1337, align 4
  store i64 6, i64* %var_rcx, align 8
  br label %loc_1288

loc_135B:                                           ; 0x135B
  %rsi_135b = load i8*, i8** %var_rsi, align 8
  %rax_new_135b = getelementptr inbounds i8, i8* %rsi_135b, i64 -20
  store i8* %rax_new_135b, i8** %var_rax, align 8
  %rdi_135b = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_135b, i8** %var_rsi, align 8
  br label %loc_11C6

loc_1367:                                           ; 0x1367
  %edx_1367 = load i32, i32* %var_edx, align 4
  store i32 %edx_1367, i32* %base.i32, align 4
  %rdi_1367 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1367 = getelementptr inbounds i8, i8* %rdi_1367, i64 4
  %edx.ptr_1367 = bitcast i8* %rdi_p4_1367 to i32*
  %edx2_1367 = load i32, i32* %edx.ptr_1367, align 4
  store i32 %edx2_1367, i32* %var_edx, align 4
  store i8* %rdi_p4_1367, i8** %var_rsi, align 8
  store i8* %rdi_1367, i8** %var_rax, align 8
  %rdi_i32ptr_1367 = bitcast i8* %rdi_1367 to i32*
  %ecx_1367 = load i32, i32* %rdi_i32ptr_1367, align 4
  ; cmp edx2, ecx ; jge loc_13D9
  %cmp_1376 = icmp sge i32 %edx2_1367, %ecx_1367
  br i1 %cmp_1376, label %loc_13D9, label %bb_137a

bb_137a:                                            ; 0x137A
  store i32 %ecx_1367, i32* %edx.ptr_1367, align 4
  store i64 7, i64* %var_rcx, align 8
  br label %loc_1288

loc_1387:                                           ; 0x1387
  %rsi_1387 = load i8*, i8** %var_rsi, align 8
  %rax_new_1387 = getelementptr inbounds i8, i8* %rsi_1387, i64 -24
  store i8* %rax_new_1387, i8** %var_rax, align 8
  %rdi_1387 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_1387, i8** %var_rsi, align 8
  br label %loc_11C6

loc_1393:                                           ; 0x1393
  %edx_1393 = load i32, i32* %var_edx, align 4
  store i32 %edx_1393, i32* %base.i32, align 4
  %rdi_1393 = load i8*, i8** %var_rdi, align 8
  %rdi_p4_1393 = getelementptr inbounds i8, i8* %rdi_1393, i64 4
  %edx.ptr_1393 = bitcast i8* %rdi_p4_1393 to i32*
  %edx2_1393 = load i32, i32* %edx.ptr_1393, align 4
  store i32 %edx2_1393, i32* %var_edx, align 4
  store i8* %rdi_p4_1393, i8** %var_rsi, align 8
  store i8* %rdi_1393, i8** %var_rax, align 8
  %rdi_i32ptr_1393 = bitcast i8* %rdi_1393 to i32*
  %ecx_1393 = load i32, i32* %rdi_i32ptr_1393, align 4
  ; cmp edx2, ecx ; jge loc_141A
  %cmp_13a4 = icmp sge i32 %edx2_1393, %ecx_1393
  br i1 %cmp_13a4, label %loc_141A, label %bb_13a6

bb_13a6:                                            ; 0x13A6
  store i32 %ecx_1393, i32* %edx.ptr_1393, align 4
  store i64 8, i64* %var_rcx, align 8
  br label %loc_1288

loc_13B3:                                           ; 0x13B3
  %rsi_13b3 = load i8*, i8** %var_rsi, align 8
  %rax_new_13b3 = getelementptr inbounds i8, i8* %rsi_13b3, i64 -28
  store i8* %rax_new_13b3, i8** %var_rax, align 8
  %rdi_13b3 = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_13b3, i8** %var_rsi, align 8
  br label %loc_11C6

loc_13BF:                                           ; 0x13BF
  %rsi_13bf = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_13bf, i8** %var_rax, align 8
  store i64 2, i64* %var_rcx, align 8
  br label %loc_11C6

loc_13CC:                                           ; 0x13CC
  %rsi_13cc = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_13cc, i8** %var_rax, align 8
  store i64 1, i64* %var_rcx, align 8
  br label %loc_11C6

loc_13D9:                                           ; 0x13D9
  %rsi_13d9 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_13d9, i8** %var_rax, align 8
  store i64 7, i64* %var_rcx, align 8
  br label %loc_11C6

loc_13E6:                                           ; 0x13E6
  %rsi_13e6 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_13e6, i8** %var_rax, align 8
  store i64 5, i64* %var_rcx, align 8
  br label %loc_11C6

loc_13F3:                                           ; 0x13F3
  %rsi_13f3 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_13f3, i8** %var_rax, align 8
  store i64 6, i64* %var_rcx, align 8
  br label %loc_11C6

loc_1400:                                           ; 0x1400
  %rsi_1400 = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_1400, i8** %var_rax, align 8
  store i64 3, i64* %var_rcx, align 8
  br label %loc_11C6

loc_140D:                                           ; 0x140D
  %rsi_140d = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_140d, i8** %var_rax, align 8
  store i64 4, i64* %var_rcx, align 8
  br label %loc_11C6

loc_141A:                                           ; 0x141A
  %rsi_141a = load i8*, i8** %var_rsi, align 8
  store i8* %rsi_141a, i8** %var_rax, align 8
  store i64 8, i64* %var_rcx, align 8
  br label %loc_11C6

loc_10F3:                                           ; 0x10F3
  ; step -4
  %edx_f3 = load i32, i32* %var_edx, align 4
  %rax_f3 = load i8*, i8** %var_rax, align 8
  %ptr_m4 = getelementptr inbounds i8, i8* %rax_f3, i64 -4
  %ptr_m4_i32 = bitcast i8* %ptr_m4 to i32*
  %r8_m4 = load i32, i32* %ptr_m4_i32, align 4
  ; cmp r8m4, edx ; jle 125B
  %cmp_f3_m4 = icmp sle i32 %r8_m4, %edx_f3
  br i1 %cmp_f3_m4, label %loc_125B, label %bb_1100

bb_1100:                                            ; 0x1100
  ; [rax] = r8m4
  %rax_i32 = bitcast i8* %rax_f3 to i32*
  store i32 %r8_m4, i32* %rax_i32, align 4
  ; cmp rcx, 1 ; jz 1263
  %rcx_f3 = load i64, i64* %var_rcx, align 8
  %is_one = icmp eq i64 %rcx_f3, 1
  br i1 %is_one, label %loc_1263, label %bb_110d

bb_110d:                                            ; 0x110D
  ; step -8
  %ptr_m8 = getelementptr inbounds i8, i8* %rax_f3, i64 -8
  %ptr_m8_i32 = bitcast i8* %ptr_m8 to i32*
  %r8_m8 = load i32, i32* %ptr_m8_i32, align 4
  %cmp_m8 = icmp sle i32 %r8_m8, %edx_f3
  br i1 %cmp_m8, label %loc_1296, label %bb_111a

bb_111a:                                            ; 0x111A
  ; [rax-4] = r8m8
  store i32 %r8_m8, i32* %ptr_m4_i32, align 4
  ; cmp rcx, 2 ; jz 12A2
  %rcx_now_111a = load i64, i64* %var_rcx, align 8
  %is_two = icmp eq i64 %rcx_now_111a, 2
  br i1 %is_two, label %loc_12A2, label %bb_1128

bb_1128:                                            ; 0x1128
  ; step -12
  %ptr_m12 = getelementptr inbounds i8, i8* %rax_f3, i64 -12
  %ptr_m12_i32 = bitcast i8* %ptr_m12 to i32*
  %r8_m12 = load i32, i32* %ptr_m12_i32, align 4
  %cmp_m12 = icmp sle i32 %r8_m12, %edx_f3
  br i1 %cmp_m12, label %loc_12CE, label %bb_1135

bb_1135:                                            ; 0x1135
  ; [rax-8] = r8m12
  store i32 %r8_m12, i32* %ptr_m8_i32, align 4
  ; cmp rcx, 3 ; jz 12DA
  %rcx_now_1135 = load i64, i64* %var_rcx, align 8
  %is_three = icmp eq i64 %rcx_now_1135, 3
  br i1 %is_three, label %loc_12DA, label %bb_1143

bb_1143:                                            ; 0x1143
  ; step -16
  %ptr_m16 = getelementptr inbounds i8, i8* %rax_f3, i64 -16
  %ptr_m16_i32 = bitcast i8* %ptr_m16 to i32*
  %r8_m16 = load i32, i32* %ptr_m16_i32, align 4
  %cmp_m16 = icmp sle i32 %r8_m16, %edx_f3
  br i1 %cmp_m16, label %loc_12FB, label %bb_1150

bb_1150:                                            ; 0x1150
  ; [rax-0xc] = r8m16
  store i32 %r8_m16, i32* %ptr_m12_i32, align 4
  ; cmp rcx, 4 ; jz 1307
  %rcx_now_1150 = load i64, i64* %var_rcx, align 8
  %is_four = icmp eq i64 %rcx_now_1150, 4
  br i1 %is_four, label %loc_1307, label %bb_115e

bb_115e:                                            ; 0x115E
  ; step -20
  %ptr_m20 = getelementptr inbounds i8, i8* %rax_f3, i64 -20
  %ptr_m20_i32 = bitcast i8* %ptr_m20 to i32*
  %r8_m20 = load i32, i32* %ptr_m20_i32, align 4
  %cmp_m20 = icmp sle i32 %r8_m20, %edx_f3
  br i1 %cmp_m20, label %loc_132B, label %bb_116b

bb_116b:                                            ; 0x116B
  ; [rax-0x10] = r8m20
  store i32 %r8_m20, i32* %ptr_m16_i32, align 4
  ; cmp rcx, 5 ; jz 1337
  %rcx_now_116b = load i64, i64* %var_rcx, align 8
  %is_five = icmp eq i64 %rcx_now_116b, 5
  br i1 %is_five, label %loc_1337, label %bb_1179

bb_1179:                                            ; 0x1179
  ; step -24
  %ptr_m24 = getelementptr inbounds i8, i8* %rax_f3, i64 -24
  %ptr_m24_i32 = bitcast i8* %ptr_m24 to i32*
  %r8_m24 = load i32, i32* %ptr_m24_i32, align 4
  %cmp_m24 = icmp sle i32 %r8_m24, %edx_f3
  br i1 %cmp_m24, label %loc_135B, label %bb_1186

bb_1186:                                            ; 0x1186
  ; [rax-0x14] = r8m24
  store i32 %r8_m24, i32* %ptr_m20_i32, align 4
  ; cmp rcx, 6 ; jz 1367
  %rcx_now_1186 = load i64, i64* %var_rcx, align 8
  %is_six = icmp eq i64 %rcx_now_1186, 6
  br i1 %is_six, label %loc_1367, label %bb_1194

bb_1194:                                            ; 0x1194
  ; step -28
  %ptr_m28 = getelementptr inbounds i8, i8* %rax_f3, i64 -28
  %ptr_m28_i32 = bitcast i8* %ptr_m28 to i32*
  %r8_m28 = load i32, i32* %ptr_m28_i32, align 4
  %cmp_m28 = icmp sle i32 %r8_m28, %edx_f3
  br i1 %cmp_m28, label %loc_1387, label %bb_11a1

bb_11a1:                                            ; 0x11A1
  ; [rax-0x18] = r8m28
  store i32 %r8_m28, i32* %ptr_m24_i32, align 4
  ; cmp rcx, 7 ; jz 1393
  %rcx_now_11a1 = load i64, i64* %var_rcx, align 8
  %is_seven = icmp eq i64 %rcx_now_11a1, 7
  br i1 %is_seven, label %loc_1393, label %bb_11af

bb_11af:                                            ; 0x11AF
  ; step -32
  %ptr_m32 = getelementptr inbounds i8, i8* %rax_f3, i64 -32
  %ptr_m32_i32 = bitcast i8* %ptr_m32 to i32*
  %r8_m32 = load i32, i32* %ptr_m32_i32, align 4
  %cmp_m32 = icmp sle i32 %r8_m32, %edx_f3
  br i1 %cmp_m32, label %loc_13B3, label %bb_11bc

bb_11bc:                                            ; 0x11BC (falls to 11C0/11C3 before 11C6)
  ; [rax-0x1c] = r8m32
  store i32 %r8_m32, i32* %ptr_m28_i32, align 4
  ; rsi = rdi
  %rdi_11bc = load i8*, i8** %var_rdi, align 8
  store i8* %rdi_11bc, i8** %var_rsi, align 8
  ; rax = rbp (base)
  %rbp_base_11bc = load i8*, i8** %var_rbp, align 8
  store i8* %rbp_base_11bc, i8** %var_rax, align 8
  br label %loc_11C6

loc_11C6:                                           ; 0x11C6
  ; rcx += 1
  %rcx_cur_11c6 = load i64, i64* %var_rcx, align 8
  %rcx_inc = add i64 %rcx_cur_11c6, 1
  store i64 %rcx_inc, i64* %var_rcx, align 8
  ; [rax] = edx
  %rax_11c6 = load i8*, i8** %var_rax, align 8
  %rax_11c6_i32 = bitcast i8* %rax_11c6 to i32*
  %edx_11c6 = load i32, i32* %var_edx, align 4
  store i32 %edx_11c6, i32* %rax_11c6_i32, align 4
  ; cmp rcx, 9 ; jnz 10D0
  %cmp_11cc = icmp ne i64 %rcx_inc, 9
  br i1 %cmp_11cc, label %loc_10D0, label %bb_11d6

bb_11d6:                                            ; 0x11D6
  ; rbp += 0x28
  %rbp_base_11d6 = load i8*, i8** %var_rbp, align 8
  %endptr = getelementptr inbounds i8, i8* %rbp_base_11d6, i64 40
  ; lea r12, unk_2004
  %fmt1.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_2004, i64 0, i64 0
  store i8* %fmt1.ptr, i8** %var_r12, align 8
  br label %loc_11E8

loc_11E8:                                           ; 0x11E8
  ; mov edx, [rbx]
  %rbx_11e8 = load i8*, i8** %var_rbx, align 8
  %rbx_i32_11e8 = bitcast i8* %rbx_11e8 to i32*
  %val_11e8 = load i32, i32* %rbx_i32_11e8, align 4
  ; rsi = r12 ; edi = 2 ; call ___printf_chk(2, fmt, val)
  %fmt1_11e8 = load i8*, i8** %var_r12, align 8
  %rbx_next = getelementptr inbounds i8, i8* %rbx_11e8, i64 4
  store i8* %rbx_next, i8** %var_rbx, align 8
  %call_11f8 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt1_11e8, i32 %val_11e8)
  ; cmp rbp, rbx ; jnz loc_11E8
  %rbx_now = load i8*, i8** %var_rbx, align 8
  %cmp_11fd = icmp ne i8* %endptr, %rbx_now
  br i1 %cmp_11fd, label %loc_11E8, label %bb_1202

bb_1202:                                            ; 0x1202
  ; xor eax,eax ; lea rsi, unk_2008 ; edi=2 ; call ___printf_chk
  %fmt2.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_2008, i64 0, i64 0
  %call_1210 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt2.ptr)
  ; canary check
  %saved = load i64, i64* %guard.slot, align 8
  %cur = load i64, i64* @__stack_chk_guard, align 8
  %ccmp = icmp ne i64 %saved, %cur
  br i1 %ccmp, label %loc_1427, label %bb_1229

bb_1229:                                            ; 0x1229
  ; epilogue return 0
  ret i32 0

loc_1427:                                           ; 0x1427
  call void @___stack_chk_fail()
  unreachable
}