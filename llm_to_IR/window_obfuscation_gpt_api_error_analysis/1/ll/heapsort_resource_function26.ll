; ModuleID = 'sub_1400024E0'
source_filename = "sub_1400024E0.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() local_unnamed_addr {
entry:
  call void asm sideeffect "fninit", "~{dirflag},~{fpsr},~{flags}"()
  ret void
}