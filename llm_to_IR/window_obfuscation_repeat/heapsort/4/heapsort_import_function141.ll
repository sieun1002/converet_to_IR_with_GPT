; ModuleID = 'pe_section_check'
source_filename = "pe_section_check.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002610(i8* %p) local_unnamed_addr {
entry:
  %baseaddr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseaddr to i16*
  %mz = load i16, i16* %mzptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr8 = getelementptr i8, i8* %baseaddr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr = getelementptr i8, i8* %baseaddr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nthdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 4
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr8 = getelementptr i8, i8* %nthdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %sec_count, label %ret0

sec_count:
  %numsec_ptr8 = getelementptr i8, i8* %nthdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %have_secs

have_secs:
  %soh_ptr8 = getelementptr i8, i8* %nthdr, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 2
  %soh_zext = zext i16 %soh16 to i64
  %p_int = ptrtoint i8* %p to i64
  %base_int = ptrtoint i8* %baseaddr to i64
  %rva = sub i64 %p_int, %base_int
  %firstsec_pre = getelementptr i8, i8* %nthdr, i64 24
  %firstsec = getelementptr i8, i8* %firstsec_pre, i64 %soh_zext
  %numsec_zext = zext i16 %numsec16 to i64
  %total_size = mul i64 %numsec_zext, 40
  %endptr = getelementptr i8, i8* %firstsec, i64 %total_size
  br label %loop

loop:
  %cur = phi i8* [ %firstsec, %have_secs ], [ %next, %loop_end_or_cont ]
  %va_ptr8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr8 to i32*
  %va32 = load i32, i32* %va_ptr, align 4
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check_range

advance:
  br label %loop_end_or_cont

check_range:
  %vsize_ptr8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 4
  %vsize64 = zext i32 %vsize32 to i64
  %end_va = add i64 %va64, %vsize64
  %in_range = icmp ult i64 %rva, %end_va
  br i1 %in_range, label %ret0, label %advance

loop_end_or_cont:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %endptr
  br i1 %done, label %ret0_after, label %loop

ret0:
  ret i32 0

ret0_after:
  ret i32 0
}