target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002770(i32*, i64*, i64*, i32)
declare void @sub_140002758(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %arg0, i64* %arg1, i64* %arg2, i32 %arg3, i32* %arg4) {
entry:
  call void @sub_140002770(i32* %arg0, i64* %arg1, i64* %arg2, i32 %arg3)
  %cmp0 = icmp eq i32 %arg3, 0
  %sel = select i1 %cmp0, i32 1, i32 2
  call void @sub_140002758(i32 %sel)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %arg0, align 4
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %arg1, align 8
  %p64b = call i64* @sub_140002800()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %arg2, align 8
  %val = load i32, i32* %arg4, align 4
  call void @sub_1400027E0(i32 %val)
  ret i32 0
}