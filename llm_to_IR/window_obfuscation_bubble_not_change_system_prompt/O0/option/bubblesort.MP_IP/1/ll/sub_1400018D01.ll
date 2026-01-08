; ModuleID = 'recovered'
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
declare i64 @sub_140002520(i64)
declare void @sub_140001760(i8*)
declare void @sub_14049615F()
declare void @sub_140001700(i8*, ...)

define void @sub_1400018D0() {
entry:
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %t0 = icmp eq i32 %g0, 0
  br i1 %t0, label %init, label %ret

init:                                             ; preds = %entry
  store i32 1, i32* @dword_1400070A0, align 4
  %v = call i32 @sub_1400022D0()
  %v64 = sext i32 %v to i64
  %mul5 = mul i64 %v64, 5
  %mul40 = mul i64 %mul5, 8
  %add15 = add i64 %mul40, 15
  %mask = and i64 %add15, -16
  %allocsz = call i64 @sub_140002520(i64 %mask)
  %dynbuf = alloca i8, i64 %allocsz, align 16
  %rdi_end_ptr = load i8*, i8** @off_1400043D0, align 8
  %rbx_start_ptr = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %var50 = alloca i8, align 1
  %var50ptr = bitcast i8* %var50 to i8*
  store i8* %var50ptr, i8** @qword_1400070A8, align 8
  %rdi_int = ptrtoint i8* %rdi_end_ptr to i64
  %rbx_int = ptrtoint i8* %rbx_start_ptr to i64
  %diff = sub i64 %rdi_int, %rbx_int
  %cmp_le7 = icmp sle i64 %diff, 7
  br i1 %cmp_le7, label %ret, label %check_range

check_range:                                      ; preds = %init
  %cmp_gt11 = icmp sgt i64 %diff, 11
  br i1 %cmp_gt11, label %path_ae8, label %path_smallhdr

path_smallhdr:                                    ; preds = %c17_inc, %check_range
  %rbx_cur0 = phi i8* [ %rbx_start_ptr, %check_range ], [ %rbx_inc12, %c17_inc ]
  %load_d0 = bitcast i8* %rbx_cur0 to i32*
  %edx0 = load i32, i32* %load_d0, align 4
  %edx0_zero = icmp eq i32 %edx0, 0
  br i1 %edx0_zero, label %smallhdr_chk2, label %path_afd

smallhdr_chk2:                                    ; preds = %path_smallhdr
  %ptr_plus4 = getelementptr i8, i8* %rbx_cur0, i64 4
  %ptr_i32_p4 = bitcast i8* %ptr_plus4 to i32*
  %eax1 = load i32, i32* %ptr_i32_p4, align 4
  %eax1_zero = icmp eq i32 %eax1, 0
  br i1 %eax1_zero, label %smallhdr_chk3, label %path_afd

smallhdr_chk3:                                    ; preds = %smallhdr_chk2
  %ptr_plus8 = getelementptr i8, i8* %rbx_cur0, i64 8
  %ptr_i32_p8 = bitcast i8* %ptr_plus8 to i32*
  %edx2 = load i32, i32* %ptr_i32_p8, align 4
  %cmp_edx2_1 = icmp eq i32 %edx2, 1
  br i1 %cmp_edx2_1, label %smallhdr_ok, label %err_protocol

err_protocol:                                     ; preds = %smallhdr_chk3
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR_0)
  br label %ret

smallhdr_ok:                                      ; preds = %smallhdr_chk3
  %rbx_after_hdr = getelementptr i8, i8* %rbx_cur0, i64 12
  %base_ptr = load i8*, i8** @off_1400043C0, align 8
  %addr_var48 = bitcast i64* %var48 to i8*
  %rbx_after_int = ptrtoint i8* %rbx_after_hdr to i64
  %cmp_jb = icmp ult i64 %rbx_after_int, %rdi_int
  br i1 %cmp_jb, label %loop_small, label %ret

