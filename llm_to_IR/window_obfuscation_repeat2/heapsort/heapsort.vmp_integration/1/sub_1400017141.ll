; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i8 @loc_14003521D()

define void @sub_140001714() {
entry:
  %call = call i8 @loc_14003521D()
  ret void
}