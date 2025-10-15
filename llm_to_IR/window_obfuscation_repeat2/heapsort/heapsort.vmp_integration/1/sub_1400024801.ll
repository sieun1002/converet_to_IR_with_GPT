; ModuleID = 'sub_140002480_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_140002480() {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}