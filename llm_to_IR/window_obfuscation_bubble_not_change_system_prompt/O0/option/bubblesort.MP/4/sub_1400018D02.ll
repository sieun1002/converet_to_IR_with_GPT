; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external dso_local global i32
@dword_1400070A4 = external dso_local global i32
@qword_1400070A8 = external dso_local global i8*
@off_1400043D0 = external dso_local global i8*
@off_1400043E0 = external dso_local global i8*
@off_1400043C0 = external dso_local global i8*
@qword_140008290 = external dso_local global void (i8*, i8*, i32, i8*)*

@aUnknownPseudoR = external dso_local global i8
@aDBitPseudoRelo = external dso_local global i8
@aUnknownPseudoR_0 = external dso_local global i8

declare dso_local i32 @sub_1400022D0()
declare dso_local i64 @sub_140002520()
declare dso_local void @sub_140001760(i8*)
declare dso_local void @sub_1400027B8(i8*, i8*, i32)
declare dso_local i32 @sub_140001700(i8*, ...)

define dso_local void @sub_1400018D0() local_unnamed_addr {
entry:
  %var48_entry = alloca i64, align 8
  %var48_r_entry = alloca i64, align 8
  %var48_v2_entry = alloca i64, align 8
  %r12_ptr_entry = bitcast i64* %var48_entry to i8*
  %r12_ptr_r_entry = bitcast i64* %var48_r_entry to i8*
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %t0 = icmp eq i32 %g0, 0
  br i1 %t0, label %init, label %ret

ret:
  ret void

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %r1 = call i32 @sub_1400022D0()
  %r1_sext = sext i32 %r1 to i64
  %mul5 = mul nsw i64 %r1_sext, 5
  %mul40 = shl i64 %mul5, 3
  %addf = add i64 %mul40, 15
  %and = and i64 %addf, -16
  %allocsz = call i64 @sub_140002520()
  %buf = alloca i8, i64 %allocsz, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %tableptr = getelementptr inbounds i8, i8* %buf, i64 48
  store i8* %tableptr, i8** @qword_1400070A8, align 8
  %endptrp = load i8*, i8** @off_1400043D0, align 8
  %startptrp = load i8*, i8** @off_1400043E0, align 8
  %int_end = ptrtoint i8* %endptrp to i64
  %int_start = ptrtoint i8* %startptrp to i64
  %diff = sub i64 %int_end, %int_start
  %cmp_le7 = icmp sle i64 %diff, 7
  br i1 %cmp_le7, label %ret, label %chk2

chk2:
  %cmp_gt_b = icmp sgt i64 %diff, 11
  br i1 %cmp_gt_b, label %ver2_header, label %ver1_header

ver1_header:
  %h0 = bitcast i8* %startptrp to i32*
  %edx0 = load i32, i32* %h0, align 4
  %t_edx0 = icmp ne i32 %edx0, 0
  br i1 %t_edx0, label %goto_1AFD, label %vh_next1

vh_next1:
  %h1ptr = getelementptr inbounds i8, i8* %startptrp, i64 4
  %h1 = bitcast i8* %h1ptr to i32*
  %eax0 = load i32, i32* %h1, align 4
  %t_eax0 = icmp ne i32 %eax0, 0
  br i1 %t_eax0, label %goto_1AFD, label %vh_next2

vh_next2:
  %h2ptr = getelementptr inbounds i8, i8* %startptrp, i64 8
  %h2 = bitcast i8* %h2ptr to i32*
  %edx1 = load i32, i32* %h2, align 4
  %cmp_edx1 = icmp eq i32 %edx1, 1
  br i1 %cmp_edx1, label %v1_setup, label %unknown_protocol

unknown_protocol:
  %msg3 = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  %c3 = call i32 (i8*, ...) @sub_140001700(i8* %msg3)
  br label %ret

v1_setup:
  %rbx_init = getelementptr inbounds i8, i8* %startptrp, i64 12
  %base = load i8*, i8** @off_1400043C0, align 8
  %rbx_init_int = ptrtoint i8* %rbx_init to i64
  %cond_less = icmp ult i64 %rbx_init_int, %int_end
  br i1 %cond_less, label %v1_loop, label %ret

goto_1AFD:
  br label %ver2_check

ver2_header:
  %v2h0 = bitcast i8* %startptrp to i32*
  %v2_r9d = load i32, i32* %v2h0, align 4
  %v2_cond1 = icmp ne i32 %v2_r9d, 0
  br i1 %v2_cond1, label %ver2_check, label %v2_check2

v2_check2:
  %v2h1p = getelementptr inbounds i8, i8* %startptrp, i64 4
  %v2h1 = bitcast i8* %v2h1p to i32*
  %v2_r8d = load i32, i32* %v2h1, align 4
  %v2_cond2 = icmp eq i32 %v2_r8d, 0
  br i1 %v2_cond2, label %check_c17, label %ver2_check

check_c17:
  %v2h2p = getelementptr inbounds i8, i8* %startptrp, i64 8
  %v2h2 = bitcast i8* %v2h2p to i32*
  %v2_ecx = load i32, i32* %v2h2, align 4
  %v2_ecx_nz = icmp ne i32 %v2_ecx, 0
  br i1 %v2_ecx_nz, label %vh_next2, label %skip12

skip12:
  %start_after12 = getelementptr inbounds i8, i8* %startptrp, i64 12
  br label %ver1_header_from_skip

ver1_header_from_skip:
  br label %ver1_header_reenter

ver1_header_reenter:
  %rbx_ph = phi i8* [ %start_after12, %ver1_header_from_skip ]
  %eh0 = bitcast i8* %rbx_ph to i32*
  %edx_eh0 = load i32, i32* %eh0, align 4
  %t_edx_eh0 = icmp ne i32 %edx_eh0, 0
  br i1 %t_edx_eh0, label %ver2_check_from_reenter, label %eh_next1

eh_next1:
  %eh1p = getelementptr inbounds i8, i8* %rbx_ph, i64 4
  %eh1 = bitcast i8* %eh1p to i32*
  %eax_eh1 = load i32, i32* %eh1, align 4
  %t_eax_eh1 = icmp ne i32 %eax_eh1, 0
  br i1 %t_eax_eh1, label %ver2_check_from_reenter, label %eh_next2

eh_next2:
  %eh2p = getelementptr inbounds i8, i8* %rbx_ph, i64 8
  %eh2 = bitcast i8* %eh2p to i32*
  %edx_eh2 = load i32, i32* %eh2, align 4
  %cmp_eh2 = icmp eq i32 %edx_eh2, 1
  br i1 %cmp_eh2, label %v1_setup_reenter, label %unknown_protocol

v1_setup_reenter:
  %rbx_init2 = getelementptr inbounds i8, i8* %rbx_ph, i64 12
  %base2 = load i8*, i8** @off_1400043C0, align 8
  %rbx_init2_int = ptrtoint i8* %rbx_init2 to i64
  %cond_less2 = icmp ult i64 %rbx_init2_int, %int_end
  br i1 %cond_less2, label %v1_loop_reenter, label %ret

ver2_check_from_reenter:
  br label %ver2_check

ver2_check:
  %rbx_v2 = phi i8* [ %startptrp, %goto_1AFD ], [ %startptrp, %ver2_header ], [ %startptrp, %v2_check2 ], [ %rbx_ph, %ver2_check_from_reenter ]
  %rbx_int_v2 = ptrtoint i8* %rbx_v2 to i64
  %cond_ge = icmp uge i64 %rbx_int_v2, %int_end
  br i1 %cond_ge, label %ret, label %v2_loop_setup

v2_loop_setup:
  %base_v2 = load i8*, i8** @off_1400043C0, align 8
  %r13_ptr_v2 = bitcast i64* %var48_v2_entry to i8*
  br label %v2_loop

v2_loop:
  %r12d_ptr = getelementptr inbounds i8, i8* %rbx_v2, i64 4
  %r12d_ptr_i32 = bitcast i8* %r12d_ptr to i32*
  %r12d_val = load i32, i32* %r12d_ptr_i32, align 4
  %rbx_v2_i32p = bitcast i8* %rbx_v2 to i32*
  %eax_val = load i32, i32* %rbx_v2_i32p, align 4
  %rbx_next = getelementptr inbounds i8, i8* %rbx_v2, i64 8
  %r12_ext = sext i32 %r12d_val to i64
  %dest_ptr = getelementptr inbounds i8, i8* %base_v2, i64 %r12_ext
  %dest_i32ptr = bitcast i8* %dest_ptr to i32*
  %mem32 = load i32, i32* %dest_i32ptr, align 4
  %sum = add i32 %eax_val, %mem32
  %sum64 = zext i32 %sum to i64
  store i64 %sum64, i64* %var48_v2_entry, align 8
  call void @sub_140001760(i8* %dest_ptr)
  call void @sub_1400027B8(i8* %dest_ptr, i8* %r13_ptr_v2, i32 4)
  %rbx_next_int = ptrtoint i8* %rbx_next to i64
  %cond_cont = icmp ult i64 %rbx_next_int, %int_end
  br i1 %cond_cont, label %v2_loop, label %v1_final_from_v2

v1_loop:
  %rbx_cur = phi i8* [ %rbx_init, %v1_setup ], [ %rbx_next_v1, %v1_case_done ]
  %base_v1 = phi i8* [ %base, %v1_setup ], [ %base, %v1_case_done ]
  %r12_p_v1 = phi i8* [ %r12_ptr_entry, %v1_setup ], [ %r12_ptr_entry, %v1_case_done ]
  %r8d_ptr_v1 = bitcast i8* %rbx_cur to i32*
  %r8d_v1 = load i32, i32* %r8d_ptr_v1, align 4
  %r15d_ptr_v1 = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %r15d_ptr_v1_i32 = bitcast i8* %r15d_ptr_v1 to i32*
  %r15d_v1 = load i32, i32* %r15d_ptr_v1_i32, align 4
  %ecx_ptr_v1 = getelementptr inbounds i8, i8* %rbx_cur, i64 8
  %ecx_ptr_v1_i32 = bitcast i8* %ecx_ptr_v1 to i32*
  %ecx_v1 = load i32, i32* %ecx_ptr_v1_i32, align 4
  %r8_ext_v1 = sext i32 %r8d_v1 to i64
  %r8_ptr_v1 = getelementptr inbounds i8, i8* %base_v1, i64 %r8_ext_v1
  %r8_ptr_v1_i64 = bitcast i8* %r8_ptr_v1 to i64*
  %r9_q = load i64, i64* %r8_ptr_v1_i64, align 8
  %r15_ext_v1 = sext i32 %r15d_v1 to i64
  %r15_ptr_v1 = getelementptr inbounds i8, i8* %base_v1, i64 %r15_ext_v1
  %cl = trunc i32 %ecx_v1 to i8
  %edx8_cmp20 = icmp eq i8 %cl, 32
  %edx8_le20 = icmp ule i8 %cl, 32
  br i1 %edx8_cmp20, label %v1_32bit, label %v1_chk_small

v1_chk_small:
  br i1 %edx8_le20, label %v1_smallbits, label %v1_chk_64

v1_chk_64:
  %is64 = icmp eq i8 %cl, 64
  br i1 %is64, label %v1_64bit, label %unknown_bits

unknown_bits:
  %msg1 = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  %var48_as_i64ptr = bitcast i8* %r12_p_v1 to i64*
  store i64 0, i64* %var48_as_i64ptr, align 8
  %c1 = call i32 (i8*, ...) @sub_140001700(i8* %msg1)
  br label %error_chain

v1_smallbits:
  %is8 = icmp eq i8 %cl, 8
  br i1 %is8, label %v1_8bit, label %v1_chk16

v1_chk16:
  %is16 = icmp eq i8 %cl, 16
  br i1 %is16, label %v1_16bit, label %unknown_bits

v1_8bit:
  %val8 = load i8, i8* %r15_ptr_v1, align 1
  %val8_sext = sext i8 %val8 to i64
  %r8_addr_i64 = ptrtoint i8* %r8_ptr_v1 to i64
  %tmp1 = sub i64 %val8_sext, %r8_addr_i64
  %tmp2 = add i64 %tmp1, %r9_q
  %var48_as_i64ptr_8 = bitcast i8* %r12_p_v1 to i64*
  store i64 %tmp2, i64* %var48_as_i64ptr_8, align 8
  %maskC0 = and i32 %ecx_v1, 192
  %mask_nz = icmp ne i32 %maskC0, 0
  br i1 %mask_nz, label %v1_common_apply1, label %v1_check8

v1_check8:
  %cmp_gt_ff = icmp sgt i64 %tmp2, 255
  br i1 %cmp_gt_ff, label %error_chain_withvals_8, label %chk_low8

chk_low8:
  %cmp_lt_min8 = icmp slt i64 %tmp2, -128
  br i1 %cmp_lt_min8, label %error_chain_withvals_8, label %v1_common_apply1

v1_16bit:
  %val16ptr = bitcast i8* %r15_ptr_v1 to i16*
  %val16 = load i16, i16* %val16ptr, align 2
  %val16_sext = sext i16 %val16 to i64
  %r8_addr_i64_2 = ptrtoint i8* %r8_ptr_v1 to i64
  %tmp1_16 = sub i64 %val16_sext, %r8_addr_i64_2
  %tmp2_16 = add i64 %tmp1_16, %r9_q
  %var48_as_i64ptr_16 = bitcast i8* %r12_p_v1 to i64*
  store i64 %tmp2_16, i64* %var48_as_i64ptr_16, align 8
  %maskC0_16 = and i32 %ecx_v1, 192
  %mask_nz_16 = icmp ne i32 %maskC0_16, 0
  br i1 %mask_nz_16, label %v1_common_apply2, label %v1_check16

v1_check16:
  %cmp_gt_ffff = icmp sgt i64 %tmp2_16, 65535
  br i1 %cmp_gt_ffff, label %error_chain_withvals_16, label %chk_low16

chk_low16:
  %cmp_lt_min16 = icmp slt i64 %tmp2_16, -32768
  br i1 %cmp_lt_min16, label %error_chain_withvals_16, label %v1_common_apply2

v1_32bit:
  %val32ptr = bitcast i8* %r15_ptr_v1 to i32*
  %val32 = load i32, i32* %val32ptr, align 4
  %val32_sext = sext i32 %val32 to i64
  %r8_addr_i64_3 = ptrtoint i8* %r8_ptr_v1 to i64
  %tmp1_32 = sub i64 %val32_sext, %r8_addr_i64_3
  %tmp2_32 = add i64 %tmp1_32, %r9_q
  %var48_as_i64ptr_32 = bitcast i8* %r12_p_v1 to i64*
  store i64 %tmp2_32, i64* %var48_as_i64ptr_32, align 8
  %maskC0_32 = and i32 %ecx_v1, 192
  %mask_nz_32 = icmp ne i32 %maskC0_32, 0
  br i1 %mask_nz_32, label %v1_common_apply4, label %v1_check32

v1_check32:
  %limit32u = zext i32 -1 to i64
  %cmp_gt_u32 = icmp ugt i64 %tmp2_32, %limit32u
  br i1 %cmp_gt_u32, label %error_chain_withvals_32, label %chk_low32

chk_low32:
  %cmp_lt_min32 = icmp slt i64 %tmp2_32, -2147483648
  br i1 %cmp_lt_min32, label %error_chain_withvals_32, label %v1_common_apply4

v1_64bit:
  %r15_ptr_v1_i64p = bitcast i8* %r15_ptr_v1 to i64*
  %val64 = load i64, i64* %r15_ptr_v1_i64p, align 8
  %r8_addr_i64_4 = ptrtoint i8* %r8_ptr_v1 to i64
  %tmp1_64 = sub i64 %val64, %r8_addr_i64_4
  %tmp2_64 = add i64 %tmp1_64, %r9_q
  %var48_as_i64ptr_64 = bitcast i8* %r12_p_v1 to i64*
  store i64 %tmp2_64, i64* %var48_as_i64ptr_64, align 8
  %maskC0_64 = and i32 %ecx_v1, 192
  %mask_nz_64 = icmp ne i32 %maskC0_64, 0
  br i1 %mask_nz_64, label %v1_common_apply8, label %v1_check64

v1_check64:
  %nonneg64 = icmp sge i64 %tmp2_64, 0
  br i1 %nonneg64, label %error_chain_withvals_64, label %v1_common_apply8

v1_common_apply1:
  call void @sub_140001760(i8* %r15_ptr_v1)
  call void @sub_1400027B8(i8* %r15_ptr_v1, i8* %r12_p_v1, i32 1)
  br label %v1_case_done

v1_common_apply2:
  call void @sub_140001760(i8* %r15_ptr_v1)
  call void @sub_1400027B8(i8* %r15_ptr_v1, i8* %r12_p_v1, i32 2)
  br label %v1_case_done

v1_common_apply4:
  call void @sub_140001760(i8* %r15_ptr_v1)
  call void @sub_1400027B8(i8* %r15_ptr_v1, i8* %r12_p_v1, i32 4)
  br label %v1_case_done

v1_common_apply8:
  call void @sub_140001760(i8* %r15_ptr_v1)
  call void @sub_1400027B8(i8* %r15_ptr_v1, i8* %r12_p_v1, i32 8)
  br label %v1_case_done

v1_case_done:
  %rbx_next_v1 = getelementptr inbounds i8, i8* %rbx_cur, i64 12
  %rbx_next_v1_int = ptrtoint i8* %rbx_next_v1 to i64
  %cmp_cont_v1 = icmp ult i64 %rbx_next_v1_int, %int_end
  br i1 %cmp_cont_v1, label %v1_loop, label %v1_final_from_v1

error_chain:
  %fmt2 = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  %dummy = call i32 (i8*, ...) @sub_140001700(i8* %fmt2)
  %fmt3 = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  %call3b = call i32 (i8*, ...) @sub_140001700(i8* %fmt3)
  br label %ret

error_chain_withvals_8:
  br label %error_chain_withvals

error_chain_withvals_16:
  br label %error_chain_withvals

error_chain_withvals_32:
  br label %error_chain_withvals

error_chain_withvals_64:
  br label %error_chain_withvals

error_chain_withvals:
  %err_val = phi i64 [ %tmp2, %error_chain_withvals_8 ], [ %tmp2_16, %error_chain_withvals_16 ], [ %tmp2_32, %error_chain_withvals_32 ], [ %tmp2_64, %error_chain_withvals_64 ]
  %err_ptr = phi i8* [ %r15_ptr_v1, %error_chain_withvals_8 ], [ %r15_ptr_v1, %error_chain_withvals_16 ], [ %r15_ptr_v1, %error_chain_withvals_32 ], [ %r15_ptr_v1, %error_chain_withvals_64 ]
  %fmt2b = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  %call2 = call i32 (i8*, ...) @sub_140001700(i8* %fmt2b, i64 %err_val, i8* %err_ptr)
  %fmt3c = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  %call3c = call i32 (i8*, ...) @sub_140001700(i8* %fmt3c)
  br label %ret

v1_final_from_v1:
  br label %v1_final

v1_final_from_v2:
  br label %v1_final

v1_loop_reenter:
  %rbx_cur_r = phi i8* [ %rbx_init2, %v1_setup_reenter ], [ %rbx_next_v1r, %v1_case_done_r ]
  %base_v1r = phi i8* [ %base2, %v1_setup_reenter ], [ %base2, %v1_case_done_r ]
  %r12_p_v1r = phi i8* [ %r12_ptr_r_entry, %v1_setup_reenter ], [ %r12_ptr_r_entry, %v1_case_done_r ]
  %r8d_ptr_v1r = bitcast i8* %rbx_cur_r to i32*
  %r8d_v1r = load i32, i32* %r8d_ptr_v1r, align 4
  %r15d_ptr_v1r = getelementptr inbounds i8, i8* %rbx_cur_r, i64 4
  %r15d_ptr_v1r_i32 = bitcast i8* %r15d_ptr_v1r to i32*
  %r15d_v1r = load i32, i32* %r15d_ptr_v1r_i32, align 4
  %ecx_ptr_v1r = getelementptr inbounds i8, i8* %rbx_cur_r, i64 8
  %ecx_ptr_v1r_i32 = bitcast i8* %ecx_ptr_v1r to i32*
  %ecx_v1r = load i32, i32* %ecx_ptr_v1r_i32, align 4
  %r8_ext_v1r = sext i32 %r8d_v1r to i64
  %r8_ptr_v1r = getelementptr inbounds i8, i8* %base_v1r, i64 %r8_ext_v1r
  %r8_ptr_v1r_i64 = bitcast i8* %r8_ptr_v1r to i64*
  %r9_qr = load i64, i64* %r8_ptr_v1r_i64, align 8
  %r15_ext_v1r = sext i32 %r15d_v1r to i64
  %r15_ptr_v1r = getelementptr inbounds i8, i8* %base_v1r, i64 %r15_ext_v1r
  %clr = trunc i32 %ecx_v1r to i8
  %edx8_cmp20r = icmp eq i8 %clr, 32
  %edx8_le20r = icmp ule i8 %clr, 32
  br i1 %edx8_cmp20r, label %v1_32bit_r, label %v1_chk_small_r

v1_chk_small_r:
  br i1 %edx8_le20r, label %v1_smallbits_r, label %v1_chk_64_r

v1_chk_64_r:
  %is64r = icmp eq i8 %clr, 64
  br i1 %is64r, label %v1_64bit_r, label %unknown_bits_r

unknown_bits_r:
  %msg1r = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  %var48_as_i64ptr_r = bitcast i8* %r12_p_v1r to i64*
  store i64 0, i64* %var48_as_i64ptr_r, align 8
  %c1r = call i32 (i8*, ...) @sub_140001700(i8* %msg1r)
  br label %error_chain

v1_smallbits_r:
  %is8r = icmp eq i8 %clr, 8
  br i1 %is8r, label %v1_8bit_r, label %v1_chk16_r

v1_chk16_r:
  %is16r = icmp eq i8 %clr, 16
  br i1 %is16r, label %v1_16bit_r, label %unknown_bits_r

v1_8bit_r:
  %val8r = load i8, i8* %r15_ptr_v1r, align 1
  %val8_sextr = sext i8 %val8r to i64
  %r8_addr_i64r = ptrtoint i8* %r8_ptr_v1r to i64
  %tmp1r = sub i64 %val8_sextr, %r8_addr_i64r
  %tmp2r = add i64 %tmp1r, %r9_qr
  %var48_as_i64ptr_8r = bitcast i8* %r12_p_v1r to i64*
  store i64 %tmp2r, i64* %var48_as_i64ptr_8r, align 8
  %maskC0r = and i32 %ecx_v1r, 192
  %mask_nzr = icmp ne i32 %maskC0r, 0
  br i1 %mask_nzr, label %v1_common_apply1_r, label %v1_check8_r

v1_check8_r:
  %cmp_gt_ffr = icmp sgt i64 %tmp2r, 255
  br i1 %cmp_gt_ffr, label %error_chain_withvals_8r, label %chk_low8_r

chk_low8_r:
  %cmp_lt_min8r = icmp slt i64 %tmp2r, -128
  br i1 %cmp_lt_min8r, label %error_chain_withvals_8r, label %v1_common_apply1_r

v1_16bit_r:
  %val16ptrr = bitcast i8* %r15_ptr_v1r to i16*
  %val16r = load i16, i16* %val16ptrr, align 2
  %val16_sextr = sext i16 %val16r to i64
  %r8_addr_i64_2r = ptrtoint i8* %r8_ptr_v1r to i64
  %tmp1_16r = sub i64 %val16_sextr, %r8_addr_i64_2r
  %tmp2_16r = add i64 %tmp1_16r, %r9_qr
  %var48_as_i64ptr_16r = bitcast i8* %r12_p_v1r to i64*
  store i64 %tmp2_16r, i64* %var48_as_i64ptr_16r, align 8
  %maskC0_16r = and i32 %ecx_v1r, 192
  %mask_nz_16r = icmp ne i32 %maskC0_16r, 0
  br i1 %mask_nz_16r, label %v1_common_apply2_r, label %v1_check16_r

v1_check16_r:
  %cmp_gt_ffffr = icmp sgt i64 %tmp2_16r, 65535
  br i1 %cmp_gt_ffffr, label %error_chain_withvals_16r, label %chk_low16_r

chk_low16_r:
  %cmp_lt_min16r = icmp slt i64 %tmp2_16r, -32768
  br i1 %cmp_lt_min16r, label %error_chain_withvals_16r, label %v1_common_apply2_r

v1_32bit_r:
  %val32ptrr = bitcast i8* %r15_ptr_v1r to i32*
  %val32r = load i32, i32* %val32ptrr, align 4
  %val32_sextr = sext i32 %val32r to i64
  %r8_addr_i64_3r = ptrtoint i8* %r8_ptr_v1r to i64
  %tmp1_32r = sub i64 %val32_sextr, %r8_addr_i64_3r
  %tmp2_32r = add i64 %tmp1_32r, %r9_qr
  %var48_as_i64ptr_32r = bitcast i8* %r12_p_v1r to i64*
  store i64 %tmp2_32r, i64* %var48_as_i64ptr_32r, align 8
  %maskC0_32r = and i32 %ecx_v1r, 192
  %mask_nz_32r = icmp ne i32 %maskC0_32r, 0
  br i1 %mask_nz_32r, label %v1_common_apply4_r, label %v1_check32_r

v1_check32_r:
  %limit32ur = zext i32 -1 to i64
  %cmp_gt_u32r = icmp ugt i64 %tmp2_32r, %limit32ur
  br i1 %cmp_gt_u32r, label %error_chain_withvals_32r, label %chk_low32_r

chk_low32_r:
  %cmp_lt_min32r = icmp slt i64 %tmp2_32r, -2147483648
  br i1 %cmp_lt_min32r, label %error_chain_withvals_32r, label %v1_common_apply4_r

v1_64bit_r:
  %r15_ptr_v1r_i64p = bitcast i8* %r15_ptr_v1r to i64*
  %val64r = load i64, i64* %r15_ptr_v1r_i64p, align 8
  %r8_addr_i64_4r = ptrtoint i8* %r8_ptr_v1r to i64
  %tmp1_64r = sub i64 %val64r, %r8_addr_i64_4r
  %tmp2_64r = add i64 %tmp1_64r, %r9_qr
  %var48_as_i64ptr_64r = bitcast i8* %r12_p_v1r to i64*
  store i64 %tmp2_64r, i64* %var48_as_i64ptr_64r, align 8
  %maskC0_64r = and i32 %ecx_v1r, 192
  %mask_nz_64r = icmp ne i32 %maskC0_64r, 0
  br i1 %mask_nz_64r, label %v1_common_apply8_r, label %v1_check64_r

v1_check64_r:
  %nonneg64r = icmp sge i64 %tmp2_64r, 0
  br i1 %nonneg64r, label %error_chain_withvals_64r, label %v1_common_apply8_r

v1_common_apply1_r:
  call void @sub_140001760(i8* %r15_ptr_v1r)
  call void @sub_1400027B8(i8* %r15_ptr_v1r, i8* %r12_p_v1r, i32 1)
  br label %v1_case_done_r

v1_common_apply2_r:
  call void @sub_140001760(i8* %r15_ptr_v1r)
  call void @sub_1400027B8(i8* %r15_ptr_v1r, i8* %r12_p_v1r, i32 2)
  br label %v1_case_done_r

v1_common_apply4_r:
  call void @sub_140001760(i8* %r15_ptr_v1r)
  call void @sub_1400027B8(i8* %r15_ptr_v1r, i8* %r12_p_v1r, i32 4)
  br label %v1_case_done_r

v1_common_apply8_r:
  call void @sub_140001760(i8* %r15_ptr_v1r)
  call void @sub_1400027B8(i8* %r15_ptr_v1r, i8* %r12_p_v1r, i32 8)
  br label %v1_case_done_r

v1_case_done_r:
  %rbx_next_v1r = getelementptr inbounds i8, i8* %rbx_cur_r, i64 12
  %rbx_next_v1r_int = ptrtoint i8* %rbx_next_v1r to i64
  %cmp_cont_v1r = icmp ult i64 %rbx_next_v1r_int, %int_end
  br i1 %cmp_cont_v1r, label %v1_loop_reenter, label %v1_final_from_v1

error_chain_withvals_8r:
  br label %error_chain_withvals_r

error_chain_withvals_16r:
  br label %error_chain_withvals_r

error_chain_withvals_32r:
  br label %error_chain_withvals_r

error_chain_withvals_64r:
  br label %error_chain_withvals_r

error_chain_withvals_r:
  %err_val_r = phi i64 [ %tmp2r, %error_chain_withvals_8r ], [ %tmp2_16r, %error_chain_withvals_16r ], [ %tmp2_32r, %error_chain_withvals_32r ], [ %tmp2_64r, %error_chain_withvals_64r ]
  %err_ptr_r = phi i8* [ %r15_ptr_v1r, %error_chain_withvals_8r ], [ %r15_ptr_v1r, %error_chain_withvals_16r ], [ %r15_ptr_v1r, %error_chain_withvals_32r ], [ %r15_ptr_v1r, %error_chain_withvals_64r ]
  %fmt2br = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  %call2r = call i32 (i8*, ...) @sub_140001700(i8* %fmt2br, i64 %err_val_r, i8* %err_ptr_r)
  %fmt3cr = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  %call3cr = call i32 (i8*, ...) @sub_140001700(i8* %fmt3cr)
  br label %ret

v1_final:
  %r13_final = phi i8* [ %r12_ptr_entry, %v1_final_from_v1 ], [ %r13_ptr_v2, %v1_final_from_v2 ]
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %has = icmp sgt i32 %cnt, 0
  br i1 %has, label %cb_setup, label %ret

cb_setup:
  %cbfunc = load void (i8*, i8*, i32, i8*)*, void (i8*, i8*, i32, i8*)** @qword_140008290, align 8
  %i0 = add i32 0, 0
  %off0 = add i64 0, 0
  br label %cb_loop

cb_loop:
  %i = phi i32 [ %i0, %cb_setup ], [ %i_next, %cb_iter_end ]
  %off = phi i64 [ %off0, %cb_setup ], [ %off_next, %cb_iter_end ]
  %tbl = load i8*, i8** @qword_1400070A8, align 8
  %recptr = getelementptr inbounds i8, i8* %tbl, i64 %off
  %recptr_i32p = bitcast i8* %recptr to i32*
  %kind = load i32, i32* %recptr_i32p, align 4
  %isz = icmp eq i32 %kind, 0
  br i1 %isz, label %cb_skip_call, label %cb_do_call

cb_do_call:
  %rcx_gep = getelementptr inbounds i8, i8* %recptr, i64 8
  %rdx_gep = getelementptr inbounds i8, i8* %recptr, i64 16
  %rcx_i64p = bitcast i8* %rcx_gep to i64*
  %rdx_i64p = bitcast i8* %rdx_gep to i64*
  %rcxv = load i64, i64* %rcx_i64p, align 8
  %rdxv = load i64, i64* %rdx_i64p, align 8
  %rcxptr = inttoptr i64 %rcxv to i8*
  %rdxptr = inttoptr i64 %rdxv to i8*
  call void %cbfunc(i8* %rcxptr, i8* %rdxptr, i32 %kind, i8* %r13_final)
  br label %cb_iter_end

cb_skip_call:
  br label %cb_iter_end

cb_iter_end:
  %i_next = add i32 %i, 1
  %off_next = add i64 %off, 40
  %cntcur = load i32, i32* @dword_1400070A4, align 4
  %cont = icmp slt i32 %i_next, %cntcur
  br i1 %cont, label %cb_loop, label %ret
}