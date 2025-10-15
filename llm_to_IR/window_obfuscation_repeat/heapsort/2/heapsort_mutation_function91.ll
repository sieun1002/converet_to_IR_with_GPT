; ModuleID = 'module'
source_filename = "module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@dword_140007030 = internal global i32 0, align 4

declare void @sub_140001870()

define void @sub_1400018F0() {
entry:
  %g = load i32, i32* @dword_140007030, align 4
  %iszero = icmp eq i32 %g, 0
  br i1 %iszero, label %do_init, label %ret

do_init:
  store i32 1, i32* @dword_140007030, align 4
  tail call void @sub_140001870()
  ret void

ret:
  ret void
}