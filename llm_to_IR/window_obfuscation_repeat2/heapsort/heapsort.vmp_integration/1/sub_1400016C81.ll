; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

declare void @sub_1403DD753(i64, i64, i64, i64)

define void @sub_1400016C8(i64 %rcx, i64 %rdx, i64 %r8, i64 %r9) {
entry:
  %hi = zext i32 1385101360 to i64
  %hi_shl = shl i64 %hi, 32
  %lo = zext i32 2240979902 to i64
  %c = or i64 %hi_shl, %lo
  %c_shl = shl i64 %c, 3
  %r9_new = add i64 %c_shl, 1101902884
  call void @sub_1403DD753(i64 %rcx, i64 %rdx, i64 %r8, i64 %r9_new)
  ret void
}