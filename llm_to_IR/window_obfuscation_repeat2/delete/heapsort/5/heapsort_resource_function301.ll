; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_140002610(i8* %arg) {
entry:
  %base_load = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_load to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_load, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pe_hdr_ptr = getelementptr i8, i8* %base_load, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %pe_hdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %cmp_pe = icmp eq i32 %pe_sig, 17744
  br i1 %cmp_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %pe_hdr_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %cmp_magic = icmp eq i16 %magic, 523
  br i1 %cmp_magic, label %numsects, label %ret0

numsects:
  %numsec_ptr_i8 = getelementptr i8, i8* %pe_hdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  %has_secs = icmp ne i32 %numsec32, 0
  br i1 %has_secs, label %compute, label %ret0

compute:
  %opt_size_ptr_i8 = getelementptr i8, i8* %pe_hdr_ptr, i64 20
  %opt_size_ptr = bitcast i8* %opt_size_ptr_i8 to i16*
  %opt_size16 = load i16, i16* %opt_size_ptr, align 1
  %opt_size32 = zext i16 %opt_size16 to i32

  %arg_int = ptrtoint i8* %arg to i64
  %base_int = ptrtoint i8* %base_load to i64
  %rva = sub i64 %arg_int, %base_int

  %numsec_minus1 = add i32 %numsec32, 4294967295
  %mul5 = mul i32 %numsec_minus1, 5

  %opt_size64 = zext i32 %opt_size32 to i64
  %offset_first = add i64 %opt_size64, 24
  %first_sec = getelementptr i8, i8* %pe_hdr_ptr, i64 %offset_first

  %mul5_64 = zext i32 %mul5 to i64
  %mul40 = mul i64 %mul5_64, 8
  %end_offset = add i64 %mul40, 40
  %end_ptr = getelementptr i8, i8* %first_sec, i64 %end_offset

  br label %loop

loop:
  %cur = phi i8* [ %first_sec, %compute ], [ %next_sec, %advance ]

  %va_ptr_i8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %cmp_before = icmp ult i64 %rva, %va64
  br i1 %cmp_before, label %advance, label %check_range

check_range:
  %vsize_ptr_i8 = getelementptr i8, i8* %cur, i64 8
  %vsize_ptr = bitcast i8* %vsize_ptr_i8 to i32*
  %vsize32 = load i32, i32* %vsize_ptr, align 1
  %sum32 = add i32 %va32, %vsize32
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %sum64
  br i1 %in_range, label %ret0, label %advance

advance:
  %next_sec = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %next_sec, %end_ptr
  br i1 %cont, label %loop, label %final

final:
  br label %ret0

ret0:
  ret i32 0
}