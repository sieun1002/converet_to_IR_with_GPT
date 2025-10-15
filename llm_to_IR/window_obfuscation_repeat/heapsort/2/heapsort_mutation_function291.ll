; ModuleID = 'pecheck'
source_filename = "pecheck.ll"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002690() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mzptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %after_mz, label %ret_zero

after_mz:
  %e_lfanew_ptr = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr32 = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_ptr32, align 1
  %e_lfanew_i64 = sext i32 %e_lfanew_i32 to i64
  %nt_header_ptr = getelementptr i8, i8* %base, i64 %e_lfanew_i64
  %sig_ptr32 = bitcast i8* %nt_header_ptr to i32*
  %sig = load i32, i32* %sig_ptr32, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %after_sig, label %ret_zero

after_sig:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_header_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret_zero

get_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_header_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec_i16 = load i16, i16* %numsec_ptr, align 1
  %numsec = zext i16 %numsec_i16 to i32
  ret i32 %numsec

ret_zero:
  ret i32 0
}