; ModuleID = 'sub_140002820_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*

define dso_local i8* @sub_140002820(i64 %rva, i32 %index) local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %dos_magic_ptr = bitcast i8* %base to i16*
  %dos_magic = load i16, i16* %dos_magic_ptr, align 1
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %check_nt, label %ret_null

check_nt:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_ptr = getelementptr i8, i8* %base, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig_val = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig_val, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic_val = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic_val, 523
  br i1 %is_pe32plus, label %check_dir, label %ret_null

check_dir:
  %dir_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir_val = load i32, i32* %dir_ptr, align 1
  %dir_nz = icmp ne i32 %dir_val, 0
  br i1 %dir_nz, label %check_sections_count, label %ret_null

check_sections_count:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %compute_sections

compute_sections:
  %numsec64 = zext i16 %numsec16 to i64
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64
  %sect_start_tmp = getelementptr i8, i8* %nt_ptr, i64 24
  %sect_table_start = getelementptr i8, i8* %sect_start_tmp, i64 %soh64
  %numsec_mul40 = mul i64 %numsec64, 40
  %sect_table_end = getelementptr i8, i8* %sect_table_start, i64 %numsec_mul40
  br label %sect_loop

sect_loop:
  %cur_ptr = phi i8* [ %sect_table_start, %compute_sections ], [ %next_sect_ptr, %sect_advance ]
  %end_cmp = icmp eq i8* %cur_ptr, %sect_table_end
  br i1 %end_cmp, label %fail_after_loop, label %sect_check

fail_after_loop:
  br label %ret_null

sect_check:
  %va_ptr_i8 = getelementptr i8, i8* %cur_ptr, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %sect_advance, label %check_within

sect_advance:
  %next_sect_ptr = getelementptr i8, i8* %cur_ptr, i64 40
  br label %sect_loop

check_within:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur_ptr, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %va_plus_vsize32 = add i32 %va32, %vsize32
  %va_plus_vsize64 = zext i32 %va_plus_vsize32 to i64
  %rva_lt_end = icmp ult i64 %rva, %va_plus_vsize64
  br i1 %rva_lt_end, label %found_in_section, label %sect_advance

found_in_section:
  %abs_ptr = getelementptr i8, i8* %base, i64 %rva
  br label %entry_scan

entry_scan:
  %cur_entry_ptr = phi i8* [ %abs_ptr, %found_in_section ], [ %next_entry_ptr2, %entry_dec ]
  %idx_phi = phi i32 [ %index, %found_in_section ], [ %idx_dec, %entry_dec ]
  %off4_ptr_i8 = getelementptr i8, i8* %cur_entry_ptr, i64 4
  %off4_ptr = bitcast i8* %off4_ptr_i8 to i32*
  %off4 = load i32, i32* %off4_ptr, align 1
  %off4_is_nz = icmp ne i32 %off4, 0
  br i1 %off4_is_nz, label %check_index, label %check_offc_zero

check_offc_zero:
  %offc_ptr_i8_a = getelementptr i8, i8* %cur_entry_ptr, i64 12
  %offc_ptr_a = bitcast i8* %offc_ptr_i8_a to i32*
  %offc_a = load i32, i32* %offc_ptr_a, align 1
  %offc_is_zero = icmp eq i32 %offc_a, 0
  br i1 %offc_is_zero, label %ret_null, label %check_index

check_index:
  %idx_gt_zero = icmp sgt i32 %idx_phi, 0
  br i1 %idx_gt_zero, label %entry_dec, label %return_value

entry_dec:
  %idx_dec = add nsw i32 %idx_phi, -1
  %next_entry_ptr2 = getelementptr i8, i8* %cur_entry_ptr, i64 20
  br label %entry_scan

return_value:
  %offc_ptr_i8_b = getelementptr i8, i8* %cur_entry_ptr, i64 12
  %offc_ptr_b = bitcast i8* %offc_ptr_i8_b to i32*
  %offc_b = load i32, i32* %offc_ptr_b, align 1
  %offc_b64 = zext i32 %offc_b to i64
  %ret_ptr = getelementptr i8, i8* %base, i64 %offc_b64
  ret i8* %ret_ptr

ret_null:
  ret i8* null
}