; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002820(i64 %rva, i32 %count) {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe_sig, label %ret0

check_pe_sig:
  %e_lfanew_off = getelementptr inbounds i8, i8* %base, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_off to i32*
  %e_lfanew_val = load i32, i32* %e_lfanew_i32ptr, align 4
  %e_lfanew64 = sext i32 %e_lfanew_val to i64
  %nt = getelementptr inbounds i8, i8* %base, i64 %e_lfanew64
  %sigptr = bitcast i8* %nt to i32*
  %sig = load i32, i32* %sigptr, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %magic_off = getelementptr inbounds i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_off to i16*
  %magic_val = load i16, i16* %magic_ptr, align 2
  %is_64 = icmp eq i16 %magic_val, 523
  br i1 %is_64, label %check_import_dir, label %ret0

check_import_dir:
  %imp_rva_off = getelementptr inbounds i8, i8* %nt, i64 144
  %imp_rva_ptr = bitcast i8* %imp_rva_off to i32*
  %imp_rva = load i32, i32* %imp_rva_ptr, align 4
  %has_imp = icmp ne i32 %imp_rva, 0
  br i1 %has_imp, label %check_sections, label %ret0

check_sections:
  %numsec_off = getelementptr inbounds i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_off to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec = zext i16 %numsec16 to i32
  %has_secs = icmp ne i32 %numsec, 0
  br i1 %has_secs, label %calc_section_headers, label %ret0

calc_section_headers:
  %soh_off = getelementptr inbounds i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_off to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %sec_table_base = getelementptr inbounds i8, i8* %nt, i64 24
  %sec_table = getelementptr inbounds i8, i8* %sec_table_base, i64 %soh64
  %numsec64 = zext i32 %numsec to i64
  %total_size = mul i64 %numsec64, 40
  %end = getelementptr inbounds i8, i8* %sec_table, i64 %total_size
  br label %section_loop

section_loop:
  %sec_cur = phi i8* [ %sec_table, %calc_section_headers ], [ %sec_next, %section_advance ]
  %va_off = getelementptr inbounds i8, i8* %sec_cur, i64 12
  %va_i32ptr = bitcast i8* %va_off to i32*
  %sec_va = load i32, i32* %va_i32ptr, align 4
  %sec_va64 = zext i32 %sec_va to i64
  %cmp_lo = icmp ult i64 %rva, %sec_va64
  br i1 %cmp_lo, label %section_advance, label %section_cmp_hi

section_cmp_hi:
  %vsize_off = getelementptr inbounds i8, i8* %sec_cur, i64 8
  %vsize_i32ptr = bitcast i8* %vsize_off to i32*
  %vsize = load i32, i32* %vsize_i32ptr, align 4
  %vsize64 = zext i32 %vsize to i64
  %va_plus = add i64 %sec_va64, %vsize64
  %cmp_hi = icmp ult i64 %rva, %va_plus
  br i1 %cmp_hi, label %found_section, label %section_advance

section_advance:
  %sec_next = getelementptr inbounds i8, i8* %sec_cur, i64 40
  %cont = icmp ne i8* %sec_next, %end
  br i1 %cont, label %section_loop, label %ret0

found_section:
  %desc_start = getelementptr inbounds i8, i8* %base, i64 %rva
  br label %desc_loop

desc_loop:
  %desc = phi i8* [ %desc_start, %found_section ], [ %desc_next, %advance_desc ]
  %cnt = phi i32 [ %count, %found_section ], [ %cnt_next, %advance_desc ]
  %tds_off = getelementptr inbounds i8, i8* %desc, i64 4
  %tds_ptr = bitcast i8* %tds_off to i32*
  %tds = load i32, i32* %tds_ptr, align 4
  %tds_nz = icmp ne i32 %tds, 0
  br i1 %tds_nz, label %valid_desc, label %check_name

check_name:
  %name_off0 = getelementptr inbounds i8, i8* %desc, i64 12
  %name_ptr0 = bitcast i8* %name_off0 to i32*
  %name_rva0 = load i32, i32* %name_ptr0, align 4
  %name_zero0 = icmp eq i32 %name_rva0, 0
  br i1 %name_zero0, label %ret0, label %valid_desc

valid_desc:
  %has_more_desc = icmp sgt i32 %cnt, 0
  br i1 %has_more_desc, label %advance_desc, label %return_name

advance_desc:
  %cnt_next = add nsw i32 %cnt, -1
  %desc_next = getelementptr inbounds i8, i8* %desc, i64 20
  br label %desc_loop

return_name:
  %name_off = getelementptr inbounds i8, i8* %desc, i64 12
  %name_ptr = bitcast i8* %name_off to i32*
  %name_rva = load i32, i32* %name_ptr, align 4
  %name_rva64 = zext i32 %name_rva to i64
  %name_va = getelementptr inbounds i8, i8* %base, i64 %name_rva64
  ret i8* %name_va

ret0:
  ret i8* null
}