; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043A0 = external dso_local global i8*, align 8

define dso_local i8* @sub_140002750() local_unnamed_addr #0 {
entry:
  %0 = load i8*, i8** @off_1400043A0, align 8
  %1 = bitcast i8* %0 to i16*
  %2 = load i16, i16* %1, align 1
  %3 = icmp eq i16 %2, 23117
  br i1 %3, label %mz_ok, label %ret_zero

ret_zero:                                         ; preds = %entry
  ret i8* null

mz_ok:                                            ; preds = %entry
  %4 = getelementptr inbounds i8, i8* %0, i64 60
  %5 = bitcast i8* %4 to i32*
  %6 = load i32, i32* %5, align 1
  %7 = sext i32 %6 to i64
  %8 = getelementptr inbounds i8, i8* %0, i64 %7
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 1
  %11 = icmp eq i32 %10, 17744
  br i1 %11, label %pe_ok, label %ret_zero2

ret_zero2:                                        ; preds = %mz_ok
  ret i8* null

pe_ok:                                            ; preds = %mz_ok
  %12 = getelementptr inbounds i8, i8* %8, i64 24
  %13 = bitcast i8* %12 to i16*
  %14 = load i16, i16* %13, align 1
  %15 = icmp eq i16 %14, 523
  br i1 %15, label %ret_base, label %ret_zero3

ret_base:                                         ; preds = %pe_ok
  ret i8* %0

ret_zero3:                                        ; preds = %pe_ok
  ret i8* null
}

attributes #0 = { nounwind "uwtable"="true" }