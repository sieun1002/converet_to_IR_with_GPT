; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

@unk_140003050 = external global i8, align 1

define dso_local i8* @sub_140002A10() {
entry:
  ret i8* @unk_140003050
}