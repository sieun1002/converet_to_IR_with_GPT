; ModuleID = 'pe_section_count'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*

define dso_local i32 @sub_140002690() {
entry:
  %baseptr = load i8*, i8** @off_1400043A0
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mzcmp = icmp eq i16 %mz, 23117
  br i1 %mzcmp, label %mz_ok, label %ret_zero

mz_ok:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew_sext
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %is_sig = icmp eq i32 %sig, 17744
  br i1 %is_sig, label %pe_ok, label %ret_zero

pe_ok:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %good, label %ret_zero

good:
  %numsec_ptr_i8 = getelementptr i8, i8* %pehdr, i64 6
  %numsec_ptr = bitcast i8* %numsec_ptr_i8 to i16*
  %numsec = load i16, i16* %numsec_ptr, align 1
  %numsec_zext = zext i16 %numsec to i32
  ret i32 %numsec_zext

ret_zero:
  ret i32 0
}