; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400E16C5()

define void @sub_140002A68() {
entry:
  call void @sub_1400E16C5()
  ret void
}