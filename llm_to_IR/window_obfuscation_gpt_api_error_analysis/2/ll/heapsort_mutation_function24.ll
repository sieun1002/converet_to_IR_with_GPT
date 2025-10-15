; ModuleID = 'sub_1400024E0'
source_filename = "sub_1400024E0.ll"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() local_unnamed_addr #0 {
entry:
  call void asm sideeffect "fninit", ""()
  ret void
}

attributes #0 = { nounwind }