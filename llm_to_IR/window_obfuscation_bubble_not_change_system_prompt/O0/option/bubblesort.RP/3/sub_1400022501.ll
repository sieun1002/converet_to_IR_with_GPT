; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mz_ptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %mz_eq = icmp eq i16 %mz, 23117
  br i1 %mz_eq, label %check_nt, label %ret0

check_nt:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_ptr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_eq = icmp eq i32 %sig, 17744
  br i1 %sig_eq, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %magic_eq = icmp eq i16 %magic, 523
  br i1 %magic_eq, label %check_sections, label %ret0

check_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_nonzero = icmp ne i16 %numsec16, 0
  br i1 %numsec_nonzero, label %cont, label %ret0

cont:
  %soh_ptr_i8 = getelementptr i8, i8* %nt_ptr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr_i8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %soh_zext = zext i16 %soh16 to i64
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %baseptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %nm1 = sub i32 %numsec32, 1
  %nm1_x4 = mul i32 %nm1, 4
  %sum5 = add i32 %nm1_x4, %nm1
  %offset1 = add i64 %soh_zext, 24
  %sections_base = getelementptr i8, i8* %nt_ptr, i64 %offset1
  %sum5_i64 = zext i32 %sum5 to i64
  %scaled = mul i64 %sum5_i64, 8
  %end_offset = add i64 %scaled, 40
  %end_ptr = getelementptr i8, i8* %sections_base, i64 %end_offset
  br label %loop

loop:
  %cur = phi i8* [ %sections_base, %cont ], [ %next, %loop_end ]
  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %lt1 = icmp ult i64 %rva, %va64
  br i1 %lt1, label %loop_end, label %in_range_check

in_range_check:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %lt2 = icmp ult i64 %rva, %sum64
  br i1 %lt2, label %ret0, label %loop_end

loop_end:
  %next = getelementptr i8, i8* %cur, i64 40
  %cmp_end = icmp ne i8* %next, %end_ptr
  br i1 %cmp_end, label %loop, label %exit

ret0:
  ret i32 0

exit:
  ret i32 0
}