loop_small:                                       ; preds = %after_write_small, %smallhdr_ok, %after_hdr2
  %rbx_cur = phi i8* [ %rbx_after_hdr, %smallhdr_ok ], [ %rbx_next_after, %after_write_small ], [ %rbx_after_hdr2, %after_hdr2 ]
  %base_phi = phi i8* [ %base_ptr, %smallhdr_ok ], [ %base_phi, %after_write_small ], [ %base_ptr2, %after_hdr2 ]
  %off_field_ptr = bitcast i8* %rbx_cur to i32*
  %offset_val = load i32, i32* %off_field_ptr, align 4
  %r15_field_ptr = getelementptr i8, i8* %rbx_cur, i64 4
  %r15_i32p = bitcast i8* %r15_field_ptr to i32*
  %r15_off_val = load i32, i32* %r15_i32p, align 4
  %kind_ptr = getelementptr i8, i8* %rbx_cur, i64 8
  %kind_i32p = bitcast i8* %kind_ptr to i32*
  %ecx_kind = load i32, i32* %kind_i32p, align 4
  %offset_z = zext i32 %offset_val to i64
  %r8ptr = getelementptr i8, i8* %base_phi, i64 %offset_z
  %r9_load_ptr = bitcast i8* %r8ptr to i64*
  %r9_val = load i64, i64* %r9_load_ptr, align 8
  %r15_z = zext i32 %r15_off_val to i64
  %r15ptr = getelementptr i8, i8* %base_phi, i64 %r15_z
  %cl_trunc = trunc i32 %ecx_kind to i8
  %edx_kind = zext i8 %cl_trunc to i32
  %cmp_20 = icmp eq i32 %edx_kind, 32
  %cmp_le_20 = icmp ule i32 %edx_kind, 32
  br i1 %cmp_20, label %case32, label %switch_pre

switch_pre:                                       ; preds = %loop_small
  br i1 %cmp_le_20, label %case_le20, label %check_40

case_le20:                                        ; preds = %switch_pre
  %cmp_8 = icmp eq i32 %edx_kind, 8
  br i1 %cmp_8, label %case8, label %check_10

check_10:                                         ; preds = %case_le20
  %cmp_10 = icmp eq i32 %edx_kind, 16
  br i1 %cmp_10, label %case16, label %error_bitsize

check_40:                                         ; preds = %switch_pre
  %cmp_40 = icmp eq i32 %edx_kind, 64
  br i1 %cmp_40, label %case64, label %error_bitsize

error_bitsize:                                    ; preds = %check_10, %check_40
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* @aUnknownPseudoR)
  br label %ret

case8:                                            ; preds = %case_le20
  %val8p = bitcast i8* %r15ptr to i8*
  %val8 = load i8, i8* %val8p, align 1
  %val8_sext = sext i8 %val8 to i64
  %r8addr = ptrtoint i8* %r8ptr to i64
  %sub8 = sub i64 %val8_sext, %r8addr
  %new8 = add i64 %sub8, %r9_val
  store i64 %new8, i64* %var48, align 8
  %maskC0_8 = and i32 %ecx_kind, 192
  %is_mask_nonzero_8 = icmp ne i32 %maskC0_8, 0
  br i1 %is_mask_nonzero_8, label %write8, label %rangechk8

rangechk8:                                        ; preds = %case8
  %cmp_hi8 = icmp sgt i64 %new8, 255
  %cmp_lo8 = icmp slt i64 %new8, -128
  %out_hi8 = or i1 %cmp_hi8, %cmp_lo8
  br i1 %out_hi8, label %error_out_of_range, label %write8

write8:                                           ; preds = %rangechk8, %case8
  call void @sub_140001760(i8* %r15ptr)
  %trunc8 = trunc i64 %new8 to i8
  store i8 %trunc8, i8* %val8p, align 1
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 12
  br label %after_write_small

case16:                                           ; preds = %check_10
  %val16p = bitcast i8* %r15ptr to i16*
  %val16 = load i16, i16* %val16p, align 2
  %val16_sext = sext i16 %val16 to i64
  %r8addr2 = ptrtoint i8* %r8ptr to i64
  %sub16 = sub i64 %val16_sext, %r8addr2
  %new16 = add i64 %sub16, %r9_val
  store i64 %new16, i64* %var48, align 8
  %maskC0_16 = and i32 %ecx_kind, 192
  %is_mask_nonzero_16 = icmp ne i32 %maskC0_16, 0
  br i1 %is_mask_nonzero_16, label %write16, label %rangechk16

rangechk16:                                       ; preds = %case16
  %cmp_hi16 = icmp sgt i64 %new16, 65535
  %cmp_lo16 = icmp slt i64 %new16, -32768
  %out16 = or i1 %cmp_hi16, %cmp_lo16
  br i1 %out16, label %error_out_of_range, label %write16

