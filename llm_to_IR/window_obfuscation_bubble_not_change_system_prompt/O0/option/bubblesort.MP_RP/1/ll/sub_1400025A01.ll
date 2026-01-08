; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @sub_140002710(i32, i64, i64, i64)
declare i64* @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64)

define i64 @sub_1400025A0(i64 %arg1, i64 %arg2, i64 %arg3, i64 %arg4) {
entry:
  %call1 = call i64 @sub_140002710(i32 1, i64 %arg2, i64 %arg3, i64 %arg4)
  %p = call i64* @sub_140002650()
  %val = load i64, i64* %p, align 8
  %call3 = call i64 @sub_140002728(i64 %val, i64 %call1, i64 %arg1, i64 0)
  ret i64 %call3
}