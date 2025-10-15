; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() local_unnamed_addr {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}