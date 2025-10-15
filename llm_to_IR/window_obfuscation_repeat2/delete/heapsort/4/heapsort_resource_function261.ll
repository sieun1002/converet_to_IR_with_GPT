; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() #0 {
entry:
  call void asm sideeffect inteldialect "fninit", ""()
  ret void
}

attributes #0 = { nounwind }