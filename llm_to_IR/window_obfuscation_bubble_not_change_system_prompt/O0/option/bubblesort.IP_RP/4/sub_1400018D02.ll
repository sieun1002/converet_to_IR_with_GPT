; ModuleID = 'sub_1400018D0_module'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*

@aUnknownPseudoR = external constant i8
@aDBitPseudoRelo = external constant i8
@aUnknownPseudoR_0 = external constant i8

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare void @sub_140001700(i8*, ...)

define dso_local void @sub_1400018D0() {
entry:
  %rbx = alloca i8*, align 8
  %rdi = alloca i8*, align 8
  %r14 = alloca i8*, align 8
  %r15 = alloca i8*, align 8
  %r12 = alloca i8*, align 8
  %r13 = alloca i8*, align 8
  %esi = alloca i32, align 4
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %var50 = alloca i8, align 1

  %guard0 = load i32, i32* @dword_1400070A0, align 4
  store i32 %guard0, i32* %esi, align 4
  %guard_is_zero = icmp eq i32 %guard0, 0
  br i1 %guard_is_zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %t_call_22d0 = call i32 @sub_1400022D0()
  %t_cdqe = sext i32 %t_call_22d0 to i64
  %mul5 = mul i64 %t_cdqe, 5
  %times8 = shl i64 %mul5, 3
  %plus15 = add i64 %times8, 15
  %aligned = and i64 %plus15, -16
  %t_call_2520 = call i64 @sub_140002520()
  %rdi_load_ptr = load i8*, i8** @off_1400043D0, align 8
  store i8* %rdi_load_ptr, i8** %rdi, align 8
  %rbx_load_ptr = load i8*, i8** @off_1400043E0, align 8
  store i8* %rbx_load_ptr, i8** %rbx, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var50_ptr = bitcast i8* %var50 to i8*
  store i8* %var50_ptr, i8** @qword_1400070A8, align 8
  %rdi_val0 = load i8*, i8** %rdi, align 8
  %rbx_val0 = load i8*, i8** %rbx, align 8
  %rdi_int0 = ptrtoint i8* %rdi_val0 to i64
  %rbx_int0 = ptrtoint i8* %rbx_val0 to i64
  %diff0 = sub i64 %rdi_int0, %rbx_int0
  %cmp_le7 = icmp sle i64 %diff0, 7
  br i1 %cmp_le7, label %ret, label %check_gt_0xB

check_gt_0xB:
  %cmp_gt_0B = icmp sgt i64 %diff0, 11
  br i1 %cmp_gt_0B, label %ver_gt_0B_path, label %ver1_header

ver1_header:
  %rbx_h = load i8*, i8** %rbx, align 8
  %p_i32_0 = bitcast i8* %rbx_h to i32*
  %hdr0 = load i32, i32* %p_i32_0, align 4
  %hdr0_is_zero = icmp eq i32 %hdr0, 0
  br i1 %hdr0_is_zero, label %ver1_h2, label %ver_gt_0B_entry

ver1_h2:
  %p_i32_4 = getelementptr inbounds i8, i8* %rbx_h, i64 4
  %p_i32_4c = bitcast i8* %p_i32_4 to i32*
  %hdr1 = load i32, i32* %p_i32_4c, align 4
  %hdr1_is_zero = icmp eq i32 %hdr1, 0
  br i1 %hdr1_is_zero, label %ver1_h3, label %ver_gt_0B_entry

ver1_h3:
  %p_i32_8 = getelementptr inbounds i8, i8* %rbx_h, i64 8
  %p_i32_8c = bitcast i8* %p_i32_8 to i32*
  %hdr2 = load i32, i32* %p_i32_8c, align 4
  %hdr2_is_1 = icmp eq i32 %hdr2, 1
  br i1 %hdr2_is_1, label %ver1_initloop, label %proto_unknown

ver1_initloop:
  %rbx_after_hdr = getelementptr inbounds i8, i8* %rbx_h, i64 12
  store i8* %rbx_after_hdr, i8** %rbx, align 8
  %r14_base = load i8*, i8** @off_1400043C0, align 8
  store i8* %r14_base, i8** %r14, align 8
  %r12_ptr = bitcast i64* %var48 to i8*
  store i8* %r12_ptr, i8** %r12, align 8
  %rbx_now = load i8*, i8** %rbx, align 8
  %rdi_now = load i8*, i8** %rdi, align 8
  %cmp_rbx_rdi = icmp ult i8* %rbx_now, %rdi_now
  br i1 %cmp_rbx_rdi, label %per_entry_A14, label %ret

per_entry_A14:
  %rbx_cur = load i8*, i8** %rbx, align 8
  %r14_cur = load i8*, i8** %r14, align 8
  %p_ent_ofs = bitcast i8* %rbx_cur to i32*
  %ofs_val = load i32, i32* %p_ent_ofs, align 4
  %p_ent_add = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %p_ent_add_c = bitcast i8* %p_ent_add to i32*
  %add_val = load i32, i32* %p_ent_add_c, align 4
  %p_ent_bits = getelementptr inbounds i8, i8* %rbx_cur, i64 8
  %p_ent_bits_c = bitcast i8* %p_ent_bits to i32*
  %bits_val = load i32, i32* %p_ent_bits_c, align 4
  %ofs64 = sext i32 %ofs_val to i64
  %add64 = sext i32 %add_val to i64
  %r8_ptr = getelementptr inbounds i8, i8* %r14_cur, i64 %ofs64
  %r15_ptr = getelementptr inbounds i8, i8* %r14_cur, i64 %add64
  store i8* %r15_ptr, i8** %r15, align 8
  %r8_load64_ptr = bitcast i8* %r8_ptr to i64*
  %r9_val = load i64, i64* %r8_load64_ptr, align 8
  %cl_trunc = trunc i32 %bits_val to i8
  %edx_u8 = zext i8 %cl_trunc to i32
  %is_32 = icmp eq i32 %edx_u8, 32
  br i1 %is_32, label %case32, label %chk_le_32

chk_le_32:
  %le_32 = icmp ule i32 %edx_u8, 32
  br i1 %le_32, label %bits_8_or_16, label %chk_64

chk_64:
  %is_64 = icmp eq i32 %edx_u8, 64
  br i1 %is_64, label %case64, label %bits_unknown

bits_8_or_16:
  %is_8 = icmp eq i32 %edx_u8, 8
  br i1 %is_8, label %case8, label %maybe16

maybe16:
  %is_16 = icmp eq i32 %edx_u8, 16
  br i1 %is_16, label %case16, label %bits_unknown

case16:
  %r15_c16 = load i8*, i8** %r15, align 8
  %p16 = bitcast i8* %r15_c16 to i16*
  %w16 = load i16, i16* %p16, align 2
  %w16_sext = sext i16 %w16 to i64
  %r8_int_c16 = ptrtoint i8* %r8_ptr to i64
  %tmp_sub16 = sub i64 %w16_sext, %r8_int_c16
  %comp16 = add i64 %tmp_sub16, %r9_val
  %flags16 = and i32 %bits_val, 192
  %flags16_is0 = icmp eq i32 %flags16, 0
  store i64 %comp16, i64* %var48, align 8
  br i1 %flags16_is0, label %range16, label %do_apply16

range16:
  %gt_65535 = icmp sgt i64 %comp16, 65535
  br i1 %gt_65535, label %range_error, label %range16_low

range16_low:
  %lt_neg32768 = icmp slt i64 %comp16, -32768
  br i1 %lt_neg32768, label %range_error, label %do_apply16

do_apply16:
  %r15_do16 = load i8*, i8** %r15, align 8
  %r12_do16 = load i8*, i8** %r12, align 8
  store i8* %r12_do16, i8** %r13, align 8
  call void @sub_140001760(i8* %r15_do16)
  call void @sub_1400027B8(i8* %r15_do16, i8* %r12_do16, i32 2)
  br label %per_entry_A14

case32:
  %r15_c32 = load i8*, i8** %r15, align 8
  %p32 = bitcast i8* %r15_c32 to i32*
  %d32 = load i32, i32* %p32, align 4
  %d32_sext = sext i32 %d32 to i64
  %r8_int_c32 = ptrtoint i8* %r8_ptr to i64
  %tmp_sub32 = sub i64 %d32_sext, %r8_int_c32
  %comp32 = add i64 %tmp_sub32, %r9_val
  %flags32 = and i32 %bits_val, 192
  %flags32_is0 = icmp eq i32 %flags32, 0
  store i64 %comp32, i64* %var48, align 8
  br i1 %flags32_is0, label %range32, label %do_apply32

range32:
  %cmp_gt_neg1 = icmp sgt i64 %comp32, -1
  br i1 %cmp_gt_neg1, label %range_error, label %range32_low

range32_low:
  %lt_min32 = icmp slt i64 %comp32, -2147483648
  br i1 %lt_min32, label %range_error, label %do_apply32

do_apply32:
  %r15_do32 = load i8*, i8** %r15, align 8
  %r12_do32 = load i8*, i8** %r12, align 8
  store i8* %r12_do32, i8** %r13, align 8
  call void @sub_140001760(i8* %r15_do32)
  call void @sub_1400027B8(i8* %r15_do32, i8* %r12_do32, i32 4)
  br label %per_entry_A14

case8:
  %r15_c8 = load i8*, i8** %r15, align 8
  %p8 = bitcast i8* %r15_c8 to i8*
  %b8 = load i8, i8* %p8, align 1
  %b8_sext = sext i8 %b8 to i64
  %r8_int_c8 = ptrtoint i8* %r8_ptr to i64
  %tmp_sub8 = sub i64 %b8_sext, %r8_int_c8
  %comp8 = add i64 %tmp_sub8, %r9_val
  %flags8 = and i32 %bits_val, 192
  %flags8_is0 = icmp eq i32 %flags8, 0
  store i64 %comp8, i64* %var48, align 8
  br i1 %flags8_is0, label %range8, label %do_apply8

range8:
  %gt_255 = icmp sgt i64 %comp8, 255
  br i1 %gt_255, label %range_error, label %range8_low

range8_low:
  %lt_neg128 = icmp slt i64 %comp8, -128
  br i1 %lt_neg128, label %range_error, label %do_apply8

do_apply8:
  %r15_do8 = load i8*, i8** %r15, align 8
  %r12_do8 = load i8*, i8** %r12, align 8
  store i8* %r12_do8, i8** %r13, align 8
  call void @sub_140001760(i8* %r15_do8)
  call void @sub_1400027B8(i8* %r15_do8, i8* %r12_do8, i32 1)
  br label %ver1_loop_continue

ver1_loop_continue:
  br label %per_entry_A14

case64:
  %r15_c64 = load i8*, i8** %r15, align 8
  %p64 = bitcast i8* %r15_c64 to i64*
  %q64 = load i64, i64* %p64, align 8
  %r8_int_c64 = ptrtoint i8* %r8_ptr to i64
  %tmp_sub64 = sub i64 %q64, %r8_int_c64
  %comp64 = add i64 %tmp_sub64, %r9_val
  %flags64 = and i32 %bits_val, 192
  %flags64_is0 = icmp eq i32 %flags64, 0
  store i64 %comp64, i64* %var48, align 8
  br i1 %flags64_is0, label %range64, label %do_apply64

range64:
  %nonneg64 = icmp sge i64 %comp64, 0
  br i1 %nonneg64, label %range_error, label %do_apply64

do_apply64:
  %rbx_cur2 = load i8*, i8** %rbx, align 8
  %rbx_next = getelementptr inbounds i8, i8* %rbx_cur2, i64 12
  store i8* %rbx_next, i8** %rbx, align 8
  %r15_do64 = load i8*, i8** %r15, align 8
  %r12_do64 = load i8*, i8** %r12, align 8
  store i8* %r12_do64, i8** %r13, align 8
  call void @sub_140001760(i8* %r15_do64)
  call void @sub_1400027B8(i8* %r15_do64, i8* %r12_do64, i32 8)
  br label %ret

bits_unknown:
  %str_unknown_bits = bitcast i8* @aUnknownPseudoR to i8*
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* %str_unknown_bits)
  br label %ret

range_error:
  %val_for_msg = phi i64 [ %comp64, %range64 ], [ %comp32, %range32 ], [ %comp32, %range32_low ], [ %comp16, %range16 ], [ %comp16, %range16_low ], [ %comp8, %range8 ], [ %comp8, %range8_low ]
  store i64 %val_for_msg, i64* %var60, align 8
  %r15_for_msg = load i8*, i8** %r15, align 8
  %fmt_range = bitcast i8* @aDBitPseudoRelo to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt_range)
  br label %ret

proto_unknown:
  %fmt_proto = bitcast i8* @aUnknownPseudoR_0 to i8*
  call void (i8*, ...) @sub_140001700(i8* %fmt_proto)
  br label %ret

ver_gt_0B_entry:
  br label %ver_gt_0B_path

ver_gt_0B_path:
  br label %ret

ret:
  ret void
}