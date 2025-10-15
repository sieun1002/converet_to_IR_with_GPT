source_filename = "module"
target triple = "x86_64-pc-windows-msvc"

declare void @loc_1400387FF()

define void @sub_140002A78() {
entry:
  call void @loc_1400387FF()
  ret void
}