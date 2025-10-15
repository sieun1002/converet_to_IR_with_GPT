; ModuleID = 'recovered'
source_filename = "recovered.ll"
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external global i32*

declare void @sub_140001010()

define void @start() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %0, align 4
  call void @sub_140001010()
  ret void
}