; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i32 @sub_1400022D0()
declare i64 @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i64)
declare void @sub_14049615F()
declare void @sub_140001700(i8*)

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

define void @sub_1400018D0() local_unnamed_addr {
entry:
  %var50 = alloca i64, align 8
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %cmp0 = icmp eq i32 %g0, 0
  br i1 %cmp0, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %c1 = call i32 @sub_1400022D0()
  %c1sext = sext i32 %c1 to i64
  %mul5 = mul i64 %c1sext, 5
  %mul8 = mul i64 %mul5, 8
  %add15 = add i64 %mul8, 15
  %align16 = and i64 %add15, -16
  %stkneed = call i64 @sub_140002520()
  %_ignored_stack = alloca i8, i64 %stkneed, align 16
  %rdi_ptr = load i8*, i8** @off_1400043D0, align 8
  %rbx_ptr = load i8*, i8** @off_1400043E0, align 8
  store i32 0, i32* @dword_1400070A4, align 4
  %var50_i8 = bitcast i64* %var50 to i8*
  store i8* %var50_i8, i8** @qword_1400070A8, align 8
  %rdi_int = ptrtoint i8* %rdi_ptr to i64
  %rbx_int = ptrtoint i8* %rbx_ptr to i64
  %diff = sub i64 %rdi_int, %rbx_int
  %cmp_le7 = icmp sle i64 %diff, 7
  br i1 %cmp_le7, label %final_check, label %check_len_gt_b

check_len_gt_b:
  %cmp_gt_b = icmp sgt i64 %diff, 11
  br i1 %cmp_gt_b, label %len_gt_b_scan, label %v2_header_check

len_gt_b_scan:
  br label %scan_loop

scan_loop:
  %scan_cur = phi i8* [ %rbx_ptr, %len_gt_b_scan ], [ %scan_next, %scan_cont ]
  %cond_end = icmp uge i8* %scan_cur, %rdi_ptr
  br i1 %cond_end, label %ret, label %scan_body

scan_body:
  %f0_ptr = bitcast i8* %scan_cur to i32*
  %f0 = load i32, i32* %f0_ptr, align 4
  %f1_ptr = getelementptr inbounds i8, i8* %scan_cur, i64 4
  %f1p = bitcast i8* %f1_ptr to i32*
  %f1 = load i32, i32* %f1p, align 4
  %f0_is0 = icmp eq i32 %f0, 0
  %f1_is0 = icmp eq i32 %f1, 0
  %both_zero = and i1 %f0_is0, %f1_is0
  br i1 %both_zero, label %scan_chk_third, label %v1_start_from_scan

scan_chk_third:
  %f2_ptr = getelementptr inbounds i8, i8* %scan_cur, i64 8
  %f2p = bitcast i8* %f2_ptr to i32*
  %f2 = load i32, i32* %f2p, align 4
  %f2_nz = icmp ne i32 %f2, 0
  br i1 %f2_nz, label %v2_from_scan_chk, label %scan_cont

v2_from_scan_chk:
  %is_v2 = icmp eq i32 %f2, 1
  br i1 %is_v2, label %v2_prep_from_scan, label %unknown_proto

scan_cont:
  %scan_next = getelementptr inbounds i8, i8* %scan_cur, i64 12
  br label %scan_loop

v2_prep_from_scan:
  %rbx_after_hdr = getelementptr inbounds i8, i8* %scan_cur, i64 12
  br label %v2_setup

v1_start_from_scan:
  br label %v1_setup

v2_header_check:
  %h0p = bitcast i8* %rbx_ptr to i32*
  %h0 = load i32, i32* %h0p, align 4
  %h0_is0 = icmp eq i32 %h0, 0
  br i1 %h0_is0, label %v2_hdr_h1, label %v1_setup

v2_hdr_h1:
  %h1_ptr = getelementptr inbounds i8, i8* %rbx_ptr, i64 4
  %h1p = bitcast i8* %h1_ptr to i32*
  %h1 = load i32, i32* %h1p, align 4
  %h1_is0 = icmp eq i32 %h1, 0
  br i1 %h1_is0, label %v2_hdr_h2, label %v1_setup

v2_hdr_h2:
  %h2_ptr = getelementptr inbounds i8, i8* %rbx_ptr, i64 8
  %h2p = bitcast i8* %h2_ptr to i32*
  %h2 = load i32, i32* %h2p, align 4
  %is_one = icmp eq i32 %h2, 1
  br i1 %is_one, label %v2_prep, label %unknown_proto

v2_prep:
  %rbx_after = getelementptr inbounds i8, i8* %rbx_ptr, i64 12
  br label %v2_setup

v2_setup:
  %v2_rbx0 = phi i8* [ %rbx_after, %v2_prep ], [ %rbx_after_hdr, %v2_prep_from_scan ]
  %base = load i8*, i8** @off_1400043C0, align 8
  %outbuf = bitcast i64* %var48 to i8*
  br label %v2_loop_header

v2_loop_header:
  %rbx_cur = phi i8* [ %v2_rbx0, %v2_setup ], [ %rbx_next, %v2_loop_continue ]
  %more = icmp ult i8* %rbx_cur, %rdi_ptr
  br i1 %more, label %v2_loop_body, label %final_check

v2_loop_body:
  %e0p = bitcast i8* %rbx_cur to i32*
  %e0 = load i32, i32* %e0p, align 4
  %e1p = getelementptr inbounds i8, i8* %rbx_cur, i64 4
  %e1pi = bitcast i8* %e1p to i32*
  %e1 = load i32, i32* %e1pi, align 4
  %e2p = getelementptr inbounds i8, i8* %rbx_cur, i64 8
  %e2pi = bitcast i8* %e2p to i32*
  %e2 = load i32, i32* %e2pi, align 4
  %off0 = sext i32 %e0 to i64
  %off1 = sext i32 %e1 to i64
  %ptr_r8 = getelementptr inbounds i8, i8* %base, i64 %off0
  %ptr_r15 = getelementptr inbounds i8, i8* %base, i64 %off1
  %refq = bitcast i8* %ptr_r8 to i64*
  %r9 = load i64, i64* %refq, align 8
  %sz8 = trunc i32 %e2 to i8
  %cmp32 = icmp eq i8 %sz8, 32
  br i1 %cmp32, label %v2_case32, label %v2_size_le32

v2_size_le32:
  %le32 = icmp ule i8 %sz8, 32
  br i1 %le32, label %v2_8_or_16, label %v2_chk64

v2_8_or_16:
  %is8 = icmp eq i8 %sz8, 8
  br i1 %is8, label %v2_case8, label %v2_maybe16

v2_maybe16:
  %is16 = icmp eq i8 %sz8, 16
  br i1 %is16, label %v2_case16, label %v2_unknown_bitsize

v2_chk64:
  %is64 = icmp eq i8 %sz8, 64
  br i1 %is64, label %v2_case64, label %v2_unknown_bitsize

v2_case8:
  %val8p = bitcast i8* %ptr_r15 to i8*
  %val8 = load i8, i8* %val8p, align 1
  %sext8 = sext i8 %val8 to i64
  %r8_int = ptrtoint i8* %ptr_r8 to i64
  %tmp8s = sub i64 %sext8, %r8_int
  %new8 = add i64 %tmp8s, %r9
  store i64 %new8, i64* %var48, align 8
  %mask8 = and i32 %e2, 192
  %skipchk8 = icmp ne i32 %mask8, 0
  br i1 %skipchk8, label %v2_write8, label %v2_range8

v2_range8:
  %gt255 = icmp sgt i64 %new8, 255
  %ltm128 = icmp slt i64 %new8, -128
  %oor8 = or i1 %gt255, %ltm128
  br i1 %oor8, label %out_of_range, label %v2_write8

v2_write8:
  call void @sub_140001760(i8* %ptr_r15)
  call void @sub_1400027B8(i8* %ptr_r15, i8* %outbuf, i64 1)
  br label %v2_loop_continue

v2_case16:
  %val16p = bitcast i8* %ptr_r15 to i16*
  %val16 = load i16, i16* %val16p, align 2
  %sext16 = sext i16 %val16 to i64
  %r8_int_16 = ptrtoint i8* %ptr_r8 to i64
  %tmp16s = sub i64 %sext16, %r8_int_16
  %new16 = add i64 %tmp16s, %r9
  store i64 %new16, i64* %var48, align 8
  %mask16 = and i32 %e2, 192
  %skipchk16 = icmp ne i32 %mask16, 0
  br i1 %skipchk16, label %v2_write16, label %v2_range16

v2_range16:
  %gt65535 = icmp sgt i64 %new16, 65535
  %ltm32768 = icmp slt i64 %new16, -32768
  %oor16 = or i1 %gt65535, %ltm32768
  br i1 %oor16, label %out_of_range, label %v2_write16

v2_write16:
  call void @sub_140001760(i8* %ptr_r15)
  call void @sub_1400027B8(i8* %ptr_r15, i8* %outbuf, i64 2)
  br label %v2_loop_continue

v2_case32:
  %val32p = bitcast i8* %ptr_r15 to i32*
  %val32 = load i32, i32* %val32p, align 4
  %sext32 = sext i32 %val32 to i64
  %r8_int_32 = ptrtoint i8* %ptr_r8 to i64
  %tmp32s = sub i64 %sext32, %r8_int_32
  %new32 = add i64 %tmp32s, %r9
  store i64 %new32, i64* %var48, align 8
  %mask32 = and i32 %e2, 192
  %skipchk32 = icmp ne i32 %mask32, 0
  br i1 %skipchk32, label %v2_write32, label %v2_range32

v2_range32:
  %gtmax32 = icmp sgt i64 %new32, 4294967295
  %ltmin32 = icmp slt i64 %new32, -2147483648
  %oor32 = or i1 %gtmax32, %ltmin32
  br i1 %oor32, label %out_of_range, label %v2_write32

v2_write32:
  call void @sub_140001760(i8* %ptr_r15)
  call void @sub_1400027B8(i8* %ptr_r15, i8* %outbuf, i64 4)
  br label %v2_loop_continue

v2_case64:
  %val64p = bitcast i8* %ptr_r15 to i64*
  %val64 = load i64, i64* %val64p, align 8
  %r8_int_64 = ptrtoint i8* %ptr_r8 to i64
  %tmp64s = sub i64 %val64, %r8_int_64
  %new64 = add i64 %tmp64s, %r9
  store i64 %new64, i64* %var48, align 8
  %mask64 = and i32 %e2, 192
  %skipchk64 = icmp ne i32 %mask64, 0
  br i1 %skipchk64, label %v2_write64, label %v2_range64

v2_range64:
  %nonneg = icmp sge i64 %new64, 0
  br i1 %nonneg, label %out_of_range, label %v2_write64

v2_write64:
  call void @sub_140001760(i8* %ptr_r15)
  call void @sub_1400027B8(i8* %ptr_r15, i8* %outbuf, i64 8)
  br label %v2_loop_continue

v2_unknown_bitsize:
  store i64 0, i64* %var48, align 8
  %s_unknown = bitcast i8* getelementptr (i8, i8* @aUnknownPseudoR, i64 0) to i8*
  call void @sub_140001700(i8* %s_unknown)
  br label %final_check

v2_loop_continue:
  %rbx_next = getelementptr inbounds i8, i8* %rbx_cur, i64 12
  br label %v2_loop_header

v1_setup:
  %base_v1 = load i8*, i8** @off_1400043C0, align 8
  %outbuf_v1 = bitcast i64* %var48 to i8*
  br label %v1_loop_header

v1_loop_header:
  %v1_rbx = phi i8* [ %rbx_ptr, %v1_setup ], [ %v1_next, %v1_loop_iter ]
  %cont_v1 = icmp ult i8* %v1_rbx, %rdi_ptr
  br i1 %cont_v1, label %v1_loop_iter, label %final_check

v1_loop_iter:
  %e0v1p = bitcast i8* %v1_rbx to i32*
  %e0v1 = load i32, i32* %e0v1p, align 4
  %e1v1p = getelementptr inbounds i8, i8* %v1_rbx, i64 4
  %e1v1pi = bitcast i8* %e1v1p to i32*
  %e1v1 = load i32, i32* %e1v1pi, align 4
  %v1_next = getelementptr inbounds i8, i8* %v1_rbx, i64 8
  %off1_v1 = sext i32 %e1v1 to i64
  %sumaddr = getelementptr inbounds i8, i8* %base_v1, i64 %off1_v1
  %sum_addr_i8 = bitcast i8* %sumaddr to i8*
  %sum_ptr_i32 = bitcast i8* %sumaddr to i32*
  %sum_load = load i32, i32* %sum_ptr_i32, align 4
  %adde = add i32 %sum_load, %e0v1
  %adde_z = zext i32 %adde to i64
  store i64 %adde_z, i64* %var48, align 8
  call void @sub_140001760(i8* %sum_addr_i8)
  call void @sub_1400027B8(i8* %sum_addr_i8, i8* %outbuf_v1, i64 4)
  br label %v1_loop_header

out_of_range:
  %new_any = phi i64 [ %new8, %v2_range8 ], [ %new16, %v2_range16 ], [ %new32, %v2_range32 ], [ %new64, %v2_range64 ]
  store i64 undef, i64* %var60, align 8
  store i64 %new_any, i64* %var60, align 8
  %s_range = bitcast i8* getelementptr (i8, i8* @aDBitPseudoRelo, i64 0) to i8*
  call void @sub_140001700(i8* %s_range)
  br label %final_check

unknown_proto:
  %s_proto = bitcast i8* getelementptr (i8, i8* @aUnknownPseudoR_0, i64 0) to i8*
  call void @sub_140001700(i8* %s_proto)
  br label %final_check

final_check:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %pos = icmp sgt i32 %cnt, 0
  br i1 %pos, label %call_finalize, label %ret

call_finalize:
  call void @sub_14049615F()
  br label %ret

ret:
  ret void
}