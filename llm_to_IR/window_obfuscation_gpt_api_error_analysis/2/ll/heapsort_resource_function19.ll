; ModuleID = 'sub_140001CA0.ll'
target triple = "x86_64-pc-windows-msvc"

; extern globals
@dword_1400070A0 = external global i32, align 4
@dword_1400070A4 = external global i32, align 4
@qword_1400070A8 = external global i8*, align 8
@off_1400043A0 = external global i8*, align 8
@off_1400043B0 = external global i8*, align 8
@off_1400043C0 = external global i8*, align 8

; extern message strings (addresses supplied by the linker)
@aUnknownPseudoR      = external constant i8
@aDBitPseudoRelo      = external constant i8
@aUnknownPseudoR_0    = external constant i8

; extern functions
declare i32 @sub_140002690()
declare i64 @sub_1400028E0()
declare void @sub_140001B30(i8*)
declare void @sub_140001AD0(i8*, ...)
declare i8* @memcpy(i8*, i8*, i64)
declare i1 @VirtualProtect(i8*, i64, i32, i32*)

define void @sub_140001CA0() local_unnamed_addr {
entry:
  %init0 = load i32, i32* @dword_1400070A0, align 4
  %cmp_init = icmp eq i32 %init0, 0
  br i1 %cmp_init, label %cold_start, label %epilogue

cold_start:
  store i32 1, i32* @dword_1400070A0, align 4
  %cnt32 = call i32 @sub_140002690()
  %cnt64 = sext i32 %cnt32 to i64
  %mul5 = mul i64 %cnt64, 5
  %bytes_per = mul i64 %mul5, 8
  %add15 = add i64 %bytes_per, 15
  %aligned = and i64 %add15, -16
  %unused_extra = call i64 @sub_1400028E0()
  %entries_buf = alloca i8, i64 %aligned, align 16
  %srcbuf = alloca [8 x i8], align 8
  %oldprot = alloca i32, align 4
  store i32 0, i32* @dword_1400070A4, align 4
  store i8* %entries_buf, i8** @qword_1400070A8, align 8
  %end_ptr0 = load i8*, i8** @off_1400043B0, align 8
  %cur_ptr0 = load i8*, i8** @off_1400043C0, align 8
  %end_i0 = ptrtoint i8* %end_ptr0 to i64
  %cur_i0 = ptrtoint i8* %cur_ptr0 to i64
  %diff0 = sub i64 %end_i0, %cur_i0
  %gt7 = icmp sgt i64 %diff0, 7
  br i1 %gt7, label %check_0B, label %epilogue

check_0B:
  %gt11 = icmp sgt i64 %diff0, 11
  br i1 %gt11, label %path_large_header, label %path_small_header

; loc_140001D33 path (small header: 8..11 bytes)
path_small_header:
  %edx0_ptr = bitcast i8* %cur_ptr0 to i32*
  %edx0 = load i32, i32* %edx0_ptr, align 1
  %nz_edx0 = icmp ne i32 %edx0, 0
  br i1 %nz_edx0, label %path_large_loop_entry, label %psh_chk2

psh_chk2:
  %eax0_ptr = getelementptr inbounds i8, i8* %cur_ptr0, i64 4
  %eax0_ip = bitcast i8* %eax0_ptr to i32*
  %eax0 = load i32, i32* %eax0_ip, align 1
  %nz_eax0 = icmp ne i32 %eax0, 0
  br i1 %nz_eax0, label %path_large_loop_entry, label %psh_proto

psh_proto:
  %proto_ptr = getelementptr inbounds i8, i8* %cur_ptr0, i64 8
  %proto_ip = bitcast i8* %proto_ptr to i32*
  %proto = load i32, i32* %proto_ip, align 1
  %is_v1 = icmp eq i32 %proto, 1
  br i1 %is_v1, label %psh_loop_prep, label %unknown_proto

unknown_proto:
  %fmt_up = bitcast i8* @aUnknownPseudoR_0 to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_up)
  br label %epilogue

psh_loop_prep:
  %cur1 = getelementptr inbounds i8, i8* %cur_ptr0, i64 12
  %baseA_ptr = load i8*, i8** @off_1400043A0, align 8
  br label %psh_loop_cond

psh_loop_cond:
  %cur_phi = phi i8* [ %cur1, %psh_loop_prep ], [ %cur_next, %psh_loop_tail ]
  %end_i1 = ptrtoint i8* %end_ptr0 to i64
  %cur_i1 = ptrtoint i8* %cur_phi to i64
  %lt_end = icmp slt i64 %cur_i1, %end_i1
  br i1 %lt_end, label %psh_loop_body, label %after_loops

