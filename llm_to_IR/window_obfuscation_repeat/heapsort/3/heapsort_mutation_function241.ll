; ModuleID = 'fninit_module'
source_filename = "fninit.ll"
target triple = "x86_64-pc-windows-msvc"

define void @sub_1400024E0() local_unnamed_addr nounwind {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}