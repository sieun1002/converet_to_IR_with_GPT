; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_140121DD8()
declare void @loc_1400ED24A()

define void @sub_140001608() {
entry:
  call void @loc_140121DD8()
  call void @loc_1400ED24A()
  ret void
}