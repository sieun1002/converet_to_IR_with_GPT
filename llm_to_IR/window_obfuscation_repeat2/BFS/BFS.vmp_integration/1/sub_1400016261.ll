; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare void @sub_1403EC685()
declare void @loc_140128A2C()

define void @sub_140001626() {
entry:
  %var_10 = alloca i64, align 8
  call void @sub_1403EC685()
  call void asm sideeffect "syscall", "~{rax},~{rcx},~{rdx},~{r8},~{r9},~{r10},~{r11},~{memory}"()
  store i64 -463627054, i64* %var_10, align 8
  call void @loc_140128A2C()
  ret void
}