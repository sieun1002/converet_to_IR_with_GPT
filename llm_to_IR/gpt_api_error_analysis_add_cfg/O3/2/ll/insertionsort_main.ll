; ModuleID = 'recovered_main_0x1080_0x142c'
target triple = "x86_64-pc-linux-gnu"

@xmmword_2010 = internal constant <4 x i32> <i32 9, i32 1, i32 8, i32 3>, align 16
@xmmword_2020 = internal constant <4 x i32> <i32 2, i32 7, i32 5, i32 6>, align 16
@.str_fmt = private unnamed_addr constant [4 x i8] c"%d \00", align 1
@.str_nl  = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

@__stack_chk_guard = external global i64, align 8

declare i32 @___printf_chk(i32, i8*, ...)
declare void @___stack_chk_fail() noreturn

define i32 @main() local_unnamed_addr {
L1080:
  %arr = alloca [10 x i32], align 16
  %rsi = alloca i32*, align 8
  %rdi = alloca i32*, align 8
  %raxp = alloca i32*, align 8
  %rbp = alloca i32*, align 8
  %rbx = alloca i32*, align 8
  %r12 = alloca i8*, align 8
  %rcx = alloca i64, align 8
  %edx = alloca i32, align 4
  %r8d = alloca i32, align 4
  %canary_saved = alloca i64, align 8

  ; stack protector: save canary
  %guard0 = load i64, i64* @__stack_chk_guard, align 8
  store i64 %guard0, i64* %canary_saved, align 8

  ; ecx = 0
  store i64 0, i64* %rcx, align 8

  ; rbp = &arr[0]
  %arr0 = getelementptr inbounds [10 x i32], [10 x i32]* %arr, i64 0, i64 0
  store i32* %arr0, i32** %rbp, align 8

  ; rbx = rbp
  store i32* %arr0, i32** %rbx, align 8

  ; rsi = rbp
  store i32* %arr0, i32** %rsi, align 8

  ; initialize array with two vectors and one scalar (positions 0..7 from vectors, 8 = 4)
  %v1 = load <4 x i32>, <4 x i32>* @xmmword_2010, align 16
  %pvec0 = bitcast i32* %arr0 to <4 x i32>*
  store <4 x i32> %v1, <4 x i32>* %pvec0, align 16

  %v2 = load <4 x i32>, <4 x i32>* @xmmword_2020, align 16
  %arr4 = getelementptr inbounds i32, i32* %arr0, i64 4
  %pvec4 = bitcast i32* %arr4 to <4 x i32>*
  store <4 x i32> %v2, <4 x i32>* %pvec4, align 16

  %arr8 = getelementptr inbounds i32, i32* %arr0, i64 8
  store i32 4, i32* %arr8, align 4

  br label %L10D0

L10D0:
  ; edx = [rsi+1], r8d = [rsi], rdi = rsi+1, rax = rsi
  %rsi_ld_10d0 = load i32*, i32** %rsi, align 8
  %edx_ptr_10d0 = getelementptr inbounds i32, i32* %rsi_ld_10d0, i64 1
  %edx_val_10d0 = load i32, i32* %edx_ptr_10d0, align 4
  store i32 %edx_val_10d0, i32* %edx, align 4

  %r8_ptr_10d0 = getelementptr inbounds i32, i32* %rsi_ld_10d0, i64 0
  %r8_val_10d0 = load i32, i32* %r8_ptr_10d0, align 4
  store i32 %r8_val_10d0, i32* %r8d, align 4

  store i32* %edx_ptr_10d0, i32** %rdi, align 8
  store i32* %rsi_ld_10d0, i32** %raxp, align 8

  ; cmp r8d, edx ; jle L12C3
  %r8_now_10d0 = load i32, i32* %r8d, align 4
  %edx_now_10d0 = load i32, i32* %edx, align 4
  %cmp_10e0 = icmp sle i32 %r8_now_10d0, %edx_now_10d0
  br i1 %cmp_10e0, label %L12C3, label %L10E6

L10E6:
  ; [rsi+1] = r8d
  %rsi_ld_10e6 = load i32*, i32** %rsi, align 8
  %r8_now_10e6 = load i32, i32* %r8d, align 4
  %ptr_next_10e6 = getelementptr inbounds i32, i32* %rsi_ld_10e6, i64 1
  store i32 %r8_now_10e6, i32* %ptr_next_10e6, align 4

  ; test rcx, rcx ; jz L1234
  %rcx_ld_10ea = load i64, i64* %rcx, align 8
  %is_zero_10ed = icmp eq i64 %rcx_ld_10ea, 0
  br i1 %is_zero_10ed, label %L1234, label %L10F3

L10F3:
  ; r8d = [rax-1] ; cmp r8d, edx ; jle L125B
  %rax_ld_10f3 = load i32*, i32** %raxp, align 8
  %ptr_m1_10f3 = getelementptr inbounds i32, i32* %rax_ld_10f3, i64 -1
  %r8_val_10f3 = load i32, i32* %ptr_m1_10f3, align 4
  store i32 %r8_val_10f3, i32* %r8d, align 4

  %edx_now_10f7 = load i32, i32* %edx, align 4
  %r8_now_10f7 = load i32, i32* %r8d, align 4
  %cmp_10fa = icmp sle i32 %r8_now_10f7, %edx_now_10f7
  br i1 %cmp_10fa, label %L125B, label %L1100

L1100:
  ; [rax] = r8d
  %rax_ld_1100 = load i32*, i32** %raxp, align 8
  %r8_now_1100 = load i32, i32* %r8d, align 4
  store i32 %r8_now_1100, i32* %rax_ld_1100, align 4

  ; cmp rcx, 1 ; jz L1263
  %rcx_ld_1103 = load i64, i64* %rcx, align 8
  %cmp_1107 = icmp eq i64 %rcx_ld_1103, 1
  br i1 %cmp_1107, label %L1263, label %L110D

L110D:
  ; r8d = [rax-2] ; cmp r8d, edx ; jle L1296
  %rax_ld_110d = load i32*, i32** %raxp, align 8
  %ptr_m2_110d = getelementptr inbounds i32, i32* %rax_ld_110d, i64 -2
  %r8_val_110d = load i32, i32* %ptr_m2_110d, align 4
  store i32 %r8_val_110d, i32* %r8d, align 4

  %edx_now_1111 = load i32, i32* %edx, align 4
  %r8_now_1111 = load i32, i32* %r8d, align 4
  %cmp_1114 = icmp sle i32 %r8_now_1111, %edx_now_1111
  br i1 %cmp_1114, label %L1296, label %L111A

L111A:
  ; [rax-1] = r8d
  %rax_ld_111a = load i32*, i32** %raxp, align 8
  %ptr_m1_111a = getelementptr inbounds i32, i32* %rax_ld_111a, i64 -1
  %r8_now_111a = load i32, i32* %r8d, align 4
  store i32 %r8_now_111a, i32* %ptr_m1_111a, align 4

  ; cmp rcx, 2 ; jz L12A2
  %rcx_ld_111e = load i64, i64* %rcx, align 8
  %cmp_1122 = icmp eq i64 %rcx_ld_111e, 2
  br i1 %cmp_1122, label %L12A2, label %L1128

L1128:
  ; r8d = [rax-3] ; cmp r8d, edx ; jle L12CE
  %rax_ld_1128 = load i32*, i32** %raxp, align 8
  %ptr_m3_1128 = getelementptr inbounds i32, i32* %rax_ld_1128, i64 -3
  %r8_val_1128 = load i32, i32* %ptr_m3_1128, align 4
  store i32 %r8_val_1128, i32* %r8d, align 4

  %edx_now_112c = load i32, i32* %edx, align 4
  %r8_now_112c = load i32, i32* %r8d, align 4
  %cmp_112f = icmp sle i32 %r8_now_112c, %edx_now_112c
  br i1 %cmp_112f, label %L12CE, label %L1135

L1135:
  ; [rax-2] = r8d
  %rax_ld_1135 = load i32*, i32** %raxp, align 8
  %ptr_m2_1135 = getelementptr inbounds i32, i32* %rax_ld_1135, i64 -2
  %r8_now_1135 = load i32, i32* %r8d, align 4
  store i32 %r8_now_1135, i32* %ptr_m2_1135, align 4

  ; cmp rcx, 3 ; jz L12DA
  %rcx_ld_1139 = load i64, i64* %rcx, align 8
  %cmp_113d = icmp eq i64 %rcx_ld_1139, 3
  br i1 %cmp_113d, label %L12DA, label %L1143

L1143:
  ; r8d = [rax-4] ; cmp r8d, edx ; jle L12FB
  %rax_ld_1143 = load i32*, i32** %raxp, align 8
  %ptr_m4_1143 = getelementptr inbounds i32, i32* %rax_ld_1143, i64 -4
  %r8_val_1143 = load i32, i32* %ptr_m4_1143, align 4
  store i32 %r8_val_1143, i32* %r8d, align 4

  %edx_now_1147 = load i32, i32* %edx, align 4
  %r8_now_1147 = load i32, i32* %r8d, align 4
  %cmp_114a = icmp sle i32 %r8_now_1147, %edx_now_1147
  br i1 %cmp_114a, label %L12FB, label %L1150

L1150:
  ; [rax-3] = r8d
  %rax_ld_1150 = load i32*, i32** %raxp, align 8
  %ptr_m3_1150 = getelementptr inbounds i32, i32* %rax_ld_1150, i64 -3
  %r8_now_1150 = load i32, i32* %r8d, align 4
  store i32 %r8_now_1150, i32* %ptr_m3_1150, align 4

  ; cmp rcx, 4 ; jz L1307
  %rcx_ld_1154 = load i64, i64* %rcx, align 8
  %cmp_1158 = icmp eq i64 %rcx_ld_1154, 4
  br i1 %cmp_1158, label %L1307, label %L115E

L115E:
  ; r8d = [rax-5] ; cmp r8d, edx ; jle L132B
  %rax_ld_115e = load i32*, i32** %raxp, align 8
  %ptr_m5_115e = getelementptr inbounds i32, i32* %rax_ld_115e, i64 -5
  %r8_val_115e = load i32, i32* %ptr_m5_115e, align 4
  store i32 %r8_val_115e, i32* %r8d, align 4

  %edx_now_1162 = load i32, i32* %edx, align 4
  %r8_now_1162 = load i32, i32* %r8d, align 4
  %cmp_1165 = icmp sle i32 %r8_now_1162, %edx_now_1162
  br i1 %cmp_1165, label %L132B, label %L116B

L116B:
  ; [rax-4] = r8d
  %rax_ld_116b = load i32*, i32** %raxp, align 8
  %ptr_m4_116b = getelementptr inbounds i32, i32* %rax_ld_116b, i64 -4
  %r8_now_116b = load i32, i32* %r8d, align 4
  store i32 %r8_now_116b, i32* %ptr_m4_116b, align 4

  ; cmp rcx, 5 ; jz L1337
  %rcx_ld_116f = load i64, i64* %rcx, align 8
  %cmp_1173 = icmp eq i64 %rcx_ld_116f, 5
  br i1 %cmp_1173, label %L1337, label %L1179

L1179:
  ; r8d = [rax-6] ; cmp r8d, edx ; jle L135B
  %rax_ld_1179 = load i32*, i32** %raxp, align 8
  %ptr_m6_1179 = getelementptr inbounds i32, i32* %rax_ld_1179, i64 -6
  %r8_val_1179 = load i32, i32* %ptr_m6_1179, align 4
  store i32 %r8_val_1179, i32* %r8d, align 4

  %edx_now_117d = load i32, i32* %edx, align 4
  %r8_now_117d = load i32, i32* %r8d, align 4
  %cmp_1180 = icmp sle i32 %r8_now_117d, %edx_now_117d
  br i1 %cmp_1180, label %L135B, label %L1186

L1186:
  ; [rax-5] = r8d
  %rax_ld_1186 = load i32*, i32** %raxp, align 8
  %ptr_m5_1186 = getelementptr inbounds i32, i32* %rax_ld_1186, i64 -5
  %r8_now_1186 = load i32, i32* %r8d, align 4
  store i32 %r8_now_1186, i32* %ptr_m5_1186, align 4

  ; cmp rcx, 6 ; jz L1367
  %rcx_ld_118a = load i64, i64* %rcx, align 8
  %cmp_118e = icmp eq i64 %rcx_ld_118a, 6
  br i1 %cmp_118e, label %L1367, label %L1194

L1194:
  ; r8d = [rax-7] ; cmp r8d, edx ; jle L1387
  %rax_ld_1194 = load i32*, i32** %raxp, align 8
  %ptr_m7_1194 = getelementptr inbounds i32, i32* %rax_ld_1194, i64 -7
  %r8_val_1194 = load i32, i32* %ptr_m7_1194, align 4
  store i32 %r8_val_1194, i32* %r8d, align 4

  %edx_now_1198 = load i32, i32* %edx, align 4
  %r8_now_1198 = load i32, i32* %r8d, align 4
  %cmp_119b = icmp sle i32 %r8_now_1198, %edx_now_1198
  br i1 %cmp_119b, label %L1387, label %L11A1

L11A1:
  ; [rax-6] = r8d
  %rax_ld_11a1 = load i32*, i32** %raxp, align 8
  %ptr_m6_11a1 = getelementptr inbounds i32, i32* %rax_ld_11a1, i64 -6
  %r8_now_11a1 = load i32, i32* %r8d, align 4
  store i32 %r8_now_11a1, i32* %ptr_m6_11a1, align 4

  ; cmp rcx, 7 ; jz L1393
  %rcx_ld_11a5 = load i64, i64* %rcx, align 8
  %cmp_11a9 = icmp eq i64 %rcx_ld_11a5, 7
  br i1 %cmp_11a9, label %L1393, label %L11AF

L11AF:
  ; r8d = [rax-8] ; cmp r8d, edx ; jle L13B3
  %rax_ld_11af = load i32*, i32** %raxp, align 8
  %ptr_m8_11af = getelementptr inbounds i32, i32* %rax_ld_11af, i64 -8
  %r8_val_11af = load i32, i32* %ptr_m8_11af, align 4
  store i32 %r8_val_11af, i32* %r8d, align 4

  %edx_now_11b3 = load i32, i32* %edx, align 4
  %r8_now_11b3 = load i32, i32* %r8d, align 4
  %cmp_11b6 = icmp sle i32 %r8_now_11b3, %edx_now_11b3
  br i1 %cmp_11b6, label %L13B3, label %L11BC

L11BC:
  ; [rax-7] = r8d
  %rax_ld_11bc = load i32*, i32** %raxp, align 8
  %ptr_m7_11bc = getelementptr inbounds i32, i32* %rax_ld_11bc, i64 -7
  %r8_now_11bc = load i32, i32* %r8d, align 4
  store i32 %r8_now_11bc, i32* %ptr_m7_11bc, align 4

  ; fall-through moves before L11C6: rsi = rdi ; rax = rbp
  %rdi_ld_11c0 = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_11c0, i32** %rsi, align 8
  %rbp_ld_11c3 = load i32*, i32** %rbp, align 8
  store i32* %rbp_ld_11c3, i32** %raxp, align 8
  br label %L11C6

L11C6:
  ; add rcx, 1
  %rcx_ld_11c6 = load i64, i64* %rcx, align 8
  %rcx_inc_11c6 = add i64 %rcx_ld_11c6, 1
  store i64 %rcx_inc_11c6, i64* %rcx, align 8

  ; [rax] = edx
  %rax_ld_11ca = load i32*, i32** %raxp, align 8
  %edx_now_11ca = load i32, i32* %edx, align 4
  store i32 %edx_now_11ca, i32* %rax_ld_11ca, align 4

  ; cmp rcx, 9 ; jnz L10D0
  %rcx_ld_11cc = load i64, i64* %rcx, align 8
  %cmp_11d0 = icmp ne i64 %rcx_ld_11cc, 9
  br i1 %cmp_11d0, label %L10D0, label %L11D6

L11D6:
  ; rbp = rbp + 0x28 (end pointer = start + 10 ints)
  %rbp_start_11d6 = load i32*, i32** %rbp, align 8
  %rbp_end_11d6 = getelementptr inbounds i32, i32* %rbp_start_11d6, i64 10
  store i32* %rbp_end_11d6, i32** %rbp, align 8

  ; r12 = &fmt
  %fmt_ptr_11da = getelementptr inbounds [4 x i8], [4 x i8]* @.str_fmt, i64 0, i64 0
  store i8* %fmt_ptr_11da, i8** %r12, align 8

  br label %L11E8

L11E8:
  ; edx = [rbx]
  %rbx_ld_11e8 = load i32*, i32** %rbx, align 8
  %val_11e8 = load i32, i32* %rbx_ld_11e8, align 4
  store i32 %val_11e8, i32* %edx, align 4

  ; rsi = r12 ; edi = 2 ; call ___printf_chk(2, r12, edx)
  %fmt_ld_11ea = load i8*, i8** %r12, align 8
  %val_edx_11ea = load i32, i32* %edx, align 4
  %rbx_next_11f4 = getelementptr inbounds i32, i32* %rbx_ld_11e8, i64 1
  store i32* %rbx_next_11f4, i32** %rbx, align 8
  %call_11f8 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %fmt_ld_11ea, i32 %val_edx_11ea)

  ; cmp rbp, rbx ; jnz L11E8
  %rbp_end_ld_11fd = load i32*, i32** %rbp, align 8
  %rbx_now_11fd = load i32*, i32** %rbx, align 8
  %cmp_1200 = icmp ne i32* %rbx_now_11fd, %rbp_end_ld_11fd
  br i1 %cmp_1200, label %L11E8, label %L1202

