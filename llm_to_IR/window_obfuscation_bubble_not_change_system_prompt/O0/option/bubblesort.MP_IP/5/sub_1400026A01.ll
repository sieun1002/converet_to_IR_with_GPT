; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @"loc_14000276C+4"()
declare void @"loc_140002755+3"(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @"loc_140002800"()
declare void @sub_1400027E0(i32)

define void @sub_1400026A0(i32* %arg1, i64* %arg2, i64* %arg3, i32 %arg4, i32* %arg5) {
entry:
  call void @"loc_14000276C+4"()

  %cmp = icmp uge i32 %arg4, 1
  %sel = select i1 %cmp, i32 2, i32 1
  call void @"loc_140002755+3"(i32 %sel)

  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %arg1, align 4

  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %arg2, align 8

  %p64b = call i64* @"loc_140002800"()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %arg3, align 8

  %in = load i32, i32* %arg5, align 4
  call void @sub_1400027E0(i32 %in)

  ret void
}