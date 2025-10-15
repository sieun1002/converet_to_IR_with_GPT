; ModuleID = 'sub_1400029C0_module'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400029C0() nounwind naked {
entry:
  call void asm sideeffect inteldialect "push rcx\0A\09push rax\0A\09cmp rax, 4096\0A\09lea rcx, [rsp+16]\0A\09jb Ldone\0A\09Lloop:\0A\09sub rcx, 4096\0A\09or qword ptr [rcx], 0\0A\09sub rax, 4096\0A\09cmp rax, 4096\0A\09ja Lloop\0A\09Ldone:\0A\09sub rcx, rax\0A\09or qword ptr [rcx], 0\0A\09pop rax\0A\09pop rcx\0A\09ret\0A", "~{dirflag},~{fpsr},~{flags},~{memory},~{rax},~{rcx}"()
  unreachable
}