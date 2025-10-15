; ModuleID = 'fninit_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define void @sub_1400024E0() {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}