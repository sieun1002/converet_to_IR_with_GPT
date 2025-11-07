; ModuleID = 'recovered'
target triple = "x86_64-pc-linux-gnu"
; NOTE: build without stack protector if you do not provide __stack_chk_guard (__attribute__((no_stack_protector)) or -fno-stack-protector)

@__stack_chk_guard = external global i64
@qword_2028 = external global i64

@.str_dfs = constant [24 x i8] c"DFS preorder from %zu: \00"
@.str_zu_s = constant [6 x i8] c"%zu%s\00"
@.str_nl  = constant [2 x i8] c"\0A\00"

declare noalias i8* @calloc(i64, i64)
declare noalias i8* @malloc(i64)
declare void @free(i8*)
declare i32 @__printf_chk(i32, i8*, ...)
declare void @__stack_chk_fail()

declare void @llvm.memset.p0i8.i64(i8*, i8, i64, i1)

define i32 @main() {
loc_10e0:
  %visited_ptr = alloca i32*, align 8
  %idx_ptr = alloca i64*, align 8
  %stack_ptr = alloca i64*, align 8
  %rdi_idx = alloca i64, align 8
  %rbp_cnt = alloca i64, align 8
  %outarr = alloca [7 x i64], align 16
  %adj = alloca [49 x i32], align 16
  %r8_slot = alloca i64*, align 8
  %rsi_vis = alloca i32*, align 8
  %rdx_cur = alloca i64, align 8
  %rax_cur = alloca i64, align 8
  %rcx7_slot = alloca i64, align 8
  %rbx_iter = alloca i64, align 8
  %space_ptr = alloca i8*, align 8
  %printf_fmt_zu_s = alloca i8*, align 8
  %canary = alloca i64, align 8

  %guard = load i64, i64* @__stack_chk_guard
  store i64 %guard, i64* %canary

  %adj_i8 = bitcast [49 x i32]* %adj to i8*
  call void @llvm.memset.p0i8.i64(i8* %adj_i8, i8 0, i64 196, i1 false)

  %p1 = call noalias i8* @calloc(i64 28, i64 1)
  %p1cast = bitcast i8* %p1 to i32*
  store i32* %p1cast, i32** %visited_ptr

  %p2 = call noalias i8* @calloc(i64 56, i64 1)
  %p2cast = bitcast i8* %p2 to i64*
  store i64* %p2cast, i64** %idx_ptr

  %p3 = call noalias i8* @malloc(i64 56)
  %p3cast = bitcast i8* %p3 to i64*
  store i64* %p3cast, i64** %stack_ptr

  %v0 = icmp eq i32* %p1cast, null
  %i0 = icmp eq i64* %p2cast, null
  %or_null = or i1 %v0, %i0
  br i1 %or_null, label %loc_1455, label %check_stack

check_stack:                                           ; not an input-labeled block
  %snull = icmp eq i64* %p3cast, null
  br i1 %snull, label %loc_1455, label %init_ok

init_ok:                                               ; not an input-labeled block
  %sptr0 = load i64*, i64** %stack_ptr
  %stack0ptr = getelementptr inbounds i64, i64* %sptr0, i64 0
  store i64 0, i64* %stack0ptr

  store i64 1, i64* %rbp_cnt
  store i64 1, i64* %rdi_idx

  %vptr0 = getelementptr inbounds i32, i32* %p1cast, i64 0
  store i32 1, i32* %vptr0

  %out0ptr = getelementptr inbounds [7 x i64], [7 x i64]* %outarr, i64 0, i64 0
  store i64 0, i64* %out0ptr

  store i64 0, i64* %rdx_cur
  br label %loc_120d

loc_1208:
  %sptr1 = load i64*, i64** %stack_ptr
  %rdi_val1 = load i64, i64* %rdi_idx
  %rdi_minus1 = add i64 %rdi_val1, -1
  %tos_ptr = getelementptr inbounds i64, i64* %sptr1, i64 %rdi_minus1
  %tos = load i64, i64* %tos_ptr
  store i64 %tos, i64* %rdx_cur
  br label %loc_120d

loc_120d:
  %idxp = load i64*, i64** %idx_ptr
  %rdx_val = load i64, i64* %rdx_cur
  %mul8 = mul i64 %rdx_val, 8
  %r8addr = getelementptr inbounds i64, i64* %idxp, i64 %mul8
  store i64* %r8addr, i64** %r8_slot
  %rax_from_idx = load i64, i64* %r8addr
  store i64 %rax_from_idx, i64* %rax_cur
  %cmp_ja = icmp ugt i64 %rax_from_idx, 6
  br i1 %cmp_ja, label %loc_1412, label %after_cmp_1412

after_cmp_1412:                                        ; not an input-labeled block
  %rcx7calc = sub i64 %mul8, %rdx_val
  store i64 %rcx7calc, i64* %rcx7_slot
  %t0 = add i64 %rax_from_idx, %rcx7calc
  %adj_ptr0 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t0
  %adj_val0 = load i32, i32* %adj_ptr0
  %adj_zero0 = icmp eq i32 %adj_val0, 0
  br i1 %adj_zero0, label %loc_1248, label %check_visit0

check_visit0:                                          ; not an input-labeled block
  %rax_now0 = load i64, i64* %rax_cur
  %vptrA0 = getelementptr inbounds i32, i32* %p1cast, i64 %rax_now0
  store i32* %vptrA0, i32** %rsi_vis
  %vis0 = load i32, i32* %vptrA0
  %is_unvisited0 = icmp eq i32 %vis0, 0
  br i1 %is_unvisited0, label %loc_13ea, label %loc_1248

loc_1248:
  %rax_now1 = load i64, i64* %rax_cur
  %rdx1 = add i64 %rax_now1, 1
  %is_eq6 = icmp eq i64 %rax_now1, 6
  br i1 %is_eq6, label %loc_133d, label %cont_1248

cont_1248:                                             ; not an input-labeled block
  %rcx7v1 = load i64, i64* %rcx7_slot
  %t1 = add i64 %rcx7v1, %rdx1
  %adj_ptr1 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t1
  %adj_val1 = load i32, i32* %adj_ptr1
  %adj_zero1 = icmp eq i32 %adj_val1, 0
  br i1 %adj_zero1, label %loc_1274, label %check_visit1

check_visit1:                                          ; not an input-labeled block
  %vptrA1 = getelementptr inbounds i32, i32* %p1cast, i64 %rdx1
  store i32* %vptrA1, i32** %rsi_vis
  %vis1 = load i32, i32* %vptrA1
  %unvis1 = icmp eq i32 %vis1, 0
  br i1 %unvis1, label %set_rdx1_and_goto_13f0, label %loc_1274

set_rdx1_and_goto_13f0:                                ; not an input-labeled block
  store i64 %rdx1, i64* %rdx_cur
  br label %loc_13f0

loc_1274:
  %rax_now2 = load i64, i64* %rax_cur
  %rdx2 = add i64 %rax_now2, 2
  %is_eq5 = icmp eq i64 %rax_now2, 5
  br i1 %is_eq5, label %loc_133d, label %cont_1274

cont_1274:                                             ; not an input-labeled block
  %rcx7v2 = load i64, i64* %rcx7_slot
  %t2 = add i64 %rcx7v2, %rdx2
  %adj_ptr2 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t2
  %adj_val2 = load i32, i32* %adj_ptr2
  %adj_zero2 = icmp eq i32 %adj_val2, 0
  br i1 %adj_zero2, label %loc_12a0, label %check_visit2

check_visit2:                                          ; not an input-labeled block
  %vptrA2 = getelementptr inbounds i32, i32* %p1cast, i64 %rdx2
  store i32* %vptrA2, i32** %rsi_vis
  %vis2 = load i32, i32* %vptrA2
  %unvis2 = icmp eq i32 %vis2, 0
  br i1 %unvis2, label %set_rdx2_and_goto_13f0, label %loc_12a0

set_rdx2_and_goto_13f0:                                ; not an input-labeled block
  store i64 %rdx2, i64* %rdx_cur
  br label %loc_13f0

loc_12a0:
  %rax_now3 = load i64, i64* %rax_cur
  %rdx3 = add i64 %rax_now3, 3
  %is_eq4 = icmp eq i64 %rax_now3, 4
  br i1 %is_eq4, label %loc_133d, label %cont_12a0

cont_12a0:                                             ; not an input-labeled block
  %rcx7v3 = load i64, i64* %rcx7_slot
  %t3 = add i64 %rcx7v3, %rdx3
  %adj_ptr3 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t3
  %adj_val3 = load i32, i32* %adj_ptr3
  %adj_zero3 = icmp eq i32 %adj_val3, 0
  br i1 %adj_zero3, label %loc_12cc, label %check_visit3

check_visit3:                                          ; not an input-labeled block
  %vptrA3 = getelementptr inbounds i32, i32* %p1cast, i64 %rdx3
  store i32* %vptrA3, i32** %rsi_vis
  %vis3 = load i32, i32* %vptrA3
  %unvis3 = icmp eq i32 %vis3, 0
  br i1 %unvis3, label %set_rdx3_and_goto_13f0, label %loc_12cc

set_rdx3_and_goto_13f0:                                ; not an input-labeled block
  store i64 %rdx3, i64* %rdx_cur
  br label %loc_13f0

loc_12cc:
  %rax_now4 = load i64, i64* %rax_cur
  %rdx4 = add i64 %rax_now4, 4
  %is_eq3 = icmp eq i64 %rax_now4, 3
  br i1 %is_eq3, label %loc_133d, label %cont_12cc

cont_12cc:                                             ; not an input-labeled block
  %rcx7v4 = load i64, i64* %rcx7_slot
  %t4 = add i64 %rcx7v4, %rdx4
  %adj_ptr4 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t4
  %adj_val4 = load i32, i32* %adj_ptr4
  %adj_zero4 = icmp eq i32 %adj_val4, 0
  br i1 %adj_zero4, label %loc_12f4, label %check_visit4

check_visit4:                                          ; not an input-labeled block
  %vptrA4 = getelementptr inbounds i32, i32* %p1cast, i64 %rdx4
  store i32* %vptrA4, i32** %rsi_vis
  %vis4 = load i32, i32* %vptrA4
  %unvis4 = icmp eq i32 %vis4, 0
  br i1 %unvis4, label %set_rdx4_and_goto_13f0, label %loc_12f4

set_rdx4_and_goto_13f0:                                ; not an input-labeled block
  store i64 %rdx4, i64* %rdx_cur
  br label %loc_13f0

loc_12f4:
  %rax_now5 = load i64, i64* %rax_cur
  %rdx5 = add i64 %rax_now5, 5
  %is_eq2 = icmp eq i64 %rax_now5, 2
  br i1 %is_eq2, label %loc_133d, label %cont_12f4

cont_12f4:                                             ; not an input-labeled block
  %rcx7v5 = load i64, i64* %rcx7_slot
  %t5 = add i64 %rcx7v5, %rdx5
  %adj_ptr5 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t5
  %adj_val5 = load i32, i32* %adj_ptr5
  %adj_zero5 = icmp eq i32 %adj_val5, 0
  br i1 %adj_zero5, label %loc_131c, label %check_visit5

check_visit5:                                          ; not an input-labeled block
  %vptrA5 = getelementptr inbounds i32, i32* %p1cast, i64 %rdx5
  store i32* %vptrA5, i32** %rsi_vis
  %vis5 = load i32, i32* %vptrA5
  %unvis5 = icmp eq i32 %vis5, 0
  br i1 %unvis5, label %set_rdx5_and_goto_13f0, label %loc_131c

set_rdx5_and_goto_13f0:                                ; not an input-labeled block
  store i64 %rdx5, i64* %rdx_cur
  br label %loc_13f0

loc_131c:
  %rax_now6 = load i64, i64* %rax_cur
  %is_nonzero_rax = icmp ne i64 %rax_now6, 0
  br i1 %is_nonzero_rax, label %loc_133d, label %cont_131c

cont_131c:                                             ; not an input-labeled block
  %rcx7v6 = load i64, i64* %rcx7_slot
  %t6 = add i64 %rcx7v6, 6
  %adj_ptr6 = getelementptr inbounds [49 x i32], [49 x i32]* %adj, i64 0, i64 %t6
  %adj_val6 = load i32, i32* %adj_ptr6
  %adj_zero6 = icmp eq i32 %adj_val6, 0
  br i1 %adj_zero6, label %loc_133d, label %check_visit_last

check_visit_last:                                      ; not an input-labeled block
  %vptrA6 = getelementptr inbounds i32, i32* %p1cast, i64 6
  store i32* %vptrA6, i32** %rsi_vis
  %vis6 = load i32, i32* %vptrA6
  %unvis6 = icmp eq i32 %vis6, 0
  br i1 %unvis6, label %set_rdx6_and_goto_13f0, label %loc_133d

set_rdx6_and_goto_13f0:                                ; not an input-labeled block
  store i64 6, i64* %rdx_cur
  br label %loc_13f0

loc_133d:
  %rdi_curr = load i64, i64* %rdi_idx
  %rdi_dec = add i64 %rdi_curr, -1
  store i64 %rdi_dec, i64* %rdi_idx
  br label %loc_1341

loc_1341:
  %rdi_now = load i64, i64* %rdi_idx
  %rdi_nonzero = icmp ne i64 %rdi_now, 0
  br i1 %rdi_nonzero, label %loc_1208, label %after_loop

after_loop:                                            ; not an input-labeled block
  %vptr_free = bitcast i32* %p1cast to i8*
  call void @free(i8* %vptr_free)
  %idx_free = bitcast i64* %p2cast to i8*
  call void @free(i8* %idx_free)
  %stk_free = bitcast i64* %p3cast to i8*
  call void @free(i8* %stk_free)

  %fmt_dfs_ptr = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %call_hdr = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dfs_ptr, i64 0)

  %rbp_val = load i64, i64* %rbp_cnt
  %rbp_zero = icmp eq i64 %rbp_val, 0
  br i1 %rbp_zero, label %loc_13ae, label %loc_137c

