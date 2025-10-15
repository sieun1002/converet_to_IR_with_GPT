; ModuleID: 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i8* @sub_140002750() {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pe_header = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %pe_header to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pe_header, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32p = icmp eq i16 %opt_magic, 523
  %ret_sel = select i1 %is_pe32p, i8* %base_ptr, i8* null
  ret i8* %ret_sel

ret_zero:
  ret i8* null
}