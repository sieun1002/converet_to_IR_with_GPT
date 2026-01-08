; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @sub_140002770()
declare void @sub_140002758(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %out_i32, i64* %out_qword1, i64* %out_qword2, i32 %flag, i32* %pval) {
entry:
  call void @sub_140002770()

  %cmp0 = icmp ult i32 %flag, 1
  %sel1 = select i1 %cmp0, i32 1, i32 2
  call void @sub_140002758(i32 %sel1)

  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %out_i32, align 4

  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %out_qword1, align 8

  %p64b = call i64* @sub_140002800()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %out_qword2, align 8

  %vfromptr = load i32, i32* %pval, align 4
  call void @sub_1400027E0(i32 %vfromptr)

  ret i32 0
}