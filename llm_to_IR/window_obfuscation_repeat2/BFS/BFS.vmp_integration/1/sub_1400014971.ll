; ModuleID = 'sub_140001497_module'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_140001497() naked {
entry:
  call void asm sideeffect inteldialect "push qword ptr [rsp+0x28]\0A\09popfq\0A\09lea rsp, [rsp+0x48]\0A\09ret 8", "~{dirflag},~{fpsw},~{flags},~{memory}"()
  unreachable
}