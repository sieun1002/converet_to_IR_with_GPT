; ModuleID = 'pe_section_locator'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define dso_local i8* @sub_140002820(i64 %rva, i32 %count) {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %p_mz = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %p_mz, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %chk_nt, label %ret_null

chk_nt:
  %p_e_lfanew_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew_i8 to i32*
  %e_lfanew = load i32, i32* %p_e_lfanew, align 1
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_z
  %p_sig = bitcast i8* %nt to i32*
  %sig = load i32, i32* %p_sig, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %chk_magic, label %ret_null

chk_magic:
  %p_magic_i8 = getelementptr i8, i8* %nt, i64 24
  %p_magic = bitcast i8* %p_magic_i8 to i16*
  %magic = load i16, i16* %p_magic, align 1
  %magic_ok = icmp eq i16 %magic, 523
  br i1 %magic_ok, label %chk_dir, label %ret_null

chk_dir:
  %p_dir_i8 = getelementptr i8, i8* %nt, i64 144
  %p_dir = bitcast i8* %p_dir_i8 to i32*
  %dir_val = load i32, i32* %p_dir, align 1
  %dir_nz = icmp ne i32 %dir_val, 0
  br i1 %dir_nz, label %chk_sections, label %ret_null

chk_sections:
  %p_nsec_i8 = getelementptr i8, i8* %nt, i64 6
  %p_nsec = bitcast i8* %p_nsec_i8 to i16*
  %nsec16 = load i16, i16* %p_nsec, align 1
  %nsec_nz = icmp ne i16 %nsec16, 0
  br i1 %nsec_nz, label %setup_sections, label %ret_null

setup_sections:
  %p_soh_i8 = getelementptr i8, i8* %nt, i64 20
  %p_soh = bitcast i8* %p_soh_i8 to i16*
  %soh16 = load i16, i16* %p_soh, align 1
  %soh64 = zext i16 %soh16 to i64
  %after_hdr = getelementptr i8, i8* %nt, i64 24
  %first_sec = getelementptr i8, i8* %after_hdr, i64 %soh64
  %nsec64 = zext i16 %nsec16 to i64
  %sect_bytes = mul i64 %nsec64, 40
  %last_sec = getelementptr i8, i8* %first_sec, i64 %sect_bytes
  br label %sect_loop

sect_loop:
  %curr_sec = phi i8* [ %first_sec, %setup_sections ], [ %next_sec, %sect_advance ]
  %at_end = icmp eq i8* %curr_sec, %last_sec
  br i1 %at_end, label %sect_notfound, label %check_in

check_in:
  %p_va_i8 = getelementptr i8, i8* %curr_sec, i64 12
  %p_va = bitcast i8* %p_va_i8 to i32*
  %va32 = load i32, i32* %p_va, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %sect_advance, label %check_upper

check_upper:
  %p_vsz_i8 = getelementptr i8, i8* %curr_sec, i64 8
  %p_vsz = bitcast i8* %p_vsz_i8 to i32*
  %vsz32 = load i32, i32* %p_vsz, align 1
  %vsz64 = zext i32 %vsz32 to i64
  %end_rva = add i64 %va64, %vsz64
  %rva_lt_end = icmp ult i64 %rva, %end_rva
  br i1 %rva_lt_end, label %found, label %sect_advance

sect_advance:
  %next_sec = getelementptr i8, i8* %curr_sec, i64 40
  br label %sect_loop

sect_notfound:
  br label %ret_null

found:
  %data_ptr = getelementptr i8, i8* %base_ptr, i64 %rva
  br label %scan_loop

scan_loop:
  %ptr_phi = phi i8* [ %data_ptr, %found ], [ %ptr_next, %scan_iter ]
  %count_phi = phi i32 [ %count, %found ], [ %count_dec, %scan_iter ]
  %p_A_i8 = getelementptr i8, i8* %ptr_phi, i64 4
  %p_A = bitcast i8* %p_A_i8 to i32*
  %A = load i32, i32* %p_A, align 1
  %A_is_zero = icmp eq i32 %A, 0
  br i1 %A_is_zero, label %check_D, label %after_check_D

check_D:
  %p_D_i8 = getelementptr i8, i8* %ptr_phi, i64 12
  %p_D = bitcast i8* %p_D_i8 to i32*
  %D_in_zero_case = load i32, i32* %p_D, align 1
  %D_zero = icmp eq i32 %D_in_zero_case, 0
  br i1 %D_zero, label %ret_null, label %after_check_D

after_check_D:
  %count_gt0 = icmp sgt i32 %count_phi, 0
  br i1 %count_gt0, label %scan_iter, label %final_return

scan_iter:
  %count_dec = add nsw i32 %count_phi, -1
  %ptr_next = getelementptr i8, i8* %ptr_phi, i64 20
  br label %scan_loop

final_return:
  %p_D2_i8 = getelementptr i8, i8* %ptr_phi, i64 12
  %p_D2 = bitcast i8* %p_D2_i8 to i32*
  %D_val = load i32, i32* %p_D2, align 1
  %D64 = zext i32 %D_val to i64
  %ret_ptr = getelementptr i8, i8* %base_ptr, i64 %D64
  ret i8* %ret_ptr

ret_null:
  ret i8* null
}