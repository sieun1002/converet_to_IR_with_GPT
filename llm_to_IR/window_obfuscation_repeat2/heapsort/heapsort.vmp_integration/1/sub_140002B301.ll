; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1403E6204()

define void @sub_140002B30() {
entry:
  call void @sub_1403E6204()
  ret void
}