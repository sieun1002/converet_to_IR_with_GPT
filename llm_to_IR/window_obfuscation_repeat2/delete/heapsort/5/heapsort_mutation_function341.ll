; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0() nounwind naked {
entry:
  call void asm sideeffect inteldialect "push rcx\0Apush rax\0Acmp rax, 4096\0Alea rcx, [rsp+16]\0Ajb Ldone\0ALloop:\0Asub rcx, 4096\0Aor qword ptr [rcx], 0\0Asub rax, 4096\0Acmp rax, 4096\0Aja Lloop\0ALdone:\0Asub rcx, rax\0Aor qword ptr [rcx], 0\0Apop rax\0Apop rcx\0Aret", "~{dirflag},~{fpsr},~{flags}"()
  unreachable
}