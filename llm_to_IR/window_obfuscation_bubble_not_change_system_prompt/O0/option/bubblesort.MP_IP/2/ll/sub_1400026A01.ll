; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_14000276C()
declare void @loc_140002755(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @loc_140002800()
declare void @sub_1400027E0(i32)

define void @sub_1400026A0(i32* %out_int, i64* %out_q1, i64* %out_q2, i32 %flag, i32* %pInt) {
entry:
  call void @loc_14000276C()
  %iszero = icmp eq i32 %flag, 0
  %ecxval = select i1 %iszero, i32 1, i32 2
  call void @loc_140002755(i32 %ecxval)
  %p32 = call i32* @sub_140002740()
  %v32 = load i32, i32* %p32, align 4
  store i32 %v32, i32* %out_int, align 4
  %p64a = call i64* @sub_140002748()
  %v64a = load i64, i64* %p64a, align 8
  store i64 %v64a, i64* %out_q1, align 8
  %p64b = call i64* @loc_140002800()
  %v64b = load i64, i64* %p64b, align 8
  store i64 %v64b, i64* %out_q2, align 8
  %v_ecx = load i32, i32* %pInt, align 4
  call void @sub_1400027E0(i32 %v_ecx)
  ret void
}