; loc_140001DE4 body
psh_loop_body:
  %r8off_ip = bitcast i8* %cur_phi to i32*
  %r8off32 = load i32, i32* %r8off_ip, align 1
  %r8off64 = zext i32 %r8off32 to i64
  %type_ptr = getelementptr inbounds i8, i8* %cur_phi, i64 8
  %type_ip = bitcast i8* %type_ptr to i32*
  %type32 = load i32, i32* %type_ip, align 1
  %r15off_ptr = getelementptr inbounds i8, i8* %cur_phi, i64 4
  %r15off_ip = bitcast i8* %r15off_ptr to i32*
  %r15off32 = load i32, i32* %r15off_ip, align 1
  %r15off64 = zext i32 %r15off32 to i64
  %r8ptr = getelementptr inbounds i8, i8* %baseA_ptr, i64 %r8off64
  %r15ptr = getelementptr inbounds i8, i8* %baseA_ptr, i64 %r15off64
  %r9val_ip = bitcast i8* %r8ptr to i64*
  %r9val = load i64, i64* %r9val_ip, align 1
  %cl8 = trunc i32 %type32 to i8
  %sizezx32 = zext i8 %cl8 to i32
  %is32 = icmp eq i32 %sizezx32, 32
  %le32 = icmp ule i32 %sizezx32, 32
  br i1 %is32, label %case32, label %check_small_cases

check_small_cases:
  br i1 %le32, label %case8or16, label %check64

check64:
  %is64 = icmp eq i32 %sizezx32, 64
  br i1 %is64, label %case64, label %unknown_bitsize

; 32-bit case (loc_140001F30)
case32:
  %val32_ip = bitcast i8* %r15ptr to i32*
  %val32 = load i32, i32* %val32_ip, align 1
  %signext64 = sext i32 %val32 to i64
  %r8addr_i = ptrtoint i8* %r8ptr to i64
  %sub1_32 = sub i64 %signext64, %r8addr_i
  %new32 = add i64 %sub1_32, %r9val
  %maskC0_32 = and i32 %type32, 192
  %nzflags32 = icmp ne i32 %maskC0_32, 0
  br i1 %nzflags32, label %store32, label %range32

range32:
  %max32 = icmp sgt i64 %new32, 4294967295
  %min32 = icmp slt i64 %new32, -2147483648
  %oor32a = or i1 %max32, %min32
  br i1 %oor32a, label %range_error, label %store32

store32:
  %srcbuf_i8 = bitcast [8 x i8]* %srcbuf to i8*
  %srcbuf_i64p = bitcast i8* %srcbuf_i8 to i64*
  store i64 %new32, i64* %srcbuf_i64p, align 8
  call void @sub_140001B30(i8* %r15ptr)
  %cpy32 = call i8* @memcpy(i8* %r15ptr, i8* %srcbuf_i8, i64 4)
  br label %psh_loop_tail

; 64-bit case (loc_140001E12..)
case64:
  %val64_ip = bitcast i8* %r15ptr to i64*
  %val64 = load i64, i64* %val64_ip, align 1
  %r8addr_i64 = ptrtoint i8* %r8ptr to i64
  %sub1_64 = sub i64 %val64, %r8addr_i64
  %new64 = add i64 %sub1_64, %r9val
  %maskC0_64 = and i32 %type32, 192
  %nzflags64 = icmp ne i32 %maskC0_64, 0
  br i1 %nzflags64, label %store64, label %checkneg64

checkneg64:
  %neg64 = icmp slt i64 %new64, 0
  br i1 %neg64, label %store64, label %range_error

store64:
  %srcbuf_i8_b = bitcast [8 x i8]* %srcbuf to i8*
  %srcbuf_i64p_b = bitcast i8* %srcbuf_i8_b to i64*
  store i64 %new64, i64* %srcbuf_i64p_b, align 8
  call void @sub_140001B30(i8* %r15ptr)
  %cpy64 = call i8* @memcpy(i8* %r15ptr, i8* %srcbuf_i8_b, i64 8)
  br label %psh_loop_tail

; 8/16-bit cases (loc_140001D70..)
case8or16:
  %is8 = icmp eq i32 %sizezx32, 8
  br i1 %is8, label %case8, label %check16

check16:
  %is16 = icmp eq i32 %sizezx32, 16
  br i1 %is16, label %case16, label %unknown_bitsize

