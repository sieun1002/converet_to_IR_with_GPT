; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@g_target_int = internal dso_local global i32 0, align 4
@off_140004400 = dso_local global i32* @g_target_int, align 8

define dso_local void @sub_140001010() {
entry:
  ret void
}

define dso_local void @sub_1400013E0() {
entry:
  %p = load i32*, i32** @off_140004400, align 8
  store i32 1, i32* %p, align 4
  call void @sub_140001010()
  ret void
}