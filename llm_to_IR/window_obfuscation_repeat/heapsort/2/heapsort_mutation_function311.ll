; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %baseptrptr = load i8*, i8** @off_1400043A0, align 8
  %mzwptr = bitcast i8* %baseptrptr to i16*
  %mz = load i16, i16* %mzwptr, align 1
  %mzok = icmp eq i16 %mz, 23117
  br i1 %mzok, label %check_pe, label %ret_null

check_pe:
  %base_plus_3c = getelementptr i8, i8* %baseptrptr, i64 60
  %lfaptr = bitcast i8* %base_plus_3c to i32*
  %lfanew = load i32, i32* %lfaptr, align 1
  %lfanew_sext = sext i32 %lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptrptr, i64 %lfanew_sext
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_null

check_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_64 = icmp eq i16 %opt_magic, 523
  br i1 %is_64, label %ret_base, label %ret_null

ret_null:
  ret i8* null

ret_base:
  ret i8* %baseptrptr
}