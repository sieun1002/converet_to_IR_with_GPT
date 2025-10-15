; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

; External functions
declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare void @sub_140001AD0(i8*)
declare i8* @memcpy(i8*, i8*, i64)

; Globals (extern)
@dword_1400070A0 = external global i32
@dword_1400070A4 = external global i32
@qword_1400070A8 = external global i8*
@off_1400043A0 = external global i8*        ; image base
@off_1400043B0 = external global i8*        ; end of table
@off_1400043C0 = external global i8*        ; start of table
@__imp_VirtualProtect = external global i8* ; import thunk

; Message strings (extern pointers)
@aUnknownPseudoR     = external global i8*
@aDBitPseudoRelo     = external global i8*
@aUnknownPseudoR_0   = external global i8*

define void @sub_140001CA0() nounwind {
entry:
  %guard0 = load i32, i32* @dword_1400070A0, align 4
  %guard_is_zero = icmp eq i32 %guard0, 0
  br i1 %guard_is_zero, label %init, label %ret

init:
  store i32 1, i32* @dword_1400070A0, align 4
  %cnt = call i32 @sub_140002690()
  %cnt64 = sext i32 %cnt to i64
  %mul5 = mul nsw i64 %cnt64, 5
  %mul8 = shl i64 %mul5, 3
  %plus15 = add i64 %mul8, 15
  %aligned = and i64 %plus15, -16
  %sz = call i64 @sub_1400028E0()
  %dyn = alloca i8, i64 %sz, align 16

  %srcbuf64 = alloca i64, align 8
  %var60 = alloca i64, align 8
  %oldprot = alloca i32, align 4

  %srcbuf_i8 = bitcast i64* %srcbuf64 to i8*
  store i8* %srcbuf_i8, i8** @qword_1400070A8, align 8
  store i32 0, i32* @dword_1400070A4, align 4

  %endPtr = load i8*, i8** @off_1400043B0, align 8
  %startPtr = load i8*, i8** @off_1400043C0, align 8
  %endInt = ptrtoint i8* %endPtr to i64
  %startInt = ptrtoint i8* %startPtr to i64
  %len = sub i64 %endInt, %startInt
  %has_entries = icmp sgt i64 %len, 7
  br i1 %has_entries, label %check_proto, label %finalize

check_proto:
  %gt11 = icmp sgt i64 %len, 11
  br i1 %gt11, label %inspect_header, label %v2_try

inspect_header:
  %d0p = bitcast i8* %startPtr to i32*
  %d0v = load i32, i32* %d0p, align 4
  %d1p_i8 = getelementptr inbounds i8, i8* %startPtr, i64 4
  %d1p = bitcast i8* %d1p_i8 to i32*
  %d1v = load i32, i32* %d1p, align 4
  %d2p_i8 = getelementptr inbounds i8, i8* %startPtr, i64 8
  %d2p = bitcast i8* %d2p_i8 to i32*
  %d2v = load i32, i32* %d2p, align 4
  %maybe_v2 = or i1 (and i1 (icmp eq i32 %d0v, 0), (icmp ne i32 %d2v, 0)), false
  br i1 %maybe_v2, label %v2_header, label %v1_loop_pre

v2_try:
  %d0p_t = bitcast i8* %startPtr to i32*
  %d0v_t = load i32, i32* %d0p_t, align 4
  %d1p_t_i8 = getelementptr inbounds i8, i8* %startPtr, i64 4
  %d1p_t = bitcast i8* %d1p_t_i8 to i32*
  %d1v_t = load i32, i32* %d1p_t, align 4
  %d2p_t_i8 = getelementptr inbounds i8, i8* %startPtr, i64 8
  %d2p_t = bitcast i8* %d2p_t_i8 to i32*
  %d2v_t = load i32, i32* %d2p_t, align 4
  %is_v2_hdr = and i1 (icmp eq i32 %d0v_t, 0), (and i1 (icmp eq i32 %d1v_t, 0), (icmp eq i32 %d2v_t, 1))
  br i1 %is_v2_hdr, label %v2_header, label %finalize

v2_header:
  %hdr_ver_p = getelementptr inbounds i8, i8* %startPtr, i64 8
  %hdr_ver_pi = bitcast i8* %hdr_ver_p to i32*
  %hdr_ver = load i32, i32* %hdr_ver_pi, align 4
  %ver_ok = icmp eq i32 %hdr_ver, 1
  br i1 %ver_ok, label %v2_loop_entry, label %unknown_protocol

v2_loop_entry:
  %rbx_cur = getelementptr inbounds i8, i8* %startPtr, i64 12
  %base = load i8*, i8** @off_1400043A0, align 8
  br label %v2_loop

v2_loop:
  %rbx_phi = phi i8* [ %rbx_cur, %v2_loop_entry ], [ %rbx_next, %v2_loop_post ]
  %rbx_int = ptrtoint i8* %rbx_phi to i64
  %cont = icmp slt i64 %rbx_int, %endInt
  br i1 %cont, label %v2_load_entry, label %finalize

v2_load_entry:
  %e_off_p = bitcast i8* %rbx_phi to i32*
  %e_off = load i32, i32* %e_off_p, align 4
  %e_add_p_i8 = getelementptr inbounds i8, i8* %rbx_phi, i64 4
  %e_add_p = bitcast i8* %e_add_p_i8 to i32*
  %e_add = load i32, i32* %e_add_p, align 4
  %e_flag_p_i8 = getelementptr inbounds i8, i8* %rbx_phi, i64 8
  %e_flag_p = bitcast i8* %e_flag_p_i8 to i32*
  %e_flag = load i32, i32* %e_flag_p, align 4
  %off64 = sext i32 %e_off to i64
  %add64 = sext i32 %e_add to i64
  %baseInt = ptrtoint i8* %base to i64
  %target_addr_int = add i64 %baseInt, %off64
  %patch_addr_int = add i64 %baseInt, %add64
  %target_addr = inttoptr i64 %target_addr_int to i8*
  %patch_addr = inttoptr i64 %patch_addr_int to i8*
  %sym_p = bitcast i8* %target_addr to i64*
  %sym_val = load i64, i64* %sym_p, align 8
  %size_tag = and i32 %e_flag, 255
  %is32 = icmp eq i32 %size_tag, 32
  %is64 = icmp eq i32 %size_tag, 64
  %is16 = icmp eq i32 %size_tag, 16
  %is8  = icmp eq i32 %size_tag, 8
  %sel32 = or i1 %is32, false
  br i1 %sel32, label %do32, label %chk64

chk64:
  br i1 %is64, label %do64, label %chk16

chk16:
  br i1 %is16, label %do16, label %chk8

chk8:
  br i1 %is8, label %do8, label %unknown_bitsize

do32:
  %p32 = bitcast i8* %patch_addr to i32*
  %old32 = load i32, i32* %p32, align 4
  %old32_sext = sext i32 %old32 to i64
  %tmp_sub32 = sub i64 %old32_sext, %target_addr_int
  %val32 = add i64 %tmp_sub32, %sym_val
  %flags_hi32 = and i32 %e_flag, 192
  %chk_needed32 = icmp eq i32 %flags_hi32, 0
  br i1 %chk_needed32, label %range32, label %store32

range32:
  %max32 = icmp sgt i64 %val32, 4294967295
  br i1 %max32, label %range_error, label %min32

min32:
  %min_ok32 = icmp sge i64 %val32, -2147483648
  br i1 %min_ok32, label %store32, label %range_error

store32:
  %store32_cast = bitcast i64* %srcbuf64 to i64*
  store i64 %val32, i64* %store32_cast, align 8
  call void @sub_140001B30(i8* %patch_addr)
  %patch_i8_32 = bitcast i8* %patch_addr to i8*
  %_ = call i8* @memcpy(i8* %patch_i8_32, i8* %srcbuf_i8, i64 4)
  br label %v2_loop_post

do16:
  %p16 = bitcast i8* %patch_addr to i16*
  %old16 = load i16, i16* %p16, align 2
  %old16_sext = sext i16 %old16 to i64
  %tmp_sub16 = sub i64 %old16_sext, %target_addr_int
  %val16 = add i64 %tmp_sub16, %sym_val
  %flags_hi16 = and i32 %e_flag, 192
  %chk_needed16 = icmp eq i32 %flags_hi16, 0
  br i1 %chk_needed16, label %range16, label %store16

range16:
  %max16 = icmp sgt i64 %val16, 65535
  br i1 %max16, label %range_error_val16, label %min16

min16:
  %min_ok16 = icmp sge i64 %val16, -32768
  br i1 %min_ok16, label %store16, label %range_error_val16

store16:
  store i64 %val16, i64* %srcbuf64, align 8
  call void @sub_140001B30(i8* %patch_addr)
  %_16 = call i8* @memcpy(i8* %patch_addr, i8* %srcbuf_i8, i64 2)
  br label %v2_loop_post

do8:
  %p8 = bitcast i8* %patch_addr to i8*
  %old8 = load i8, i8* %p8, align 1
  %old8_sext = sext i8 %old8 to i64
  %tmp_sub8 = sub i64 %old8_sext, %target_addr_int
  %val8 = add i64 %tmp_sub8, %sym_val
  %flags_hi8 = and i32 %e_flag, 192
  %chk_needed8 = icmp eq i32 %flags_hi8, 0
  br i1 %chk_needed8, label %range8, label %store8

range8:
  %max8 = icmp sgt i64 %val8, 255
  br i1 %max8, label %range_error_val8, label %min8

min8:
  %min_ok8 = icmp sge i64 %val8, -128
  br i1 %min_ok8, label %store8, label %range_error_val8

store8:
  store i64 %val8, i64* %srcbuf64, align 8
  call void @sub_140001B30(i8* %patch_addr)
  %_8 = call i8* @memcpy(i8* %patch_addr, i8* %srcbuf_i8, i64 1)
  br label %v2_loop_post

do64:
  %p64 = bitcast i8* %patch_addr to i64*
  %old64 = load i64, i64* %p64, align 8
  %tmp_sub64 = sub i64 %old64, %target_addr_int
  %val64 = add i64 %tmp_sub64, %sym_val
  %flags_hi64 = and i32 %e_flag, 192
  %chk_needed64 = icmp eq i32 %flags_hi64, 0
  br i1 %chk_needed64, label %range64, label %store64

range64:
  %is_neg = icmp slt i64 %val64, 0
  br i1 %is_neg, label %store64, label %range_error_val64

store64:
  store i64 %val64, i64* %srcbuf64, align 8
  call void @sub_140001B30(i8* %patch_addr)
  %_64 = call i8* @memcpy(i8* %patch_addr, i8* %srcbuf_i8, i64 8)
  br label %v2_loop_post

v2_loop_post:
  %rbx_next = getelementptr inbounds i8, i8* %rbx_phi, i64 12
  br label %v2_loop

unknown_bitsize:
  %msgp_bits_ptr = load i8*, i8** @aUnknownPseudoR, align 8
  store i64 0, i64* %srcbuf64, align 8
  call void @sub_140001AD0(i8* %msgp_bits_ptr)
  br label %finalize

range_error:
  store i64 %val32, i64* %var60, align 8
  %msgp_reloc_ptr = load i8*, i8** @aDBitPseudoRelo, align 8
  call void @sub_140001AD0(i8* %msgp_reloc_ptr)
  br label %finalize

range_error_val16:
  store i64 %val16, i64* %var60, align 8
  %msgp_reloc_ptr16 = load i8*, i8** @aDBitPseudoRelo, align 8
  call void @sub_140001AD0(i8* %msgp_reloc_ptr16)
  br label %finalize

range_error_val8:
  store i64 %val8, i64* %var60, align 8
  %msgp_reloc_ptr8 = load i8*, i8** @aDBitPseudoRelo, align 8
  call void @sub_140001AD0(i8* %msgp_reloc_ptr8)
  br label %finalize

range_error_val64:
  store i64 %val64, i64* %var60, align 8
  %msgp_reloc_ptr64 = load i8*, i8** @aDBitPseudoRelo, align 8
  call void @sub_140001AD0(i8* %msgp_reloc_ptr64)
  br label %finalize

unknown_protocol:
  %msgp_proto_ptr = load i8*, i8** @aUnknownPseudoR_0, align 8
  call void @sub_140001AD0(i8* %msgp_proto_ptr)
  br label %finalize

v1_loop_pre:
  %base_v1 = load i8*, i8** @off_1400043A0, align 8
  br label %v1_loop

v1_loop:
  %rbx_v1 = phi i8* [ %startPtr, %v1_loop_pre ], [ %rbx_v1_next, %v1_store ]
  %rbx_v1_int = ptrtoint i8* %rbx_v1 to i64
  %cont_v1 = icmp slt i64 %rbx_v1_int, %endInt
  br i1 %cont_v1, label %v1_load, label %finalize

v1_load:
  %v1_add_off_p_i8 = getelementptr inbounds i8, i8* %rbx_v1, i64 4
  %v1_add_off_p = bitcast i8* %v1_add_off_p_i8 to i32*
  %v1_add_off = load i32, i32* %v1_add_off_p, align 4
  %v1_val_p = bitcast i8* %rbx_v1 to i32*
  %v1_val = load i32, i32* %v1_val_p, align 4
  %rbx_v1_next = getelementptr inbounds i8, i8* %rbx_v1, i64 8
  %base_v1_int = ptrtoint i8* %base_v1 to i64
  %add64_v1 = sext i32 %v1_add_off to i64
  %dest_addr_int = add i64 %base_v1_int, %add64_v1
  %dest_addr = inttoptr i64 %dest_addr_int to i8*
  %dest_dword_p = inttoptr i64 %dest_addr_int to i32*
  %mem_val = load i32, i32* %dest_dword_p, align 4
  %sum = add i32 %v1_val, %mem_val
  %sum_zext = zext i32 %sum to i64
  store i64 %sum_zext, i64* %srcbuf64, align 8
  call void @sub_140001B30(i8* %dest_addr)
  br label %v1_store

v1_store:
  %_v1 = call i8* @memcpy(i8* %dest_addr, i8* %srcbuf_i8, i64 4)
  br label %v1_loop

finalize:
  %count = load i32, i32* @dword_1400070A4, align 4
  %have = icmp sgt i32 %count, 0
  br i1 %have, label %vp_loop, label %ret

vp_loop:
  %i = phi i32 [ 0, %finalize ], [ %i_next, %vp_post ]
  %i64 = sext i32 %i to i64
  %base_list = load i8*, i8** @qword_1400070A8, align 8
  %offset = mul nsw i64 %i64, 40
  %entry = getelementptr inbounds i8, i8* %base_list, i64 %offset
  %newprot_p = bitcast i8* %entry to i32*
  %newprot = load i32, i32* %newprot_p, align 4
  %nz = icmp ne i32 %newprot, 0
  br i1 %nz, label %vp_call, label %vp_post

vp_call:
  %addr_p_i8 = getelementptr inbounds i8, i8* %entry, i64 8
  %addr_p = bitcast i8* %addr_p_i8 to i8**
  %addr = load i8*, i8** %addr_p, align 8
  %size_p_i8 = getelementptr inbounds i8, i8* %entry, i64 16
  %size_p = bitcast i8* %size_p_i8 to i64*
  %size = load i64, i64* %size_p, align 8
  %fp_i8 = load i8*, i8** @__imp_VirtualProtect, align 8
  %fp = bitcast i8* %fp_i8 to i1 (i8*, i64, i32, i32*)*
  %ok = call i1 %fp(i8* %addr, i64 %size, i32 %newprot, i32* %oldprot)
  br label %vp_post

vp_post:
  %i_next = add i32 %i, 1
  %again = icmp slt i32 %i_next, %count
  br i1 %again, label %vp_loop, label %ret

ret:
  ret void
}