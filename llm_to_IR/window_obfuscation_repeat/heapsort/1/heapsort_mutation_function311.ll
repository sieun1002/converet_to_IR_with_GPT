; ModuleID = 'pecheck'
source_filename = "pecheck.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %p_mz.i16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %p_mz.i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret_null

check_pe:
  %p_e_lfanew.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %p_e_lfanew.i32 = bitcast i8* %p_e_lfanew.i8 to i32*
  %e_lfanew = load i32, i32* %p_e_lfanew.i32, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt_hdr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %p_pe_sig = bitcast i8* %nt_hdr.i8 to i32*
  %pe_sig = load i32, i32* %p_pe_sig, align 1
  %is_pe = icmp eq i32 %pe_sig, 17744
  br i1 %is_pe, label %check_opt, label %ret_null

check_opt:
  %opt_magic.ptr.i8 = getelementptr inbounds i8, i8* %nt_hdr.i8, i64 24
  %opt_magic.ptr.i16 = bitcast i8* %opt_magic.ptr.i8 to i16*
  %opt_magic = load i16, i16* %opt_magic.ptr.i16, align 1
  %is_peplus = icmp eq i16 %opt_magic, 523
  %res = select i1 %is_peplus, i8* %base.ptr, i8* null
  br label %ret

ret_null:
  br label %ret

ret:
  %retval = phi i8* [ null, %ret_null ], [ %res, %check_opt ]
  ret i8* %retval
}