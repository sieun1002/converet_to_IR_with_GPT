; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_14002793A()

define void @sub_140002A60() {
entry:
  call void @sub_14002793A()
  call void asm sideeffect inteldialect "mov bh, 0x90", "~{rbx}"()
  call void asm sideeffect inteldialect "nop", ""()
  ret void
}