L1202:
  ; print newline: ___printf_chk(2, "\n")
  %nl_ptr_1204 = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_1210 = call i32 (i32, i8*, ...) @___printf_chk(i32 2, i8* %nl_ptr_1204)

  ; stack canary check: if (saved != *guard) goto L1427
  %saved_can_1215 = load i64, i64* %canary_saved, align 8
  %guard_now_121a = load i64, i64* @__stack_chk_guard, align 8
  %mismatch_1223 = icmp ne i64 %saved_can_1215, %guard_now_121a
  br i1 %mismatch_1223, label %L1427, label %L1229_ret

L1229_ret:
  ret i32 0

; -------- special-case and helper labeled blocks --------

L1234:
  ; [rbp_start] = edx
  %rbp_start_1234 = load i32*, i32** %rbp, align 8
  ; Note: at this point %rbp holds start pointer (before L11D6 changes it)
  ; but L1234 only occurs before L11D6, so rbp still base.
  %base_ptr_1234 = load i32*, i32** %rbp, align 8
  %edx_now_1234 = load i32, i32* %edx, align 4
  store i32 %edx_now_1234, i32* %base_ptr_1234, align 4

  ; edx = [rdi+1]
  %rdi_ld_1237 = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_1237 = getelementptr inbounds i32, i32* %rdi_ld_1237, i64 1
  %edx_val_1237 = load i32, i32* %ptr_rdi_p1_1237, align 4
  store i32 %edx_val_1237, i32* %edx, align 4

  ; rsi = rsi + 2
  %rsi_ld_123a = load i32*, i32** %rsi, align 8
  %rsi_plus2_123a = getelementptr inbounds i32, i32* %rsi_ld_123a, i64 2
  store i32* %rsi_plus2_123a, i32** %rsi, align 8

  ; rax = rdi
  store i32* %rdi_ld_1237, i32** %raxp, align 8

  ; ecx = [rdi]
  %ecx_val_1241 = load i32, i32* %rdi_ld_1237, align 4
  ; cmp ecx, edx ; jle L13CC
  %edx_now_1243 = load i32, i32* %edx, align 4
  %cmp_1245 = icmp sle i32 %ecx_val_1241, %edx_now_1243
  br i1 %cmp_1245, label %L13CC, label %L124B

