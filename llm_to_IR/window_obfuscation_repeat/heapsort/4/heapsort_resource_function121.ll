; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local i32 @sub_140001910() local_unnamed_addr #0 {
entry:
  ret i32 0
}

attributes #0 = { nounwind readnone willreturn }