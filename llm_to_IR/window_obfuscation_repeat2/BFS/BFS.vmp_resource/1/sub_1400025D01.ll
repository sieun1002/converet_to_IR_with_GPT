; ModuleID = 'pe_check_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i8 @sub_1400025D0(i8* %rcx) {
entry:
  %mzptr = bitcast i8* %rcx to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %check_pe, label %ret0

ret0:
  ret i8 0

check_pe:
  %lfanew_ptr_i8 = getelementptr inbounds i8, i8* %rcx, i64 60
  %lfanew_ptr = bitcast i8* %lfanew_ptr_i8 to i32*
  %lfanew32 = load i32, i32* %lfanew_ptr, align 1
  %lfanew64 = sext i32 %lfanew32 to i64
  %nt_ptr = getelementptr inbounds i8, i8* %rcx, i64 %lfanew64
  %nt_ptr32 = bitcast i8* %nt_ptr to i32*
  %pe_sig = load i32, i32* %nt_ptr32, align 1
  %cmp_pe = icmp eq i32 %pe_sig, 17744
  br i1 %cmp_pe, label %check_magic, label %ret0

check_magic:
  %magic_ptr_i8 = getelementptr inbounds i8, i8* %nt_ptr, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic = load i16, i16* %magic_ptr, align 1
  %is64 = icmp eq i16 %magic, 523
  %res = select i1 %is64, i8 1, i8 0
  ret i8 %res
}