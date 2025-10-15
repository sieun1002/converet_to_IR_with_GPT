; ModuleID = 'pecheck'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %dos_ptr = bitcast i8* %base to i16*
  %dos_magic = load i16, i16* %dos_ptr, align 1
  %is_mz = icmp eq i16 %dos_magic, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

ret_zero:
  ret i8* null

check_pe:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pe_hdr = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %pe_hdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %opt_ptr.i8 = getelementptr i8, i8* %pe_hdr, i64 24
  %opt_ptr = bitcast i8* %opt_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_ptr, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  %result = select i1 %is_pe32p, i8* %base, i8* null
  ret i8* %result
}