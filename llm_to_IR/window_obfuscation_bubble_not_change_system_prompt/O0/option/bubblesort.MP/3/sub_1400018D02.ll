; ModuleID = 'sub_1400018D0.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043C0 = external global i8*
@qword_140008290 = external global i8*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare void @sub_140001700(i8*, ...)

define dso_local void @sub_1400018D0() local_unnamed_addr {
entry:
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %initflag = load i32, i32* @dword_1400070A0, align 4
  %iszero = icmp eq i32 %initflag, 0
  br i1 %iszero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %cnt32 = call i32 @sub_1400022D0()
  %cnt64 = sext i32 %cnt32 to i64
  %mul5 = mul i64 %cnt64, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %aligned = and i64 %add15, -16
  %allocsz = call i64 @sub_140002520()
  %dynbuf = alloca i8, i64 %allocsz, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %dynbuf, i8** @qword_1400070A8, align 8
  %endp0 = load i8*, i8** @off_1400043D0, align 8
  %startp0 = load i8*, i8** @off_1400043E0, align 8
  %end_i = ptrtoint i8* %endp0 to i64
  %start_i = ptrtoint i8* %startp0 to i64
  %range = sub i64 %end_i, %start_i
  %le7 = icmp sle i64 %range, 7
  br i1 %le7, label %ret, label %range_check_mid

range_check_mid:
  %gt11 = icmp sgt i64 %range, 11
  br i1 %gt11, label %v1_entry_check, label %v2_header_check

v2_header_check:
  %hdr0_ptr = bitcast i8* %startp0 to i32*
  %hdr0 = load i32, i32* %hdr0_ptr, align 1
  %hdr0nz = icmp ne i32 %hdr0, 0
  br i1 %hdr0nz, label %v1_loop_entry, label %v2_hdr_next0

v2_hdr_next0:
  %hdr1_ptr = getelementptr i8, i8* %startp0, i64 4
  %hdr1p = bitcast i8* %hdr1_ptr to i32*
  %hdr1 = load i32, i32* %hdr1p, align 1
  %hdr1nz = icmp ne i32 %hdr1, 0
  br i1 %hdr1nz, label %v1_loop_entry, label %v2_hdr_next1

v2_hdr_next1:
  %hdr2_ptr = getelementptr i8, i8* %startp0, i64 8
  %hdr2p = bitcast i8* %hdr2_ptr to i32*
  %hdr2 = load i32, i32* %hdr2p, align 1
  %isv2 = icmp eq i32 %hdr2, 1
  br i1 %isv2, label %v2_loop_prep, label %unknown_proto

v2_loop_prep:
  %cur0 = getelementptr i8, i8* %startp0, i64 12
  %base0 = load i8*, i8** @off_1400043C0, align 8
  br label %v2_loop_check

v2_loop_check:
  %cur = phi i8* [ %cur0, %v2_loop_prep ], [ %cur_next, %v2_loop_iter_end ]
  %endp = phi i8* [ %endp0, %v2_loop_prep ], [ %endp0, %v2_loop_iter_end ]
  %base_l = phi i8* [ %base0, %v2_loop_prep ], [ %base_l, %v2_loop_iter_end ]
  %lt = icmp ult i8* %cur, %endp
  br i1 %lt, label %v2_entry_load, label %after_v2_loop

v2_entry_load:
  %off_p_p = bitcast i8* %cur to i32*
  %off_p32 = load i32, i32* %off_p_p, align 1
  %off_p64 = zext i32 %off_p32 to i64
  %type_ptr = getelementptr i8, i8* %cur, i64 8
  %type_p32 = bitcast i8* %type_ptr to i32*
  %type32 = load i32, i32* %type_p32, align 1
  %type8 = trunc i32 %type32 to i8
  %off_t_ptr = getelementptr i8, i8* %cur, i64 4
  %off_t_p32 = bitcast i8* %off_t_ptr to i32*
  %off_t32 = load i32, i32* %off_t_p32, align 1
  %off_t64 = zext i32 %off_t32 to i64
  %p_ptr = getelementptr i8, i8* %base_l, i64 %off_p64
  %p64p = bitcast i8* %p_ptr to i64*
  %r9val = load i64, i64* %p64p, align 1
  %t_ptr = getelementptr i8, i8* %base_l, i64 %off_t64
  %type_switch = zext i8 %type8 to i32
  switch i32 %type_switch, label %unknown_bitsize [
    i32 32, label %case32
    i32 64, label %case64
    i32 8,  label %case8
    i32 16, label %case16
  ]

case16:
  %t16p = bitcast i8* %t_ptr to i16*
  %v16 = load i16, i16* %t16p, align 1
  %v16_sext = sext i16 %v16 to i64
  %p_addr16 = ptrtoint i8* %p_ptr to i64
  %tmp16a = sub i64 %v16_sext, %p_addr16
  %new16 = add i64 %tmp16a, %r9val
  %flags16 = and i32 %type32, 192
  %fzero16 = icmp eq i32 %flags16, 0
  br i1 %fzero16, label %range16, label %emit16

range16:
  %gt_ffff = icmp sgt i64 %new16, 65535
  br i1 %gt_ffff, label %range_error, label %range16b

range16b:
  %lt_min16 = icmp slt i64 %new16, -32768
  br i1 %lt_min16, label %range_error, label %emit16

emit16:
  store i64 %new16, i64* %var48, align 8
  call void @sub_140001760(i8* %t_ptr)
  %var48_i8_16 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %t_ptr, i8* %var48_i8_16, i32 2)
  br label %v2_loop_iter_end