L124B:
  ; [rdi+1] = ecx
  %ptr_rdi_p1_124b = getelementptr inbounds i32, i32* %rdi_ld_1237, i64 1
  store i32 %ecx_val_1241, i32* %ptr_rdi_p1_124b, align 4

  ; xchg rdi, rsi
  %rsi_ld_124e = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_124e, i32** %rdi, align 8
  store i32* %rdi_ld_1237, i32** %rsi, align 8

  ; ecx = 1
  store i64 1, i64* %rcx, align 8

  br label %L10F3

L125B:
  ; rsi = rdi ; jmp L11C6
  %rdi_ld_125b = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_125b, i32** %rsi, align 8
  br label %L11C6

L1263:
  ; [base] = edx
  %base_ptr_1263 = load i32*, i32** %rbp, align 8
  %edx_now_1263 = load i32, i32* %edx, align 4
  store i32 %edx_now_1263, i32* %base_ptr_1263, align 4

  ; edx = [rdi+1]
  %rdi_ld_1266 = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_1266 = getelementptr inbounds i32, i32* %rdi_ld_1266, i64 1
  %edx_val_1266 = load i32, i32* %ptr_rdi_p1_1266, align 4
  store i32 %edx_val_1266, i32* %edx, align 4

  ; rsi = rdi+1
  store i32* %ptr_rdi_p1_1266, i32** %rsi, align 8

  ; rax = rdi
  store i32* %rdi_ld_1266, i32** %raxp, align 8

  ; ecx = [rdi]
  %ecx_val_1270 = load i32, i32* %rdi_ld_1266, align 4

  ; cmp edx, ecx ; jge L13BF
  %cmp_1274 = icmp sge i32 %edx_val_1266, %ecx_val_1270
  br i1 %cmp_1274, label %L13BF, label %L127A

