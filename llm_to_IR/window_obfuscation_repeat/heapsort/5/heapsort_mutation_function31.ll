; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@g_storage = internal global i32 0, align 4
@off_140004400 = global i32* @g_storage, align 8

declare void @sub_140001010()

define void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}