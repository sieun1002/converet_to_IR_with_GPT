; ModuleID = 'pe_section_count'
target triple = "x86_64-pc-windows-msvc"

@off_1400043C0 = external global i8*, align 8

define dso_local i32 @sub_140002770() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043C0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nthdr_i8 = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %nthdr_i8 to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret0

check_magic:
  %oh_magic_i8 = getelementptr i8, i8* %nthdr_i8, i64 24
  %oh_magic_ptr = bitcast i8* %oh_magic_i8 to i16*
  %oh_magic = load i16, i16* %oh_magic_ptr, align 1
  %cmp_magic = icmp eq i16 %oh_magic, 523
  br i1 %cmp_magic, label %get_sections, label %ret0

get_sections:
  %nos_i8 = getelementptr i8, i8* %nthdr_i8, i64 6
  %nos_ptr = bitcast i8* %nos_i8 to i16*
  %nos = load i16, i16* %nos_ptr, align 1
  %nos_zext = zext i16 %nos to i32
  ret i32 %nos_zext

ret0:
  ret i32 0
}