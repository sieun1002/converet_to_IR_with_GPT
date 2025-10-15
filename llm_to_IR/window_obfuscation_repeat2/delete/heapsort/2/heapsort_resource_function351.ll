; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002820(i32 %count) {
entry:
  %baseptrptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptrptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:                                           ; preds = %entry
  %e_lfanew_ptr = getelementptr i8, i8* %baseptrptr, i64 60
  %e_lfanew_i32p = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_i32p, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt = getelementptr i8, i8* %baseptrptr, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %nt to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_optmagic, label %ret0

check_optmagic:                                     ; preds = %check_pe
  %magic_ptr_i8 = getelementptr i8, i8* %nt, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32p = icmp eq i16 %magic, 523
  br i1 %is_pe32p, label %load_dir, label %ret0

load_dir:                                           ; preds = %check_optmagic
  %dir_ptr_i8 = getelementptr i8, i8* %nt, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %rva32 = load i32, i32* %dir_ptr, align 1
  %has_dir = icmp ne i32 %rva32, 0
  br i1 %has_dir, label %load_sections, label %ret0

load_sections:                                      ; preds = %load_dir
  %numsec_ptr_i8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %calc_firstsec

calc_firstsec:                                      ; preds = %load_sections
  %sizeopt_ptr_i8 = getelementptr i8, i8* %nt, i64 20
  %sizeopt_ptr = bitcast i8* %sizeopt_ptr_i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt_ptr, align 1
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %nt_plus_24 = getelementptr i8, i8* %nt, i64 24
  %firstsec_ptr = getelementptr i8, i8* %nt_plus_24, i64 %sizeopt64
  %nsec32 = zext i16 %numsec16 to i32
  %nsec64 = zext i32 %nsec32 to i64
  %bytes_secs = mul i64 %nsec64, 40
  %endptr = getelementptr i8, i8* %firstsec_ptr, i64 %bytes_secs
  %rva64 = zext i32 %rva32 to i64
  br label %sec_loop

sec_loop:                                           ; preds = %seek_next, %calc_firstsec
  %sec_phi = phi i8* [ %firstsec_ptr, %calc_firstsec ], [ %next_sec, %seek_next ]
  %va_ptr_i8 = getelementptr i8, i8* %sec_phi, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %vsz_ptr_i8 = getelementptr i8, i8* %sec_phi, i64 8
  %vsz_ptr = bitcast i8* %vsz_ptr_i8 to i32*
  %vsz = load i32, i32* %vsz_ptr, align 1
  %va_z = zext i32 %va to i64
  %cond_below = icmp ult i64 %rva64, %va_z
  br i1 %cond_below, label %seek_next, label %check_upper

check_upper:                                        ; preds = %sec_loop
  %sum32 = add i32 %va, %vsz
  %sum64 = zext i32 %sum32 to i64
  %cond_in = icmp ult i64 %rva64, %sum64
  br i1 %cond_in, label %found_in_section, label %seek_next

seek_next:                                          ; preds = %check_upper, %sec_loop
  %next_sec = getelementptr i8, i8* %sec_phi, i64 40
  %end_reached = icmp eq i8* %next_sec, %endptr
  br i1 %end_reached, label %ret0, label %sec_loop

found_in_section:                                   ; preds = %check_upper
  %rva_ptr_in_image = getelementptr i8, i8* %baseptrptr, i64 %rva64
  br label %desc_loop

desc_loop:                                          ; preds = %advance_desc, %found_in_section
  %desc_phi = phi i8* [ %rva_ptr_in_image, %found_in_section ], [ %next_desc, %advance_desc ]
  %count_phi = phi i32 [ %count, %found_in_section ], [ %count_dec, %advance_desc ]
  %tstamp_ptr_i8 = getelementptr i8, i8* %desc_phi, i64 4
  %tstamp_ptr = bitcast i8* %tstamp_ptr_i8 to i32*
  %tstamp = load i32, i32* %tstamp_ptr, align 1
  %tstamp_zero = icmp eq i32 %tstamp, 0
  br i1 %tstamp_zero, label %check_name_end, label %check_count

check_name_end:                                     ; preds = %desc_loop
  %name_rva_ptr_i8_0 = getelementptr i8, i8* %desc_phi, i64 12
  %name_rva_ptr_0 = bitcast i8* %name_rva_ptr_i8_0 to i32*
  %name_rva0 = load i32, i32* %name_rva_ptr_0, align 1
  %name_rva0_zero = icmp eq i32 %name_rva0, 0
  br i1 %name_rva0_zero, label %ret0, label %check_count

check_count:                                        ; preds = %check_name_end, %desc_loop
  %gt0 = icmp sgt i32 %count_phi, 0
  br i1 %gt0, label %advance_desc, label %return_name

advance_desc:                                       ; preds = %check_count
  %count_dec = add nsw i32 %count_phi, -1
  %next_desc = getelementptr i8, i8* %desc_phi, i64 20
  br label %desc_loop

return_name:                                        ; preds = %check_count
  %name_rva_ptr_i8 = getelementptr i8, i8* %desc_phi, i64 12
  %name_rva_ptr = bitcast i8* %name_rva_ptr_i8 to i32*
  %name_rva = load i32, i32* %name_rva_ptr, align 1
  %name_rva64 = zext i32 %name_rva to i64
  %name_ptr = getelementptr i8, i8* %baseptrptr, i64 %name_rva64
  ret i8* %name_ptr

ret0:                                               ; preds = %seek_next, %check_name_end, %load_sections, %load_dir, %check_optmagic, %check_pe, %entry
  ret i8* null
}