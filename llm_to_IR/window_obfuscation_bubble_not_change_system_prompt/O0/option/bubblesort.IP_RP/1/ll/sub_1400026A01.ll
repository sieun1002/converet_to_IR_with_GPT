; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @"loc_14000276D+3"()
declare void @"loc_140002755+3"(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %out_int, i64* %out_qword1, i64* %out_qword2, i32 %flag, i32* %arg5_ptr) {
entry:
  call void @"loc_14000276D+3"()

  %iszero = icmp eq i32 %flag, 0
  %ecxval = select i1 %iszero, i32 1, i32 2
  call void @"loc_140002755+3"(i32 %ecxval)

  %p_int = call i32* @sub_140002740()
  %v_int = load i32, i32* %p_int, align 4
  store i32 %v_int, i32* %out_int, align 4

  %p_q1 = call i64* @sub_140002748()
  %v_q1 = load i64, i64* %p_q1, align 8
  store i64 %v_q1, i64* %out_qword1, align 8

  %p_q2 = call i64* @sub_140002800()
  %v_q2 = load i64, i64* %p_q2, align 8
  store i64 %v_q2, i64* %out_qword2, align 8

  %v_arg5 = load i32, i32* %arg5_ptr, align 4
  call void @sub_1400027E0(i32 %v_arg5)

  ret i32 0
}