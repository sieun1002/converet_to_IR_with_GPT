; ModuleID = 'module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_14000158D() {
entry:
  %stack = alloca [112 x i8], align 16
  %ptr20.i8 = getelementptr inbounds [112 x i8], [112 x i8]* %stack, i64 0, i64 32
  %ptr20 = bitcast i8* %ptr20.i8 to i64*
  %val20 = load volatile i64, i64* %ptr20, align 8
  %add = add i64 %val20, -1073915413
  store volatile i64 %add, i64* %ptr20, align 8
  %ptr50.i8 = getelementptr inbounds [112 x i8], [112 x i8]* %stack, i64 0, i64 80
  %ptr50 = bitcast i8* %ptr50.i8 to i64*
  %val50 = load volatile i64, i64* %ptr50, align 8
  ret void
}