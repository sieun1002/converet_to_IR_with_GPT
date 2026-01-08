; ModuleID = 'sub_1400018D0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@aUnknownPseudoR = external global [0 x i8]
@aDBitPseudoRelo = external global [0 x i8]
@aUnknownPseudoR_0 = external global [0 x i8]
@__imp_VirtualProtect = external global i32 (i8*, i64, i32, i32*)*

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_140001700(i8*, ...)
declare i8* @memcpy(i8*, i8*, i64)

define void @sub_1400018D0() {
entry:
  %srcbuf = alloca [8 x i8], align 8
  %oldprot_i32ptr = bitcast [8 x i8]* %srcbuf to i32*
  %var60 = alloca i64, align 8
  %flag0 = load i32, i32* @dword_1400070A0, align 4
  %flag0_is_zero = icmp eq i32 %flag0, 0
  br i1 %flag0_is_zero, label %cont_init, label %ret

cont_init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n0 = call i32 @sub_1400022D0()
  %n0_sext = sext i32 %n0 to i64
  %mul5 = mul i64 %n0_sext, 5
  %mul40_pre = shl i64 %mul5, 3
  %add15 = add i64 %mul40_pre, 15
  %align16mask = and i64 %add15, -16
  %stacksize = call i64 @sub_140002520()
  %dynbuf = alloca i8, i64 %stacksize, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %dynbuf, i8** @qword_1400070A8, align 8
  %endptr = load i8*, i8** @off_1400043D0, align 8
  %startptr = load i8*, i8** @off_1400043E0, align 8
  %endint = ptrtoint i8* %endptr to i64
  %startint = ptrtoint i8* %startptr to i64
  %diff = sub i64 %endint, %startint
  %diff_le7 = icmp sle i64 %diff, 7
  br i1 %diff_le7, label %ret, label %check11

check11:
  %diff_gt11 = icmp sgt i64 %diff, 11
  br i1 %diff_gt11, label %proto2_check, label %proto1_header

proto1_header:
  %rbx0 = phi i8* [ %startptr, %check11 ], [ %rbx_ext2, %p2_adv_hdr ]
  %hdr0_ptr = bitcast i8* %rbx0 to i32*
  %hdr0 = load i32, i32* %hdr0_ptr, align 4
  %hdr0_is_zero = icmp eq i32 %hdr0, 0
  br i1 %hdr0_is_zero, label %p1_hdr_next, label %p_common_AFD

p1_hdr_next:
  %hdr1_ptr = getelementptr inbounds i8, i8* %rbx0, i64 4
  %hdr1_i32p = bitcast i8* %hdr1_ptr to i32*
  %hdr1 = load i32, i32* %hdr1_i32p, align 4
  %hdr1_is_zero = icmp eq i32 %hdr1, 0
  br i1 %hdr1_is_zero, label %p1_hdr_vfld, label %p_common_AFD

p1_hdr_vfld:
  %rbx_for_p1 = phi i8* [ %rbx0, %p1_hdr_next ], [ %rbx_ext, %p2_check_third ]
  %hdr2_ptr = getelementptr inbounds i8, i8* %rbx_for_p1, i64 8
  %hdr2_i32p = bitcast i8* %hdr2_ptr to i32*
  %hdr2 = load i32, i32* %hdr2_i32p, align 4
  %hdr2_is_one = icmp eq i32 %hdr2, 1
  br i1 %hdr2_is_one, label %p1_after_hdr, label %unknown_proto

p1_after_hdr:
  %rbx_afterhdr = getelementptr inbounds i8, i8* %rbx_for_p1, i64 12
  %base = load i8*, i8** @off_1400043C0, align 8
  %srcptr_init = bitcast [8 x i8]* %srcbuf to i8*
  %rbx_vs_end = icmp ult i8* %rbx_afterhdr, %endptr
  br i1 %rbx_vs_end, label %p1_loop, label %ret

p1_loop:
  %rbx_cur = phi i8* [ %rbx_afterhdr, %p1_after_hdr ], [ %rbx_next, %p1_loop_cont ]
  %srcptr_live = phi i8* [ %srcptr_init, %p1_after_hdr ], [ %srcptr_init, %p1_loop_cont ]
  %r13_live = phi i8* [ %srcptr_init, %p1_after_hdr ], [ %r13_phi, %p1_loop_cont ]
  %ent0_i32p = bitcast i8* %rbx_cur to i32*
  %ent0 = load i32, i32* %ent0_i32p, align 4
  %ent1_ptr = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %ent1_i32p = bitcast i8* %ent1_ptr to i32*
  %ent1 = load i32, i32* %ent1_i32p, align 4
  %ent2_ptr = getelementptr inbounds i8, i8* %rbx_cur, i64 8
  %ent2_i32p = bitcast i8* %ent2_ptr to i32*
  %ent2 = load i32, i32* %ent2_i32p, align 4
  %ent0_sext2 = sext i32 %ent0 to i64
  %r8_ptr = getelementptr inbounds i8, i8* %base, i64 %ent0_sext2
  %r9_i64p = bitcast i8* %r8_ptr to i64*
  %r9_val = load i64, i64* %r9_i64p, align 8
  %ent1_sext = sext i32 %ent1 to i64
  %r15_ptr = getelementptr inbounds i8, i8* %base, i64 %ent1_sext
  %cl_mask = and i32 %ent2, 255
  %is_32 = icmp eq i32 %cl_mask, 32
  br i1 %is_32, label %p1_32bit, label %p1_cl_be

p1_cl_be:
  %cmp_le_32 = icmp ule i32 %cl_mask, 32
  br i1 %cmp_le_32, label %p1_small_sizes, label %p1_check_40

p1_small_sizes:
  %is_8 = icmp eq i32 %cl_mask, 8
  br i1 %is_8, label %p1_8bit, label %p1_check_16

p1_check_16:
  %is_16 = icmp eq i32 %cl_mask, 16
  br i1 %is_16, label %p1_16bit, label %unknown_bitsize

p1_16bit:
  %val16p = bitcast i8* %r15_ptr to i16*
  %val16 = load i16, i16* %val16p, align 2
  %val16_sext64 = sext i16 %val16 to i64
  %r8_int = ptrtoint i8* %r8_ptr to i64
  %tmp16 = sub i64 %val16_sext64, %r8_int
  %res16 = add i64 %tmp16, %r9_val
  %cc_and = and i32 %ent2, 192
  %cc_zero = icmp eq i32 %cc_and, 0
  br i1 %cc_zero, label %p1_16_check, label %p1_16_store

p1_16_check:
  %gt_ffff = icmp sgt i64 %res16, 65535
  br i1 %gt_ffff, label %report_range, label %p1_16_check2

p1_16_check2:
  %lt_min16 = icmp slt i64 %res16, -32768
  br i1 %lt_min16, label %report_range, label %p1_16_store

p1_16_store:
  %src64p = bitcast [8 x i8]* %srcbuf to i64*
  store i64 %res16, i64* %src64p, align 8
  %r13_after = bitcast [8 x i8]* %srcbuf to i8*
  call void @sub_140001760(i8* %r15_ptr)
  %src_i8p = bitcast [8 x i8]* %srcbuf to i8*
  %_ = call i8* @memcpy(i8* %r15_ptr, i8* %src_i8p, i64 2)
  br label %p1_loop_cont

p1_32bit:
  %val32p = bitcast i8* %r15_ptr to i32*
  %val32 = load i32, i32* %val32p, align 4
  %val32_sext64 = sext i32 %val32 to i64
  %r8_int32 = ptrtoint i8* %r8_ptr to i64
  %tmp32 = sub i64 %val32_sext64, %r8_int32
  %res32 = add i64 %tmp32, %r9_val
  %cc_and32 = and i32 %ent2, 192
  %cc_zero32 = icmp eq i32 %cc_and32, 0
  br i1 %cc_zero32, label %p1_32_check, label %p1_32_store

p1_32_check:
  %intmax = add i32 -1, 0
  %intmax64 = sext i32 %intmax to i64
  %gt_intmax = icmp sgt i64 %res32, %intmax64
  br i1 %gt_intmax, label %report_range, label %p1_32_check2

p1_32_check2:
  %intmin64 = add i64 -2147483648, 0
  %lt_intmin = icmp slt i64 %res32, %intmin64
  br i1 %lt_intmin, label %report_range, label %p1_32_store

p1_32_store:
  %src64p2 = bitcast [8 x i8]* %srcbuf to i64*
  store i64 %res32, i64* %src64p2, align 8
  %r13_after32 = bitcast [8 x i8]* %srcbuf to i8*
  call void @sub_140001760(i8* %r15_ptr)
  %src_i8p2 = bitcast [8 x i8]* %srcbuf to i8*
  %__ = call i8* @memcpy(i8* %r15_ptr, i8* %src_i8p2, i64 4)
  br label %p1_loop_cont

p1_check_40:
  %is_40 = icmp eq i32 %cl_mask, 64
  br i1 %is_40, label %p1_64bit, label %unknown_bitsize

p1_64bit:
  %val64p = bitcast i8* %r15_ptr to i64*
  %val64 = load i64, i64* %val64p, align 8
  %r8_int64 = ptrtoint i8* %r8_ptr to i64
  %tmp64 = sub i64 %val64, %r8_int64
  %res64 = add i64 %tmp64, %r9_val
  %cc_and64 = and i32 %ent2, 192
  %cc_zero64 = icmp eq i32 %cc_and64, 0
  br i1 %cc_zero64, label %p1_64_check, label %p1_64_store

p1_64_check:
  %nonneg = icmp sge i64 %res64, 0
  br i1 %nonneg, label %report_range, label %p1_64_store

p1_64_store:
  %src64p3 = bitcast [8 x i8]* %srcbuf to i64*
  store i64 %res64, i64* %src64p3, align 8
  %r13_after64 = bitcast [8 x i8]* %srcbuf to i8*
  call void @sub_140001760(i8* %r15_ptr)
  %src_i8p3 = bitcast [8 x i8]* %srcbuf to i8*
  %___ = call i8* @memcpy(i8* %r15_ptr, i8* %src_i8p3, i64 8)
  br label %p1_loop_cont

p1_8bit:
  %val8p = bitcast i8* %r15_ptr to i8*
  %val8 = load i8, i8* %val8p, align 1
  %val8_sext64 = sext i8 %val8 to i64
  %r8_int8 = ptrtoint i8* %r8_ptr to i64
  %tmp8 = sub i64 %val8_sext64, %r8_int8
  %res8 = add i64 %tmp8, %r9_val
  %cc_and8 = and i32 %ent2, 192
  %cc_zero8 = icmp eq i32 %cc_and8, 0
  br i1 %cc_zero8, label %p1_8_check, label %p1_8_store

p1_8_check:
  %gt_255 = icmp sgt i64 %res8, 255
  br i1 %gt_255, label %report_range, label %p1_8_check2

p1_8_check2:
  %lt_min8 = icmp slt i64 %res8, -128
  br i1 %lt_min8, label %report_range, label %p1_8_store

p1_8_store:
  %src64p4 = bitcast [8 x i8]* %srcbuf to i64*
  store i64 %res8, i64* %src64p4, align 8
  %r13_after8 = bitcast [8 x i8]* %srcbuf to i8*
  call void @sub_140001760(i8* %r15_ptr)
  %src_i8p4 = bitcast [8 x i8]* %srcbuf to i8*
  %____ = call i8* @memcpy(i8* %r15_ptr, i8* %src_i8p4, i64 1)
  br label %p1_loop_cont

p1_loop_cont:
  %r13_phi = phi i8* [ %r13_after, %p1_16_store ], [ %r13_after32, %p1_32_store ], [ %r13_after64, %p1_64_store ], [ %r13_after8, %p1_8_store ]
  %rbx_next = getelementptr inbounds i8, i8* %rbx_cur, i64 12
  %cont_cmp = icmp ult i8* %rbx_next, %endptr
  br i1 %cont_cmp, label %p1_loop, label %post_loops

proto2_check:
  %rbx_ext = phi i8* [ %startptr, %check11 ]
  %hdrA_i32p = bitcast i8* %rbx_ext to i32*
  %hdrA = load i32, i32* %hdrA_i32p, align 4
  %hdrA_nz = icmp ne i32 %hdrA, 0
  br i1 %hdrA_nz, label %p_common_AFD, label %p2_hdr_next

p2_hdr_next:
  %hdrB_ptr = getelementptr inbounds i8, i8* %rbx_ext, i64 4
  %hdrB_i32p = bitcast i8* %hdrB_ptr to i32*
  %hdrB = load i32, i32* %hdrB_i32p, align 4
  %hdrB_nz = icmp ne i32 %hdrB, 0
  br i1 %hdrB_nz, label %p2_loop_prep, label %p2_check_third

p2_check_third:
  %hdrC_ptr = getelementptr inbounds i8, i8* %rbx_ext, i64 8
  %hdrC_i32p = bitcast i8* %hdrC_ptr to i32*
  %hdrC = load i32, i32* %hdrC_i32p, align 4
  %hdrC_nz = icmp ne i32 %hdrC, 0
  br i1 %hdrC_nz, label %p1_hdr_vfld, label %p2_adv_hdr

p2_adv_hdr:
  %rbx_ext2 = getelementptr inbounds i8, i8* %rbx_ext, i64 12
  br label %proto1_header

p2_loop_prep:
  %rbx_loop0 = phi i8* [ %rbx_ext, %p2_hdr_next ]
  %rbx_ge = icmp uge i8* %rbx_loop0, %endptr
  br i1 %rbx_ge, label %ret, label %p2_loop_start

p2_loop_start:
  %rbx_init = phi i8* [ %rbx_loop0, %p2_loop_prep ], [ %rbx_chk, %p_common_AFD ]
  %base2 = load i8*, i8** @off_1400043C0, align 8
  %p2_src = bitcast [8 x i8]* %srcbuf to i8*
  %p2_r13 = bitcast [8 x i8]* %srcbuf to i8*
  br label %p2_loop

p2_loop:
  %rbx_e_cur = phi i8* [ %rbx_init, %p2_loop_start ], [ %rbx_e_next, %p2_loop_cont ]
  %off_ptr = getelementptr inbounds i8, i8* %rbx_e_cur, i64 4
  %off_i32p = bitcast i8* %off_ptr to i32*
  %off = load i32, i32* %off_i32p, align 4
  %addend_i32p = bitcast i8* %rbx_e_cur to i32*
  %addend = load i32, i32* %addend_i32p, align 4
  %rbx_e_next = getelementptr inbounds i8, i8* %rbx_e_cur, i64 8
  %off_sext = sext i32 %off to i64
  %dst_ptr = getelementptr inbounds i8, i8* %base2, i64 %off_sext
  %dst_i32p = bitcast i8* %dst_ptr to i32*
  %old32 = load i32, i32* %dst_i32p, align 4
  %sum32 = add i32 %addend, %old32
  %src_i32p = bitcast [8 x i8]* %srcbuf to i32*
  store i32 %sum32, i32* %src_i32p, align 4
  call void @sub_140001760(i8* %dst_ptr)
  %p2_src_i8 = bitcast [8 x i8]* %srcbuf to i8*
  %_____ = call i8* @memcpy(i8* %dst_ptr, i8* %p2_src_i8, i64 4)
  %cmp_next = icmp ult i8* %rbx_e_next, %endptr
  br i1 %cmp_next, label %p2_loop_cont, label %post_loops

p2_loop_cont:
  br label %p2_loop

p_common_AFD:
  %rbx_chk = phi i8* [ %rbx0, %p1_hdr_next ], [ %rbx_ext, %proto2_check ], [ %rbx0, %proto1_header ]
  %rbx_ge2 = icmp uge i8* %rbx_chk, %endptr
  br i1 %rbx_ge2, label %ret, label %p2_loop_start

unknown_bitsize:
  %fmt_unk_bits_gep = getelementptr inbounds [0 x i8], [0 x i8]* @aUnknownPseudoR, i64 0, i64 0
  %src64p_ub = bitcast [8 x i8]* %srcbuf to i64*
  store i64 0, i64* %src64p_ub, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_unk_bits_gep)
  br label %report_aftermsg

