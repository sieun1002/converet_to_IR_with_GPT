; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = external global i8

define dso_local i8* @sub_1400029B0() {
entry:
  ret i8* @unk_140003050
}