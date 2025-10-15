; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_140010D34()

define void @sub_1400016B5() {
entry:
  call void @loc_140010D34()
  ret void
}