case32:
  %t32p = bitcast i8* %t_ptr to i32*
  %v32 = load i32, i32* %t32p, align 1
  %v32_sext = sext i32 %v32 to i64
  %p_addr32 = ptrtoint i8* %p_ptr to i64
  %tmp32a = sub i64 %v32_sext, %p_addr32
  %new32 = add i64 %tmp32a, %r9val
  %flags32 = and i32 %type32, 192
  %fzero32 = icmp eq i32 %flags32, 0
  br i1 %fzero32, label %range32, label %emit32

range32:
  %minus1 = add i32 0, -1
  %minus1_64 = sext i32 %minus1 to i64
  %gt_neg1 = icmp sgt i64 %new32, %minus1_64
  br i1 %gt_neg1, label %range_error, label %range32b

range32b:
  %min32 = add i64 -2147483648, 0
  %lt_min32 = icmp slt i64 %new32, %min32
  br i1 %lt_min32, label %range_error, label %emit32

emit32:
  store i64 %new32, i64* %var48, align 8
  call void @sub_140001760(i8* %t_ptr)
  %var48_i8_32 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %t_ptr, i8* %var48_i8_32, i32 4)
  br label %v2_loop_iter_end

case8:
  %t8p = bitcast i8* %t_ptr to i8*
  %v8 = load i8, i8* %t8p, align 1
  %v8_sext = sext i8 %v8 to i64
  %p_addr8 = ptrtoint i8* %p_ptr to i64
  %tmp8a = sub i64 %v8_sext, %p_addr8
  %new8 = add i64 %tmp8a, %r9val
  %flags8 = and i32 %type32, 192
  %fzero8 = icmp eq i32 %flags8, 0
  br i1 %fzero8, label %range8, label %emit8

range8:
  %gt_ff = icmp sgt i64 %new8, 255
  br i1 %gt_ff, label %range_error, label %range8b

range8b:
  %lt_min8 = icmp slt i64 %new8, -128
  br i1 %lt_min8, label %range_error, label %emit8

emit8:
  store i64 %new8, i64* %var48, align 8
  call void @sub_140001760(i8* %t_ptr)
  %var48_i8_8 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %t_ptr, i8* %var48_i8_8, i32 1)
  br label %v2_loop_iter_end

case64:
  %t64p = bitcast i8* %t_ptr to i64*
  %v64 = load i64, i64* %t64p, align 1
  %p_addr64 = ptrtoint i8* %p_ptr to i64
  %tmp64a = sub i64 %v64, %p_addr64
  %new64 = add i64 %tmp64a, %r9val
  %flags64 = and i32 %type32, 192
  %fzero64 = icmp eq i32 %flags64, 0
  br i1 %fzero64, label %range64, label %emit64

range64:
  %is_nonneg = icmp sge i64 %new64, 0
  br i1 %is_nonneg, label %range_error, label %emit64

emit64:
  store i64 %new64, i64* %var48, align 8
  call void @sub_140001760(i8* %t_ptr)
  %var48_i8_64 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %t_ptr, i8* %var48_i8_64, i32 8)
  br label %v2_loop_iter_end

unknown_bitsize:
  %fmt_unk = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  store i64 0, i64* %var48, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_unk)
  br label %v2_loop_iter_end

range_error:
  store i64 0, i64* %var60, align 8
  %arg0 = load i64, i64* %var48, align 8
  store i64 %arg0, i64* %var60, align 8
  %fmt_range = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  %t_ptr_as_i8 = bitcast i8* %t_ptr to i8*
  %val_for_fmt = load i64, i64* %var60, align 8
  call void (i8*, ...) @sub_140001700(i8* %fmt_range, i64 %val_for_fmt, i8* %t_ptr_as_i8)
  br label %v2_loop_iter_end

v2_loop_iter_end:
  %cur_next = getelementptr i8, i8* %cur, i64 12
  br label %v2_loop_check

after_v2_loop:
  %count = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %count, 0
  br i1 %gt0, label %postproc_prep, label %ret

postproc_prep:
  %cb0 = load i8*, i8** @qword_140008290, align 8
  %esi_init = add i32 %initflag, 0
  br label %postproc_loop

