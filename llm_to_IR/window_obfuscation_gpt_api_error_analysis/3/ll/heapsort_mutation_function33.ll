target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002820(i64 %rva, i32 %count) local_unnamed_addr {
entry:
  %base_load = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_load to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %base_load, i64 60
  %e_lfanew_i32p = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32p, align 4
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base_load, i64 %e_lfanew_z
  %pe_sig_p = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_p, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %magic_p16 = bitcast i8* %magic_ptr to i16*
  %magic = load i16, i16* %magic_p16, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %check_dir, label %ret_null

check_dir:
  %dir_va_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 144
  %dir_va_p32 = bitcast i8* %dir_va_ptr to i32*
  %dir_va = load i32, i32* %dir_va_p32, align 4
  %dir_nonzero = icmp ne i32 %dir_va, 0
  br i1 %dir_nonzero, label %check_sections, label %ret_null

check_sections:
  %numsec_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %numsec_p16 = bitcast i8* %numsec_ptr to i16*
  %numsec16 = load i16, i16* %numsec_p16, align 2
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %have_sections

have_sections:
  %soh_ptr = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %soh_p16 = bitcast i8* %soh_ptr to i16*
  %soh = load i16, i16* %soh_p16, align 2
  %soh_z = zext i16 %soh to i64
  %sect_start_tmp = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %sect_base = getelementptr inbounds i8, i8* %sect_start_tmp, i64 %soh_z
  %numsec64 = zext i16 %numsec16 to i64
  %sect_table_bytes = mul nuw i64 %numsec64, 40
  %sect_end = getelementptr inbounds i8, i8* %sect_base, i64 %sect_table_bytes
  br label %sect_loop

sect_loop:
  %sect_cur = phi i8* [ %sect_base, %have_sections ], [ %sect_next, %sect_loop_next ]
  %va_off = getelementptr inbounds i8, i8* %sect_cur, i64 12
  %va_p32 = bitcast i8* %va_off to i32*
  %va = load i32, i32* %va_p32, align 4
  %vs_off = getelementptr inbounds i8, i8* %sect_cur, i64 8
  %vs_p32 = bitcast i8* %vs_off to i32*
  %vs = load i32, i32* %vs_p32, align 4
  %va_z = zext i32 %va to i64
  %vs_z = zext i32 %vs to i64
  %rva_ge_va = icmp uge i64 %rva, %va_z
  %va_plus_vs = add nuw i64 %va_z, %vs_z
  %rva_lt_va_vs = icmp ult i64 %rva, %va_plus_vs
  %in_range = and i1 %rva_ge_va, %rva_lt_va_vs
  br i1 %in_range, label %found_section, label %sect_loop_next

sect_loop_next:
  %sect_next = getelementptr inbounds i8, i8* %sect_cur, i64 40
  %done = icmp eq i8* %sect_next, %sect_end
  br i1 %done, label %ret_null, label %sect_loop

found_section:
  %addr_in_image = getelementptr inbounds i8, i8* %base_load, i64 %rva
  br label %desc_loop

desc_loop:
  %desc_ptr = phi i8* [ %addr_in_image, %found_section ], [ %desc_next, %desc_iter ]
  %remaining = phi i32 [ %count, %found_section ], [ %remaining_next, %desc_iter ]
  %tds_ptr = getelementptr inbounds i8, i8* %desc_ptr, i64 4
  %tds_p32 = bitcast i8* %tds_ptr to i32*
  %tds = load i32, i32* %tds_p32, align 4
  %tds_nz = icmp ne i32 %tds, 0
  br i1 %tds_nz, label %check_count, label %check_name

check_name:
  %name_rva_ptr_chk = getelementptr inbounds i8, i8* %desc_ptr, i64 12
  %name_rva_p32_chk = bitcast i8* %name_rva_ptr_chk to i32*
  %name_rva_chk = load i32, i32* %name_rva_p32_chk, align 4
  %name_is_zero = icmp eq i32 %name_rva_chk, 0
  br i1 %name_is_zero, label %ret_null, label %check_count

check_count:
  %rem_gt_zero = icmp sgt i32 %remaining, 0
  br i1 %rem_gt_zero, label %desc_iter, label %produce_result

desc_iter:
  %remaining_next = add nsw i32 %remaining, -1
  %desc_next = getelementptr inbounds i8, i8* %desc_ptr, i64 20
  br label %desc_loop

produce_result:
  %name_rva_ptr = getelementptr inbounds i8, i8* %desc_ptr, i64 12
  %name_rva_p32 = bitcast i8* %name_rva_ptr to i32*
  %name_rva = load i32, i32* %name_rva_p32, align 4
  %name_rva_z = zext i32 %name_rva to i64
  %name_ptr = getelementptr inbounds i8, i8* %base_load, i64 %name_rva_z
  ret i8* %name_ptr

ret_null:
  ret i8* null
}