target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define dso_local i32 @sub_1400023D0(i8* %rcx) {
entry:
  %base.ptr = load i8*, i8** @off_1400043C0, align 8
  %dos_hdr_ptr = bitcast i8* %base.ptr to i16*
  %dos_magic = load i16, i16* %dos_hdr_ptr, align 1
  %cmp_mz = icmp eq i16 %dos_magic, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew.ptr.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %base.ptr, i64 %e_lfanew64
  %pe_sig.ptr = bitcast i8* %nt_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig.ptr, align 1
  %cmp_pe = icmp eq i32 %pe_sig, 17744
  br i1 %cmp_pe, label %check_magic, label %ret0

check_magic:
  %magic.ptr.i8 = getelementptr i8, i8* %nt_hdr, i64 24
  %magic.ptr = bitcast i8* %magic.ptr.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret0

get_sections:
  %nsec.ptr.i8 = getelementptr i8, i8* %nt_hdr, i64 6
  %nsec.ptr = bitcast i8* %nsec.ptr.i8 to i16*
  %nsec16 = load i16, i16* %nsec.ptr, align 1
  %nsec_zero = icmp eq i16 %nsec16, 0
  br i1 %nsec_zero, label %ret0, label %after_nsec

after_nsec:
  %sizeopt.ptr.i8 = getelementptr i8, i8* %nt_hdr, i64 20
  %sizeopt.ptr = bitcast i8* %sizeopt.ptr.i8 to i16*
  %sizeopt16 = load i16, i16* %sizeopt.ptr, align 1
  %rcx_int = ptrtoint i8* %rcx to i64
  %base_int = ptrtoint i8* %base.ptr to i64
  %rva = sub i64 %rcx_int, %base_int
  %nsec32 = zext i16 %nsec16 to i32
  %nsec_m1 = sub i32 %nsec32, 1
  %nsec_m1_64 = zext i32 %nsec_m1 to i64
  %mul5 = mul i64 %nsec_m1_64, 5
  %first_sect_base = getelementptr i8, i8* %nt_hdr, i64 24
  %sizeopt64 = zext i16 %sizeopt16 to i64
  %first_sect = getelementptr i8, i8* %first_sect_base, i64 %sizeopt64
  %mul5x8 = shl i64 %mul5, 3
  %end_off = add i64 %mul5x8, 40
  %end_ptr = getelementptr i8, i8* %first_sect, i64 %end_off
  br label %loop

loop:
  %cur = phi i8* [ %first_sect, %after_nsec ], [ %next, %advance ]
  %va.ptr.i8 = getelementptr i8, i8* %cur, i64 12
  %va.ptr = bitcast i8* %va.ptr.i8 to i32*
  %va32 = load i32, i32* %va.ptr, align 1
  %va64 = zext i32 %va32 to i64
  %rva_before_va = icmp ult i64 %rva, %va64
  br i1 %rva_before_va, label %advance, label %check_within

check_within:
  %vsz.ptr.i8 = getelementptr i8, i8* %cur, i64 8
  %vsz.ptr = bitcast i8* %vsz.ptr.i8 to i32*
  %vsz32 = load i32, i32* %vsz.ptr, align 1
  %sum32 = add i32 %va32, %vsz32
  %sum64 = zext i32 %sum32 to i64
  %in_range = icmp ult i64 %rva, %sum64
  br i1 %in_range, label %found, label %advance

advance:
  %next = getelementptr i8, i8* %cur, i64 40
  %cont = icmp ne i8* %next, %end_ptr
  br i1 %cont, label %loop, label %ret0

found:
  %ch.ptr.i8 = getelementptr i8, i8* %cur, i64 36
  %ch.ptr = bitcast i8* %ch.ptr.i8 to i32*
  %chars = load i32, i32* %ch.ptr, align 1
  %notchars = xor i32 %chars, -1
  %res = lshr i32 %notchars, 31
  ret i32 %res

ret0:
  ret i32 0
}