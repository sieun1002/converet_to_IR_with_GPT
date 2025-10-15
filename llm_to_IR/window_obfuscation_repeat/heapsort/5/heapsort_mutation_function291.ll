; ModuleID: 'pe_utils'
source_filename = "pe_utils"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr.i16 = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr.i16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %mz_ok, label %ret_zero

mz_ok:
  %e_lfanew.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 60
  %e_lfanew.ptr = bitcast i8* %e_lfanew.ptr.i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew.ptr, align 1
  %e_lfanew.sext = sext i32 %e_lfanew to i64
  %nt.ptr.i8 = getelementptr inbounds i8, i8* %base.ptr, i64 %e_lfanew.sext
  %sig.ptr = bitcast i8* %nt.ptr.i8 to i32*
  %sig = load i32, i32* %sig.ptr, align 1
  %is_pe = icmp eq i32 %sig, 17744
  br i1 %is_pe, label %pe_ok, label %ret_zero

pe_ok:
  %opt.magic.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 24
  %opt.magic.ptr = bitcast i8* %opt.magic.ptr.i8 to i16*
  %opt.magic = load i16, i16* %opt.magic.ptr, align 1
  %is_pe32plus = icmp eq i16 %opt.magic, 523
  br i1 %is_pe32plus, label %magic_ok, label %ret_zero

magic_ok:
  %numsec.ptr.i8 = getelementptr inbounds i8, i8* %nt.ptr.i8, i64 6
  %numsec.ptr = bitcast i8* %numsec.ptr.i8 to i16*
  %numsec16 = load i16, i16* %numsec.ptr, align 1
  %numsec32 = zext i16 %numsec16 to i32
  ret i32 %numsec32

ret_zero:
  ret i32 0
}