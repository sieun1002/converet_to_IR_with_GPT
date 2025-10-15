; ModuleID = 'fninit_stub'
source_filename = "fninit_stub.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

define dso_local void @sub_1400024E0() {
entry:
  call void asm sideeffect "fninit", "~{dirflag},~{fpsr},~{flags}"()
  ret void
}