; ModuleID = 'sub_1400025A0'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002710(i32, i8*)
declare i64* @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64, ...)

define i64 @sub_1400025A0(i64 %rcx, i64 %rdx, i64 %r8, i64 %r9) {
entry:
  %arr = alloca [3 x i64], align 16
  %arr0 = getelementptr inbounds [3 x i64], [3 x i64]* %arr, i64 0, i64 0
  store i64 %rdx, i64* %arr0, align 8
  %arr1 = getelementptr inbounds i64, i64* %arr0, i64 1
  store i64 %r8, i64* %arr1, align 8
  %arr2 = getelementptr inbounds i64, i64* %arr0, i64 2
  store i64 %r9, i64* %arr2, align 8
  %arr_i8 = bitcast i64* %arr0 to i8*
  %call1 = call i64 @sub_140002710(i32 1, i8* %arr_i8)
  %call2 = call i64* @sub_140002650()
  %load = load i64, i64* %call2, align 8
  %call3 = call i64 @sub_140002728(i64 %load, i64 %call1, i64 %rcx, i64 0, i8* %arr_i8)
  ret i64 %call3
}