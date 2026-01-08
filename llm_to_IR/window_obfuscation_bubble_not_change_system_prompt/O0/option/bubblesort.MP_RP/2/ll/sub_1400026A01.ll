; ModuleID = 'sub_1400026A0.ll'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002770()
declare void @sub_140002758(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %arg1, i64* %arg2, i64* %arg3, i32 %arg4, i32* %arg5) {
entry:
  call void @sub_140002770()
  %cmp = icmp ult i32 %arg4, 1
  %sel = select i1 %cmp, i32 1, i32 2
  call void @sub_140002758(i32 %sel)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32
  store i32 %v32, i32* %arg1
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a
  store i64 %v64a, i64* %arg2
  %p64b = call i64* @sub_140002800()
  %v64b = load i64, i64* %p64b
  store i64 %v64b, i64* %arg3
  %v5 = load i32, i32* %arg5
  call void @sub_1400027E0(i32 %v5)
  ret i32 0
}