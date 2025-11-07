; ModuleID = 'recovered.main'
target triple = "x86_64-pc-linux-gnu"

@aDfsPreorderFro = constant [24 x i8] c"DFS preorder from %zu: \00"
@asc_2022 = constant [2 x i8] c"\0A\00"
@fmt_zu_s = constant [6 x i8] c"%zu%s\00"
@qword_2028 = external global i64
@__stack_chk_guard = external global i64

declare i8* @calloc(i64, i64)
declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()
declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() local_unnamed_addr {
entry_10e0:
  %guard_slot = alloca i64, align 8
  %visited_ptr = alloca i8*, align 8
  %next_ptr = alloca i8*, align 8
  %stack_ptr = alloca i8*, align 8
  %rdi_index = alloca i64, align 8
  %rbp_count = alloca i64, align 8
  %rdx_val = alloca i64, align 8
  %rax_val = alloca i64, align 8
  %r8_ptr = alloca i8*, align 8
  %rsi_ptr = alloca i8*, align 8
  %adj = alloca [56 x i32], align 16
  %varlist = alloca [64 x i64], align 16
  %vF4 = alloca i64, align 8
  %vD0 = alloca i64, align 8
  %iv = alloca i64, align 8
  %g = load i64, i64* @__stack_chk_guard, align 8
  store i64 %g, i64* %guard_slot, align 8
  %adj_i8 = bitcast [56 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 224, i1 false)
  %adj0_ptr = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 0
  store i32 0, i32* %adj0_ptr, align 4
  %q2028 = load i64, i64* @qword_2028, align 8
  store i64 %q2028, i64* %vF4, align 8
  store i64 %q2028, i64* %vD0, align 8
  %call_calloc1 = call i8* @calloc(i64 28, i64 1)
  store i8* %call_calloc1, i8** %visited_ptr, align 8
  %call_calloc2 = call i8* @calloc(i64 56, i64 1)
  store i8* %call_calloc2, i8** %next_ptr, align 8
  %call_malloc = call i8* @malloc(i64 56)
  store i8* %call_malloc, i8** %stack_ptr, align 8
  %rbx0 = load i8*, i8** %visited_ptr, align 8
  %t0 = icmp eq i8* %rbx0, null
  %r130 = load i8*, i8** %next_ptr, align 8
  %t1 = icmp eq i8* %r130, null
  %t01 = or i1 %t0, %t1
  br i1 %t01, label %loc_1455, label %after_first_null

after_first_null:
  %r120 = load i8*, i8** %stack_ptr, align 8
  %t2 = icmp eq i8* %r120, null
  br i1 %t2, label %loc_1455, label %cont_11e0

cont_11e0:
  %stack64 = bitcast i8* %r120 to i64*
  store i64 0, i64* %stack64, align 8
  store i64 0, i64* %rdx_val, align 8
  store i64 1, i64* %rbp_count, align 8
  store i64 1, i64* %rdi_index, align 8
  %visited_i32 = bitcast i8* %rbx0 to i32*
  store i32 1, i32* %visited_i32, align 4
  %var0 = getelementptr inbounds [64 x i64], [64 x i64]* %varlist, i64 0, i64 0
  store i64 0, i64* %var0, align 8
  br label %loc_120D

loc_1208:
  %r12b = load i8*, i8** %stack_ptr, align 8
  %rdi_cur = load i64, i64* %rdi_index, align 8
  %idx_minus1 = add i64 %rdi_cur, -1
  %stack64b = bitcast i8* %r12b to i64*
  %elt_ptr2 = getelementptr inbounds i64, i64* %stack64b, i64 %idx_minus1
  %rdx_load = load i64, i64* %elt_ptr2, align 8
  store i64 %rdx_load, i64* %rdx_val, align 8
  br label %loc_120D

loc_120D:
  %rdx_now = load i64, i64* %rdx_val, align 8
  %rcx_mul = mul i64 %rdx_now, 8
  %r13p = load i8*, i8** %next_ptr, align 8
  %r8addr = getelementptr i8, i8* %r13p, i64 %rcx_mul
  store i8* %r8addr, i8** %r8_ptr, align 8
  %r8q = bitcast i8* %r8addr to i64*
  %rax_load = load i64, i64* %r8q, align 8
  store i64 %rax_load, i64* %rax_val, align 8
  %cmp_ja = icmp ugt i64 %rax_load, 6
  br i1 %cmp_ja, label %loc_1412, label %cont_1227

cont_1227:
  %rcx_minus = sub i64 %rcx_mul, %rdx_now
  %rdx2 = add i64 %rax_load, %rcx_minus
  %adjp = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %rdx2
  %r14d = load i32, i32* %adjp, align 4
  %t_r14_zero = icmp eq i32 %r14d, 0
  br i1 %t_r14_zero, label %loc_1248, label %cont_1238

cont_1238:
  %rbx_ptr = load i8*, i8** %visited_ptr, align 8
  %rax_now = load i64, i64* %rax_val, align 8
  %offset_vis = mul i64 %rax_now, 4
  %rsi_vis = getelementptr i8, i8* %rbx_ptr, i64 %offset_vis
  store i8* %rsi_vis, i8** %rsi_ptr, align 8
  %rsi_i32p = bitcast i8* %rsi_vis to i32*
  %r11d = load i32, i32* %rsi_i32p, align 4
  %r11_zero = icmp eq i32 %r11d, 0
  br i1 %r11_zero, label %loc_13EA, label %loc_1248

loc_1248:
  %rax_now2 = load i64, i64* %rax_val, align 8
  %rdx_a1 = add i64 %rax_now2, 1
  %cmp_eq6 = icmp eq i64 %rax_now2, 6
  br i1 %cmp_eq6, label %loc_133D, label %cont_1256

cont_1256:
  %idx = add i64 %rcx_minus, %rdx_a1
  %adjp2 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx
  %r10d = load i32, i32* %adjp2, align 4
  %r10_zero = icmp eq i32 %r10d, 0
  br i1 %r10_zero, label %loc_1274, label %cont_1264

cont_1264:
  %rbx_ptr2 = load i8*, i8** %visited_ptr, align 8
  %off2 = mul i64 %rdx_a1, 4
  %rsi2 = getelementptr i8, i8* %rbx_ptr2, i64 %off2
  store i8* %rsi2, i8** %rsi_ptr, align 8
  %rsi2_i32 = bitcast i8* %rsi2 to i32*
  %r9d = load i32, i32* %rsi2_i32, align 4
  %r9_zero = icmp eq i32 %r9d, 0
  br i1 %r9_zero, label %loc_13F0_prep_a1, label %loc_1274

loc_13F0_prep_a1:
  store i64 %rdx_a1, i64* %rdx_val, align 8
  br label %loc_13F0

loc_1274:
  %rax_now3 = load i64, i64* %rax_val, align 8
  %rdx_a2 = add i64 %rax_now3, 2
  %cmp_eq5 = icmp eq i64 %rax_now3, 5
  br i1 %cmp_eq5, label %loc_133D, label %cont_1282

cont_1282:
  %idx2 = add i64 %rcx_minus, %rdx_a2
  %adjp3 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx2
  %r14d3 = load i32, i32* %adjp3, align 4
  %r14_zero3 = icmp eq i32 %r14d3, 0
  br i1 %r14_zero3, label %loc_12A0, label %cont_1290

cont_1290:
  %rbx_ptr3 = load i8*, i8** %visited_ptr, align 8
  %off3 = mul i64 %rdx_a2, 4
  %rsi3 = getelementptr i8, i8* %rbx_ptr3, i64 %off3
  store i8* %rsi3, i8** %rsi_ptr, align 8
  %rsi3_i32 = bitcast i8* %rsi3 to i32*
  %r11d3 = load i32, i32* %rsi3_i32, align 4
  %r11_zero3 = icmp eq i32 %r11d3, 0
  br i1 %r11_zero3, label %loc_13F0_prep_a2, label %loc_12A0

loc_13F0_prep_a2:
  store i64 %rdx_a2, i64* %rdx_val, align 8
  br label %loc_13F0

loc_12A0:
  %rax_now4 = load i64, i64* %rax_val, align 8
  %rdx_a3 = add i64 %rax_now4, 3
  %cmp_eq4 = icmp eq i64 %rax_now4, 4
  br i1 %cmp_eq4, label %loc_133D, label %cont_12AE

cont_12AE:
  %idx3 = add i64 %rcx_minus, %rdx_a3
  %adjp4 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx3
  %r10d4 = load i32, i32* %adjp4, align 4
  %r10_zero4 = icmp eq i32 %r10d4, 0
  br i1 %r10_zero4, label %loc_12CC, label %cont_12BC

cont_12BC:
  %rbx_ptr4 = load i8*, i8** %visited_ptr, align 8
  %off4 = mul i64 %rdx_a3, 4
  %rsi4 = getelementptr i8, i8* %rbx_ptr4, i64 %off4
  store i8* %rsi4, i8** %rsi_ptr, align 8
  %rsi4_i32 = bitcast i8* %rsi4 to i32*
  %r9d4 = load i32, i32* %rsi4_i32, align 4
  %r9_zero4 = icmp eq i32 %r9d4, 0
  br i1 %r9_zero4, label %loc_13F0_prep_a3, label %loc_12CC

loc_13F0_prep_a3:
  store i64 %rdx_a3, i64* %rdx_val, align 8
  br label %loc_13F0

loc_12CC:
  %rax_now5 = load i64, i64* %rax_val, align 8
  %rdx_a4 = add i64 %rax_now5, 4
  %cmp_eq3 = icmp eq i64 %rax_now5, 3
  br i1 %cmp_eq3, label %loc_133D, label %cont_12D6

cont_12D6:
  %idx4 = add i64 %rcx_minus, %rdx_a4
  %adjp5 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx4
  %r14d5 = load i32, i32* %adjp5, align 4
  %r14_zero5 = icmp eq i32 %r14d5, 0
  br i1 %r14_zero5, label %loc_12F4, label %cont_12E4

cont_12E4:
  %rbx_ptr5 = load i8*, i8** %visited_ptr, align 8
  %off5 = mul i64 %rdx_a4, 4
  %rsi5 = getelementptr i8, i8* %rbx_ptr5, i64 %off5
  store i8* %rsi5, i8** %rsi_ptr, align 8
  %rsi5_i32 = bitcast i8* %rsi5 to i32*
  %r11d5 = load i32, i32* %rsi5_i32, align 4
  %r11_zero5 = icmp eq i32 %r11d5, 0
  br i1 %r11_zero5, label %loc_13F0_prep_a4, label %loc_12F4

loc_13F0_prep_a4:
  store i64 %rdx_a4, i64* %rdx_val, align 8
  br label %loc_13F0

loc_12F4:
  %rax_now6 = load i64, i64* %rax_val, align 8
  %rdx_a5 = add i64 %rax_now6, 5
  %cmp_eq2 = icmp eq i64 %rax_now6, 2
  br i1 %cmp_eq2, label %loc_133D, label %cont_12FE

cont_12FE:
  %idx5 = add i64 %rcx_minus, %rdx_a5
  %adjp6 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx5
  %r10d6 = load i32, i32* %adjp6, align 4
  %r10_zero6 = icmp eq i32 %r10d6, 0
  br i1 %r10_zero6, label %loc_131C, label %cont_130C

cont_130C:
  %rbx_ptr6 = load i8*, i8** %visited_ptr, align 8
  %off6 = mul i64 %rdx_a5, 4
  %rsi6 = getelementptr i8, i8* %rbx_ptr6, i64 %off6
  store i8* %rsi6, i8** %rsi_ptr, align 8
  %rsi6_i32 = bitcast i8* %rsi6 to i32*
  %r9d6 = load i32, i32* %rsi6_i32, align 4
  %r9_zero6 = icmp eq i32 %r9d6, 0
  br i1 %r9_zero6, label %loc_13F0_prep_a5, label %loc_131C

loc_13F0_prep_a5:
  store i64 %rdx_a5, i64* %rdx_val, align 8
  br label %loc_13F0

loc_131C:
  %rax_now7 = load i64, i64* %rax_val, align 8
  %rax_is_nonzero = icmp ne i64 %rax_now7, 0
  br i1 %rax_is_nonzero, label %loc_133D, label %cont_1321

cont_1321:
  %idx6 = add i64 %rcx_minus, 0
  %adjp7 = getelementptr inbounds [56 x i32], [56 x i32]* %adj, i64 0, i64 %idx6
  %edxval = load i32, i32* %adjp7, align 4
  %edx_is_zero = icmp eq i32 %edxval, 0
  br i1 %edx_is_zero, label %loc_133D, label %cont_1329

cont_1329:
  %rbx_ptr7 = load i8*, i8** %visited_ptr, align 8
  %vis6_ptr_i8 = getelementptr i8, i8* %rbx_ptr7, i64 24
  %vis6_ptr = bitcast i8* %vis6_ptr_i8 to i32*
  %eax7 = load i32, i32* %vis6_ptr, align 4
  store i8* %vis6_ptr_i8, i8** %rsi_ptr, align 8
  %eax7_zero = icmp eq i32 %eax7, 0
  br i1 %eax7_zero, label %loc_13F0_prep_6, label %loc_133D

loc_13F0_prep_6:
  store i64 6, i64* %rdx_val, align 8
  br label %loc_13F0

loc_133D:
  %rdi_cur2 = load i64, i64* %rdi_index, align 8
  %rdi_dec = add i64 %rdi_cur2, -1
  store i64 %rdi_dec, i64* %rdi_index, align 8
  br label %loc_1341

loc_1341:
  %rdi_now = load i64, i64* %rdi_index, align 8
  %rdi_nonzero = icmp ne i64 %rdi_now, 0
  br i1 %rdi_nonzero, label %loc_1208, label %cont_134a

cont_134a:
  %rbx_fin = load i8*, i8** %visited_ptr, align 8
  call void @free(i8* %rbx_fin)
  %r13_fin = load i8*, i8** %next_ptr, align 8
  call void @free(i8* %r13_fin)
  %r12_fin = load i8*, i8** %stack_ptr, align 8
  call void @free(i8* %r12_fin)
  %p_fmt = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call_printf1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %p_fmt, i64 0)
  %rbp_now = load i64, i64* %rbp_count, align 8
  %rbp_zero = icmp eq i64 %rbp_now, 0
  br i1 %rbp_zero, label %loc_13AE, label %cont_137c

