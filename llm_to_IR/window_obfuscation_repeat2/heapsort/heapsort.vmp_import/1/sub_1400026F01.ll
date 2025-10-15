; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_1400026F0() {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %p_dos = bitcast i8* %baseptr to i16*
  %dos_magic = load i16, i16* %p_dos, align 2
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

mz_ok:
  %p_e_lfanew_byte = getelementptr i8, i8* %baseptr, i64 60
  %p_e_lfanew = bitcast i8* %p_e_lfanew_byte to i32*
  %e_lfanew32 = load i32, i32* %p_e_lfanew, align 4
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %nt_hdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew64
  %p_sig = bitcast i8* %nt_hdr to i32*
  %sig = load i32, i32* %p_sig, align 4
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:
  %p_magic_byte = getelementptr i8, i8* %nt_hdr, i64 24
  %p_magic = bitcast i8* %p_magic_byte to i16*
  %opt_magic = load i16, i16* %p_magic, align 2
  %is_pep = icmp eq i16 %opt_magic, 523
  %res = select i1 %is_pep, i8* %baseptr, i8* null
  ret i8* %res

ret_zero:
  ret i8* null
}