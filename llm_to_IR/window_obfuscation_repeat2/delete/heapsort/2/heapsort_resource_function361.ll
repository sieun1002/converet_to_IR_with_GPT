; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400028E0(i64 %size) {
entry:
  call void asm sideeffect inteldialect "push rcx
push rax
cmp rax, 4096
lea rcx, [rsp+16]
jb .Ldone
.Lloop:
sub rcx, 4096
or qword ptr [rcx], 0
sub rax, 4096
cmp rax, 4096
ja .Lloop
.Ldone:
sub rcx, rax
or qword ptr [rcx], 0
pop rax
pop rcx", "{rax},~{rcx},~{rsp},~{dirflag},~{fpsr},~{flags},~{memory}"(i64 %size)
  ret void
}