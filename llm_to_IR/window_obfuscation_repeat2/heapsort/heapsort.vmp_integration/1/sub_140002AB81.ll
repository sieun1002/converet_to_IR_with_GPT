; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_14000DC43()

define void @sub_140002AB8() {
entry:
  call void @loc_14000DC43()
  ret void
}