; ModuleID: 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define i32 @sub_140002770() {
entry:
  %pbaseptr = load i8*, i8** @off_1400043C0, align 8
  %dos_hdr_ptr = bitcast i8* %pbaseptr to i16*
  %dos_sig = load i16, i16* %dos_hdr_ptr, align 1
  %cmp_dos = icmp eq i16 %dos_sig, 23117
  br i1 %cmp_dos, label %dos_ok, label %ret_zero

ret_zero:
  ret i32 0

dos_ok:
  %base_plus_3c = getelementptr i8, i8* %pbaseptr, i64 60
  %ptr_e_lfanew = bitcast i8* %base_plus_3c to i32*
  %e_lfanew32 = load i32, i32* %ptr_e_lfanew, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_base_i8 = getelementptr i8, i8* %pbaseptr, i64 %e_lfanew64
  %nt_sig_ptr = bitcast i8* %nt_base_i8 to i32*
  %nt_sig = load i32, i32* %nt_sig_ptr, align 1
  %cmp_pe = icmp eq i32 %nt_sig, 17744
  br i1 %cmp_pe, label %pe_ok, label %ret_zero

pe_ok:
  %opt_magic_off = getelementptr i8, i8* %nt_base_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_off to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %good, label %ret_zero

good:
  %num_sec_off = getelementptr i8, i8* %nt_base_i8, i64 6
  %num_sec_ptr = bitcast i8* %num_sec_off to i16*
  %num_sec16 = load i16, i16* %num_sec_ptr, align 1
  %num_sec32 = zext i16 %num_sec16 to i32
  ret i32 %num_sec32
}