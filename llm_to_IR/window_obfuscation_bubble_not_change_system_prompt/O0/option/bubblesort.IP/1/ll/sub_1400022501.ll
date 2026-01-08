; ModuleID = 'sub_140002250'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %dos_hdr_ptr = bitcast i8* %baseptr to i16*
  %mzw = load i16, i16* %dos_hdr_ptr, align 1
  %is_mz = icmp eq i16 %mzw, 23117
  br i1 %is_mz, label %after_mz, label %ret0

after_mz:
  %e_lfanew_ptr = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_i32p = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32p, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_pe_sig, label %ret0

after_pe_sig:
  %opt_magic_ptr = getelementptr i8, i8* %nt_ptr, i64 24
  %opt_magic_i16p = bitcast i8* %opt_magic_ptr to i16*
  %opt_magic = load i16, i16* %opt_magic_i16p, align 1
  %is_64 = icmp eq i16 %opt_magic, 523
  br i1 %is_64, label %check_sections, label %ret0

check_sections:
  %numsec_ptrb = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptrb to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_zero = icmp eq i16 %numsec, 0
  br i1 %numsec_zero, label %ret0, label %cont1

cont1:
  %soh_ptrb = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptrb to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh = zext i16 %soh16 to i64
  %arg_i64 = ptrtoint i8* %rcx to i64
  %base_i64 = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %arg_i64, %base_i64
  %numsec32 = zext i16 %numsec to i32
  %nminus1 = sub i32 %numsec32, 1
  %edx64 = zext i32 %nminus1 to i64
  %edx_x4 = mul i64 %edx64, 4
  %idx5 = add i64 %edx64, %edx_x4
  %sect_base_off = add i64 %soh, 24
  %sect_base = getelementptr i8, i8* %nt_ptr, i64 %sect_base_off
  %idx_bytes = mul i64 %idx5, 8
  %tmp_end = getelementptr i8, i8* %sect_base, i64 %idx_bytes
  %end_ptr = getelementptr i8, i8* %tmp_end, i64 40
  br label %loop

loop:
  %phi_cur = phi i8* [ %sect_base, %cont1 ], [ %next_ptr, %loop_next ]
  %at_end = icmp eq i8* %phi_cur, %end_ptr
  br i1 %at_end, label %final_ret, label %loop_body

loop_body:
  %va_ptrb = getelementptr i8, i8* %phi_cur, i64 12
  %va_ptr = bitcast i8* %va_ptrb to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %lt_start = icmp ult i64 %rva, %va64
  br i1 %lt_start, label %loop_next, label %check_end

check_end:
  %vsize_ptrb = getelementptr i8, i8* %phi_cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptrb to i32*
  %vsize = load i32, i32* %vsize_ptr, align 1
  %vsize64 = zext i32 %vsize to i64
  %end_va = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %end_va
  br i1 %in_range, label %ret0, label %loop_next

loop_next:
  %next_ptr = getelementptr i8, i8* %phi_cur, i64 40
  br label %loop

final_ret:
  br label %ret0

ret0:
  ret i32 0
}