write16:                                          ; preds = %rangechk16, %case16
  call void @sub_140001760(i8* %r15ptr)
  %trunc16 = trunc i64 %new16 to i16
  store i16 %trunc16, i16* %val16p, align 2
  %rbx_next2 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %after_write_small

case32:                                           ; preds = %loop_small
  %val32p = bitcast i8* %r15ptr to i32*
  %val32 = load i32, i32* %val32p, align 4
  %val32_sext = sext i32 %val32 to i64
  %r8addr3 = ptrtoint i8* %r8ptr to i64
  %sub32 = sub i64 %val32_sext, %r8addr3
  %new32 = add i64 %sub32, %r9_val
  store i64 %new32, i64* %var48, align 8
  %maskC0_32 = and i32 %ecx_kind, 192
  %is_mask_nonzero_32 = icmp ne i32 %maskC0_32, 0
  br i1 %is_mask_nonzero_32, label %write32, label %rangechk32

rangechk32:                                       ; preds = %case32
  %cmp_hi32 = icmp sgt i64 %new32, 4294967295
  %cmp_lo32 = icmp slt i64 %new32, -2147483648
  %out32 = or i1 %cmp_hi32, %cmp_lo32
  br i1 %out32, label %error_out_of_range, label %write32

write32:                                          ; preds = %rangechk32, %case32
  call void @sub_140001760(i8* %r15ptr)
  %trunc32 = trunc i64 %new32 to i32
  store i32 %trunc32, i32* %val32p, align 4
  %rbx_next3 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %after_write_small

case64:                                           ; preds = %check_40
  %val64p = bitcast i8* %r15ptr to i64*
  %val64 = load i64, i64* %val64p, align 8
  %r8addr4 = ptrtoint i8* %r8ptr to i64
  %sub64 = sub i64 %val64, %r8addr4
  %new64 = add i64 %sub64, %r9_val
  store i64 %new64, i64* %var48, align 8
  %maskC0_64 = and i32 %ecx_kind, 192
  %is_mask_nonzero_64 = icmp ne i32 %maskC0_64, 0
  br i1 %is_mask_nonzero_64, label %write64, label %rangechk64

rangechk64:                                       ; preds = %case64
  %cmp_nonneg64 = icmp sge i64 %new64, 0
  br i1 %cmp_nonneg64, label %error_out_of_range, label %write64

write64:                                          ; preds = %rangechk64, %case64
  call void @sub_140001760(i8* %r15ptr)
  store i64 %new64, i64* %val64p, align 8
  %rbx_next4 = getelementptr i8, i8* %rbx_cur, i64 12
  br label %after_write_small

after_write_small:                                ; preds = %write64, %write32, %write16, %write8
  %rbx_next_after = phi i8* [ %rbx_next, %write8 ], [ %rbx_next2, %write16 ], [ %rbx_next3, %write32 ], [ %rbx_next4, %write64 ]
  %rbx_next_int = ptrtoint i8* %rbx_next_after to i64
  %cmp_jnb = icmp uge i64 %rbx_next_int, %rdi_int
  br i1 %cmp_jnb, label %after_small_loop_end, label %loop_small

after_small_loop_end:                             ; preds = %after_write_small
  br label %epilogue_check

error_out_of_range:                               ; preds = %rangechk64, %rangechk32, %rangechk16, %rangechk8
  %err_val = phi i64 [ %new16, %rangechk16 ], [ %new32, %rangechk32 ], [ %new64, %rangechk64 ], [ %new8, %rangechk8 ]
  store i64 %err_val, i64* %var60, align 8
  call void (i8*, ...) @sub_140001700(i8* @aDBitPseudoRelo, i64 %err_val, i8* %r15ptr)
  br label %ret

path_ae8:                                         ; preds = %check_range
  %rbx_l = phi i8* [ %rbx_start_ptr, %check_range ]
  %p0 = bitcast i8* %rbx_l to i32*
  %r9d0 = load i32, i32* %p0, align 4
  %r9d0_zero = icmp eq i32 %r9d0, 0
  br i1 %r9d0_zero, label %ae8_chk2, label %path_afd

