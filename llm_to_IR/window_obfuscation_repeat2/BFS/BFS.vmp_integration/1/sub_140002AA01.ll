; ModuleID = 'sub_140002AA0_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare i64* @sub_140002AF0(i64, i64, i64, i64)
declare void @sub_140002BC8(i64, i64, i64, i64)

define void @sub_140002AA0(i64 %rcx_0, i64 %rdx_0, i64 %r8_0, i64 %r9_0) {
entry:
  %call1 = call i64* @sub_140002AF0(i64 %rcx_0, i64 %rdx_0, i64 %r8_0, i64 %r9_0)
  %val = load i64, i64* %call1, align 8
  call void @sub_140002BC8(i64 %val, i64 %rcx_0, i64 %rdx_0, i64 0)
  ret void
}