; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define dso_local i32 @sub_140002690() local_unnamed_addr {
entry:
  %base.ptr = load i8*, i8** @off_1400043A0, align 8
  %mz.ptr = bitcast i8* %base.ptr to i16*
  %mz = load i16, i16* %mz.ptr, align 1
  %cmp.mz = icmp eq i16 %mz, 23117
  br i1 %cmp.mz, label %check_pe, label %ret_zero

check_pe:
  %elfanew.i8 = getelementptr i8, i8* %base.ptr, i64 60
  %elfanew.ptr = bitcast i8* %elfanew.i8 to i32*
  %elfanew = load i32, i32* %elfanew.ptr, align 1
  %elfanew.sext = sext i32 %elfanew to i64
  %pehdr = getelementptr i8, i8* %base.ptr, i64 %elfanew.sext
  %pesig.ptr = bitcast i8* %pehdr to i32*
  %pesig = load i32, i32* %pesig.ptr, align 1
  %is.pe = icmp eq i32 %pesig, 17744
  br i1 %is.pe, label %check_magic, label %ret_zero

check_magic:
  %magic.i8 = getelementptr i8, i8* %pehdr, i64 24
  %magic.ptr = bitcast i8* %magic.i8 to i16*
  %magic = load i16, i16* %magic.ptr, align 1
  %is.pe32plus = icmp eq i16 %magic, 523
  br i1 %is.pe32plus, label %get_sections, label %ret_zero

get_sections:
  %nsec.i8 = getelementptr i8, i8* %pehdr, i64 6
  %nsec.ptr = bitcast i8* %nsec.i8 to i16*
  %nsec = load i16, i16* %nsec.ptr, align 1
  %nsec.zext = zext i16 %nsec to i32
  ret i32 %nsec.zext

ret_zero:
  ret i32 0
}