cont_137c:
  %v0 = getelementptr inbounds [64 x i64], [64 x i64]* %varlist, i64 0, i64 0
  %firstv = load i64, i64* %v0, align 8
  br label %cont_1387

cont_1387:
  %rbp_now2 = load i64, i64* %rbp_count, align 8
  %cmp_rbp1 = icmp ne i64 %rbp_now2, 1
  br i1 %cmp_rbp1, label %loc_1421, label %loc_1398

loc_1398:
  %empty = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 1
  %fmt_zu_s_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @fmt_zu_s, i64 0, i64 0
  %call_printf2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s_ptr, i64 %firstv, i8* %empty)
  br label %loc_13AE

loc_13AE:
  %nl = getelementptr inbounds [2 x i8], [2 x i8]* @asc_2022, i64 0, i64 0
  %call_printf3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl)
  %g_end = load i64, i64* %guard_slot, align 8
  %g_cur = load i64, i64* @__stack_chk_guard, align 8
  %guard_ok = icmp eq i64 %g_end, %g_cur
  br i1 %guard_ok, label %epilogue_good, label %loc_1487

epilogue_good:
  ret i32 0

loc_13EA:
  %rax_now8 = load i64, i64* %rax_val, align 8
  store i64 %rax_now8, i64* %rdx_val, align 8
  br label %loc_13F0

