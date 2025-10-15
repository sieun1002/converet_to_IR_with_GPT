; ModuleID = 'Function'
source_filename = "Function"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

define dso_local void @Function() local_unnamed_addr #0 {
entry:
  ret void
}

attributes #0 = { nounwind uwtable }