report_range:
  %res_for_msg = phi i64 [ %res8, %p1_8_check2 ], [ %res8, %p1_8_check ], [ %res16, %p1_16_check2 ], [ %res16, %p1_16_check ], [ %res32, %p1_32_check2 ], [ %res32, %p1_32_check ], [ %res64, %p1_64_check ]
  %r15_for_msg = phi i8* [ %r15_ptr, %p1_8_check2 ], [ %r15_ptr, %p1_8_check ], [ %r15_ptr, %p1_16_check2 ], [ %r15_ptr, %p1_16_check ], [ %r15_ptr, %p1_32_check2 ], [ %r15_ptr, %p1_32_check ], [ %r15_ptr, %p1_64_check ]
  store i64 %res_for_msg, i64* %var60, align 8
  %fmt_range_gep = getelementptr inbounds [0 x i8], [0 x i8]* @aDBitPseudoRelo, i64 0, i64 0
  %val_for_msg = load i64, i64* %var60, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_range_gep, i64 %val_for_msg, i8* %r15_for_msg)
  br label %unknown_proto

report_aftermsg:
  br label %unknown_proto

post_loops:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %cnt_le0 = icmp sle i32 %cnt, 0
  br i1 %cnt_le0, label %ret, label %vp_start

vp_start:
  %imp_vp = load i32 (i8*, i64, i32, i32*)*, i32 (i8*, i64, i32, i32*)** @__imp_VirtualProtect, align 8
  %idx0 = load i32, i32* @dword_1400070A0, align 4
  %base_arr = load i8*, i8** @qword_1400070A8, align 8
  br label %vp_loop

