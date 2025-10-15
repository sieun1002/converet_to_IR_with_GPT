; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_14010B448()

define void @sub_1400016BA() {
entry:
  call void asm sideeffect inteldialect "mov qword ptr [rsp], 0x5857FAA8", "~{memory},~{dirflag},~{fpsr},~{flags}"()
  call void @loc_14010B448()
  ret void
}