; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

declare void @loc_14010B448()
declare void @loc_1403EBF04()
declare void @loc_140036B2B() noreturn

define void @sub_14000153F() {
entry:
  call void @loc_14010B448()
  call void asm sideeffect inteldialect "syscall", "~{rcx},~{rdx},~{r8},~{r9},~{rax},~{r10},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"()
  call void @loc_1403EBF04()
  call void asm sideeffect inteldialect "syscall", "~{rcx},~{rdx},~{r8},~{r9},~{rax},~{r10},~{r11},~{memory},~{dirflag},~{fpsr},~{flags}"()
  call void @loc_140036B2B()
  unreachable
}