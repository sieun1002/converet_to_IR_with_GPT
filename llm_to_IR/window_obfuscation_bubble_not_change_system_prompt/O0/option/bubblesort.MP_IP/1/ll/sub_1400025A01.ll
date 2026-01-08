target triple = "x86_64-pc-windows-msvc"

define i64 @sub_1400025A0(i64 %rcx_in, i64 %rdx_in, i64 %r8_in, i64 %r9_in) {
entry:
  %arr = alloca [3 x i64], align 16
  %arr0ptr = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  store i64 %rdx_in, i64* %arr0ptr, align 8
  %arr1ptr = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 1
  store i64 %r8_in, i64* %arr1ptr, align 8
  %arr2ptr = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 2
  store i64 %r9_in, i64* %arr2ptr, align 8
  %call1 = call i64 @sub_140002710(i32 1)
  call void @sub_140002650()
  %ptr = inttoptr i64 %call1 to i64*
  %rcx_val = load i64, i64* %ptr, align 8
  %arrptr = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  %res = call i64 @sub_140002728(i64 %rcx_val, i64 %call1, i64 %rcx_in, i64 0, i64* %arrptr)
  ret i64 %res
}

declare i64 @sub_140002710(i32)
declare void @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64, i64*)