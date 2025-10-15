; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_1400043F0 = external global i8*

define i8* @sub_140002A20() {
entry:
  %0 = load i8*, i8** @off_1400043F0, align 8
  %1 = bitcast i8* %0 to i8**
  %2 = load i8*, i8** %1, align 8
  ret i8* %2
}