L127A:
  ; [rdi+1] = ecx
  store i32 %ecx_val_1270, i32* %ptr_rdi_p1_1266, align 4

  ; ecx = 2
  store i64 2, i64* %rcx, align 8
  br label %L1288

L1288:
  ; swap rdi and rsi, then jmp L10F3
  %rsi_ld_1288 = load i32*, i32** %rsi, align 8
  %rdi_ld_1288 = load i32*, i32** %rdi, align 8
  store i32* %rsi_ld_1288, i32** %rdi, align 8
  store i32* %rdi_ld_1288, i32** %rsi, align 8
  br label %L10F3

L1296:
  ; rax = rsi-1 ; rsi = rdi ; jmp L11C6
  %rsi_ld_1296 = load i32*, i32** %rsi, align 8
  %rax_new_1296 = getelementptr inbounds i32, i32* %rsi_ld_1296, i64 -1
  store i32* %rax_new_1296, i32** %raxp, align 8

  %rdi_ld_129a = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_129a, i32** %rsi, align 8
  br label %L11C6

L12A2:
  ; [base] = edx
  %base_ptr_12a2 = load i32*, i32** %rbp, align 8
  %edx_now_12a2 = load i32, i32* %edx, align 4
  store i32 %edx_now_12a2, i32* %base_ptr_12a2, align 4

  ; edx = [rdi+1]
  %rdi_ld_12a5 = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_12a5 = getelementptr inbounds i32, i32* %rdi_ld_12a5, i64 1
  %edx_val_12a5 = load i32, i32* %ptr_rdi_p1_12a5, align 4
  store i32 %edx_val_12a5, i32* %edx, align 4

  ; rsi = rdi+1 ; rax = rdi
  store i32* %ptr_rdi_p1_12a5, i32** %rsi, align 8
  store i32* %rdi_ld_12a5, i32** %raxp, align 8

  ; ecx = [rdi]
  %ecx_val_12af = load i32, i32* %rdi_ld_12a5, align 4

  ; cmp ecx, edx ; jle L1400
  %cmp_12b3 = icmp sle i32 %ecx_val_12af, %edx_val_12a5
  br i1 %cmp_12b3, label %L1400, label %L12B9

