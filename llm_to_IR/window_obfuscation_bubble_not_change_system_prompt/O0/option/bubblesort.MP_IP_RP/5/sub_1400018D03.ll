; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%cb_t = type i32 (i8*, i8*, i32, i8*)*

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043D0 = external dso_local global i8*
@off_1400043E0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@aUnknownPseudoR = external dso_local global i8
@aDBitPseudoRelo = external dso_local global i8
@aUnknownPseudoR_0 = external dso_local global i8

declare dso_local i32 @sub_1400022D0()
declare dso_local void @sub_140002520()
declare dso_local void @sub_140001760(i8*)
declare dso_local void @sub_1400027B8(i8*, i8*, i32)
declare dso_local i32 @sub_1404E27D2()
declare dso_local void @sub_140001700(i8*, ...)

define dso_local void @sub_1400018D0(%cb_t %cb) local_unnamed_addr {
entry:
  %var48 = alloca i64, align 8
  %r13ptr0 = bitcast i64* %var48 to i8*
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp_g0 = icmp ne i32 %g0, 0
  br i1 %cmp_g0, label %ret, label %init

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %call_cnt = call i32 @sub_1400022D0()
  %cnt_sext = sext i32 %call_cnt to i64
  %mul5 = mul i64 %cnt_sext, 5
  %mul5x8 = shl i64 %mul5, 3
  %add15 = add i64 %mul5x8, 15
  %align16 = and i64 %add15, -16
  call void @sub_140002520()
  %buf_dyn = alloca i8, i64 %align16, align 16
  %endp0 = load i8*, i8** @off_1400043D0, align 8
  %startp0 = load i8*, i8** @off_1400043E0, align 8
  %end_i = ptrtoint i8* %endp0 to i64
  %start_i = ptrtoint i8* %startp0 to i64
  %diff = sub i64 %end_i, %start_i
  store i32 0, i32* @dword_1400070A4, align 4
  %relbuf = alloca i8, i64 %diff, align 1
  store i8* %relbuf, i8** @qword_1400070A8, align 8
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %ret, label %check_gt11

check_gt11:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %proto2_entry, label %proto1_precheck

proto1_precheck:
  %rbx_cur0 = phi i8* [ %startp0, %check_gt11 ]
  %rdi_end0 = phi i8* [ %endp0, %check_gt11 ]
  %p_first = bitcast i8* %rbx_cur0 to i32*
  %first = load i32, i32* %p_first, align 4
  %first_ne0 = icmp ne i32 %first, 0
  br i1 %first_ne0, label %proto2_entry, label %proto1_check2

proto1_check2:
  %rbx_plus4 = getelementptr i8, i8* %rbx_cur0, i64 4
  %p_second = bitcast i8* %rbx_plus4 to i32*
  %second = load i32, i32* %p_second, align 4
  %second_ne0 = icmp ne i32 %second, 0
  br i1 %second_ne0, label %proto2_entry, label %proto1_check3

proto1_check3:
  %rbx_plus8 = getelementptr i8, i8* %rbx_cur0, i64 8
  %p_third = bitcast i8* %rbx_plus8 to i32*
  %third = load i32, i32* %p_third, align 4
  %third_eq1 = icmp eq i32 %third, 1
  br i1 %third_eq1, label %v1_setup_loop_entry, label %unknown_proto

unknown_proto:
  %fmt_unknown_proto = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt_unknown_proto)
  br label %ret

v1_setup_loop_entry:
  %rbx_next0 = getelementptr i8, i8* %rbx_cur0, i64 12
  %baseC0_0 = load i8*, i8** @off_1400043C0, align 8
  %more0 = icmp ult i8* %rbx_next0, %rdi_end0
  br i1 %more0, label %v1_loop, label %v1_done_check

v1_loop:
  %cur = phi i8* [ %rbx_next0, %v1_setup_loop_entry ], [ %rbx_inc2, %after_case_common2 ]
  %baseC0 = phi i8* [ %baseC0_0, %v1_setup_loop_entry ], [ %baseC0, %after_case_common2 ]
  %r12ptr = phi i8* [ %r13ptr0, %v1_setup_loop_entry ], [ %r12ptr, %after_case_common2 ]
  %p_off_r8 = bitcast i8* %cur to i32*
  %off_r8 = load i32, i32* %p_off_r8, align 4
  %off_r8_i64 = sext i32 %off_r8 to i64
  %r8ptr = getelementptr i8, i8* %baseC0, i64 %off_r8_i64
  %p_r9 = bitcast i8* %r8ptr to i64*
  %r9 = load i64, i64* %p_r9, align 8
  %off_r15_ptr = getelementptr i8, i8* %cur, i64 4
  %p_off_r15 = bitcast i8* %off_r15_ptr to i32*
  %off_r15 = load i32, i32* %p_off_r15, align 4
  %off_r15_i64 = sext i32 %off_r15 to i64
  %r15ptr = getelementptr i8, i8* %baseC0, i64 %off_r15_i64
  %cl_ptr = getelementptr i8, i8* %cur, i64 8
  %p_cl = bitcast i8* %cl_ptr to i32*
  %cl_full = load i32, i32* %p_cl, align 4
  %cl_low8 = trunc i32 %cl_full to i8
  %edx = zext i8 %cl_low8 to i32
  switch i32 %edx, label %unknown_bitsize [
    i32 32, label %case32
    i32 8, label %case8
    i32 16, label %case16
    i32 64, label %case64
  ]

