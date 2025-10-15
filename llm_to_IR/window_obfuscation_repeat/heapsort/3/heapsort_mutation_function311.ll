; ModuleID = 'pecheck'
source_filename = "pecheck.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %base_ptr = load i8*, i8** @off_1400043A0, align 8
  %mz_ptr = bitcast i8* %base_ptr to i16*
  %mz = load i16, i16* %mz_ptr, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

ret_zero:                                            ; preds = %entry, %mz_ok
  ret i8* null

mz_ok:                                               ; preds = %entry
  %nt_off_ptr.i8 = getelementptr inbounds i8, i8* %base_ptr, i64 60
  %nt_off_ptr = bitcast i8* %nt_off_ptr.i8 to i32*
  %nt_off = load i32, i32* %nt_off_ptr, align 1
  %nt_off_sext = sext i32 %nt_off to i64
  %nt_hdr_ptr = getelementptr inbounds i8, i8* %base_ptr, i64 %nt_off_sext
  %sig_ptr = bitcast i8* %nt_hdr_ptr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:                                               ; preds = %mz_ok
  %opt_magic_ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr_ptr, i64 24
  %opt_magic_ptr = bitcast i8* %opt_magic_ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic_ptr, align 1
  %is_pe32plus = icmp eq i16 %opt_magic, 523
  %ret_sel = select i1 %is_pe32plus, i8* %base_ptr, i8* null
  ret i8* %ret_sel
}