L12B9:
  ; [rdi+1] = ecx ; ecx = 3 ; jmp L1288
  store i32 %ecx_val_12af, i32* %ptr_rdi_p1_12a5, align 4
  store i64 3, i64* %rcx, align 8
  br label %L1288

L12C3:
  ; rsi = rdi ; rax = rdi ; jmp L11C6
  %rdi_ld_12c3 = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_12c3, i32** %rsi, align 8
  store i32* %rdi_ld_12c3, i32** %raxp, align 8
  br label %L11C6

L12CE:
  ; rax = rsi-2 ; rsi = rdi ; jmp L11C6
  %rsi_ld_12ce = load i32*, i32** %rsi, align 8
  %rax_new_12ce = getelementptr inbounds i32, i32* %rsi_ld_12ce, i64 -2
  store i32* %rax_new_12ce, i32** %raxp, align 8

  %rdi_ld_12d2 = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_12d2, i32** %rsi, align 8
  br label %L11C6

L12DA:
  ; [base] = edx ; edx = [rdi+1] ; rsi = rdi+1 ; rax = rdi ; ecx = [rdi]
  %base_ptr_12da = load i32*, i32** %rbp, align 8
  %edx_now_12da = load i32, i32* %edx, align 4
  store i32 %edx_now_12da, i32* %base_ptr_12da, align 4

  %rdi_ld_12dd = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_12dd = getelementptr inbounds i32, i32* %rdi_ld_12dd, i64 1
  %edx_val_12dd = load i32, i32* %ptr_rdi_p1_12dd, align 4
  store i32 %edx_val_12dd, i32* %edx, align 4

  store i32* %ptr_rdi_p1_12dd, i32** %rsi, align 8
  store i32* %rdi_ld_12dd, i32** %raxp, align 8

  %ecx_val_12e7 = load i32, i32* %rdi_ld_12dd, align 4

  ; cmp edx, ecx ; jge L140D
  %cmp_12eb = icmp sge i32 %edx_val_12dd, %ecx_val_12e7
  br i1 %cmp_12eb, label %L140D, label %L12F1

