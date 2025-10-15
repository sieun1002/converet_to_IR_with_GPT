; ModuleID = 'pe_check'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002750() {
entry:
  %gptr = load i8*, i8** @off_1400043A0, align 8
  %wordptr = bitcast i8* %gptr to i16*
  %mz = load i16, i16* %wordptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

mz_ok:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %gptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %pehdr_i8 = getelementptr i8, i8* %gptr, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %pehdr_i8 to i32*
  %sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %ret_base, label %ret_zero

ret_zero:
  ret i8* null

ret_base:
  ret i8* %gptr
}