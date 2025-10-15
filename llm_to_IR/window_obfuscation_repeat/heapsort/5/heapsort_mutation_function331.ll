; ModuleID: 'pe_helper'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*

define dso_local i8* @sub_140002820(i32 %rva, i32 %index) {
entry:
  %base_ptrptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr_i8 = bitcast i8* %base_ptrptr to i16*
  %mz_val = load i16, i16* %mz_ptr_i8, align 1
  %mz_ok = icmp eq i16 %mz_val, 23117
  br i1 %mz_ok, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptrptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr = getelementptr i8, i8* %base_ptrptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %pe_ok = icmp eq i32 %pe_sig, 17744
  br i1 %pe_ok, label %check_opt, label %ret_null

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %check_dir, label %ret_null

check_dir:
  %dir_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir_val = load i32, i32* %dir_ptr, align 1
  %dir_is_zero = icmp eq i32 %dir_val, 0
  br i1 %dir_is_zero, label %ret_null, label %load_sections

load_sections:
  %num_sec_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %num_sec_ptr = bitcast i8* %num_sec_ptr_i8 to i16*
  %num_sections = load i16, i16* %num_sec_ptr, align 1
  %has_sections = icmp ne i16 %num_sections, 0
  br i1 %has_sections, label %calc_sect, label %ret_null

calc_sect:
  %size_opt_ptr_i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %size_opt_ptr = bitcast i8* %size_opt_ptr_i8 to i16*
  %size_opt = load i16, i16* %size_opt_ptr, align 1
  %size_opt_zext32 = zext i16 %size_opt to i32
  %size_opt_zext64 = zext i32 %size_opt_zext32 to i64
  %first_after_headers = getelementptr i8, i8* %nt_hdr, i64 24
  %first_section = getelementptr i8, i8* %first_after_headers, i64 %size_opt_zext64
  %num_sections_zext32 = zext i16 %num_sections to i32
  %num_sections_zext64 = zext i32 %num_sections_zext32 to i64
  %sections_size = mul i64 %num_sections_zext64, 40
  %sections_end = getelementptr i8, i8* %first_section, i64 %sections_size
  br label %sect_loop

sect_loop:
  %sect_cur = phi i8* [ %first_section, %calc_sect ], [ %sect_next, %sect_loop_cont ]
  %at_end = icmp eq i8* %sect_cur, %sections_end
  br i1 %at_end, label %ret_null, label %check_sect

check_sect:
  %va_ptr_i8 = getelementptr i8, i8* %sect_cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %sect_va = load i32, i32* %va_ptr, align 1
  %rva_zext64 = zext i32 %rva to i64
  %sect_va_zext64 = zext i32 %sect_va to i64
  %rva_ge_va = icmp uge i64 %rva_zext64, %sect_va_zext64
  br i1 %rva_ge_va, label %check_upper, label %sect_loop_cont

check_upper:
  %vsize_ptr_i8 = getelementptr i8, i8* %sect_cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %vsize_zext64 = zext i32 %vsize to i64
  %va_plus_vsize = add i64 %sect_va_zext64, %vsize_zext64
  %rva_lt_top = icmp ult i64 %rva_zext64, %va_plus_vsize
  br i1 %rva_lt_top, label %found_sect, label %sect_loop_cont

sect_loop_cont:
  %sect_next = getelementptr i8, i8* %sect_cur, i64 40
  br label %sect_loop

found_sect:
  %rva_as64 = zext i32 %rva to i64
  %desc_base = getelementptr i8, i8* %base_ptrptr, i64 %rva_as64
  br label %desc_check

desc_check:
  %desc_cur = phi i8* [ %desc_base, %found_sect ], [ %desc_next, %desc_step ]
  %count_cur = phi i32 [ %index, %found_sect ], [ %count_next, %desc_step ]
  %ts_ptr_i8 = getelementptr i8, i8* %desc_cur, i64 4
  %ts_ptr = bitcast i8* %ts_ptr_i8 to i32*
  %ts_val = load i32, i32* %ts_ptr, align 1
  %ts_nonzero = icmp ne i32 %ts_val, 0
  br i1 %ts_nonzero, label %desc_after_termcheck, label %desc_time_zero

desc_time_zero:
  %name_rva_ptr_i8 = getelementptr i8, i8* %desc_cur, i64 12
  %name_rva_ptr = bitcast i8* %name_rva_ptr_i8 to i32*
  %name_rva_val = load i32, i32* %name_rva_ptr, align 1
  %name_is_zero = icmp eq i32 %name_rva_val, 0
  br i1 %name_is_zero, label %ret_null, label %desc_after_termcheck

desc_after_termcheck:
  %count_pos = icmp sgt i32 %count_cur, 0
  br i1 %count_pos, label %desc_step, label %return_name

desc_step:
  %count_next = add i32 %count_cur, -1
  %desc_next = getelementptr i8, i8* %desc_cur, i64 20
  br label %desc_check

return_name:
  %name_rva_ptr2_i8 = getelementptr i8, i8* %desc_cur, i64 12
  %name_rva_ptr2 = bitcast i8* %name_rva_ptr2_i8 to i32*
  %name_rva_val2 = load i32, i32* %name_rva_ptr2, align 1
  %name_rva_zext64 = zext i32 %name_rva_val2 to i64
  %name_va = getelementptr i8, i8* %base_ptrptr, i64 %name_rva_zext64
  ret i8* %name_va

ret_null:
  ret i8* null
}