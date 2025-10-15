; ModuleID = 'fixed'
source_filename = "fixed"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_14002E606() noreturn

define dso_local void @sub_140002A70() {
entry:
  call void @sub_14002E606()
  unreachable
}