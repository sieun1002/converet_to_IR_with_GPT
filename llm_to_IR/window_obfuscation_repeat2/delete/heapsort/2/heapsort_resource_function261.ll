target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}