; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @loc_1403CE1DA()
declare void @loc_140010841()

define void @sub_140002C58() {
entry:
  call void @loc_1403CE1DA()
  call void @loc_140010841()
  ret void
}