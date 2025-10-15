; target: Windows x86-64 PE checks
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002750() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr_i16p = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mzptr_i16p, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %base_ptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew_sext = sext i32 %e_lfanew to i64
  %nt_hdr_ptr = getelementptr i8, i8* %base_ptr, i64 %e_lfanew_sext
  %pe_sig_ptr = bitcast i8* %nt_hdr_ptr to i32*
  %pe_sig = load i32, i32* %pe_sig_ptr, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_zero

check_opt:
  %opt_magic_ptr_i8 = getelementptr i8, i8* %nt_hdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr_i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  br i1 %is_pe32plus, label %ret_base, label %ret_zero

ret_zero:
  ret i8* null

ret_base:
  ret i8* %base_ptr
}