loc_137c:
  %out0ptr2 = getelementptr inbounds [7 x i64], [7 x i64]* %outarr, i64 0, i64 0
  %first_out = load i64, i64* %out0ptr2
  store i64 %first_out, i64* %rdx_cur
  %fmt_zu_s_ptr = getelementptr inbounds [6 x i8], [6 x i8]* @.str_zu_s, i64 0, i64 0
  store i8* %fmt_zu_s_ptr, i8** %printf_fmt_zu_s
  %rbp_now = load i64, i64* %rbp_cnt
  %rbp_is1 = icmp ne i64 %rbp_now, 1
  br i1 %rbp_is1, label %loc_1421, label %loc_1398

loc_1398:
  %empty_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 1
  %fmt_zu_s_load = load i8*, i8** %printf_fmt_zu_s
  %rdx_for_last = load i64, i64* %rdx_cur
  %call_one = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s_load, i64 %rdx_for_last, i8* %empty_ptr)
  br label %loc_13ae

loc_13ae:
  %nl_ptr = getelementptr inbounds [2 x i8], [2 x i8]* @.str_nl, i64 0, i64 0
  %call_nl = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %nl_ptr)
  %guard_end = load i64, i64* @__stack_chk_guard
  %guard_saved = load i64, i64* %canary
  %guard_cmp = icmp ne i64 %guard_saved, %guard_end
  br i1 %guard_cmp, label %loc_1487, label %ret_block

