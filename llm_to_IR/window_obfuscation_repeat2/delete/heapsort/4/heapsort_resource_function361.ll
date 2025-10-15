; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0() #0 {
entry:
  call void asm sideeffect inteldialect "push rcx; push rax; cmp rax, 0x1000; lea rcx, [rsp+0x10]; jb 2f; 1: sub rcx, 0x1000; or qword ptr [rcx], 0; sub rax, 0x1000; cmp rax, 0x1000; ja 1b; 2: sub rcx, rax; or qword ptr [rcx], 0; pop rax; pop rcx; ret", "~{rcx},~{rax},~{dirflag},~{fpsr},~{flags},~{memory}"()
  unreachable
}

attributes #0 = { naked noinline nounwind }