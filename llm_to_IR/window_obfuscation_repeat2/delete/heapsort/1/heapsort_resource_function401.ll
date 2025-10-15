; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = external global i8

define i8* @sub_140002A10() {
entry:
  ret i8* @unk_140003050
}