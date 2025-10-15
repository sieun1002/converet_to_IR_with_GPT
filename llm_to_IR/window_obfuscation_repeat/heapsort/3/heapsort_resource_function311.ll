; ModuleID = 'pe_sections.ll'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*

define i32 @sub_140002690() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_i8 = getelementptr i8, i8* %base, i64 %e_lfanew_sext
  %sig_ptr = bitcast i8* %pehdr_i8 to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %cmp_sig = icmp eq i32 %sig, 17744
  br i1 %cmp_sig, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %cmp_magic = icmp eq i16 %magic, 523
  br i1 %cmp_magic, label %get_sections, label %ret0

get_sections:
  %num_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 6
  %num_ptr = bitcast i8* %num_ptr_i8 to i16*
  %num = load i16, i16* %num_ptr, align 1
  %zext = zext i16 %num to i32
  ret i32 %zext

ret0:
  ret i32 0
}