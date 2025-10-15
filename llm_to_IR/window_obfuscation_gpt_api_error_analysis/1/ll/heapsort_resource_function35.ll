; target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %index) {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i16 = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr_i16, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_zext = zext i32 %e_lfanew to i64
  %nt_hdr = getelementptr inbounds i8, i8* %base_ptr, i64 %e_lfanew_zext
  %pe_sig_ptr = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %opt_magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_dir, label %ret_null

check_dir:
  %dir_check_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 144
  %dir_check_ptr = bitcast i8* %dir_check_ptr_i8 to i32*
  %dir_check = load i32, i32* %dir_check_ptr, align 4
  %has_dir = icmp ne i32 %dir_check, 0
  br i1 %has_dir, label %load_sections, label %ret_null

load_sections:
  %num_sections_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 6
  %num_sections_ptr = bitcast i8* %num_sections_ptr_i8 to i16*
  %num_sections = load i16, i16* %num_sections_ptr, align 2
  %has_sections = icmp ne i16 %num_sections, 0
  br i1 %has_sections, label %sec_calc, label %ret_null

sec_calc:
  %size_opt_ptr_i8 = getelementptr inbounds i8, i8* %nt_hdr, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr_i8 to i16*
  %size_opt = load i16, i16* %size_opt_ptr, align 2
  %size_opt_z = zext i16 %size_opt to i64
  %opt_hdr_start = getelementptr inbounds i8, i8* %nt_hdr, i64 24
  %first_sec = getelementptr inbounds i8, i8* %opt_hdr_start, i64 %size_opt_z
  %nsec_z = zext i16 %num_sections to i64
  %total_bytes = mul nuw nsw i64 %nsec_z, 40
  %end_sec = getelementptr inbounds i8, i8* %first_sec, i64 %total_bytes
  br label %sec_loop

sec_loop:
  %cur = phi i8* [ %first_sec, %sec_calc ], [ %next, %sec_next ]
  %va_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va to i64
  %cmp_ge = icmp uge i64 %rva, %va64
  br i1 %cmp_ge, label %check_end, label %sec_next

check_end:
  %vsize_ptr_i8 = getelementptr inbounds i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 4
  %vsize64 = zext i32 %vsize to i64
  %va_end = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %va_end
  br i1 %in_range, label %found_sec, label %sec_next

sec_next:
  %next = getelementptr inbounds i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end_sec
  br i1 %done, label %ret_null, label %sec_loop

found_sec:
  %desc_base = getelementptr inbounds i8, i8* %base_ptr, i64 %rva
  br label %desc_loop

desc_loop:
  %desc = phi i8* [ %desc_base, %found_sec ], [ %desc_next, %desc_step ]
  %i = phi i32 [ %index, %found_sec ], [ %i2, %desc_step ]
  %tds_ptr_i8 = getelementptr inbounds i8, i8* %desc, i64 4
  %tds_ptr = bitcast i8* %tds_ptr_i8 to i32*
  %tds = load i32, i32* %tds_ptr, align 4
  %tds_nz = icmp ne i32 %tds, 0
  br i1 %tds_nz, label %check_idx, label %tds_zero

tds_zero:
  %name_rva_chk_ptr_i8 = getelementptr inbounds i8, i8* %desc, i64 12
  %name_rva_chk_ptr = bitcast i8* %name_rva_chk_ptr_i8 to i32*
  %name_rva_chk = load i32, i32* %name_rva_chk_ptr, align 4
  %name_is_zero = icmp eq i32 %name_rva_chk, 0
  br i1 %name_is_zero, label %ret_null, label %check_idx

check_idx:
  %gt_zero = icmp sgt i32 %i, 0
  br i1 %gt_zero, label %desc_step, label %return_name

desc_step:
  %i2 = add nsw i32 %i, -1
  %desc_next = getelementptr inbounds i8, i8* %desc, i64 20
  br label %desc_loop

return_name:
  %name_rva_ptr_i8 = getelementptr inbounds i8, i8* %desc, i64 12
  %name_rva_ptr = bitcast i8* %name_rva_ptr_i8 to i32*
  %name_rva = load i32, i32* %name_rva_ptr, align 4
  %name_rva64 = zext i32 %name_rva to i64
  %name_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %name_rva64
  ret i8* %name_ptr

ret_null:
  ret i8* null
}