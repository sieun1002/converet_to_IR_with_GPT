; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_140002ABD()
declare void @loc_140002AA3(i32)
declare i32* @loc_140002A8D()
declare i64* @sub_140002A98()
declare i64* @sub_140002B50()
declare void @sub_140002B30(i32)

define i32 @sub_140002A00(i32* %out32, i64* %out64a, i64* %out64b, i32 %flag, i32* %pval) {
entry:
  call void @loc_140002ABD()
  %cmp = icmp ult i32 %flag, 1
  %sel = select i1 %cmp, i32 1, i32 2
  call void @loc_140002AA3(i32 %sel)
  %p1 = call i32* @loc_140002A8D()
  %v1 = load i32, i32* %p1, align 4
  store i32 %v1, i32* %out32, align 4
  %p2 = call i64* @sub_140002A98()
  %v2 = load i64, i64* %p2, align 8
  store i64 %v2, i64* %out64a, align 8
  %p3 = call i64* @sub_140002B50()
  %v3 = load i64, i64* %p3, align 8
  store i64 %v3, i64* %out64b, align 8
  %v4 = load i32, i32* %pval, align 4
  call void @sub_140002B30(i32 %v4)
  ret i32 0
}