ret_block:                                             ; not an input-labeled block
  ret i32 0

loc_13ea:
  %rax_for_13ea = load i64, i64* %rax_cur
  store i64 %rax_for_13ea, i64* %rdx_cur
  br label %loc_13f0

loc_13f0:
  %rdx_push = load i64, i64* %rdx_cur
  %rbp_before = load i64, i64* %rbp_cnt
  %out_ptr_bp = getelementptr inbounds [7 x i64], [7 x i64]* %outarr, i64 0, i64 %rbp_before
  store i64 %rdx_push, i64* %out_ptr_bp
  %rbp_inc = add i64 %rbp_before, 1
  store i64 %rbp_inc, i64* %rbp_cnt

  %stp = load i64*, i64** %stack_ptr
  %rdi_now2 = load i64, i64* %rdi_idx
  %stack_slot = getelementptr inbounds i64, i64* %stp, i64 %rdi_now2
  store i64 %rdx_push, i64* %stack_slot
  %rdi_inc2 = add i64 %rdi_now2, 1
  store i64 %rdi_inc2, i64* %rdi_idx

  %r8_loaded = load i64*, i64** %r8_slot
  %rax_new = add i64 %rdx_push, 1
  store i64 %rax_new, i64* %r8_loaded

  %rsi_ptr_loaded = load i32*, i32** %rsi_vis
  store i32 1, i32* %rsi_ptr_loaded

  br label %loc_1341

