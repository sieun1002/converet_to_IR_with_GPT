; ModuleID = 'pe_section_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i32 @sub_140002790(i8* %addr) local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %base_i16 = bitcast i8* %base to i16*
  %mz = load i16, i16* %base_i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %chk_pe, label %ret0

chk_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_z = zext i32 %e_lfanew to i64
  %pe_hdr = getelementptr i8, i8* %base, i64 %e_lfanew_z
  %pe_sig_ptr = bitcast i8* %pe_hdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %chk_opt, label %ret0

chk_opt:
  %opt_magic_i8 = getelementptr i8, i8* %pe_hdr, i64 24
  %opt_magic_p = bitcast i8* %opt_magic_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_p, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32p, label %cont1, label %ret0

cont1:
  %numsec_i8 = getelementptr i8, i8* %pe_hdr, i64 6
  %numsec_p = bitcast i8* %numsec_i8 to i16*
  %numsec16 = load i16, i16* %numsec_p, align 1
  %numsec_zero = icmp eq i16 %numsec16, 0
  br i1 %numsec_zero, label %ret0, label %cont2

ret0:
  ret i32 0

cont2:
  %soh_i8 = getelementptr i8, i8* %pe_hdr, i64 20
  %soh_p = bitcast i8* %soh_i8 to i16*
  %soh16 = load i16, i16* %soh_p, align 1
  %soh64 = zext i16 %soh16 to i64
  %opt_start_off = add i64 %soh64, 24
  %first_sh = getelementptr i8, i8* %pe_hdr, i64 %opt_start_off
  %addr_int = ptrtoint i8* %addr to i64
  %base_int = ptrtoint i8* %base to i64
  %rva = sub i64 %addr_int, %base_int
  %numsec32 = zext i16 %numsec16 to i32
  %numsec_minus1 = sub i32 %numsec32, 1
  %numsec_minus1_64 = zext i32 %numsec_minus1 to i64
  %x4 = shl i64 %numsec_minus1_64, 2
  %x5 = add i64 %numsec_minus1_64, %x4
  %x5x8 = shl i64 %x5, 3
  %tmp_end = getelementptr i8, i8* %first_sh, i64 %x5x8
  %end = getelementptr i8, i8* %tmp_end, i64 40
  br label %loop

loop:
  %sh_cur = phi i8* [ %first_sh, %cont2 ], [ %sh_next, %incr ]
  %va_ptr_i8 = getelementptr i8, i8* %sh_cur, i64 12
  %va_ptr = bitcast i8* %va_ptr_i8 to i32*
  %va = load i32, i32* %va_ptr, align 1
  %va64 = zext i32 %va to i64
  %ltva = icmp ult i64 %rva, %va64
  br i1 %ltva, label %incr, label %check

check:
  %vs_ptr_i8 = getelementptr i8, i8* %sh_cur, i64 8
  %vs_ptr = bitcast i8* %vs_ptr_i8 to i32*
  %vsize = load i32, i32* %vs_ptr, align 1
  %sum32 = add i32 %va, %vsize
  %sum64b = zext i32 %sum32 to i64
  %ltsum = icmp ult i64 %rva, %sum64b
  br i1 %ltsum, label %found, label %incr

incr:
  %sh_next = getelementptr i8, i8* %sh_cur, i64 40
  %done = icmp eq i8* %end, %sh_next
  br i1 %done, label %ret0, label %loop

found:
  %char_ptr_i8 = getelementptr i8, i8* %sh_cur, i64 36
  %char_ptr = bitcast i8* %char_ptr_i8 to i32*
  %ch = load i32, i32* %char_ptr, align 1
  %notch = xor i32 %ch, -1
  %shr = lshr i32 %notch, 31
  ret i32 %shr
}