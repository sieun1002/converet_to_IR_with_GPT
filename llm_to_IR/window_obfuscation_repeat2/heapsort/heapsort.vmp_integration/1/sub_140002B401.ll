; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @loc_1400F2138() noreturn

define void @sub_140002B40() {
entry:
  call void @loc_1400F2138()
  unreachable
}