L12F1:
  ; [rdi+1] = ecx ; ecx = 4 ; jmp L1288
  store i32 %ecx_val_12e7, i32* %ptr_rdi_p1_12dd, align 4
  store i64 4, i64* %rcx, align 8
  br label %L1288

L12FB:
  ; rax = rsi-3 ; rsi = rdi ; jmp L11C6
  %rsi_ld_12fb = load i32*, i32** %rsi, align 8
  %rax_new_12fb = getelementptr inbounds i32, i32* %rsi_ld_12fb, i64 -3
  store i32* %rax_new_12fb, i32** %raxp, align 8

  %rdi_ld_12ff = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_12ff, i32** %rsi, align 8
  br label %L11C6

L1307:
  ; [base] = edx ; edx = [rdi+1] ; rsi = rdi+1 ; rax = rdi ; ecx = [rdi]
  %base_ptr_1307 = load i32*, i32** %rbp, align 8
  %edx_now_1307 = load i32, i32* %edx, align 4
  store i32 %edx_now_1307, i32* %base_ptr_1307, align 4

  %rdi_ld_130a = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_130a = getelementptr inbounds i32, i32* %rdi_ld_130a, i64 1
  %edx_val_130a = load i32, i32* %ptr_rdi_p1_130a, align 4
  store i32 %edx_val_130a, i32* %edx, align 4

  store i32* %ptr_rdi_p1_130a, i32** %rsi, align 8
  store i32* %rdi_ld_130a, i32** %raxp, align 8

  %ecx_val_1314 = load i32, i32* %rdi_ld_130a, align 4

  ; cmp edx, ecx ; jge L13E6
  %cmp_1318 = icmp sge i32 %edx_val_130a, %ecx_val_1314
  br i1 %cmp_1318, label %L13E6, label %L131E

