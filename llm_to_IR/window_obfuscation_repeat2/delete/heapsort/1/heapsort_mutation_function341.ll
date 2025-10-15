; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0() {
entry:
  call void asm sideeffect inteldialect "push rcx\0A\09push rax\0A\09cmp rax, 4096\0A\09lea rcx, [rsp+16]\0A\09jb .Lsmall\0A.Lloop:\0A\09sub rcx, 4096\0A\09or qword ptr [rcx], 0\0A\09sub rax, 4096\0A\09cmp rax, 4096\0A\09ja .Lloop\0A.Lsmall:\0A\09sub rcx, rax\0A\09or qword ptr [rcx], 0\0A\09pop rax\0A\09pop rcx\0A\09ret", "~{rax},~{rcx},~{rsp},~{memory},~{flags},~{dirflag},~{fpsr}"()
  unreachable
}