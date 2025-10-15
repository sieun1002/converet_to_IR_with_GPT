; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043F0 = external global i8*, align 8

define dso_local i64 @sub_140002A20() {
entry:
  %p = load i8*, i8** @off_1400043F0, align 8
  %pi64 = bitcast i8* %p to i64*
  %val = load i64, i64* %pi64, align 1
  ret i64 %val
}