loc_13F0:
  %rdx_now2 = load i64, i64* %rdx_val, align 8
  %rax_next = add i64 %rdx_now2, 1
  %rbp_cur = load i64, i64* %rbp_count, align 8
  %varptr = getelementptr inbounds [64 x i64], [64 x i64]* %varlist, i64 0, i64 %rbp_cur
  store i64 %rdx_now2, i64* %varptr, align 8
  %rbp_inc = add i64 %rbp_cur, 1
  store i64 %rbp_inc, i64* %rbp_count, align 8
  %r12c = load i8*, i8** %stack_ptr, align 8
  %rdi_c = load i64, i64* %rdi_index, align 8
  %stack64c = bitcast i8* %r12c to i64*
  %dst_ptr = getelementptr inbounds i64, i64* %stack64c, i64 %rdi_c
  store i64 %rdx_now2, i64* %dst_ptr, align 8
  %rdi_inc = add i64 %rdi_c, 1
  store i64 %rdi_inc, i64* %rdi_index, align 8
  %r8p_now = load i8*, i8** %r8_ptr, align 8
  %r8p64 = bitcast i8* %r8p_now to i64*
  store i64 %rax_next, i64* %r8p64, align 8
  %rsi_vis_now = load i8*, i8** %rsi_ptr, align 8
  %rsi_vis_i32_now = bitcast i8* %rsi_vis_now to i32*
  store i32 1, i32* %rsi_vis_i32_now, align 4
  br label %loc_1341

