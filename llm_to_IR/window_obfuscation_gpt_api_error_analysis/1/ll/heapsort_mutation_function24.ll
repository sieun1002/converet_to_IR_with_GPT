; ModuleID = 'sub_1400024E0'
define void @sub_1400024E0() {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}