; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043F0 = external global i8**

define i8* @sub_140002A20() local_unnamed_addr {
entry:
  %0 = load i8**, i8*** @off_1400043F0, align 8
  %1 = load i8*, i8** %0, align 8
  ret i8* %1
}