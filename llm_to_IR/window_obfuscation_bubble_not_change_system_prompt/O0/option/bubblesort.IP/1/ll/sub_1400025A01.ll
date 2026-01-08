; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i64 @loc_140002710(i32)
declare i64* @sub_140002650()
declare i64 @sub_140002728(i64, i64, i64, i64, i64*)

define i64 @sub_1400025A0(i64 %rcx, i64 %rdx, i64 %r8, i64 %r9) {
entry:
  %args = alloca [3 x i64], align 8
  %args.ptr0 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 0
  store i64 %rdx, i64* %args.ptr0, align 8
  %args.ptr1 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 1
  store i64 %r8, i64* %args.ptr1, align 8
  %args.ptr2 = getelementptr inbounds [3 x i64], [3 x i64]* %args, i64 0, i64 2
  store i64 %r9, i64* %args.ptr2, align 8
  %call1 = call i64 @loc_140002710(i32 1)
  %call2 = call i64* @sub_140002650()
  %load3 = load i64, i64* %call2, align 8
  %call4 = call i64 @sub_140002728(i64 %load3, i64 %call1, i64 %rcx, i64 0, i64* %args.ptr0)
  ret i64 %call4
}