; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_14004260F()
declare void @sub_1400458D8(i64)

define void @sub_140002C48() {
entry:
  %0 = call i64 @sub_14004260F()
  call void @sub_1400458D8(i64 %0)
  ret void
}