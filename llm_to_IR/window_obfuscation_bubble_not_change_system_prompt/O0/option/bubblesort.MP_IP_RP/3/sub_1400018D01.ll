; ModuleID = 'sub_1400018D0'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043D0 = external global i8*
@off_1400043E0 = external global i8*
@off_1400043C0 = external global i8*
@aUnknownPseudoR = external global i8
@aDBitPseudoRelo = external global i8
@aUnknownPseudoR_0 = external global i8

declare i32 @sub_1400022D0()
declare void @sub_140002520()
declare void @sub_140001760(i8*)
declare void @sub_1400027B8(i8*, i8*, i32)
declare i32 @sub_1404E27D2()
declare void @sub_140001700(...)

define void @sub_1400018D0(i8* %callback_rdi) {
entry:
  %var48 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %g0 = load i32, i32* @dword_1400070A0, align 4
  %g0_is_zero = icmp eq i32 %g0, 0
  br i1 %g0_is_zero, label %init, label %ret

ret:
  ret void

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %call_sz = call i32 @sub_1400022D0()
  %sz64 = sext i32 %call_sz to i64
  %mul5 = mul nsw i64 %sz64, 5
  %shl8 = shl i64 %mul5, 3
  %add15 = add i64 %shl8, 15
  %size_aligned = and i64 %add15, -16
  call void @sub_140002520()
  %endp = load i8*, i8** @off_1400043D0, align 8
  %startp = load i8*, i8** @off_1400043E0, align 8
  %dyn = alloca i8, i64 %size_aligned, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %dyn, i8** @qword_1400070A8, align 8
  %end_int = ptrtoint i8* %endp to i64
  %start_int = ptrtoint i8* %startp to i64
  %delta = sub i64 %end_int, %start_int
  %le7 = icmp sle i64 %delta, 7
  br i1 %le7, label %ret, label %check_more

check_more:
  %gt0B = icmp sgt i64 %delta, 11
  br i1 %gt0B, label %proto_new, label %proto_old_check

; rax > 0xB path (loc_140001AE8 ..)
proto_new:
  %rbx_init = load i8*, i8** @off_1400043E0, align 8
  %end2 = load i8*, i8** @off_1400043D0, align 8
  %base14_new = load i8*, i8** @off_1400043C0, align 8
  br label %new_loop

new_loop:
  %rbx_cur = phi i8* [ %rbx_init, %proto_new ], [ %rbx_next, %after_new_iter ]
  %cmp_end = icmp uge i8* %rbx_cur, %end2
  br i1 %cmp_end, label %goto_A90, label %new_iter

new_iter:
  %d_off = getelementptr i8, i8* %rbx_cur, i64 4
  %d_off_i32p = bitcast i8* %d_off to i32*
  %off2 = load i32, i32* %d_off_i32p, align 4
  %valp_i32p = bitcast i8* %rbx_cur to i32*
  %val0 = load i32, i32* %valp_i32p, align 4
  %rbx_next = getelementptr i8, i8* %rbx_cur, i64 8
  %off2_z = zext i32 %off2 to i64
  %addr = getelementptr i8, i8* %base14_new, i64 %off2_z
  %addr_i32p = bitcast i8* %addr to i32*
  %mem32 = load i32, i32* %addr_i32p, align 4
  %sum32 = add i32 %val0, %mem32
  %sum64 = zext i32 %sum32 to i64
  store i64 %sum64, i64* %var48, align 8
  call void @sub_140001760(i8* %addr)
  %var48_i8 = bitcast i64* %var48 to i8*
  call void @sub_1400027B8(i8* %addr, i8* %var48_i8, i32 4)
  br label %after_new_iter

after_new_iter:
  br label %new_loop

; 7 < rax <= 0xB path start (check protocol header)
proto_old_check:
  %hdr0p = bitcast i8* %startp to i32*
  %hdr0 = load i32, i32* %hdr0p, align 4
  %hdr0_nz = icmp ne i32 %hdr0, 0
  br i1 %hdr0_nz, label %loc_140001AFD, label %hdr1

hdr1:
  %hdr1p_i8 = getelementptr i8, i8* %startp, i64 4
  %hdr1p = bitcast i8* %hdr1p_i8 to i32*
  %hdr1v = load i32, i32* %hdr1p, align 4
  %hdr1_nz = icmp ne i32 %hdr1v, 0
  br i1 %hdr1_nz, label %loc_140001AFD, label %hdr2

hdr2:
  %hdr2p_i8 = getelementptr i8, i8* %startp, i64 8
  %hdr2p = bitcast i8* %hdr2p_i8 to i32*
  %hdr2v = load i32, i32* %hdr2p, align 4
  %hdr2_is1 = icmp eq i32 %hdr2v, 1
  br i1 %hdr2_is1, label %proto1_setup, label %unknown_proto

; protocol 1 setup and loop
proto1_setup:
  %rbx_after = getelementptr i8, i8* %startp, i64 12
  %base14 = load i8*, i8** @off_1400043C0, align 8
  %r12ptr = bitcast i64* %var48 to i8*
  br label %old_loop_head

old_loop_head:
  %rbx_phi = phi i8* [ %rbx_after, %proto1_setup ], [ %rbx_next_64, %after_process_entry64 ], [ %rbx_next_32, %after_process_entry32 ], [ %rbx_next_16, %after_process_entry16 ], [ %rbx_next_8, %after_process_entry8 ]
  %cmp_end_old = icmp ult i8* %rbx_phi, %endp
  br i1 %cmp_end_old, label %process_entry, label %goto_A90

process_entry:
  %f0p = bitcast i8* %rbx_phi to i32*
  %f0 = load i32, i32* %f0p, align 4
  %f1pi8 = getelementptr i8, i8* %rbx_phi, i64 4
  %f1p = bitcast i8* %f1pi8 to i32*
  %f1 = load i32, i32* %f1p, align 4
  %f2pi8 = getelementptr i8, i8* %rbx_phi, i64 8
  %f2p = bitcast i8* %f2pi8 to i32*
  %f2 = load i32, i32* %f2p, align 4
  %r8off = zext i32 %f0 to i64
  %r8ptr = getelementptr i8, i8* %base14, i64 %r8off
  %r9loadp = bitcast i8* %r8ptr to i64*
  %r9val = load i64, i64* %r9loadp, align 8
  %r15off = zext i32 %f1 to i64
  %r15ptr = getelementptr i8, i8* %base14, i64 %r15off
  %edx = and i32 %f2, 255
  %is32 = icmp eq i32 %edx, 32
  br i1 %is32, label %handle32, label %check_le32

check_le32:
  %le32 = icmp ule i32 %edx, 32
  br i1 %le32, label %check8or16, label %check64

check8or16:
  %is8 = icmp eq i32 %edx, 8
  br i1 %is8, label %handle8, label %check16

check16:
  %is16 = icmp eq i32 %edx, 16
  br i1 %is16, label %handle16, label %unknown_bitsize

check64:
  %is64 = icmp eq i32 %edx, 64
  br i1 %is64, label %handle64, label %unknown_bitsize

unknown_bitsize:
  %fmt_unk = bitcast i8* @aUnknownPseudoR to i8*
  store i64 0, i64* %var48, align 8
  call void (...) @sub_140001700(i8* %fmt_unk)
  br label %goto_A90

; 64-bit handler
handle64:
  %q64p = bitcast i8* %r15ptr to i64*
  %val64 = load i64, i64* %q64p, align 8
  %r8addr = ptrtoint i8* %r8ptr to i64
  %sub64 = sub i64 %val64, %r8addr
  %sum64_2 = add i64 %sub64, %r9val
  %maskC0 = and i32 %f2, 192
  store i64 %sum64_2, i64* %var48, align 8
  %maskNZ = icmp ne i32 %maskC0, 0
  br i1 %maskNZ, label %cont64, label %check64sign

check64sign:
  %nonneg = icmp sge i64 %sum64_2, 0
  br i1 %nonneg, label %range_error64, label %cont64

cont64:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 8)
  %rbx_next_64 = getelementptr i8, i8* %rbx_phi, i64 12
  br label %after_process_entry64

