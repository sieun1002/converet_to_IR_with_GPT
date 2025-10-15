; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

define dso_local i32 @sub_1400024F0(i8* %ptr) local_unnamed_addr #0 {
entry:
  %p16 = bitcast i8* %ptr to i16*
  %mz = load i16, i16* %p16, align 1
  %is_mz = icmp eq i16 %mz, 23117
  br i1 %is_mz, label %check_pe, label %ret0

check_pe:
  %ptr_3c = getelementptr i8, i8* %ptr, i64 60
  %p3c32 = bitcast i8* %ptr_3c to i32*
  %e_lfanew32 = load i32, i32* %p3c32, align 1
  %e_lfanew64 = sext i32 %e_lfanew32 to i64
  %pnew = getelementptr i8, i8* %ptr, i64 %e_lfanew64
  %pnew32 = bitcast i8* %pnew to i32*
  %pesig = load i32, i32* %pnew32, align 1
  %is_pe = icmp eq i32 %pesig, 17744
  br i1 %is_pe, label %check_plus, label %ret0

check_plus:
  %magic_ptr_i8 = getelementptr i8, i8* %pnew, i64 24
  %magic_ptr = bitcast i8* %magic_ptr_i8 to i16*
  %magic_val = load i16, i16* %magic_ptr, align 1
  %is_20b = icmp eq i16 %magic_val, 523
  %res = zext i1 %is_20b to i32
  ret i32 %res

ret0:
  ret i32 0
}

attributes #0 = { nounwind uwtable "frame-pointer"="none" "target-cpu"="x86-64" }