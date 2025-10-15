; ModuleID = 'pe_import_name'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i32 %index) {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_64 = zext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_64
  %pe_sig_ptr = bitcast i8* %nthdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %isPE = icmp eq i32 %pe_sig, 17744
  br i1 %isPE, label %opt_magic, label %ret_null

opt_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nthdr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %isPE32p = icmp eq i16 %magic, 523
  br i1 %isPE32p, label %have_pe32p, label %ret_null

have_pe32p:
  %imp_rva_ptr_i8 = getelementptr i8, i8* %nthdr, i64 144
  %imp_rva_ptr = bitcast i8* %imp_rva_ptr_i8 to i32*
  %imp_rva = load i32, i32* %imp_rva_ptr, align 1
  %imp_rva_iszero = icmp eq i32 %imp_rva, 0
  br i1 %imp_rva_iszero, label %ret_null, label %cont1

cont1:
  %numsec_ptr_i8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_iszero = icmp eq i16 %numsec, 0
  br i1 %numsec_iszero, label %ret_null, label %secprep

secprep:
  %soh_ptr_i8 = getelementptr i8, i8* %nthdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %first_sec = getelementptr i8, i8* %nthdr, i64 24
  %sections = getelementptr i8, i8* %first_sec, i64 %soh_zext
  %numsec_zext32 = zext i16 %numsec to i32
  %numsec_zext64 = zext i32 %numsec_zext32 to i64
  %secsize = mul i64 %numsec_zext64, 40
  %end_sec = getelementptr i8, i8* %sections, i64 %secsize
  %imp_rva_z64 = zext i32 %imp_rva to i64
  br label %sec_loop

sec_loop:
  %cursec = phi i8* [ %sections, %secprep ], [ %nextsec, %sec_loop_inc ]
  %at_end = icmp eq i8* %cursec, %end_sec
  br i1 %at_end, label %ret_null, label %check_sec

check_sec:
  %va_ptr_i8 = getelementptr i8, i8* %cursec, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va_z64 = zext i32 %va to i64
  %vsize_ptr_i8 = getelementptr i8, i8* %cursec, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %vsize_z64 = zext i32 %vsize to i64
  %in_lower = icmp uge i64 %imp_rva_z64, %va_z64
  %end_rva = add i64 %va_z64, %vsize_z64
  %in_upper = icmp ult i64 %imp_rva_z64, %end_rva
  %in_range = and i1 %in_lower, %in_upper
  br i1 %in_range, label %found_section, label %sec_loop_inc

sec_loop_inc:
  %nextsec = getelementptr i8, i8* %cursec, i64 40
  br label %sec_loop

found_section:
  %imp_va_ptr = getelementptr i8, i8* %baseptr, i64 %imp_rva_z64
  br label %desc_loop

desc_loop:
  %desc_ptr = phi i8* [ %imp_va_ptr, %found_section ], [ %desc_next, %desc_iter ]
  %idx = phi i32 [ %index, %found_section ], [ %idx_dec, %desc_iter ]
  %tds_ptr_i8 = getelementptr i8, i8* %desc_ptr, i64 4
  %tds_ptr = bitcast i8* %tds_ptr_i8 to i32*
  %tds = load i32, i32* %tds_ptr, align 1
  %tds_is_nonzero = icmp ne i32 %tds, 0
  br i1 %tds_is_nonzero, label %check_continue, label %check_name_if_zero

check_name_if_zero:
  %name_ptr_i8_0 = getelementptr i8, i8* %desc_ptr, i64 12
  %name_ptr_0 = bitcast i8* %name_ptr_i8_0 to i32*
  %name_rva_0 = load i32, i32* %name_ptr_0, align 1
  %name_is_zero = icmp eq i32 %name_rva_0, 0
  br i1 %name_is_zero, label %ret_null, label %check_continue

check_continue:
  %idx_gt_zero = icmp sgt i32 %idx, 0
  br i1 %idx_gt_zero, label %desc_iter, label %return_name

desc_iter:
  %idx_dec = add i32 %idx, -1
  %desc_next = getelementptr i8, i8* %desc_ptr, i64 20
  br label %desc_loop

return_name:
  %name_ptr_i8 = getelementptr i8, i8* %desc_ptr, i64 12
  %name_ptr32 = bitcast i8* %name_ptr_i8 to i32*
  %name_rva = load i32, i32* %name_ptr32, align 1
  %name_rva_z64 = zext i32 %name_rva to i64
  %name_va = getelementptr i8, i8* %baseptr, i64 %name_rva_z64
  ret i8* %name_va

ret_null:
  ret i8* null
}