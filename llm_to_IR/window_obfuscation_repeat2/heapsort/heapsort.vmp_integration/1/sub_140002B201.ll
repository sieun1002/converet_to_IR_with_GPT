; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_14001B5ED() noreturn

define void @sub_140002B20() noreturn {
entry:
  call void @sub_14001B5ED()
  unreachable
}