after_process_entry64:
  br label %old_loop_head

; 32-bit handler
handle32:
  %p32 = bitcast i8* %r15ptr to i32*
  %val32 = load i32, i32* %p32, align 4
  %val32_sext = sext i32 %val32 to i64
  %r8addr32 = ptrtoint i8* %r8ptr to i64
  %sub32 = sub i64 %val32_sext, %r8addr32
  %sum32_2 = add i64 %sub32, %r9val
  %maskC0_32 = and i32 %f2, 192
  store i64 %sum32_2, i64* %var48, align 8
  %maskNZ32 = icmp ne i32 %maskC0_32, 0
  br i1 %maskNZ32, label %cont32, label %check32range

check32range:
  %gt_upper = icmp sgt i64 %sum32_2, 4294967295
  %lt_lower = icmp slt i64 %sum32_2, -2147483648
  %oor32 = or i1 %gt_upper, %lt_lower
  br i1 %oor32, label %range_error32, label %cont32

cont32:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 4)
  %rbx_next_32 = getelementptr i8, i8* %rbx_phi, i64 12
  br label %after_process_entry32

after_process_entry32:
  br label %old_loop_head

; 16-bit handler
handle16:
  %p16 = bitcast i8* %r15ptr to i16*
  %val16 = load i16, i16* %p16, align 2
  %val16_sext = sext i16 %val16 to i64
  %r8addr16 = ptrtoint i8* %r8ptr to i64
  %sub16 = sub i64 %val16_sext, %r8addr16
  %sum16_2 = add i64 %sub16, %r9val
  %maskC0_16 = and i32 %f2, 192
  store i64 %sum16_2, i64* %var48, align 8
  %maskNZ16 = icmp ne i32 %maskC0_16, 0
  br i1 %maskNZ16, label %cont16, label %check16range

