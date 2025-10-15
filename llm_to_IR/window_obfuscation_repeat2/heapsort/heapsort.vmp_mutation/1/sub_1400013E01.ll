; ModuleID = 'fixed'
source_filename = "fixed"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*, align 8

declare void @sub_140001010()

define void @sub_1400013E0() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %0, align 4
  call void @sub_140001010()
  ret void
}