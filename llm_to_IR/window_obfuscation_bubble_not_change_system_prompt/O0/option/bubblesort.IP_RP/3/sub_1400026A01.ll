target triple = "x86_64-pc-windows-msvc"

declare void @loc_14000276D$3()
declare void @loc_140002755$3(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %0, i64* %1, i64* %2, i32 %3, i32* %4) {
entry:
  call void @loc_14000276D$3()
  %cmp = icmp ult i32 %3, 1
  %ecx.arg = select i1 %cmp, i32 1, i32 2
  call void @loc_140002755$3(i32 %ecx.arg)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %0, align 4
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %1, align 8
  %p64b = call i64* @sub_140002800()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %2, align 8
  %varg5 = load i32, i32* %4, align 4
  call void @sub_1400027E0(i32 %varg5)
  ret i32 0
}