; 8-bit
case8:
  %val8 = load i8, i8* %r15ptr, align 1
  %val8_se = sext i8 %val8 to i64
  %r8addr_i8 = ptrtoint i8* %r8ptr to i64
  %sub1_8 = sub i64 %val8_se, %r8addr_i8
  %new8 = add i64 %sub1_8, %r9val
  %maskC0_8 = and i32 %type32, 192
  %nzflags8 = icmp ne i32 %maskC0_8, 0
  br i1 %nzflags8, label %store8, label %range8

range8:
  %max8 = icmp sgt i64 %new8, 255
  %min8 = icmp slt i64 %new8, -128
  %oor8 = or i1 %max8, %min8
  br i1 %oor8, label %range_error, label %store8

store8:
  %srcbuf_i8_c = bitcast [8 x i8]* %srcbuf to i8*
  %srcbuf_i64p_c = bitcast i8* %srcbuf_i8_c to i64*
  store i64 %new8, i64* %srcbuf_i64p_c, align 8
  call void @sub_140001B30(i8* %r15ptr)
  %cpy8 = call i8* @memcpy(i8* %r15ptr, i8* %srcbuf_i8_c, i64 1)
  br label %psh_loop_tail

; 16-bit
case16:
  %val16_ip = bitcast i8* %r15ptr to i16*
  %val16 = load i16, i16* %val16_ip, align 1
  %val16_se = sext i16 %val16 to i64
  %r8addr_i16 = ptrtoint i8* %r8ptr to i64
  %sub1_16 = sub i64 %val16_se, %r8addr_i16
  %new16 = add i64 %sub1_16, %r9val
  %maskC0_16 = and i32 %type32, 192
  %nzflags16 = icmp ne i32 %maskC0_16, 0
  br i1 %nzflags16, label %store16, label %range16

range16:
  %max16 = icmp sgt i64 %new16, 65535
  %min16 = icmp slt i64 %new16, -32768
  %oor16 = or i1 %max16, %min16
  br i1 %oor16, label %range_error, label %store16

store16:
  %srcbuf_i8_d = bitcast [8 x i8]* %srcbuf to i8*
  %srcbuf_i64p_d = bitcast i8* %srcbuf_i8_d to i64*
  store i64 %new16, i64* %srcbuf_i64p_d, align 8
  call void @sub_140001B30(i8* %r15ptr)
  %cpy16 = call i8* @memcpy(i8* %r15ptr, i8* %srcbuf_i8_d, i64 2)
  br label %psh_loop_tail

unknown_bitsize:
  %fmt_unk = bitcast i8* @aUnknownPseudoR to i8*
  %zero64 = ptrtoint i8* null to i64
  %zero_i64 = add i64 %zero64, 0
  %zero_i8p = inttoptr i64 %zero_i64 to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_unk)
  br label %psh_loop_tail

range_error:
  %fmt_range = bitcast i8* @aDBitPseudoRelo to i8*
  call void (i8*, ...) @sub_140001AD0(i8* %fmt_range, i32 %sizezx32, i8* %r15ptr)
  br label %psh_loop_tail

psh_loop_tail:
  %cur_next = getelementptr inbounds i8, i8* %cur_phi, i64 12
  br label %psh_loop_cond

; loc_140001EB8 path (large header: >11 bytes)
path_large_header:
  %r9d_ptr = bitcast i8* %cur_ptr0 to i32*
  %r9d_val = load i32, i32* %r9d_ptr, align 1
  %nz_r9d = icmp ne i32 %r9d_val, 0
  br i1 %nz_r9d, label %path_large_loop_entry, label %plh_chk2

plh_chk2:
  %r8d_ptrA = getelementptr inbounds i8, i8* %cur_ptr0, i64 4
  %r8d_ipA = bitcast i8* %r8d_ptrA to i32*
  %r8d_valA = load i32, i32* %r8d_ipA, align 1
  %nz_r8dA = icmp ne i32 %r8d_valA, 0
  br i1 %nz_r8dA, label %path_large_loop_entry, label %plh_to_fe7

; loc_140001FE7 flow
plh_to_fe7:
  %ecx_ptr_fe7 = getelementptr inbounds i8, i8* %cur_ptr0, i64 8
  %ecx_ip_fe7 = bitcast i8* %ecx_ptr_fe7 to i32*
  %ecx_val_fe7 = load i32, i32* %ecx_ip_fe7, align 1
  %nz_ecx_fe7 = icmp ne i32 %ecx_val_fe7, 0
  br i1 %nz_ecx_fe7, label %path_small_header, label %skip12_restart

skip12_restart:
  %cur_ptr1 = getelementptr inbounds i8, i8* %cur_ptr0, i64 12
  %end_i_restart = ptrtoint i8* %end_ptr0 to i64
  %cur_i_restart = ptrtoint i8* %cur_ptr1 to i64
  %diff_restart = sub i64 %end_i_restart, %cur_i_restart
  %gt7_restart = icmp sgt i64 %diff_restart, 7
  br i1 %gt7_restart, label %check_0B_restart, label %epilogue