loc_1412:
  %rax_for_1412 = load i64, i64* %rax_cur
  %cmp_ne7 = icmp ne i64 %rax_for_1412, 7
  br i1 %cmp_ne7, label %loc_1208, label %loc_133d

loc_1421:
  store i64 1, i64* %rbx_iter
  %space = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 22
  store i8* %space, i8** %space_ptr
  br label %loc_1430

loc_1430:
  %space_load = load i8*, i8** %space_ptr
  %fmt_zu_s2 = load i8*, i8** %printf_fmt_zu_s
  %rdx_curr_print = load i64, i64* %rdx_cur
  %call_loop = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_zu_s2, i64 %rdx_curr_print, i8* %space_load)
  br label %after_print_loop_call

after_print_loop_call:                                 ; not an input-labeled block
  %rbx_now = load i64, i64* %rbx_iter
  %rbx_inc = add i64 %rbx_now, 1
  store i64 %rbx_inc, i64* %rbx_iter
  %rbx_idx_fetch = add i64 %rbx_inc, -1
  %next_out_ptr = getelementptr inbounds [7 x i64], [7 x i64]* %outarr, i64 0, i64 %rbx_idx_fetch
  %next_val = load i64, i64* %next_out_ptr
  store i64 %next_val, i64* %rdx_cur
  %rbp_for_cmp = load i64, i64* %rbp_cnt
  %cmp_rbx_rbp = icmp ne i64 %rbx_inc, %rbp_for_cmp
  br i1 %cmp_rbx_rbp, label %loc_1430, label %loc_1398

loc_1455:
  %vptr_free2 = bitcast i32* %p1cast to i8*
  call void @free(i8* %vptr_free2)
  %idx_free2 = bitcast i64* %p2cast to i8*
  call void @free(i8* %idx_free2)
  %stk_free2 = bitcast i64* %p3cast to i8*
  call void @free(i8* %stk_free2)
  %fmt_dfs2 = getelementptr inbounds [24 x i8], [24 x i8]* @.str_dfs, i64 0, i64 0
  %call_hdr2 = call i32 (i32, i8*, ...) @__printf_chk(i32 2, i8* %fmt_dfs2, i64 0)
  br label %loc_13ae

loc_1487:
  call void @__stack_chk_fail()
  unreachable
}