unknown_bitsize:
  %fmt_unknown_bitsize = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_unknown_bitsize)
  br label %ret

case32:
  %p_v32 = bitcast i8* %r15ptr to i32*
  %v32 = load i32, i32* %p_v32, align 4
  %v32_sext = sext i32 %v32 to i64
  %r8addr = ptrtoint i8* %r8ptr to i64
  %sub32 = sub i64 %v32_sext, %r8addr
  %rax32 = add i64 %sub32, %r9
  %mask32 = and i32 %cl_full, 192
  store i64 %rax32, i64* %var48, align 8
  %mask32_nz = icmp ne i32 %mask32, 0
  br i1 %mask32_nz, label %case32_do, label %case32_check

case32_check:
  %gt_max32 = icmp sgt i64 %rax32, 4294967295
  %lt_min32 = icmp slt i64 %rax32, -2147483648
  %range_bad32 = or i1 %gt_max32, %lt_min32
  br i1 %range_bad32, label %range_error, label %case32_do

case32_do:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 4)
  %rbx_after32 = getelementptr i8, i8* %cur, i64 12
  %done_after32 = icmp uge i8* %rbx_after32, %rdi_end0
  br i1 %done_after32, label %v1_done_check, label %after_case_common2

after_case_common2:
  %rbx_inc2 = phi i8* [ %rbx_after32, %case32_do ], [ %rbx_after8, %case8_do ], [ %rbx_after16, %case16_do ], [ %rbx_after64, %case64_do ]
  br label %v1_loop

case8:
  %v8 = load i8, i8* %r15ptr, align 1
  %v8_sext = sext i8 %v8 to i64
  %r8addr_8 = ptrtoint i8* %r8ptr to i64
  %sub8 = sub i64 %v8_sext, %r8addr_8
  %rax8 = add i64 %sub8, %r9
  %mask8 = and i32 %cl_full, 192
  store i64 %rax8, i64* %var48, align 8
  %mask8_nz = icmp ne i32 %mask8, 0
  br i1 %mask8_nz, label %case8_do, label %case8_check

case8_check:
  %gt_max8 = icmp sgt i64 %rax8, 255
  %lt_min8 = icmp slt i64 %rax8, -128
  %range_bad8 = or i1 %gt_max8, %lt_min8
  br i1 %range_bad8, label %range_error, label %case8_do

case8_do:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 1)
  %rbx_after8 = getelementptr i8, i8* %cur, i64 12
  %done_after8 = icmp uge i8* %rbx_after8, %rdi_end0
  br i1 %done_after8, label %v1_done_check, label %after_case_common2

case16:
  %p_v16 = bitcast i8* %r15ptr to i16*
  %v16 = load i16, i16* %p_v16, align 2
  %v16_sext = sext i16 %v16 to i64
  %r8addr_16 = ptrtoint i8* %r8ptr to i64
  %sub16 = sub i64 %v16_sext, %r8addr_16
  %rax16 = add i64 %sub16, %r9
  %mask16 = and i32 %cl_full, 192
  store i64 %rax16, i64* %var48, align 8
  %mask16_nz = icmp ne i32 %mask16, 0
  br i1 %mask16_nz, label %case16_do, label %case16_check

case16_check:
  %gt_max16 = icmp sgt i64 %rax16, 65535
  %lt_min16 = icmp slt i64 %rax16, -32768
  %range_bad16 = or i1 %gt_max16, %lt_min16
  br i1 %range_bad16, label %range_error, label %case16_do

case16_do:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 2)
  %rbx_after16 = getelementptr i8, i8* %cur, i64 12
  %done_after16 = icmp uge i8* %rbx_after16, %rdi_end0
  br i1 %done_after16, label %v1_done_check, label %after_case_common2

case64:
  %p_v64 = bitcast i8* %r15ptr to i64*
  %v64 = load i64, i64* %p_v64, align 8
  %r8addr_64 = ptrtoint i8* %r8ptr to i64
  %sub64 = sub i64 %v64, %r8addr_64
  %rax64 = add i64 %sub64, %r9
  %mask64 = and i32 %cl_full, 192
  store i64 %rax64, i64* %var48, align 8
  %mask64_nz = icmp ne i32 %mask64, 0
  br i1 %mask64_nz, label %case64_do, label %case64_check

case64_check:
  %nonneg64 = icmp sge i64 %rax64, 0
  br i1 %nonneg64, label %range_error, label %case64_do

