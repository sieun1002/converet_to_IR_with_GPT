; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external global i8*, align 8

define i8* @sub_140002750() {
entry:
  %baseptr = load i8*, i8** @off_1400043A0, align 8
  %mzptr = bitcast i8* %baseptr to i16*
  %mz = load i16, i16* %mzptr, align 1
  %isMZ = icmp eq i16 %mz, 23117
  br i1 %isMZ, label %check_pe, label %ret_zero

check_pe:
  %e_lfanew_ptr_i8 = getelementptr i8, i8* %baseptr, i64 60
  %e_lfanew_ptr = bitcast i8* %e_lfanew_ptr_i8 to i32*
  %e_lfanew = load i32, i32* %e_lfanew_ptr, align 1
  %e_lfanew64 = sext i32 %e_lfanew to i64
  %pehdr = getelementptr i8, i8* %baseptr, i64 %e_lfanew64
  %sigptr = bitcast i8* %pehdr to i32*
  %sig = load i32, i32* %sigptr, align 1
  %isPE = icmp eq i32 %sig, 17744
  br i1 %isPE, label %check_magic, label %ret_zero

check_magic:
  %optmagicptr_i8 = getelementptr i8, i8* %pehdr, i64 24
  %optmagicptr = bitcast i8* %optmagicptr_i8 to i16*
  %optmagic = load i16, i16* %optmagicptr, align 1
  %isPE32p = icmp eq i16 %optmagic, 523
  br i1 %isPE32p, label %ret_base, label %ret_zero

ret_base:
  ret i8* %baseptr

ret_zero:
  ret i8* null
}