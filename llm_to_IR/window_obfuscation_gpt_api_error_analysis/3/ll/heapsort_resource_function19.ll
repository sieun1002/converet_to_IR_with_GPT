; Target: Windows x86_64 (MinGW/PE)
target triple = "x86_64-w64-windows-gnu"

; Externals and runtime support
declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare i8* @memcpy(i8*, i8*, i64)
declare void @sub_140001AD0(i8*, ...)

@__imp_VirtualProtect = external dllimport global i8*

; Pseudo-reloc tables and state (provided by the runtime/loader)
@off_1400043A0 = external global i8*          ; image base
@off_1400043B0 = external global i8*          ; table end
@off_1400043C0 = external global i8*          ; table begin

; Diagnostics strings (extern – sizes/contents defined elsewhere)
@aUnknownPseudoR     = external global i8
@aDBitPseudoRelo     = external global i8
@aUnknownPseudoR_0   = external global i8

; Module globals
@dword_1400070A0 = external global i32        ; reentrancy flag
@dword_1400070A4 = external global i32        ; count of VP entries
@qword_1400070A8 = external global i8*        ; base of VP entries buffer

define void @sub_140001CA0() local_unnamed_addr nounwind {
entry:
  %flag0 = load i32, i32* @dword_1400070A0, align 4
  %flag0_is_zero = icmp eq i32 %flag0, 0
  br i1 %flag0_is_zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %n32 = call i32 @sub_140002690()
  %n64 = sext i32 %n32 to i64
  %mul5 = mul i64 %n64, 5
  %bytes0 = mul i64 %mul5, 8
  %bytes1 = add i64 %bytes0, 15
  %bytes_aligned = and i64 %bytes1, -16
  %dyn_sz = call i64 @sub_1400028E0()
  %vpbuf = alloca i8, i64 %dyn_sz, align 16
  store i32 0, i32* @dword_1400070A4, align 4
  %srcval = alloca i64, align 8
  %oldprot = alloca i32, align 4
  %vpbuf_cast = bitcast i8* %vpbuf to i8*
  store i8* %vpbuf_cast, i8** @qword_1400070A8, align 8
  %end_ptr = load i8*, i8** @off_1400043B0, align 8
  %beg_ptr = load i8*, i8** @off_1400043C0, align 8
  %end_int = ptrtoint i8* %end_ptr to i64
  %beg_int = ptrtoint i8* %beg_ptr to i64
  %diff = sub i64 %end_int, %beg_int
  %le7 = icmp sle i64 %diff, 7
  br i1 %le7, label %finalize, label %sizecheck

sizecheck:
  %gt11 = icmp sgt i64 %diff, 11
  br i1 %gt11, label %maybe_v1_header_scan, label %v2_header_check

; Check for v2 header at table start: {0,0,version=1}
v2_header_check:
  %h0_ptr = bitcast i8* %beg_ptr to i32*
  %h0 = load i32, i32* %h0_ptr, align 4
  %h0_nz = icmp ne i32 %h0, 0
  br i1 %h0_nz, label %v1_entries, label %v2_h1

v2_h1:
  %h1_ptr_ip = getelementptr i8, i8* %beg_ptr, i64 4
  %h1_ptr = bitcast i8* %h1_ptr_ip to i32*
  %h1 = load i32, i32* %h1_ptr, align 4
  %h1_nz = icmp ne i32 %h1, 0
  br i1 %h1_nz, label %v1_entries, label %v2_hver

v2_hver:
  %h2_ptr_ip = getelementptr i8, i8* %beg_ptr, i64 8
  %h2_ptr = bitcast i8* %h2_ptr_ip to i32*
  %h2 = load i32, i32* %h2_ptr, align 4
  %is_ver1 = icmp eq i32 %h2, 1
  br i1 %is_ver1, label %v2_start, label %unknown_protocol

; If not clearly v2, scan for v2 header or fall back to v1 entries
maybe_v1_header_scan:
  br label %v1_scan_loop

v1_scan_loop:
  %scan_cur = phi i8* [ %beg_ptr, %maybe_v1_header_scan ], [ %scan_next, %v1_scan_step ]
  %scan_ge_end = icmp uge i8* %scan_cur, %end_ptr
  br i1 %scan_ge_end, label %finalize, label %v1_scan_step

v1_scan_step:
  %s_h0p = bitcast i8* %scan_cur to i32*
  %s_h0 = load i32, i32* %s_h0p, align 4
  %s_h1p_ip = getelementptr i8, i8* %scan_cur, i64 4
  %s_h1p = bitcast i8* %s_h1p_ip to i32*
  %s_h1 = load i32, i32* %s_h1p, align 4
  %both_zero = and i1 (icmp eq i32 %s_h0, 0), (icmp eq i32 %s_h1, 0)
  br i1 %both_zero, label %v1_scan_check_ver, label %v1_entries_from_scan

v1_scan_check_ver:
  %s_h2p_ip = getelementptr i8, i8* %scan_cur, i64 8
  %s_h2p = bitcast i8* %s_h2p_ip to i32*
  %s_h2 = load i32, i32* %s_h2p, align 4
  %s_is0 = icmp eq i32 %s_h2, 0
  %s_is1 = icmp eq i32 %s_h2, 1
  %scan_next = getelementptr i8, i8* %scan_cur, i64 12
  br i1 %s_is1, label %v2_start_from_scan, label %v1_scan_zero_or_unknown

v1_scan_zero_or_unknown:
  br i1 %s_is0, label %v1_scan_loop, label %unknown_protocol

v2_start_from_scan:
  br label %v2_start

v1_entries_from_scan:
  br label %v1_entries

; v1 entries processing (8-byte entries)
v1_entries:
  %base_img_v1 = load i8*, i8** @off_1400043A0, align 8
  br label %v1_loop

v1_loop:
  %v1_cur = phi i8* [ %beg_ptr, %v1_entries ], [ %v1_next, %v1_body ]
  %v1_ge_end = icmp uge i8* %v1_cur, %end_ptr
  br i1 %v1_ge_end, label %finalize, label %v1_body

v1_body:
  %addend_p = bitcast i8* %v1_cur to i32*
  %addend = load i32, i32* %addend_p, align 4
  %off_p_ip = getelementptr i8, i8* %v1_cur, i64 4
  %off_p = bitcast i8* %off_p_ip to i32*
  %off = load i32, i32* %off_p, align 4
  %v1_next = getelementptr i8, i8* %v1_cur, i64 8
  %off_zext = zext i32 %off to i64
  %dst_ptr = getelementptr i8, i8* %base_img_v1, i64 %off_zext
  %dst_i32p = bitcast i8* %dst_ptr to i32*
  %dst_val = load i32, i32* %dst_i32p, align 4
  %dst_val_64 = sext i32 %dst_val to i64
  %addend_64 = sext i32 %addend to i64
  %sum64 = add i64 %dst_val_64, %addend_64
  %sum32 = trunc i64 %sum64 to i32
  %sum64_st = sext i32 %sum32 to i64
  store i64 %sum64_st, i64* %srcval, align 8
  call void @sub_140001B30(i8* %dst_ptr)
  %srcval_i8p = bitcast i64* %srcval to i8*
  %dst_i8p = bitcast i8* %dst_ptr to i8*
  %cpy_v1 = call i8* @memcpy(i8* %dst_i8p, i8* %srcval_i8p, i64 4)
  br label %v1_loop

; v2 entries processing (12-byte entries)
v2_start:
  %base_img_v2 = load i8*, i8** @off_1400043A0, align 8
  %v2_beg = phi i8* [ %beg_ptr, %v2_start ], [ %scan_next, %v2_start_from_scan ]
  %rbx_init = getelementptr i8, i8* %v2_beg, i64 12
  br label %v2_loop

v2_loop:
  %cur2 = phi i8* [ %rbx_init, %v2_start ], [ %next2, %v2_after ]
  %cont2 = icmp ult i8* %cur2, %end_ptr
  br i1 %cont2, label %v2_body, label %finalize

v2_body:
  %off_from_p = bitcast i8* %cur2 to i32*
  %off_from = load i32, i32* %off_from_p, align 4
  %off_to_p_ip = getelementptr i8, i8* %cur2, i64 4
  %off_to_p = bitcast i8* %off_to_p_ip to i32*
  %off_to = load i32, i32* %off_to_p, align 4
  %flags_p_ip = getelementptr i8, i8* %cur2, i64 8
  %flags_p = bitcast i8* %flags_p_ip to i32*
  %flags = load i32, i32* %flags_p, align 4
  %off_from_z = zext i32 %off_from to i64
  %from_ptr = getelementptr i8, i8* %base_img_v2, i64 %off_from_z
  %off_to_z = zext i32 %off_to to i64
  %to_ptr = getelementptr i8, i8* %base_img_v2, i64 %off_to_z
  %from64p = bitcast i8* %from_ptr to i64*
  %from_val64 = load i64, i64* %from64p, align 8
  %flags_u8 = trunc i32 %flags to i8
  %flags_u64 = zext i8 %flags_u8 to i64
  %bitmask = and i32 %flags, 192
  %next2 = getelementptr i8, i8* %cur2, i64 12
  %case8 = icmp eq i8 %flags_u8, 8
  br i1 %case8, label %v2_case8, label %v2_casenext1

v2_casenext1:
  %case16 = icmp eq i8 %flags_u8, 16
  br i1 %case16, label %v2_case16, label %v2_casenext2

v2_casenext2:
  %case32 = icmp eq i8 %flags_u8, 32
  br i1 %case32, label %v2_case32, label %v2_casenext3

v2_casenext3:
  %case64 = icmp eq i8 %flags_u8, 64
  br i1 %case64, label %v2_case64, label %v2_unknown_bitsize

; 8-bit
v2_case8:
  %to8p = bitcast i8* %to_ptr to i8*
  %val8 = load i8, i8* %to8p, align 1
  %val8_sext = sext i8 %val8 to i64
  %from_ptr_int = ptrtoint i8* %from_ptr to i64
  %delta8 = sub i64 %val8_sext, %from_ptr_int
  %new8 = add i64 %delta8, %from_val64
  store i64 %new8, i64* %srcval, align 8
  %need_range8 = icmp eq i32 %bitmask, 0
  br i1 %need_range8, label %v2_case8_range, label %v2_case8_apply

v2_case8_range:
  %too_big8 = icmp sgt i64 %new8, 255
  %too_small8 = icmp slt i64 %new8, -128
  %bad8 = or i1 %too_big8, %too_small8
  br i1 %bad8, label %v2_error_range, label %v2_case8_apply

v2_case8_apply:
  call void @sub_140001B30(i8* %to_ptr)
  %src_i8p_8 = bitcast i64* %srcval to i8*
  %cpy8 = call i8* @memcpy(i8* %to8p, i8* %src_i8p_8, i64 1)
  br label %v2_after

; 16-bit
v2_case16:
  %to16p = bitcast i8* %to_ptr to i16*
  %val16 = load i16, i16* %to16p, align 2
  %val16_sext = sext i16 %val16 to i64
  %from_ptr_int16 = ptrtoint i8* %from_ptr to i64
  %delta16 = sub i64 %val16_sext, %from_ptr_int16
  %new16 = add i64 %delta16, %from_val64
  store i64 %new16, i64* %srcval, align 8
  %need_range16 = icmp eq i32 %bitmask, 0
  br i1 %need_range16, label %v2_case16_range, label %v2_case16_apply

v2_case16_range:
  %too_big16 = icmp sgt i64 %new16, 65535
  %too_small16 = icmp slt i64 %new16, -32768
  %bad16 = or i1 %too_big16, %too_small16
  br i1 %bad16, label %v2_error_range, label %v2_case16_apply

v2_case16_apply:
  call void @sub_140001B30(i8* %to_ptr)
  %src_i8p_16 = bitcast i64* %srcval to i8*
  %dst_i8p_16 = bitcast i16* %to16p to i8*
  %cpy16 = call i8* @memcpy(i8* %dst_i8p_16, i8* %src_i8p_16, i64 2)
  br label %v2_after

; 32-bit
v2_case32:
  %to32p = bitcast i8* %to_ptr to i32*
  %val32 = load i32, i32* %to32p, align 4
  %val32_sext = sext i32 %val32 to i64
  %from_ptr_int32 = ptrtoint i8* %from_ptr to i64
  %delta32 = sub i64 %val32_sext, %from_ptr_int32
  %new32 = add i64 %delta32, %from_val64
  store i64 %new32, i64* %srcval, align 8
  %need_range32 = icmp eq i32 %bitmask, 0
  br i1 %need_range32, label %v2_case32_range, label %v2_case32_apply

v2_case32_range:
  %too_big32 = icmp ugt i64 %new32, 4294967295
  %min32 = add i64 0, -2147483648
  %too_small32 = icmp slt i64 %new32, %min32
  %bad32 = or i1 %too_big32, %too_small32
  br i1 %bad32, label %v2_error_range, label %v2_case32_apply

v2_case32_apply:
  call void @sub_140001B30(i8* %to_ptr)
  %src_i8p_32 = bitcast i64* %srcval to i8*
  %dst_i8p_32 = bitcast i32* %to32p to i8*
  %cpy32 = call i8* @memcpy(i8* %dst_i8p_32, i8* %src_i8p_32, i64 4)
  br label %v2_after

; 64-bit
v2_case64:
  %to64p = bitcast i8* %to_ptr to i64*
  %val64 = load i64, i64* %to64p, align 8
  %from_ptr_int64 = ptrtoint i8* %from_ptr to i64
  %delta64 = sub i64 %val64, %from_ptr_int64
  %new64 = add i64 %delta64, %from_val64
  store i64 %new64, i64* %srcval, align 8
  %need_check64 = icmp eq i32 %bitmask, 0
  br i1 %need_check64, label %v2_case64_check, label %v2_case64_apply

v2_case64_check:
  %nonneg64 = icmp sge i64 %new64, 0
  br i1 %nonneg64, label %v2_error_range, label %v2_case64_apply

v2_case64_apply:
  call void @sub_140001B30(i8* %to_ptr)
  %src_i8p_64 = bitcast i64* %srcval to i8*
  %dst_i8p_64 = bitcast i64* %to64p to i8*
  %cpy64 = call i8* @memcpy(i8* %dst_i8p_64, i8* %src_i8p_64, i64 8)
  br label %v2_after

v2_unknown_bitsize:
  %unkfmt_ptr = getelementptr i8, i8* @aUnknownPseudoR, i64 0
  store i64 0, i64* %srcval, align 8
  call void (i8*, ...) @sub_140001AD0(i8* %unkfmt_ptr)
  br label %v2_error_range

v2_error_range:
  %rangefmt_ptr = getelementptr i8, i8* @aDBitPseudoRelo, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %rangefmt_ptr)
  br label %v2_after