case64_do:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 8)
  %rbx_after64 = getelementptr i8, i8* %cur, i64 12
  %done_after64 = icmp uge i8* %rbx_after64, %rdi_end0
  br i1 %done_after64, label %v1_done_check, label %after_case_common2

range_error:
  %err_val = phi i64 [ %rax32, %case32_check ], [ %rax8, %case8_check ], [ %rax16, %case16_check ], [ %rax64, %case64_check ]
  %err_r15 = phi i8* [ %r15ptr, %case32_check ], [ %r15ptr, %case8_check ], [ %r15ptr, %case16_check ], [ %r15ptr, %case64_check ]
  %fmt_range = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt_range, i64 %err_val, i8* %err_r15)
  br label %ret

v1_done_check:
  %cnt1 = load i32, i32* @dword_1400070A4, align 4
  %gt0_1 = icmp sgt i32 %cnt1, 0
  br i1 %gt0_1, label %callback_prep, label %ret

callback_prep:
  %res_chk = call i32 @sub_1404E27D2()
  %res_chk_neg = icmp slt i32 %res_chk, 0
  br i1 %res_chk_neg, label %cb_test, label %cb_loop_head

cb_test:
  %x0 = xor i32 %res_chk, 21960
  %x0_neg = icmp slt i32 %x0, 0
  br i1 %x0_neg, label %cb_loop_head_from_test, label %ret

cb_loop_head_from_test:
  br label %cb_loop_head

cb_loop_head:
  %eax_state = phi i32 [ %res_chk, %callback_prep ], [ %res_chk, %cb_loop_head_from_test ], [ %eax_after, %cb_test_after_call ]
  %idx = phi i64 [ 0, %callback_prep ], [ 0, %cb_loop_head_from_test ], [ %next_idx, %cb_test_after_call ]
  %base_ptr = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr = getelementptr i8, i8* %base_ptr, i64 %idx
  %p_r8d = bitcast i8* %entry_ptr to i32*
  %r8d_val = load i32, i32* %p_r8d, align 4
  %r8d_is0 = icmp eq i32 %r8d_val, 0
  br i1 %r8d_is0, label %cb_skip_call, label %cb_do_call

cb_do_call:
  %rcx_ptr = getelementptr i8, i8* %entry_ptr, i64 8
  %rdx_ptr = getelementptr i8, i8* %entry_ptr, i64 16
  %p_rcx = bitcast i8* %rcx_ptr to i8**
  %p_rdx = bitcast i8* %rdx_ptr to i8**
  %rcx_val = load i8*, i8** %p_rcx, align 8
  %rdx_val = load i8*, i8** %p_rdx, align 8
  %r9_arg = bitcast i64* %var48 to i8*
  %ret_cb = call i32 %cb(i8* %rcx_val, i8* %rdx_val, i32 %r8d_val, i8* %r9_arg)
  br label %cb_test_after_call

cb_skip_call:
  br label %cb_test_after_call

cb_test_after_call:
  %eax_after = phi i32 [ %ret_cb, %cb_do_call ], [ %eax_state, %cb_skip_call ]
  %next_idx = add i64 %idx, 40
  %x1 = xor i32 %eax_after, 21960
  %x1_neg = icmp slt i32 %x1, 0
  br i1 %x1_neg, label %cb_loop_head, label %ret

proto2_entry:
  %rbx2 = getelementptr i8, i8* %startp0, i64 0
  %end2 = getelementptr i8, i8* %endp0, i64 0
  %init_done2 = icmp uge i8* %rbx2, %end2
  br i1 %init_done2, label %v1_done_check, label %p2_loop

p2_loop:
  %cur2 = phi i8* [ %rbx2, %proto2_entry ], [ %rbx2_next, %p2_loop ]
  %base2 = load i8*, i8** @off_1400043C0, align 8
  %p_a = bitcast i8* %cur2 to i32*
  %a = load i32, i32* %p_a, align 4
  %cur2_plus4 = getelementptr i8, i8* %cur2, i64 4
  %p_r12d = bitcast i8* %cur2_plus4 to i32*
  %r12d = load i32, i32* %p_r12d, align 4
  %rbx2_next = getelementptr i8, i8* %cur2, i64 8
  %r12_i64 = sext i32 %r12d to i64
  %dest_ptr2 = getelementptr i8, i8* %base2, i64 %r12_i64
  %p_sum = bitcast i8* %dest_ptr2 to i32*
  %sum = load i32, i32* %p_sum, align 4
  %eax_sum = add i32 %a, %sum
  %eax_sum_sext = sext i32 %eax_sum to i64
  store i64 %eax_sum_sext, i64* %var48, align 8
  call void @sub_140001760(i8* %dest_ptr2)
  call void @sub_1400027B8(i8* %dest_ptr2, i8* %r13ptr0, i32 4)
  %done2 = icmp uge i8* %rbx2_next, %end2
  br i1 %done2, label %v1_done_check, label %p2_loop

ret:
  ret void
}