; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare void @loc_14000276D()
declare void @loc_140002755(i32)
declare i32* @sub_140002740()
declare i64* @sub_140002748()
declare i64* @sub_140002800()
declare void @sub_1400027E0(i32)

define i32 @sub_1400026A0(i32* %rcx, i64* %rdx, i64* %r8, i32 %r9d, i32* %arg5) {
entry:
  %fn1_base = ptrtoint void ()* @loc_14000276D to i64
  %fn1_ptr_i64 = add i64 %fn1_base, 3
  %fn1_ptr = inttoptr i64 %fn1_ptr_i64 to void ()*
  call void %fn1_ptr()

  %is_lt = icmp ult i32 %r9d, 1
  %ecx_val = select i1 %is_lt, i32 1, i32 2

  %fn2_base = ptrtoint void (i32)* @loc_140002755 to i64
  %fn2_ptr_i64 = add i64 %fn2_base, 3
  %fn2_ptr = inttoptr i64 %fn2_ptr_i64 to void (i32)*
  call void %fn2_ptr(i32 %ecx_val)

  %pint = call i32* @sub_140002740()
  %ival = load i32, i32* %pint, align 4
  store i32 %ival, i32* %rcx, align 4

  %p64_1 = call i64* @sub_140002748()
  %val64_1 = load i64, i64* %p64_1, align 8
  store i64 %val64_1, i64* %rdx, align 8

  %p64_2 = call i64* @sub_140002800()
  %val64_2 = load i64, i64* %p64_2, align 8
  store i64 %val64_2, i64* %r8, align 8

  %arg5_val = load i32, i32* %arg5, align 4
  call void @sub_1400027E0(i32 %arg5_val)

  ret i32 0
}