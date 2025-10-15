; ModuleID = 'sub_140002820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %count) local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %check_dir, label %ret_null

check_dir:
  %dir_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir = load i32, i32* %dir_ptr, align 1
  %has_dir = icmp ne i32 %dir, 0
  br i1 %has_dir, label %check_sections, label %ret_null

check_sections:
  %nsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %nsec_ptr = bitcast i8* %nsec_ptr_i8 to i16*
  %nsec16 = load i16, i16* %nsec_ptr, align 1
  %has_sections = icmp ne i16 %nsec16, 0
  br i1 %has_sections, label %sec_prep, label %ret_null

sec_prep:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_z = zext i16 %soh16 to i64
  %first_sec_base = getelementptr i8, i8* %nt_ptr, i64 24
  %first_sec = getelementptr i8, i8* %first_sec_base, i64 %soh_z
  %nsec64 = zext i16 %nsec16 to i64
  %nsec_bytes = mul i64 %nsec64, 40
  %end_sec = getelementptr i8, i8* %first_sec, i64 %nsec_bytes
  br label %sec_loop

sec_loop:
  %sec_cur = phi i8* [ %first_sec, %sec_prep ], [ %sec_next, %sec_continue ]
  %va_ptr_i8 = getelementptr i8, i8* %sec_cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %lt = icmp ult i64 %rva, %va64
  br i1 %lt, label %sec_continue, label %check_within

check_within:
  %vs_ptr_i8 = getelementptr i8, i8* %sec_cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vs = load i32, i32* %vs_ptr, align 1
  %vs64 = zext i32 %vs to i64
  %va_plus_size = add i64 %va64, %vs64
  %inrange = icmp ult i64 %rva, %va_plus_size
  br i1 %inrange, label %found_section, label %sec_continue

sec_continue:
  %sec_next = getelementptr i8, i8* %sec_cur, i64 40
  %done = icmp eq i8* %sec_next, %end_sec
  br i1 %done, label %ret_null, label %sec_loop

found_section:
  %rva_off = getelementptr i8, i8* %baseptr, i64 %rva
  br label %desc_loop_header

desc_loop_header:
  %cur = phi i8* [ %rva_off, %found_section ], [ %cur_next, %desc_loop_body_end ]
  %ec = phi i32 [ %count, %found_section ], [ %ec_next, %desc_loop_body_end ]
  %tstamp_ptr_i8 = getelementptr i8, i8* %cur, i64 4
  %tstamp_ptr = bitcast i8* %tstamp_ptr_i8 to i32*
  %tstamp = load i32, i32* %tstamp_ptr, align 1
  %tstamp_is_zero = icmp eq i32 %tstamp, 0
  br i1 %tstamp_is_zero, label %check_name_zero, label %after_checks

check_name_zero:
  %name_rva_ptr_i8_chk = getelementptr i8, i8* %cur, i64 12
  %name_rva_ptr_chk = bitcast i8* %name_rva_ptr_i8_chk to i32*
  %name_rva_val_chk = load i32, i32* %name_rva_ptr_chk, align 1
  %name_nonzero = icmp ne i32 %name_rva_val_chk, 0
  br i1 %name_nonzero, label %after_checks, label %ret_null

after_checks:
  %ec_pos = icmp sgt i32 %ec, 0
  br i1 %ec_pos, label %advance, label %finalize

advance:
  %ec_next = add nsw i32 %ec, -1
  %cur_next = getelementptr i8, i8* %cur, i64 20
  br label %desc_loop_body_end

desc_loop_body_end:
  br label %desc_loop_header

finalize:
  %name_rva_ptr_i8_fin = getelementptr i8, i8* %cur, i64 12
  %name_rva_ptr_fin = bitcast i8* %name_rva_ptr_i8_fin to i32*
  %name_rva_val_fin = load i32, i32* %name_rva_ptr_fin, align 1
  %name_rva64 = zext i32 %name_rva_val_fin to i64
  %result_ptr = getelementptr i8, i8* %baseptr, i64 %name_rva64
  ret i8* %result_ptr

ret_null:
  ret i8* null
}