check16range:
  %gtFFFF = icmp sgt i64 %sum16_2, 65535
  %ltMin = icmp slt i64 %sum16_2, -32768
  %oor16 = or i1 %gtFFFF, %ltMin
  br i1 %oor16, label %range_error16, label %cont16

cont16:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 2)
  %rbx_next_16 = getelementptr i8, i8* %rbx_phi, i64 12
  br label %after_process_entry16

after_process_entry16:
  br label %old_loop_head

; 8-bit handler
handle8:
  %p8 = bitcast i8* %r15ptr to i8*
  %val8 = load i8, i8* %p8, align 1
  %val8_sext = sext i8 %val8 to i64
  %r8addr8 = ptrtoint i8* %r8ptr to i64
  %sub8 = sub i64 %val8_sext, %r8addr8
  %sum8_2 = add i64 %sub8, %r9val
  %maskC0_8 = and i32 %f2, 192
  store i64 %sum8_2, i64* %var48, align 8
  %maskNZ8 = icmp ne i32 %maskC0_8, 0
  br i1 %maskNZ8, label %cont8, label %check8range

check8range:
  %gtFF = icmp sgt i64 %sum8_2, 255
  %ltMin8 = icmp slt i64 %sum8_2, -128
  %oor8 = or i1 %gtFF, %ltMin8
  br i1 %oor8, label %range_error8, label %cont8

cont8:
  call void @sub_140001760(i8* %r15ptr)
  call void @sub_1400027B8(i8* %r15ptr, i8* %r12ptr, i32 1)
  %rbx_next_8 = getelementptr i8, i8* %rbx_phi, i64 12
  br label %after_process_entry8

after_process_entry8:
  br label %old_loop_head

; range error handlers
range_error64:
  store i64 %sum64_2, i64* %var60, align 8
  %fmt_range64 = bitcast i8* @aDBitPseudoRelo to i8*
  call void (...) @sub_140001700(i8* %fmt_range64)
  br label %ret

range_error32:
  store i64 %sum32_2, i64* %var60, align 8
  %fmt_range32 = bitcast i8* @aDBitPseudoRelo to i8*
  call void (...) @sub_140001700(i8* %fmt_range32)
  br label %ret

range_error16:
  store i64 %sum16_2, i64* %var60, align 8
  %fmt_range16 = bitcast i8* @aDBitPseudoRelo to i8*
  call void (...) @sub_140001700(i8* %fmt_range16)
  br label %ret

range_error8:
  store i64 %sum8_2, i64* %var60, align 8
  %fmt_range8 = bitcast i8* @aDBitPseudoRelo to i8*
  call void (...) @sub_140001700(i8* %fmt_range8)
  br label %ret

; path where header nonzero (loc_140001AFD)
loc_140001AFD:
  br label %goto_A90

; unknown protocol version (loc_140001C53)
unknown_proto:
  %fmt_proto = bitcast i8* @aUnknownPseudoR_0 to i8*
  call void (...) @sub_140001700(i8* %fmt_proto)
  br label %ret

; finalization (loc_140001A90)
goto_A90:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %gt0 = icmp sgt i32 %cnt, 0
  br i1 %gt0, label %do_callbacks, label %ret

do_callbacks:
  %res = call i32 @sub_1404E27D2()
  %neg = icmp slt i32 %res, 0
  br i1 %neg, label %ret, label %ret
}