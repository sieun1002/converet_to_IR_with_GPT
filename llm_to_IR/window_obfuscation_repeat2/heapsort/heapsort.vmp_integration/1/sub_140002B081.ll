; ModuleID = 'sub_140002B08_module'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1400D715D()

define void @sub_140002B08() {
entry:
  call void @sub_1400D715D()
  call void asm sideeffect inteldialect "adc dword ptr [rax+0x68E85690], 0x90000FC2", "~{dirflag},~{fpsr},~{flags},~{memory}"()
  call void asm sideeffect inteldialect "nop", "~{dirflag},~{fpsr},~{flags}"()
  call void asm sideeffect inteldialect "nop dword ptr [rax+rax+0]", "~{dirflag},~{fpsr},~{flags},~{memory}"()
  ret void
}