loc_1412:
  %rax_now9 = load i64, i64* %rax_val, align 8
  %cmp_ne7 = icmp ne i64 %rax_now9, 7
  br i1 %cmp_ne7, label %loc_1208, label %loc_133D

loc_1421:
  store i64 1, i64* %iv, align 8
  %space_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 22
  %varbase = getelementptr inbounds [64 x i64], [64 x i64]* %varlist, i64 0, i64 0
  br label %loc_1430

loc_1430:
  %iv_now = load i64, i64* %iv, align 8
  %elem_ptr = getelementptr inbounds i64, i64* %varbase, i64 %iv_now
  %rdx_print = load i64, i64* %elem_ptr, align 8
  %fmt_ptr2 = getelementptr inbounds [6 x i8], [6 x i8]* @fmt_zu_s, i64 0, i64 0
  %call_printf_loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_ptr2, i64 %rdx_print, i8* %space_ptr)
  %iv_next = add i64 %iv_now, 1
  store i64 %iv_next, i64* %iv, align 8
  %rbp_now3 = load i64, i64* %rbp_count, align 8
  %cond_loop = icmp ne i64 %iv_next, %rbp_now3
  br i1 %cond_loop, label %loc_1430, label %loc_1398

loc_1455:
  %rbx_null = phi i8* [ %rbx0, %entry_10e0 ], [ %rbx0, %after_first_null ]
  %r13_free = phi i8* [ %r130, %entry_10e0 ], [ %r130, %after_first_null ]
  %r12_free = phi i8* [ null, %entry_10e0 ], [ %r120, %after_first_null ]
  call void @free(i8* %rbx_null)
  call void @free(i8* %r13_free)
  call void @free(i8* %r12_free)
  %p_fmt2 = getelementptr inbounds [24 x i8], [24 x i8]* @aDfsPreorderFro, i64 0, i64 0
  %call_printf_fail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %p_fmt2, i64 0)
  br label %loc_13AE

loc_1487:
  call void @__stack_chk_fail()
  unreachable
}