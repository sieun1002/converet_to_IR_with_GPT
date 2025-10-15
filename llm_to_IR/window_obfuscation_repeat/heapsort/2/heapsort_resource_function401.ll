; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = global i8 0, align 1

define dso_local i8* @sub_140002A10() {
entry:
  ret i8* @unk_140003050
}