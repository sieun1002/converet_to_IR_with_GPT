; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dllimport void @exit(i32) noreturn

define dso_local i32 @sub_140001010() {
entry:
  call void @exit(i32 0)
  unreachable
}