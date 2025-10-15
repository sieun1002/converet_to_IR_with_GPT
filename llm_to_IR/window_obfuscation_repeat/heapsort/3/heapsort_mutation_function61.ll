; ModuleID = 'retn_module'
source_filename = "retn.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define void @Function() #0 {
entry:
  ret void
}

attributes #0 = { nounwind }