target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*

define dso_local i32 @sub_140002250(i8* %rcx) {
entry:
  %base = load i8*, i8** @off_1400043C0, align 8
  %base_i16p = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16p, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %p3c = getelementptr i8, i8* %base, i64 60
  %p3c_i32p = bitcast i8* %p3c to i32*
  %e_lfanew = load i32, i32* %p3c_i32p, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %nt_i32p = bitcast i8* %nt to i32*
  %sig = load i32, i32* %nt_i32p, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret0

check_opt:
  %opt_magic_ptr8 = getelementptr i8, i8* %nt, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20b = icmp eq i16 %opt_magic, 523
  br i1 %is_20b, label %cont1, label %ret0

cont1:
  %numsec_ptr8 = getelementptr i8, i8* %nt, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 1
  %numsec_is_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_is_zero, label %ret0, label %cont2

cont2:
  %soh_ptr8 = getelementptr i8, i8* %nt, i64 20
  %soh_ptr = bitcast i8* %soh_ptr8 to i16*
  %soh16 = load i16, i16* %soh_ptr, align 1
  %p_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base to i64
  %rva = sub i64 %p_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %nm1 = sub i32 %numsec32, 1
  %mul5 = mul i32 %nm1, 5
  %mul5_z = zext i32 %mul5 to i64
  %off_bytes = mul i64 %mul5_z, 8
  %soh32 = zext i16 %soh16 to i32
  %soh64 = zext i32 %soh32 to i64
  %sect0_base = getelementptr i8, i8* %nt, i64 24
  %sect0 = getelementptr i8, i8* %sect0_base, i64 %soh64
  %add40 = add i64 %off_bytes, 40
  %end = getelementptr i8, i8* %sect0, i64 %add40
  br label %loop

loop:
  %cur = phi i8* [ %sect0, %cont2 ], [ %next, %advance ]
  %va_ptr8 = getelementptr i8, i8* %cur, i64 12
  %va_ptr = bitcast i8* %va_ptr8 to i32*
  %va32 = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_lt_va = icmp ult i64 %rva, %va64
  br i1 %rva_lt_va, label %advance, label %check_range

check_range:
  %vsz_ptr8 = getelementptr i8, i8* %cur, i64 8
  %vsz_ptr = bitcast i8* %vsz_ptr8 to i32*
  %vsz32 = load i32, i32* %vsz_ptr, align 1
  %sum32 = add i32 %va32, %vsz32
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %sum64
  br i1 %in_range, label %ret0, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %done = icmp eq i8* %next, %end
  br i1 %done, label %exit, label %loop

exit:
  br label %ret0

ret0:
  ret i32 0
}