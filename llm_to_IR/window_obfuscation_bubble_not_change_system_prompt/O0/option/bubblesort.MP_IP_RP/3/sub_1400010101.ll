; ModuleID = 'sub_140001010_module'
target triple = "x86_64-pc-windows-msvc"

@off_140004470 = external global i8*
@qword_140008280 = external global i8*
@off_140004480 = external global i32*
@dword_140007004 = external global i32
@off_1400043F0 = external global i8*
@qword_140007010 = external global i8*
@dword_140007020 = external global i32
@qword_140007018 = external global i8*
@off_140004430 = external global i32*
@off_140004440 = external global i32*
@off_140004450 = external global i32*
@off_1400043C0 = external global i8*
@dword_140007008 = external global i32
@off_140004420 = external global i32*
@off_140004460 = external global i8*
@off_1400044A0 = external global i8*
@off_140004490 = external global i8*

declare void @sub_140002660()
declare void @sub_140002880()
declare void @sub_140002790()
declare void @sub_140002120()
declare void @sub_140002720()
declare void @sub_140002670()
declare void @sub_1400027B8()
declare void @sub_140002700()
declare void @sub_1400027F8()
declare void @sub_140002780()
declare void @sub_1400018D0()
declare void @sub_14000AA1D()
declare void @sub_140001CB0()
declare void @nullsub_1()
declare void @loc_140002775()