ae8_chk2:                                         ; preds = %path_ae8
  %p4 = getelementptr i8, i8* %rbx_l, i64 4
  %p4i32 = bitcast i8* %p4 to i32*
  %r8d0 = load i32, i32* %p4i32, align 4
  %r8d0_zero = icmp eq i32 %r8d0, 0
  br i1 %r8d0_zero, label %c17_blk, label %path_afd

c17_blk:                                          ; preds = %ae8_chk2
  %p8 = getelementptr i8, i8* %rbx_l, i64 8
  %p8i32 = bitcast i8* %p8 to i32*
  %ecx3 = load i32, i32* %p8i32, align 4
  %test_ecx3 = icmp ne i32 %ecx3, 0
  br i1 %test_ecx3, label %goto_1978, label %c17_inc

c17_inc:                                          ; preds = %c17_blk
  %rbx_inc12 = getelementptr i8, i8* %rbx_l, i64 12
  br label %path_smallhdr

goto_1978:                                        ; preds = %c17_blk
  %edx1978 = load i32, i32* %p8i32, align 4
  %is_one1978 = icmp eq i32 %edx1978, 1
  br i1 %is_one1978, label %after_hdr2, label %err_protocol

after_hdr2:                                       ; preds = %goto_1978
  %rbx_after_hdr2 = getelementptr i8, i8* %rbx_l, i64 12
  %base_ptr2 = load i8*, i8** @off_1400043C0, align 8
  br label %loop_small

path_afd:                                         ; preds = %ae8_chk2, %path_ae8, %smallhdr_chk2, %path_smallhdr
  %rbx_for_afd = phi i8* [ %rbx_cur0, %path_smallhdr ], [ %rbx_cur0, %smallhdr_chk2 ], [ %rbx_l, %path_ae8 ], [ %rbx_l, %ae8_chk2 ]
  %rbx_for_int = ptrtoint i8* %rbx_for_afd to i64
  %cmp_ge = icmp uge i64 %rbx_for_int, %rdi_int
  br i1 %cmp_ge, label %ret, label %loop_afd_entry

loop_afd_entry:                                   ; preds = %path_afd
  %base3 = load i8*, i8** @off_1400043C0, align 8
  br label %loop_afd

loop_afd:                                         ; preds = %after_write_afd, %loop_afd_entry
  %rbx_loop = phi i8* [ %rbx_for_afd, %loop_afd_entry ], [ %rbx_inc8, %after_write_afd ]
  %r12_ptr = getelementptr i8, i8* %rbx_loop, i64 4
  %r12_i32p = bitcast i8* %r12_ptr to i32*
  %r12d = load i32, i32* %r12_i32p, align 4
  %eax0p = bitcast i8* %rbx_loop to i32*
  %eax0 = load i32, i32* %eax0p, align 4
  %rbx_inc8 = getelementptr i8, i8* %rbx_loop, i64 8
  %r12_z = zext i32 %r12d to i64
  %addr_base_plus_r12 = getelementptr i8, i8* %base3, i64 %r12_z
  %addr_base_plus_r12_i32p = bitcast i8* %addr_base_plus_r12 to i32*
  %val_at_addr = load i32, i32* %addr_base_plus_r12_i32p, align 4
  %sum_eax = add i32 %eax0, %val_at_addr
  %var48_i32p = bitcast i64* %var48 to i32*
  store i32 %sum_eax, i32* %var48_i32p, align 4
  call void @sub_140001760(i8* %addr_base_plus_r12)
  store i32 %sum_eax, i32* %addr_base_plus_r12_i32p, align 4
  %rbx_loop_int_next = ptrtoint i8* %rbx_inc8 to i64
  %cmpjb2 = icmp ult i64 %rbx_loop_int_next, %rdi_int
  br i1 %cmpjb2, label %after_write_afd, label %epilogue_check

after_write_afd:                                  ; preds = %loop_afd
  br label %loop_afd

epilogue_check:                                   ; preds = %loop_afd, %after_small_loop_end
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %le = icmp sle i32 %cnt, 0
  br i1 %le, label %ret, label %call_49615F

call_49615F:                                      ; preds = %epilogue_check
  call void @sub_14049615F()
  br label %ret

ret:                                              ; preds = %call_49615F, %epilogue_check, %loop_afd, %error_bitsize, %after_hdr2, %err_protocol, %smallhdr_ok, %path_ae8, %init, %entry
  ret void
}