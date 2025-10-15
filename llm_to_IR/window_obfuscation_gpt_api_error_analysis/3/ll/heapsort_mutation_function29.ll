; ModuleID = 'pe_utils'
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %e_lfanew_ptr = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_magic, label %ret0

check_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20B = icmp eq i16 %opt_magic, 523
  br i1 %is_20B, label %read_sections, label %ret0

read_sections:
  %sec_count_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %sec_count_ptr = bitcast i8* %sec_count_ptr_i8 to i16*
  %sec_count16 = load i16, i16* %sec_count_ptr, align 1
  %sec_count32 = zext i16 %sec_count16 to i32
  ret i32 %sec_count32

ret0:
  ret i32 0
}