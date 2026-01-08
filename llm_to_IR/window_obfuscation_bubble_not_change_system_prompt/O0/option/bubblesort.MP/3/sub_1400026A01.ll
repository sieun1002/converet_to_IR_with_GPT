; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002770()
declare void @sub_140002758(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define dso_local i32 @sub_1400026A0(i32* %rcx, i64* %rdx, i64* %r8, i32 %r9d, i32* %arg5) {
entry:
  call void @sub_140002770()
  %cmp = icmp ne i32 %r9d, 0
  %ecx_val = select i1 %cmp, i32 2, i32 1
  call void @sub_140002758(i32 %ecx_val)
  %p1 = call i32* @sub_140002740()
  %v1 = load i32, i32* %p1, align 4
  store i32 %v1, i32* %rcx, align 4
  %p2 = call i64* @sub_140002748()
  %v2 = load i64, i64* %p2, align 8
  store i64 %v2, i64* %rdx, align 8
  %p3 = call i64* @sub_140002800()
  %v3 = load i64, i64* %p3, align 8
  store i64 %v3, i64* %r8, align 8
  %v4 = load i32, i32* %arg5, align 4
  call void @sub_1400027E0(i32 %v4)
  ret i32 0
}