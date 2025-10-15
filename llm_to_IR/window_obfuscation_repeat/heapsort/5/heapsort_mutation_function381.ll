; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@unk_140003050 = external global i8

define i8* @sub_140002A10() {
entry:
  ret i8* @unk_140003050
}