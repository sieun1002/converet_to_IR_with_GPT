; ModuleID = 'sub_1400024E0'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400024E0() local_unnamed_addr {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}