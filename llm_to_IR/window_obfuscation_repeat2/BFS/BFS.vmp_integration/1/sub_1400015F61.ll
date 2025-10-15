target triple = "x86_64-pc-windows-msvc"

declare void @sub_1403EB18E()
declare void @loc_140037195()
declare void @loc_1400323E5()

define void @sub_1400015F6() {
entry:
  br i1 false, label %bb_ge, label %bb_cont

bb_ge:
  tail call void @loc_1400323E5()
  ret void

bb_cont:
  call void @sub_1403EB18E()
  call void asm sideeffect "syscall", "~{rcx},~{r11},~{dirflag},~{fpsr},~{flags},~{memory}"()
  call void @loc_140037195()
  ret void
}