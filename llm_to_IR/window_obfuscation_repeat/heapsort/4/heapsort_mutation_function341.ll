; ModuleID = 'chkstk_like'
source_filename = "chkstk_like.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400028E0(i64 %bytes) local_unnamed_addr nounwind {
entry:
  call void asm sideeffect inteldialect "push rcx\0Apush rax\0Acmp rax, 4096\0Alea rcx, [rsp+16]\0Ajb 2f\0A1:\0Asub rcx, 4096\0Aor qword ptr [rcx], 0\0Asub rax, 4096\0Acmp rax, 4096\0Aja 1b\0A2:\0Asub rcx, rax\0Aor qword ptr [rcx], 0\0Apop rax\0Apop rcx", "a,~{rcx},~{dirflag},~{fpsr},~{flags},~{memory}"(i64 %bytes)
  ret void
}