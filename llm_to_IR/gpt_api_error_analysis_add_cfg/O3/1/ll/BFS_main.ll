; ModuleID = 'bfs_ir_module'
source_filename = "bfs_ir_module.ll"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str_bfs = private constant [21 x i8] c"BFS order from %zu: \00", align 1
@.str_zu_s = private constant [6 x i8] c"%zu%s\00", align 1
@.str_dist = private constant [23 x i8] c"dist(%zu -> %zu) = %d\0A\00", align 1

@__stack_chk_guard = external global i64
@qword_2038 = external global i64

declare void @llvm.memset.p0i8.i64(i8* nocapture writeonly, i8, i64, i1 immarg)

declare i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

define i32 @main() {
bb_10c0:
  %frame = alloca [344 x i8], align 16
  %canary = alloca i64, align 8
  %ptrp = alloca i8*, align 8
  %rdi_ptr = alloca i64*, align 8
  %rsi = alloca i64, align 8
  %rbx = alloca i64, align 8
  %r12_base = alloca i8*, align 8
  %rax_idx2 = alloca i64, align 8
  %rdx_idx_ptr_slot = alloca i8*, align 8
  %frame_i8 = bitcast [344 x i8]* %frame to i8*
  call void @llvm.memset.p0i8.i64(i8* %frame_i8, i8 0, i64 344, i1 false)
  %guard.ld = load i64, i64* @__stack_chk_guard
  store i64 %guard.ld, i64* %canary
  %mem = call i8* @malloc(i64 56)
  store i8* %mem, i8** %ptrp
  %isnull = icmp eq i8* %mem, null
  br i1 %isnull, label %bb_1414, label %bb_after_alloc

bb_after_alloc:
  %mem_i64 = bitcast i8* %mem to i64*
  store i64* %mem_i64, i64** %rdi_ptr
  store i64 1, i64* %rsi
  %var138_ptr = getelementptr i8, i8* %frame_i8, i64 0
  store i8* %var138_ptr, i8** %r12_base
  store i64 0, i64* %rbx
  store i64 0, i64* %mem_i64, align 8
  br label %bb_11d3

bb_11c0:
  %p_rdi = load i64*, i64** %rdi_ptr
  %v_rbx = load i64, i64* %rbx
  %elem_ptr = getelementptr i64, i64* %p_rdi, i64 %v_rbx
  %rdx_val = load i64, i64* %elem_ptr, align 8
  %rdx_mul8 = mul i64 %rdx_val, 8
  %rcx_val = sub i64 %rdx_mul8, %rdx_val
  %rax_index = mul i64 %rcx_val, 4
  %gep_f8 = getelementptr i8, i8* %frame_i8, i64 %rax_index
  %f8_i32ptr = bitcast i8* %gep_f8 to i32*
  %eax_loaded = load i32, i32* %f8_i32ptr, align 4
  br label %bb_11d3

bb_11d3:
  %eax_phi = phi i32 [ 0, %bb_after_alloc ], [ %eax_loaded, %bb_11c0 ]
  %p_rdi2 = load i64*, i64** %rdi_ptr
  %rbx0 = load i64, i64* %rbx
  %rbx1 = add i64 %rbx0, 1
  store i64 %rbx1, i64* %rbx
  %rbx_minus1 = add i64 %rbx1, -1
  %ptr_prev = getelementptr i64, i64* %p_rdi2, i64 %rbx_minus1
  %rdx2 = load i64, i64* %ptr_prev, align 8
  %r12b = load i8*, i8** %r12_base
  %r12_as_i64 = bitcast i8* %r12b to i64*
  %out_slot = getelementptr i64, i64* %r12_as_i64, i64 %rbx_minus1
  store i64 %rdx2, i64* %out_slot, align 8
  %test_eax = icmp eq i32 %eax_phi, 0
  br i1 %test_eax, label %bb_1200, label %bb_11e5

bb_11e5:
  %var158_ptr = getelementptr i8, i8* %frame_i8, i64 0
  %var158_i32 = bitcast i8* %var158_ptr to i32*
  %val_var158 = load i32, i32* %var158_i32, align 4
  %cmp_not_minus1 = icmp ne i32 %val_var158, -1
  br i1 %cmp_not_minus1, label %bb_1200, label %bb_11eb

bb_11eb:
  %rdx4 = mul i64 %rdx2, 4
  %ptr_var158_idx = getelementptr i8, i8* %frame_i8, i64 %rdx4
  %ptr_i32 = bitcast i8* %ptr_var158_idx to i32*
  %eax3 = load i32, i32* %ptr_i32, align 4
  %rsi1 = load i64, i64* %rsi
  %dest_ptr = getelementptr i64, i64* %p_rdi2, i64 %rsi1
  store i64 0, i64* %dest_ptr, align 8
  %rsi2 = add i64 %rsi1, 1
  store i64 %rsi2, i64* %rsi
  %eax_inc = add i32 %eax3, 1
  store i32 %eax_inc, i32* %var158_i32, align 4
  br label %bb_1200

bb_1200:
  %rcx3_mul8 = mul i64 %rdx2, 8
  %rcx3 = sub i64 %rcx3_mul8, %rdx2
  %rcx4 = mul i64 %rcx3, 4
  %ptr_varF4 = getelementptr i8, i8* %frame_i8, i64 %rcx4
  %ptr_varF4_i32 = bitcast i8* %ptr_varF4 to i32*
  %r11d = load i32, i32* %ptr_varF4_i32, align 4
  store i64 %rcx4, i64* %rax_idx2
  %rdx4c = mul i64 %rdx2, 4
  %ptr_var158_idx_i8_c = getelementptr i8, i8* %frame_i8, i64 %rdx4c
  store i8* %ptr_var158_idx_i8_c, i8** %rdx_idx_ptr_slot
  %cond_r11_zero = icmp eq i32 %r11d, 0
  br i1 %cond_r11_zero, label %bb_1240, label %bb_121d

bb_121d:
  %ptr_var158p4 = getelementptr i8, i8* %frame_i8, i64 4
  %var158p4_i32 = bitcast i8* %ptr_var158p4 to i32*
  %val_var158p4 = load i32, i32* %var158p4_i32, align 4
  %cmp_ne_m1_b = icmp ne i32 %val_var158p4, -1
  br i1 %cmp_ne_m1_b, label %bb_1240, label %bb_1224

bb_1224:
  %ptr_idx_i8_ld = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b = bitcast i8* %ptr_idx_i8_ld to i32*
  %ecx_load = load i32, i32* %ptr_var158_idx_b, align 4
  %p_rdi3 = load i64*, i64** %rdi_ptr
  %rsi3 = load i64, i64* %rsi
  %dest2 = getelementptr i64, i64* %p_rdi3, i64 %rsi3
  store i64 1, i64* %dest2, align 8
  %rsi4 = add i64 %rsi3, 1
  store i64 %rsi4, i64* %rsi
  %ecx_inc = add i32 %ecx_load, 1
  store i32 %ecx_inc, i32* %var158p4_i32, align 4
  br label %bb_1240

bb_1240:
  %rax_idx_load = load i64, i64* %rax_idx2
  %ptr_varF4p4_i8 = getelementptr i8, i8* %frame_i8, i64 %rax_idx_load
  %ptr_varF4p4_i32 = bitcast i8* %ptr_varF4p4_i8 to i32*
  %ptr_varF4p4_plus = getelementptr i32, i32* %ptr_varF4p4_i32, i64 1
  %r10d = load i32, i32* %ptr_varF4p4_plus, align 4
  %r10_zero = icmp eq i32 %r10d, 0
  br i1 %r10_zero, label %bb_1270, label %bb_124a

bb_124a:
  %ptr_var158p8_i8 = getelementptr i8, i8* %frame_i8, i64 8
  %ptr_var158p8 = bitcast i8* %ptr_var158p8_i8 to i32*
  %val_p8 = load i32, i32* %ptr_var158p8, align 4
  %cmp_ne_m1_c = icmp ne i32 %val_p8, -1
  br i1 %cmp_ne_m1_c, label %bb_1270, label %bb_1251

bb_1251:
  %ptr_idx_i8_ld2 = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b2 = bitcast i8* %ptr_idx_i8_ld2 to i32*
  %ecx2 = load i32, i32* %ptr_var158_idx_b2, align 4
  %p_rdi4 = load i64*, i64** %rdi_ptr
  %rsi5 = load i64, i64* %rsi
  %dest3 = getelementptr i64, i64* %p_rdi4, i64 %rsi5
  store i64 2, i64* %dest3, align 8
  %rsi6 = add i64 %rsi5, 1
  store i64 %rsi6, i64* %rsi
  %ecx_inc2 = add i32 %ecx2, 1
  store i32 %ecx_inc2, i32* %ptr_var158p8, align 4
  br label %bb_1270

bb_1270:
  %ptr_varEC_i8 = getelementptr i8, i8* %frame_i8, i64 %rax_idx_load
  %ptr_varEC_i32 = bitcast i8* %ptr_varEC_i8 to i32*
  %r9d = load i32, i32* %ptr_varEC_i32, align 4
  %r9_zero = icmp eq i32 %r9d, 0
  br i1 %r9_zero, label %bb_12A0, label %bb_127a

bb_127a:
  %ptr_var158pC_i8 = getelementptr i8, i8* %frame_i8, i64 12
  %ptr_var158pC = bitcast i8* %ptr_var158pC_i8 to i32*
  %val_pC = load i32, i32* %ptr_var158pC, align 4
  %ne_m1_d = icmp ne i32 %val_pC, -1
  br i1 %ne_m1_d, label %bb_12A0, label %bb_1281

bb_1281:
  %ptr_idx_i8_ld3 = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b3 = bitcast i8* %ptr_idx_i8_ld3 to i32*
  %ecx3 = load i32, i32* %ptr_var158_idx_b3, align 4
  %p_rdi5 = load i64*, i64** %rdi_ptr
  %rsi7 = load i64, i64* %rsi
  %dest4 = getelementptr i64, i64* %p_rdi5, i64 %rsi7
  store i64 3, i64* %dest4, align 8
  %rsi8 = add i64 %rsi7, 1
  store i64 %rsi8, i64* %rsi
  %ecx_inc3 = add i32 %ecx3, 1
  store i32 %ecx_inc3, i32* %ptr_var158pC, align 4
  br label %bb_12A0

bb_12A0:
  %ptr_varE8_i8 = getelementptr i8, i8* %frame_i8, i64 %rax_idx_load
  %ptr_varE8_i32 = bitcast i8* %ptr_varE8_i8 to i32*
  %r8d = load i32, i32* %ptr_varE8_i32, align 4
  %r8_zero = icmp eq i32 %r8d, 0
  br i1 %r8_zero, label %bb_12D0, label %bb_12aa

bb_12aa:
  %ptr_var148_i8b = getelementptr i8, i8* %frame_i8, i64 16
  %ptr_var148 = bitcast i8* %ptr_var148_i8b to i32*
  %val_148 = load i32, i32* %ptr_var148, align 4
  %ne_m1_e = icmp ne i32 %val_148, -1
  br i1 %ne_m1_e, label %bb_12D0, label %bb_12b1

bb_12b1:
  %ptr_idx_i8_ld4 = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b4 = bitcast i8* %ptr_idx_i8_ld4 to i32*
  %ecx4 = load i32, i32* %ptr_var158_idx_b4, align 4
  %p_rdi6 = load i64*, i64** %rdi_ptr
  %rsi9 = load i64, i64* %rsi
  %dest5 = getelementptr i64, i64* %p_rdi6, i64 %rsi9
  store i64 4, i64* %dest5, align 8
  %rsi10 = add i64 %rsi9, 1
  store i64 %rsi10, i64* %rsi
  %ecx_inc4 = add i32 %ecx4, 1
  store i32 %ecx_inc4, i32* %ptr_var148, align 4
  br label %bb_12D0

bb_12D0:
  %ptr_varE4_i8 = getelementptr i8, i8* %frame_i8, i64 %rax_idx_load
  %ptr_varE4_i32 = bitcast i8* %ptr_varE4_i8 to i32*
  %ecx5 = load i32, i32* %ptr_varE4_i32, align 4
  %ecx_zero = icmp eq i32 %ecx5, 0
  br i1 %ecx_zero, label %bb_12F8, label %bb_12d8

bb_12d8:
  %ptr_var144_i8 = getelementptr i8, i8* %frame_i8, i64 20
  %ptr_var144 = bitcast i8* %ptr_var144_i8 to i32*
  %val_144 = load i32, i32* %ptr_var144, align 4
  %ne_m1_f = icmp ne i32 %val_144, -1
  br i1 %ne_m1_f, label %bb_12F8, label %bb_12df

bb_12df:
  %ptr_idx_i8_ld5 = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b5 = bitcast i8* %ptr_idx_i8_ld5 to i32*
  %ecx6 = load i32, i32* %ptr_var158_idx_b5, align 4
  %p_rdi7 = load i64*, i64** %rdi_ptr
  %rsi11 = load i64, i64* %rsi
  %dest6 = getelementptr i64, i64* %p_rdi7, i64 %rsi11
  store i64 5, i64* %dest6, align 8
  %rsi12 = add i64 %rsi11, 1
  store i64 %rsi12, i64* %rsi
  %ecx_inc5 = add i32 %ecx6, 1
  store i32 %ecx_inc5, i32* %ptr_var144, align 4
  br label %bb_12F8

bb_12F8:
  %ptr_varE0_i8 = getelementptr i8, i8* %frame_i8, i64 %rax_idx_load
  %ptr_varE0_i32 = bitcast i8* %ptr_varE0_i8 to i32*
  %eax7 = load i32, i32* %ptr_varE0_i32, align 4
  %eax7_zero = icmp eq i32 %eax7, 0
  br i1 %eax7_zero, label %bb_1320, label %bb_1300

bb_1300:
  %ptr_var140_i8 = getelementptr i8, i8* %frame_i8, i64 24
  %ptr_var140 = bitcast i8* %ptr_var140_i8 to i32*
  %val_140 = load i32, i32* %ptr_var140, align 4
  %ne_m1_g = icmp ne i32 %val_140, -1
  br i1 %ne_m1_g, label %bb_1320, label %bb_1307

bb_1307:
  %ptr_idx_i8_ld6 = load i8*, i8** %rdx_idx_ptr_slot
  %ptr_var158_idx_b6 = bitcast i8* %ptr_idx_i8_ld6 to i32*
  %eax8 = load i32, i32* %ptr_var158_idx_b6, align 4
  %p_rdi8 = load i64*, i64** %rdi_ptr
  %rsi13 = load i64, i64* %rsi
  %dest7 = getelementptr i64, i64* %p_rdi8, i64 %rsi13
  store i64 6, i64* %dest7, align 8
  %rsi14 = add i64 %rsi13, 1
  store i64 %rsi14, i64* %rsi
  %eax_inc9 = add i32 %eax8, 1
  store i32 %eax_inc9, i32* %ptr_var140, align 4
  br label %bb_1320

bb_1320:
  %rbx_cur = load i64, i64* %rbx
  %rsi_cur = load i64, i64* %rsi
  %jb = icmp ult i64 %rbx_cur, %rsi_cur
  br i1 %jb, label %bb_11c0, label %bb_after_loop

bb_after_loop:
  %p_rdi_free = load i64*, i64** %rdi_ptr
  %p_rdi_free_i8 = bitcast i64* %p_rdi_free to i8*
  call void @free(i8* %p_rdi_free_i8)
  %fmt_bfs = getelementptr [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call1 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs, i64 0)
  %r12_base_val = load i8*, i8** %r12_base
  %r12_as_i64_2 = bitcast i8* %r12_base_val to i64*
  %first_elem = load i64, i64* %r12_as_i64_2, align 8
  %rbx_after = load i64, i64* %rbx
  %cmp_ne1 = icmp ne i64 %rbx_after, 1
  br i1 %cmp_ne1, label %bb_13dd, label %bb_1360

bb_1360:
  %fmt_zu_s = getelementptr [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %dist_str = getelementptr [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 22
  %call2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s, i64 %first_elem, i8* %dist_str)
  br label %bb_1376

bb_1376:
  %newline_ptr = getelementptr [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 21
  %call3 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %newline_ptr)
  store i64 0, i64* %rbx
  br label %bb_1398

bb_1398:
  %r12b3 = load i8*, i8** %r12_base
  %r12_as_i32 = bitcast i8* %r12b3 to i32*
  %rbx_idx = load i64, i64* %rbx
  %dist_ptr = getelementptr i32, i32* %r12_as_i32, i64 %rbx_idx
  %dist_val = load i32, i32* %dist_ptr, align 4
  %fmt_dist = getelementptr [23 x i8], [23 x i8]* @.str_dist, i64 0, i64 0
  %rbx_for_print = load i64, i64* %rbx
  %call4 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dist, i64 0, i64 %rbx_for_print, i32 %dist_val)
  %rbx_inc = add i64 %rbx_for_print, 1
  store i64 %rbx_inc, i64* %rbx
  %cmp_rbx7 = icmp ne i64 %rbx_inc, 7
  br i1 %cmp_rbx7, label %bb_1398, label %bb_epilogue_check

bb_13dd:
  %r12start = load i8*, i8** %r12_base
  %rbx_now = load i64, i64* %rbx
  %bytes = mul i64 %rbx_now, 8
  %r12_end = getelementptr i8, i8* %r12start, i64 %bytes
  %rbp = alloca i8*, align 8
  %rbp_init = getelementptr i8, i8* %r12start, i64 8
  store i8* %rbp_init, i8** %rbp
  %space_ptr = getelementptr [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 19
  br label %bb_13f0

bb_13f0:
  %cur_rbp = load i8*, i8** %rbp
  %prev_ptr = getelementptr i8, i8* %cur_rbp, i64 -8
  %prev_q = bitcast i8* %prev_ptr to i64*
  %val_prev = load i64, i64* %prev_q, align 8
  %fmt_zu_s2 = getelementptr [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  %call5 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s2, i64 %val_prev, i8* %space_ptr)
  %next_rbp = getelementptr i8, i8* %cur_rbp, i64 8
  store i8* %next_rbp, i8** %rbp
  %cur_rbp2 = load i8*, i8** %rbp
  %cmp_ne = icmp ne i8* %cur_rbp2, %r12_end
  br i1 %cmp_ne, label %bb_13f0, label %bb_to_1360

bb_to_1360:
  br label %bb_1360

bb_epilogue_check:
  %can0 = load i64, i64* %canary
  %guard2 = load i64, i64* @__stack_chk_guard
  %eq = icmp eq i64 %can0, %guard2
  br i1 %eq, label %bb_ret, label %bb_142e

bb_ret:
  ret i32 0

bb_1414:
  %fmt_bfs2 = getelementptr [21 x i8], [21 x i8]* @.str_bfs, i64 0, i64 0
  %call_fail = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_bfs2, i64 0)
  br label %bb_1376

bb_142e:
  call void @__stack_chk_fail()
  unreachable
}