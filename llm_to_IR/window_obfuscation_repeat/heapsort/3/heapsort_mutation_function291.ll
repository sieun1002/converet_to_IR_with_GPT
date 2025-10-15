; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 2
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 4
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pesig_ptr = bitcast i8* %nt_hdr_ptr to i32*
  %pesig = load i32, i32* %pesig_ptr, align 4
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 2
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %get_sections, label %ret0

get_sections:
  %numsec_ptr_i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec16 = load i16, i16* %numsec_ptr, align 2
  %numsec32 = zext i16 %numsec16 to i32
  ret i32 %numsec32

ret0:
  ret i32 0
}