v2_after:
  br label %v2_loop

unknown_protocol:
  %proto_ptr = getelementptr i8, i8* @aUnknownPseudoR_0, i64 0
  call void (i8*, ...) @sub_140001AD0(i8* %proto_ptr)
  br label %finalize

; Finalization: apply recorded VirtualProtect changes
finalize:
  %cnt = load i32, i32* @dword_1400070A4, align 4
  %has_cnt = icmp sgt i32 %cnt, 0
  br i1 %has_cnt, label %vp_loop_entry, label %ret

vp_loop_entry:
  %imp_raw = load i8*, i8** @__imp_VirtualProtect, align 8
  %fnty = bitcast i8* %imp_raw to i1 (i8*, i64, i32, i32*)*
  %base_list = load i8*, i8** @qword_1400070A8, align 8
  %idx0 = add i32 0, 0
  %off0 = zext i32 %idx0 to i64
  br label %vp_loop

vp_loop:
  %i = phi i32 [ 0, %vp_loop_entry ], [ %i_next, %vp_loop_step ]
  %ofs = phi i64 [ 0, %vp_loop_entry ], [ %ofs_next, %vp_loop_step ]
  %cnt_cur = load i32, i32* @dword_1400070A4, align 4
  %cmp_i = icmp slt i32 %i, %cnt_cur
  br i1 %cmp_i, label %vp_iter, label %ret

vp_iter:
  %entry_ptr = getelementptr i8, i8* %base_list, i64 %ofs
  %flnp_p = bitcast i8* %entry_ptr to i32*
  %flnp = load i32, i32* %flnp_p, align 4
  %nzfl = icmp ne i32 %flnp, 0
  br i1 %nzfl, label %vp_do, label %vp_loop_step

vp_do:
  %addr_p_ip = getelementptr i8, i8* %entry_ptr, i64 8
  %addr_p = bitcast i8* %addr_p_ip to i8**
  %addr = load i8*, i8** %addr_p, align 8
  %size_p_ip = getelementptr i8, i8* %entry_ptr, i64 16
  %size_p = bitcast i8* %size_p_ip to i64*
  %size = load i64, i64* %size_p, align 8
  %call_vp = call i1 %fnty(i8* %addr, i64 %size, i32 %flnp, i32* %oldprot)
  br label %vp_loop_step

vp_loop_step:
  %i_next = add i32 %i, 1
  %ofs_add = add i64 0, 40
  %ofs_next = add i64 %ofs, %ofs_add
  br label %vp_loop

ret:
  ret void
}