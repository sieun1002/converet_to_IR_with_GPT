; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140029DBE()
declare void @sub_1403D1A2B()

define void @sub_140002BF8() {
entry:
  call void @sub_140029DBE()
  call void @sub_1403D1A2B()
  ret void
}