L131E:
  ; [rdi+1] = ecx ; ecx = 5 ; jmp L1288
  store i32 %ecx_val_1314, i32* %ptr_rdi_p1_130a, align 4
  store i64 5, i64* %rcx, align 8
  br label %L1288

L132B:
  ; rax = rsi-4 ; rsi = rdi ; jmp L11C6
  %rsi_ld_132b = load i32*, i32** %rsi, align 8
  %rax_new_132b = getelementptr inbounds i32, i32* %rsi_ld_132b, i64 -4
  store i32* %rax_new_132b, i32** %raxp, align 8

  %rdi_ld_132f = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_132f, i32** %rsi, align 8
  br label %L11C6

L1337:
  ; [base] = edx ; edx = [rdi+1] ; rsi = rdi+1 ; rax = rdi ; ecx = [rdi]
  %base_ptr_1337 = load i32*, i32** %rbp, align 8
  %edx_now_1337 = load i32, i32* %edx, align 4
  store i32 %edx_now_1337, i32* %base_ptr_1337, align 4

  %rdi_ld_133a = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_133a = getelementptr inbounds i32, i32* %rdi_ld_133a, i64 1
  %edx_val_133a = load i32, i32* %ptr_rdi_p1_133a, align 4
  store i32 %edx_val_133a, i32* %edx, align 4

  store i32* %ptr_rdi_p1_133a, i32** %rsi, align 8
  store i32* %rdi_ld_133a, i32** %raxp, align 8

  %ecx_val_1344 = load i32, i32* %rdi_ld_133a, align 4

  ; cmp edx, ecx ; jge L13F3
  %cmp_1348 = icmp sge i32 %edx_val_133a, %ecx_val_1344
  br i1 %cmp_1348, label %L13F3, label %L134E

L134E:
  ; [rdi+1] = ecx ; ecx = 6 ; jmp L1288
  store i32 %ecx_val_1344, i32* %ptr_rdi_p1_133a, align 4
  store i64 6, i64* %rcx, align 8
  br label %L1288

L135B:
  ; rax = rsi-5 ; rsi = rdi ; jmp L11C6
  %rsi_ld_135b = load i32*, i32** %rsi, align 8
  %rax_new_135b = getelementptr inbounds i32, i32* %rsi_ld_135b, i64 -5
  store i32* %rax_new_135b, i32** %raxp, align 8

  %rdi_ld_135f = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_135f, i32** %rsi, align 8
  br label %L11C6

L1367:
  ; [base] = edx ; edx = [rdi+1] ; rsi = rdi+1 ; rax = rdi ; ecx = [rdi]
  %base_ptr_1367 = load i32*, i32** %rbp, align 8
  %edx_now_1367 = load i32, i32* %edx, align 4
  store i32 %edx_now_1367, i32* %base_ptr_1367, align 4

  %rdi_ld_136a = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_136a = getelementptr inbounds i32, i32* %rdi_ld_136a, i64 1
  %edx_val_136a = load i32, i32* %ptr_rdi_p1_136a, align 4
  store i32 %edx_val_136a, i32* %edx, align 4

  store i32* %ptr_rdi_p1_136a, i32** %rsi, align 8
  store i32* %rdi_ld_136a, i32** %raxp, align 8

  %ecx_val_1374 = load i32, i32* %rdi_ld_136a, align 4

  ; cmp edx, ecx ; jge L13D9
  %cmp_1378 = icmp sge i32 %edx_val_136a, %ecx_val_1374
  br i1 %cmp_1378, label %L13D9, label %L137A

