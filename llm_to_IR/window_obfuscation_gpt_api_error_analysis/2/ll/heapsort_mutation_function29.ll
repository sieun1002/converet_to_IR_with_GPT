target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i32 @sub_140002690() {
entry:
  %baseptr_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %baseptr_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr_i8 = getelementptr i8, i8* %baseptr_ptr, i64 %e_lfanew_sext
  %pesig_ptr = bitcast i8* %pehdr_i8 to i32*
  %pesig = load i32, i32* %pesig_ptr, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %magic_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %magic, 523
  br i1 %is_pe32plus, label %ret_sections, label %ret_zero

ret_sections:
  %sections_ptr_i8 = getelementptr i8, i8* %pehdr_i8, i64 6
  %sections_ptr = bitcast i8* %sections_ptr_i8 to i16*
  %sections16 = load i16, i16* %sections_ptr, align 1
  %sections32 = zext i16 %sections16 to i32
  ret i32 %sections32

ret_zero:
  ret i32 0
}