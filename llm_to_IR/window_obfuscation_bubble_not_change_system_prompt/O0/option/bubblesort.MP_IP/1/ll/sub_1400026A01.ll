; ModuleID = 'sub_1400026A0.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @"loc_14000276C+4"()
declare void @"loc_140002755+3"(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @"loc_140002800"()
declare void @sub_1400027E0(i32)

define void @sub_1400026A0(i32* %rcx, i64* %rdx, i64* %r8, i32 %r9d, i32* %arg5) {
entry:
  call void @"loc_14000276C+4"()
  %cmp0 = icmp eq i32 %r9d, 0
  %ecx_val = select i1 %cmp0, i32 1, i32 2
  call void @"loc_140002755+3"(i32 %ecx_val)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %rcx, align 4
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %rdx, align 8
  %p64b = call i64* @"loc_140002800"()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %r8, align 8
  %varg = load i32, i32* %arg5, align 4
  call void @sub_1400027E0(i32 %varg)
  ret void
}