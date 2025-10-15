; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

declare void @loc_14002ECFB()
declare void @loc_140002A5F()

define void @sub_140002AC8() {
entry:
  call void @loc_14002ECFB()
  ret void
}