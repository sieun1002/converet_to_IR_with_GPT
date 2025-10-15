; ModuleID = 'pe_check_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002750() {
entry:
  %base = load i8*, i8** @off_1400043A0, align 8
  %magic_ptr = bitcast i8* %base to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is_mz = icmp eq i16 %magic, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr.i8 = getelementptr i8, i8* %base, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %lfanew64 = sext i32 %e_lfanew to i64
  %nt_headers_ptr = getelementptr i8, i8* %base, i64 %lfanew64
  %sig_ptr = bitcast i8* %nt_headers_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %opt_magic_ptr.i8 = getelementptr i8, i8* %nt_headers_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_20b = icmp eq i16 %opt_magic, 523
  %res = select i1 %is_20b, i8* %base, i8* null
  ret i8* %res

ret_zero:
  ret i8* null
}