; ModuleID = 'sub_140002A00_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

declare dso_local void @sub_140002AC0(i64, i64, i64, i32)
declare dso_local i32 @sub_140002AA8(i32)

define dso_local i32 @sub_140002A00(i64 %rcx_in, i64 %rdx_in, i64 %r8_in, i32 %r9d_in) {
entry:
  call void @sub_140002AC0(i64 %rcx_in, i64 %rdx_in, i64 %r8_in, i32 %r9d_in)
  %cmp = icmp ult i32 %r9d_in, 1
  %arg = select i1 %cmp, i32 1, i32 2
  %ret = call i32 @sub_140002AA8(i32 %arg)
  ret i32 %ret
}