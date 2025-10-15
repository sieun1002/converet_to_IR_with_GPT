; ModuleID: 'pe_utils'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %cmp_mz = icmp eq i16 %mz, 23117
  br i1 %cmp_mz, label %mzhit, label %ret0

mzhit:
  %e_lfanew_ptr = getelementptr inbounds i8, i8* %baseptr, i64 60
  %e_lfanew_i32ptr = bitcast i8* %e_lfanew_ptr to i32*
  %e_lfanew_i32 = load i32, i32* %e_lfanew_i32ptr, align 1
  %e_lfanew = sext i32 %e_lfanew_i32 to i64
  %nthdr = getelementptr inbounds i8, i8* %baseptr, i64 %e_lfanew
  %sig_ptr = bitcast i8* %nthdr to i32*
  %sig = load i32, i32* %sig_ptr, align 1
  %sig_ok = icmp eq i32 %sig, 17744
  br i1 %sig_ok, label %pe_ok, label %ret0

pe_ok:
  %optmagic_ptr8 = getelementptr inbounds i8, i8* %nthdr, i64 24
  %optmagic_ptr = bitcast i8* %optmagic_ptr8 to i16*
  %optmagic = load i16, i16* %optmagic_ptr, align 1
  %is64 = icmp eq i16 %optmagic, 523
  br i1 %is64, label %get_sections, label %ret0

get_sections:
  %numsecptr8 = getelementptr inbounds i8, i8* %nthdr, i64 6
  %numsecptr = bitcast i8* %numsecptr8 to i16*
  %numsec16 = load i16, i16* %numsecptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  ret i32 %numsec32

ret0:
  ret i32 0
}