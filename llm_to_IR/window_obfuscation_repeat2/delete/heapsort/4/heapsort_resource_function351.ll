; ModuleID = 'pe_helper'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002820(i64 %rva, i32 %idx) {
entry:
  %baseptrptr = load i8*, i8** @off_1400043A0, align 8
  %base_i16ptr = bitcast i8* %baseptrptr to i16*
  %mz = load i16, i16* %base_i16ptr, align 1
  %mz_ok = icmp eq i16 %mz, 23117
  br i1 %mz_ok, label %mz_yes, label %ret_null

ret_null:
  ret i8* null

mz_yes:
  %base_plus_3c = getelementptr i8, i8* %baseptrptr, i64 60
  %peoff_ptr = bitcast i8* %base_plus_3c to i32*
  %peoff32 = load i32, i32* %peoff_ptr, align 1
  %peoff64 = zext i32 %peoff32 to i64
  %ntptr = getelementptr i8, i8* %baseptrptr, i64 %peoff64
  %nt_sig_ptr = bitcast i8* %ntptr to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %sig_ok = icmp eq i32 %nt_sig, 17744
  br i1 %sig_ok, label %sig_yes, label %ret_null

sig_yes:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %ntptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %after_magic, label %ret_null

after_magic:
  %dir_ptr_i8 = getelementptr i8, i8* %ntptr, i64 144
  %dir_ptr = bitcast i8* %dir_ptr_i8 to i32*
  %dir_val = load i32, i32* %dir_ptr, align 1
  %dir_nonzero = icmp ne i32 %dir_val, 0
  br i1 %dir_nonzero, label %check_sections, label %ret_null

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %ntptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_zero, label %ret_null, label %have_sections

have_sections:
  %soh_ptr_i8 = getelementptr i8, i8* %ntptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh to i64
  %firstsec = getelementptr i8, i8* %ntptr, i64 24
  %section_table = getelementptr i8, i8* %firstsec, i64 %soh_zext
  %numsec_zext64 = zext i16 %numsec to i64
  %sec_table_bytes = mul i64 %numsec_zext64, 40
  %endptr = getelementptr i8, i8* %section_table, i64 %sec_table_bytes
  br label %sec_loop

sec_loop:
  %curptr_phi = phi i8* [ %section_table, %have_sections ], [ %nextsec, %sec_continue ]
  %va_ptr_i8 = getelementptr i8, i8* %curptr_phi, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %sec_advance, label %sec_check2

sec_check2:
  %srd_ptr_i8 = getelementptr i8, i8* %curptr_phi, i64 8
  %srd_ptr = bitcast i8* %srd_ptr_i8 to i32*
  %srd = load i32, i32* %srd_ptr, align 1
  %end_rva32 = add i32 %va, %srd
  %end_rva64 = zext i32 %end_rva32 to i64
  %inrange = icmp ult i64 %rva, %end_rva64
  br i1 %inrange, label %found_section, label %sec_advance

sec_advance:
  %nextsec = getelementptr i8, i8* %curptr_phi, i64 40
  %done = icmp eq i8* %nextsec, %endptr
  br i1 %done, label %not_found, label %sec_continue

sec_continue:
  br label %sec_loop

not_found:
  ret i8* null

found_section:
  %rva_plus_base = getelementptr i8, i8* %baseptrptr, i64 %rva
  br label %imp_loop

imp_loop:
  %ptr_phi = phi i8* [ %rva_plus_base, %found_section ], [ %ptr_next, %imp_continue ]
  %idx_phi = phi i32 [ %idx, %found_section ], [ %idx_dec, %imp_continue ]
  %td_ptr_i8 = getelementptr i8, i8* %ptr_phi, i64 4
  %td_ptr = bitcast i8* %td_ptr_i8 to i32*
  %tdd = load i32, i32* %td_ptr, align 1
  %tdd_is_zero = icmp eq i32 %tdd, 0
  br i1 %tdd_is_zero, label %check_name_when_zero, label %check_idx

check_name_when_zero:
  %name_ptr_i8 = getelementptr i8, i8* %ptr_phi, i64 12
  %name_ptr = bitcast i8* %name_ptr_i8 to i32*
  %name_rva_ifzero = load i32, i32* %name_ptr, align 1
  %name_zero = icmp eq i32 %name_rva_ifzero, 0
  br i1 %name_zero, label %not_found, label %check_idx

check_idx:
  %gtz = icmp sgt i32 %idx_phi, 0
  br i1 %gtz, label %imp_continue, label %return_name

imp_continue:
  %idx_dec = add nsw i32 %idx_phi, -1
  %ptr_next = getelementptr i8, i8* %ptr_phi, i64 20
  br label %imp_loop

return_name:
  %name_ptr2_i8 = getelementptr i8, i8* %ptr_phi, i64 12
  %name_ptr2 = bitcast i8* %name_ptr2_i8 to i32*
  %name_rva = load i32, i32* %name_ptr2, align 1
  %name_rva64 = zext i32 %name_rva to i64
  %name_va = getelementptr i8, i8* %baseptrptr, i64 %name_rva64
  ret i8* %name_va
}