; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @"loc_14000276C+4"()
declare void @"loc_140002755+3"(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @"loc_140002800"()
declare void @sub_1400027E0(i32)

define void @sub_1400026A0(i32* %out32, i64* %out64a, i64* %out64b, i32 %flag, i32* %inptr) {
entry:
  call void @"loc_14000276C+4"()
  %iszero = icmp eq i32 %flag, 0
  %ecxval = select i1 %iszero, i32 1, i32 2
  call void @"loc_140002755+3"(i32 %ecxval)
  %p1 = call i32* @sub_140002740()
  %v1 = load i32, i32* %p1, align 4
  store i32 %v1, i32* %out32, align 4
  %p2 = call i64* @sub_140002748()
  %v2 = load i64, i64* %p2, align 8
  store i64 %v2, i64* %out64a, align 8
  %p3 = call i64* @"loc_140002800"()
  %v3 = load i64, i64* %p3, align 8
  store i64 %v3, i64* %out64b, align 8
  %inval = load i32, i32* %inptr, align 4
  call void @sub_1400027E0(i32 %inval)
  ret void
}