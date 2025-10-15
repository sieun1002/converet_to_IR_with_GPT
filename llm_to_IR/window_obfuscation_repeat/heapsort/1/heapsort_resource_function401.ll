; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = dso_local global i8 0, align 1

define dso_local i8* @sub_140002A10() {
entry:
  ret i8* @unk_140003050
}