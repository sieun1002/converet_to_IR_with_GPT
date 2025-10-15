; ModuleID = 'pe_section_lookup'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_1400025B0(i8* %target) {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_zext = zext i32 %e_lfanew to i64
  %nt_headers = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_zext
  %pe_sig_ptr = bitcast i8* %nt_headers to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_headers, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %cont_headers, label %ret_null

cont_headers:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_headers, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret_null, label %have_numsec

have_numsec:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_headers, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh64 = zext i16 %soh16 to i64

  %target_i = ptrtoint i8* %target to i64
  %base_i = ptrtoint i8* %base_ptr to i64
  %rva = sub i64 %target_i, %base_i

  %opt_start = getelementptr i8, i8* %nt_headers, i64 24
  %first_section = getelementptr i8, i8* %opt_start, i64 %soh64

  %numsec32 = zext i16 %numsec16 to i32
  %numsec64 = zext i32 %numsec32 to i64
  %total_size = mul i64 %numsec64, 40
  %sections_end = getelementptr i8, i8* %first_section, i64 %total_size
  br label %loop

loop:
  %cur = phi i8* [ %first_section, %have_numsec ], [ %next, %loop_continue ]
  %done = icmp eq i8* %cur, %sections_end
  br i1 %done, label %end_not_found, label %loop_body

loop_body:
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %loop_continue, label %check_end

check_end:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize to i64
  %va_plus_vsize = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %va_plus_vsize
  br i1 %in_range, label %ret_cur, label %loop_continue

loop_continue:
  %next = getelementptr i8, i8* %cur, i64 40
  br label %loop

ret_cur:
  ret i8* %cur

end_not_found:
  ret i8* null

ret_null:
  ret i8* null
}