vp_loop:
  %idx = phi i32 [ %idx0, %vp_start ], [ %idx_next, %vp_loop_cont ]
  %cmp_idx = icmp slt i32 %idx, %cnt
  br i1 %cmp_idx, label %vp_body, label %ret

vp_body:
  %idx_zext = zext i32 %idx to i64
  %entry_off = mul i64 %idx_zext, 40
  %entry_ptr = getelementptr inbounds i8, i8* %base_arr, i64 %entry_off
  %fl_ptr = bitcast i8* %entry_ptr to i32*
  %fl = load i32, i32* %fl_ptr, align 4
  %fl_nz = icmp ne i32 %fl, 0
  br i1 %fl_nz, label %vp_call, label %vp_loop_cont

vp_call:
  %addr_ptr = getelementptr inbounds i8, i8* %entry_ptr, i64 8
  %addr = bitcast i8* %addr_ptr to i8**
  %addr_val = load i8*, i8** %addr, align 8
  %size_ptr = getelementptr inbounds i8, i8* %entry_ptr, i64 16
  %sizep = bitcast i8* %size_ptr to i64*
  %size_val = load i64, i64* %sizep, align 8
  %oldprot_ptr = bitcast [8 x i8]* %srcbuf to i32*
  %callres = call i32 %imp_vp(i8* %addr_val, i64 %size_val, i32 %fl, i32* %oldprot_ptr)
  br label %vp_loop_cont

vp_loop_cont:
  %idx_next = add i32 %idx, 1
  br label %vp_loop

unknown_proto:
  %fmt_unk_proto = getelementptr inbounds [0 x i8], [0 x i8]* @aUnknownPseudoR_0, i64 0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt_unk_proto)
  br label %ret

ret:
  ret void
}