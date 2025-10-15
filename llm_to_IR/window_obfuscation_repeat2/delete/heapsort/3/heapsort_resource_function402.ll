; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = dso_local global [1 x i8] zeroinitializer, align 1

define dso_local i8* @sub_140002A10() {
entry:
  %0 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140003050, i64 0, i64 0
  ret i8* %0
}