define dso_local void @sub_140001010() naked {
entry:
  call void asm sideeffect inteldialect "
    push    r15
    push    r14
    push    r13
    push    r12
    push    rbp
    push    rdi
    push    rsi
    push    rbx
    sub     rsp, 58h
    mov     eax, 30h
    mov     rax, qword ptr gs:[rax]
    mov     rsi, qword ptr [rax+8]
    mov     rbx, qword ptr [rip + off_140004470]
    mov     rdi, qword ptr [rip + qword_140008280]
    jmp     short loc_140001050
loc_140001040:
    cmp     rsi, rax
    jz      loc_140001100
    mov     ecx, 3E8h
    call    rdi
loc_140001050:
    xor     eax, eax
    lock cmpxchg qword ptr [rbx], rsi
    jnz     short loc_140001040
    xor     r14d, r14d
    mov     rbp, qword ptr [rip + off_140004480]
    mov     eax, dword ptr [rbp+0]
    cmp     eax, 1
    jz      loc_1400013C8
    mov     eax, dword ptr [rbp+0]
    test    eax, eax
    jz      loc_140001110
    mov     dword ptr [rip + dword_140007004], 1
    test    r14d, r14d
    jz      loc_140001328
    mov     rax, qword ptr [rip + off_1400043F0]
    mov     rax, qword ptr [rax]
    test    rax, rax
    jz      short loc_1400010A8
    xor     r8d, r8d
    mov     edx, 2
    xor     ecx, ecx
    call    rax
loc_1400010A8:
    call    sub_140002660
    mov     r8, qword ptr [rip + qword_140007010]
    mov     ecx, dword ptr [rip + dword_140007020]
    mov     qword ptr [rax], r8
    mov     rdx, qword ptr [rip + qword_140007018]
    call    sub_140002880
loc_140001100:
    mov     r14d, 1
    jmp     loc_14000105C
loc_14000105C:
    mov     rbp, qword ptr [rip + off_140004480]
    mov     eax, dword ptr [rbp+0]
    cmp     eax, 1
    jz      loc_1400013C8
    mov     eax, dword ptr [rbp+0]
    test    eax, eax
    jz      loc_140001110
    mov     dword ptr [rip + dword_140007004], 1
    test    r14d, r14d
    jz      loc_140001328
    mov     rax, qword ptr [rip + off_1400043F0]
    mov     rax, qword ptr [rax]
    test    rax, rax
    jz      short loc_1400010A8_dup
    xor     r8d, r8d
    mov     edx, 2
    xor     ecx, ecx
    call    rax
loc_1400010A8_dup:
    call    sub_140002660
    mov     r8, qword ptr [rip + qword_140007010]
    mov     ecx, dword ptr [rip + dword_140007020]
    mov     qword ptr [rax], r8
    mov     rdx, qword ptr [rip + qword_140007018]
    call    sub_140002880
    jmp     loc_140001100
loc_140001110:
    mov     dword ptr [rbp+0], 1
    call    sub_1400018D0
    lea     rcx, [rip + sub_140001CB0]
    push    rsi
    call    sub_14000AA1D
    mov     rdx, qword ptr [rip + off_140004460]
    lea     rcx, [rip + nullsub_1]
    mov     qword ptr [rdx], rax
    call    sub_140002790
    call    sub_140002120
    mov     rax, qword ptr [rip + off_140004430]
    xor     ecx, ecx
    mov     dword ptr [rax], 1
    mov     rax, qword ptr [rip + off_140004440]
    mov     dword ptr [rax], 1
    mov     rax, qword ptr [rip + off_140004450]
    mov     dword ptr [rax], 1
    mov     rax, qword ptr [rip + off_1400043C0]
    cmp     word ptr [rax], 5A4Dh
    jnz     short loc_1400011C0
    movsxd  rdx, dword ptr [rax+3Ch]
    add     rax, rdx
    cmp     dword ptr [rax], 4550h
    jnz     short loc_1400011C0
    movzx   edx, word ptr [rax+18h]
    cmp     dx, 10Bh
    jz      loc_1400013AA
    cmp     dx, 20Bh
    jnz     short loc_1400011C0
    cmp     dword ptr [rax+84h], 0Eh
    jbe     short loc_1400011C0
    mov     r9d, dword ptr [rax+0F8h]
    xor     ecx, ecx
    test    r9d, r9d
    setnz   cl
    nop     dword ptr [rax+rax+00000000h]
loc_1400011C0:
    mov     rax, qword ptr [rip + off_140004420]
    mov     dword ptr [rip + dword_140007008], ecx
    mov     r8d, dword ptr [rax]
    test    r8d, r8d
    jnz     loc_140001338
    mov     ecx, 1
    call    loc_140002775+3
loc_1400011E3:
    call    sub_140002720
loc_1400012C8:
    mov     rdx, qword ptr [r15+rsi*8-8]
    mov     r8, rdi
    mov     rcx, rax
    call    sub_1400027B8
    cmp     r12, rsi
    jz      short loc_140001347
    add     rsi, 1
    mov     rcx, qword ptr [r15+rsi*8-8]
    call    sub_140002700
    lea     rdi, [rax+1]
    mov     rcx, rdi
    call    sub_1400027F8
    mov     qword ptr [r13+rsi*8-8], rax
    test    rax, rax
    jnz     short loc_1400012C8
    mov     ecx, 8
    call    sub_140002670
loc_140001328:
    xor     eax, eax
    xchg    rax, qword ptr [rbx]
    jmp     loc_14000108D
loc_14000108D:
    mov     rax, qword ptr [rip + off_1400043F0]
    mov     rax, qword ptr [rax]
    test    rax, rax
    jz      short loc_1400010A8_tail
    xor     r8d, r8d
    mov     edx, 2
    xor     ecx, ecx
    call    rax
loc_1400010A8_tail:
    call    sub_140002660
    mov     r8, qword ptr [rip + qword_140007010]
    mov     ecx, dword ptr [rip + dword_140007020]
    mov     qword ptr [rax], r8
    mov     rdx, qword ptr [rip + qword_140007018]
    call    sub_140002880
    jmp     loc_140001100
loc_140001338:
    mov     ecx, 2
    call    loc_140002775+3
    jmp     loc_1400011E3
loc_140001347:
    lea     rax, [r13+r12*8+0]
    mov     qword ptr [rax], 0
    mov     rdx, qword ptr [rip + off_1400044A0]
    mov     rcx, qword ptr [rip + off_140004490]
    mov     qword ptr [rip + qword_140007018], r13
    call    sub_140002780
loc_1400013AA:
    cmp     dword ptr [rax+74h], 0Eh
    jbe     loc_1400011C0
    mov     r10d, dword ptr [rax+0E8h]
    xor     ecx, ecx
    test    r10d, r10d
    setnz   cl
    jmp     loc_1400011C0
loc_1400013C8:
    mov     ecx, 1Fh
    call    sub_140002670

    add     rsp, 58h
    pop     rbx
    pop     rsi
    pop     rdi
    pop     rbp
    pop     r12
    pop     r13
    pop     r14
    pop     r15
    ret
  ", "~{rax},~{rbx},~{rcx},~{rdx},~{rsi},~{rdi},~{rbp},~{r8},~{r9},~{r10},~{r11},~{r12},~{r13},~{r14},~{r15},~{dirflag},~{fpsr},~{flags},~{memory}"()
  unreachable
}