; ModuleID = 'handler'
source_filename = "handler"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @Handler() #0 {
entry:
  ret void
}

attributes #0 = { nounwind }