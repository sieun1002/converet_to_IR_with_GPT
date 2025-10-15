; ModuleID = 'stack_probe'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0() nounwind {
entry:
  call void asm sideeffect inteldialect "
    push rcx
    push rax
    cmp rax, 4096
    lea rcx, [rsp+16]
    jb 2f
  1:
    sub rcx, 4096
    or qword ptr [rcx], 0
    sub rax, 4096
    cmp rax, 4096
    ja 1b
  2:
    sub rcx, rax
    or qword ptr [rcx], 0
    pop rax
    pop rcx
  ", "~{memory},~{dirflag},~{fpsr},~{flags}"()
  ret void
}