check_0B_restart:
  %gt11_restart = icmp sgt i64 %diff_restart, 11
  br i1 %gt11_restart, label %path_large_header_restart, label %path_small_header_restart

path_large_header_restart:
  br label %path_large_loop_entry

path_small_header_restart:
  br label %path_small_header

; loc_140001ECD loop (large path loop)
path_large_loop_entry:
  %baseB_ptr = load i8*, i8** @off_1400043A0, align 8
  br label %pll_cond

pll_cond:
  %curL_phi = phi i8* [ %cur_ptr0, %path_large_loop_entry ], [ %curL_next, %pll_tail ]
  %curL_i = ptrtoint i8* %curL_phi to i64
  %endL_i = ptrtoint i8* %end_ptr0 to i64
  %ltL = icmp slt i64 %curL_i, %endL_i
  br i1 %ltL, label %pll_body, label %after_loops

pll_body:
  %off_ip = bitcast i8* %curL_phi to i32*
  %addend_ptr = getelementptr inbounds i8, i8* %curL_phi, i64 0
  %addend_ip = bitcast i8* %addend_ptr to i32*
  %addend32 = load i32, i32* %addend_ip, align 1
  %off_ptr = getelementptr inbounds i8, i8* %curL_phi, i64 4
  %off_ip2 = bitcast i8* %off_ptr to i32*
  %off32 = load i32, i32* %off_ip2, align 1
  %curL_next = getelementptr inbounds i8, i8* %curL_phi, i64 8
  %off64 = zext i32 %off32 to i64
  %tgt_ptr = getelementptr inbounds i8, i8* %baseB_ptr, i64 %off64
  %tgt_ip32 = bitcast i8* %tgt_ptr to i32*
  %tgt_val32 = load i32, i32* %tgt_ip32, align 1
  %tgt_sum = add i32 %tgt_val32, %addend32
  %srcbuf_i8_e = bitcast [8 x i8]* %srcbuf to i8*
  %srcbuf_i32p_e = bitcast i8* %srcbuf_i8_e to i32*
  store i32 %tgt_sum, i32* %srcbuf_i32p_e, align 4
  call void @sub_140001B30(i8* %tgt_ptr)
  %cpy4 = call i8* @memcpy(i8* %tgt_ptr, i8* %srcbuf_i8_e, i64 4)
  br label %pll_tail

pll_tail:
  br label %pll_cond

; common after loops -> VirtualProtect section (loc_140001E60)
after_loops:
  %countVP = load i32, i32* @dword_1400070A4, align 4
  %count_pos = icmp sgt i32 %countVP, 0
  br i1 %count_pos, label %vp_loop, label %epilogue

vp_loop:
  %baseEntries = load i8*, i8** @qword_1400070A8, align 8
  %i0 = add i32 0, 0
  br label %vp_cond

vp_cond:
  %i = phi i32 [ %i0, %vp_loop ], [ %i_next, %vp_tail ]
  %cnt_now = load i32, i32* @dword_1400070A4, align 4
  %lt_cnt = icmp slt i32 %i, %cnt_now
  br i1 %lt_cnt, label %vp_body, label %epilogue

vp_body:
  %i64 = sext i32 %i to i64
  %ofs_bytes = mul i64 %i64, 40
  %ent_ptr = getelementptr inbounds i8, i8* %baseEntries, i64 %ofs_bytes
  %fl_ip = bitcast i8* %ent_ptr to i32*
  %fl = load i32, i32* %fl_ip, align 4
  %hasfl = icmp ne i32 %fl, 0
  br i1 %hasfl, label %vp_call, label %vp_tail

vp_call:
  %addr_ptr = getelementptr inbounds i8, i8* %ent_ptr, i64 8
  %addr_ip = bitcast i8* %addr_ptr to i8**
  %addr = load i8*, i8** %addr_ip, align 8
  %size_ptr = getelementptr inbounds i8, i8* %ent_ptr, i64 16
  %size_ip = bitcast i8* %size_ptr to i64*
  %size = load i64, i64* %size_ip, align 8
  %oldp_ptr = bitcast i32* %oldprot to i32*
  %vpok = call i1 @VirtualProtect(i8* %addr, i64 %size, i32 %fl, i32* %oldp_ptr)
  br label %vp_tail

vp_tail:
  %i_next = add i32 %i, 1
  br label %vp_cond

; final epilogue (shared early returns)
epilogue:
  ret void
}