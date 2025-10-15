; ModuleID = 'pe_checks'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002630() {
entry:
  %p_ptr = load i8*, i8** @off_1400043A0, align 8
  %p_i16ptr = bitcast i8* %p_ptr to i16*
  %mz = load i16, i16* %p_i16ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %p_plus_60 = getelementptr i8, i8* %p_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %p_plus_60 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %p_int = ptrtoint i8* %p_ptr to i64
  %nt_int = add i64 %p_int, %e_lfanew_sext
  %nt_ptr = inttoptr i64 %nt_int to i8*
  %nt_i32ptr = bitcast i8* %nt_ptr to i32*
  %sig = load i32, i32* %nt_i32ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_magic, label %ret_zero

check_magic:
  %nt_plus_24 = getelementptr i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %nt_plus_24 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pep = icmp eq i16 %magic, 523
  br i1 %is_pep, label %ret_sections, label %ret_zero

ret_sections:
  %nt_plus_6 = getelementptr i8, i8* %nt_ptr, i64 6
  %sections_ptr = bitcast i8* %nt_plus_6 to i16*
  %sections = load i16, i16* %sections_ptr, align 1
  %zext = zext i16 %sections to i32
  ret i32 %zext

ret_zero:
  ret i32 0
}