postproc_loop:
  %i = phi i32 [ %esi_init, %postproc_prep ], [ %i1, %postproc_next ]
  %offset = phi i64 [ 0, %postproc_prep ], [ %offset_next, %postproc_next ]
  %base_list = load i8*, i8** @qword_1400070A8, align 8
  %entry_ptr = getelementptr i8, i8* %base_list, i64 %offset
  %entry_i32p = bitcast i8* %entry_ptr to i32*
  %flag = load i32, i32* %entry_i32p, align 1
  %flag_nz = icmp ne i32 %flag, 0
  br i1 %flag_nz, label %do_call, label %skip_call

do_call:
  %rdx_ptr = getelementptr i8, i8* %entry_ptr, i64 16
  %rdx_loadp = bitcast i8* %rdx_ptr to i8**
  %rdx_val = load i8*, i8** %rdx_loadp, align 8
  %rcx_ptr = getelementptr i8, i8* %entry_ptr, i64 8
  %rcx_loadp = bitcast i8* %rcx_ptr to i8**
  %rcx_val = load i8*, i8** %rcx_loadp, align 8
  %fnptr = bitcast i8* %cb0 to void (i8*, i8*, i32, i8*)*
  %r13_arg = bitcast i64* %var48 to i8*
  call void %fnptr(i8* %rcx_val, i8* %rdx_val, i32 %flag, i8* %r13_arg)
  br label %postproc_next

skip_call:
  br label %postproc_next

postproc_next:
  %i1 = add i32 %i, 1
  %offset_next = add i64 %offset, 40
  %curcnt = load i32, i32* @dword_1400070A4, align 4
  %more = icmp slt i32 %i1, %curcnt
  br i1 %more, label %postproc_loop, label %ret

v1_entry_check:
  %hdrA_p = bitcast i8* %startp0 to i32*
  %hdrA = load i32, i32* %hdrA_p, align 1
  %hdrAnz = icmp ne i32 %hdrA, 0
  br i1 %hdrAnz, label %v1_loop_entry, label %v1_hdr_next0

v1_hdr_next0:
  %hdrB_ptr = getelementptr i8, i8* %startp0, i64 4
  %hdrB_p = bitcast i8* %hdrB_ptr to i32*
  %hdrB = load i32, i32* %hdrB_p, align 1
  %hdrBnz = icmp ne i32 %hdrB, 0
  br i1 %hdrBnz, label %v1_loop_entry, label %v1_hdr_next1

v1_hdr_next1:
  %hdrC_ptr = getelementptr i8, i8* %startp0, i64 8
  %hdrC_p = bitcast i8* %hdrC_ptr to i32*
  %hdrC = load i32, i32* %hdrC_p, align 1
  %hdrCnz = icmp ne i32 %hdrC, 0
  br i1 %hdrCnz, label %v2_header_check, label %v1_skip12

v1_skip12:
  %rbx_next = getelementptr i8, i8* %startp0, i64 12
  br label %v2_header_check

v1_loop_entry:
  %rdi0 = load i8*, i8** @off_1400043D0, align 8
  %rbx0 = load i8*, i8** @off_1400043E0, align 8
  %ge = icmp uge i8* %rbx0, %rdi0
  br i1 %ge, label %ret, label %v1_loop

v1_loop:
  %rbx = phi i8* [ %rbx0, %v1_loop_entry ], [ %rbx_next2, %v1_iter_end ]
  %rdi = phi i8* [ %rdi0, %v1_loop_entry ], [ %rdi0, %v1_iter_end ]
  %base1 = load i8*, i8** @off_1400043C0, align 8
  %var48p = bitcast i64* %var48 to i8*
  %off_t_p2 = getelementptr i8, i8* %rbx, i64 4
  %off_t_p2i32 = bitcast i8* %off_t_p2 to i32*
  %off_t2 = load i32, i32* %off_t_p2i32, align 1
  %off_t2_64 = zext i32 %off_t2 to i64
  %val_p2 = bitcast i8* %rbx to i32*
  %val32_2 = load i32, i32* %val_p2, align 1
  %rbx_next1 = getelementptr i8, i8* %rbx, i64 8
  %ptr_add = getelementptr i8, i8* %base1, i64 %off_t2_64
  %ptr_add_i32p = bitcast i8* %ptr_add to i32*
  %baseval = load i32, i32* %ptr_add_i32p, align 1
  %sum32 = add i32 %val32_2, %baseval
  %sum32_z = zext i32 %sum32 to i64
  store i64 %sum32_z, i64* %var48, align 8
  call void @sub_140001760(i8* %ptr_add)
  call void @sub_1400027B8(i8* %ptr_add, i8* %var48p, i32 4)
  %cont = icmp ult i8* %rbx_next1, %rdi
  br i1 %cont, label %v1_iter_end, label %after_v2_loop

v1_iter_end:
  %rbx_next2 = phi i8* [ %rbx_next1, %v1_loop ]
  br label %v1_loop

unknown_proto:
  %fmt_proto = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  call void (i8*, ...) @sub_140001700(i8* %fmt_proto)
  br label %ret

ret:
  ret void
}