L137A:
  ; [rdi+1] = ecx ; ecx = 7 ; jmp L1288
  store i32 %ecx_val_1374, i32* %ptr_rdi_p1_136a, align 4
  store i64 7, i64* %rcx, align 8
  br label %L1288

L1387:
  ; rax = rsi-6 ; rsi = rdi ; jmp L11C6
  %rsi_ld_1387 = load i32*, i32** %rsi, align 8
  %rax_new_1387 = getelementptr inbounds i32, i32* %rsi_ld_1387, i64 -6
  store i32* %rax_new_1387, i32** %raxp, align 8

  %rdi_ld_138b = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_138b, i32** %rsi, align 8
  br label %L11C6

L1393:
  ; [base] = edx ; edx = [rdi+1] ; rsi = rdi+1 ; rax = rdi ; ecx = [rdi]
  %base_ptr_1393 = load i32*, i32** %rbp, align 8
  %edx_now_1393 = load i32, i32* %edx, align 4
  store i32 %edx_now_1393, i32* %base_ptr_1393, align 4

  %rdi_ld_1396 = load i32*, i32** %rdi, align 8
  %ptr_rdi_p1_1396 = getelementptr inbounds i32, i32* %rdi_ld_1396, i64 1
  %edx_val_1396 = load i32, i32* %ptr_rdi_p1_1396, align 4
  store i32 %edx_val_1396, i32* %edx, align 4

  store i32* %ptr_rdi_p1_1396, i32** %rsi, align 8
  store i32* %rdi_ld_1396, i32** %raxp, align 8

  %ecx_val_13a0 = load i32, i32* %rdi_ld_1396, align 4

  ; cmp edx, ecx ; jge L141A
  %cmp_13a4 = icmp sge i32 %edx_val_1396, %ecx_val_13a0
  br i1 %cmp_13a4, label %L141A, label %L13A6

L13A6:
  ; [rdi+1] = ecx ; ecx = 8 ; jmp L1288
  store i32 %ecx_val_13a0, i32* %ptr_rdi_p1_1396, align 4
  store i64 8, i64* %rcx, align 8
  br label %L1288

L13B3:
  ; rax = rsi-7 ; rsi = rdi ; jmp L11C6
  %rsi_ld_13b3 = load i32*, i32** %rsi, align 8
  %rax_new_13b3 = getelementptr inbounds i32, i32* %rsi_ld_13b3, i64 -7
  store i32* %rax_new_13b3, i32** %raxp, align 8

  %rdi_ld_13b7 = load i32*, i32** %rdi, align 8
  store i32* %rdi_ld_13b7, i32** %rsi, align 8
  br label %L11C6

L13BF:
  ; rax = rsi ; ecx = 2 ; jmp L11C6
  %rsi_ld_13bf = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_13bf, i32** %raxp, align 8
  store i64 2, i64* %rcx, align 8
  br label %L11C6

L13CC:
  ; rax = rsi ; ecx = 1 ; jmp L11C6
  %rsi_ld_13cc = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_13cc, i32** %raxp, align 8
  store i64 1, i64* %rcx, align 8
  br label %L11C6

L13D9:
  ; rax = rsi ; ecx = 7 ; jmp L11C6
  %rsi_ld_13d9 = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_13d9, i32** %raxp, align 8
  store i64 7, i64* %rcx, align 8
  br label %L11C6

L13E6:
  ; rax = rsi ; ecx = 5 ; jmp L11C6
  %rsi_ld_13e6 = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_13e6, i32** %raxp, align 8
  store i64 5, i64* %rcx, align 8
  br label %L11C6

L13F3:
  ; rax = rsi ; ecx = 6 ; jmp L11C6
  %rsi_ld_13f3 = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_13f3, i32** %raxp, align 8
  store i64 6, i64* %rcx, align 8
  br label %L11C6

L1400:
  ; rax = rsi ; ecx = 3 ; jmp L11C6
  %rsi_ld_1400 = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_1400, i32** %raxp, align 8
  store i64 3, i64* %rcx, align 8
  br label %L11C6

L140D:
  ; rax = rsi ; ecx = 4 ; jmp L11C6
  %rsi_ld_140d = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_140d, i32** %raxp, align 8
  store i64 4, i64* %rcx, align 8
  br label %L11C6

L141A:
  ; rax = rsi ; ecx = 8 ; jmp L11C6
  %rsi_ld_141a = load i32*, i32** %rsi, align 8
  store i32* %rsi_ld_141a, i32** %raxp, align 8
  store i64 8, i64* %rcx, align 8
  br label %L11C6

L1427:
  call void @___stack_chk_fail()
  unreachable
}