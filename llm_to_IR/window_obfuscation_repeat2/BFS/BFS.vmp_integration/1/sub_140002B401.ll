; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_140002C0D()
declare void @sub_140002BF8(i32)
declare i32* @sub_140002BE0()
declare i64* @sub_140002BE8()
declare i64* @sub_140002CA0()
declare void @sub_140002C80(i32)

define void @sub_140002B40(i32* %out_int, i64* %out_ptr1, i64* %out_ptr2, i32 %flag, i32* %in_int_ptr) {
entry:
  call void @loc_140002C0D()

  %is_zero = icmp eq i32 %flag, 0
  %ecx_val = select i1 %is_zero, i32 1, i32 2
  call void @sub_140002BF8(i32 %ecx_val)

  %p_i32 = call i32* @sub_140002BE0()
  %val_i32 = load i32, i32* %p_i32, align 4
  store i32 %val_i32, i32* %out_int, align 4

  %p_i64_a = call i64* @sub_140002BE8()
  %val_i64_a = load i64, i64* %p_i64_a, align 8
  store i64 %val_i64_a, i64* %out_ptr1, align 8

  %p_i64_b = call i64* @sub_140002CA0()
  %val_i64_b = load i64, i64* %p_i64_b, align 8
  store i64 %val_i64_b, i64* %out_ptr2, align 8

  %in_val = load i32, i32* %in_int_ptr, align 4
  call void @sub_140002C80(i32 %in_val)

  ret void
}