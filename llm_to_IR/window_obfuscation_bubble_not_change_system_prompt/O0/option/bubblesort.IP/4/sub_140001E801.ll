; ModuleID = 'sub_140001E80_ir'
target triple = "x86_64-pc-windows-msvc"

@unk_140007100 = external global i8

declare void @sub_1400DC968(i8*)
declare void @loc_1400ADE72()
declare void @loc_1403E33B2()

define void @sub_140001E80() naked {
entry:
  call void asm sideeffect inteldialect "
    push rbp
    push rdi
    push rsi
    push rbx
    sub rsp, 40
    lea rcx, [rip + unk_140007100]
    call sub_1400DC968
    mov edx, 0x441D8B48
    push rdx
    .word 0
    test rbx, rbx
    jz .Lloc_140001ED4
    pop rbp
    call loc_1400ADE72
    ror byte ptr [rax-0x75], cl
    cmp eax, 0x63B1
    nop
  .Lloc_140001EB0:
    mov ecx, dword ptr [rbx]
    call rbp
    mov rsi, rax
    call rdi
    test rsi, rsi
    jz .Lloc_140001ECB
    test eax, eax
    jnz .Lloc_140001ECB
    mov rax, qword ptr [rbx+8]
    mov rcx, rsi
    call rax
  .Lloc_140001ECB:
    mov rbx, qword ptr [rbx+16]
    test rbx, rbx
    jnz .Lloc_140001EB0
  .Lloc_140001ED4:
    lea rcx, [rip + unk_140007100]
    add rsp, 40
    pop rbx
    pop rsi
    pop rdi
    pop rbp
    push rax
    call loc_1403E33B2
  ", "~{rax},~{rbx},~{rcx},~{rdx},~{rsi},~{rdi},~{rbp},~{r8},~{r9},~{r10},~{r11},~{r12},~{r13},~{r14},~{r15},~{dirflag},~{fpsr},~{flags},~{memory}"()
  unreachable
}