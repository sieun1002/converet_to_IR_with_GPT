; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140004400 = external dso_local global i32*

declare dso_local void @sub_140001010()

define dso_local void @sub_140001400() {
entry:
  %0 = load i32*, i32** @off_140004400, align 8
  store i32 0, i32* %0, align 4
  call void @sub_140001010()
  ret void
}