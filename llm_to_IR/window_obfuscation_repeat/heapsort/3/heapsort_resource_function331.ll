; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %mzok = icmp eq i16 %mz, 23117
  br i1 %mzok, label %check_pe, label %ret_null

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew32 = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew64
  %pe_sig_ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pe_sig_ptr, align 1
  %peok = icmp eq i32 %pesig, 17744
  br i1 %peok, label %check_magic, label %ret_null

check_magic:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %res = select i1 %is_pe32plus, i8* %baseptr, i8* null
  ret i8* %res

ret_null:
  ret i8* null
}