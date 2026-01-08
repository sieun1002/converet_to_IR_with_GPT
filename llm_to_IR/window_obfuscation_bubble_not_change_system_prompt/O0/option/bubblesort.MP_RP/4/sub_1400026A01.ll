; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002770(i32*)
declare void @sub_140002758(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define dso_local i32 @sub_1400026A0(i32* %rcx_out, i64* %rdx_out, i64* %r8_out, i32 %r9d, i32* %arg5_ptr) {
entry:
  call void @sub_140002770(i32* %rcx_out)
  %cmp0 = icmp eq i32 %r9d, 0
  %ecx.sel = select i1 %cmp0, i32 1, i32 2
  call void @sub_140002758(i32 %ecx.sel)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %rcx_out, align 4
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %rdx_out, align 8
  %p64b = call i64* @sub_140002800()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %r8_out, align 8
  %fifth = load i32, i32* %arg5_ptr, align 4
  call void @sub_1400027E0(i32 %fifth)
  ret i32 0
}