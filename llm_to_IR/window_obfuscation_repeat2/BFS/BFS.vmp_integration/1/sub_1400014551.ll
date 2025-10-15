; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400EC546()
declare void @sub_1403CAB43()

define dso_local void @sub_140001455() {
entry:
  call void @sub_1400EC546()
  call void @sub_1403CAB43()
  ret void
}