; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32)
declare i8** @sub_140002650()
declare void @sub_140002728(i8*, i8*, i8*, i32, i64*)

define void @sub_1400025A0(i8* %arg1, i64 %arg2, i64 %arg3, i64 %arg4) {
entry:
  %va.arr = alloca [3 x i64], align 8
  %va.ptr0 = getelementptr inbounds [3 x i64], [3 x i64]* %va.arr, i32 0, i32 0
  store i64 %arg2, i64* %va.ptr0, align 8
  %va.ptr1 = getelementptr inbounds i64, i64* %va.ptr0, i64 1
  store i64 %arg3, i64* %va.ptr1, align 8
  %va.ptr2 = getelementptr inbounds i64, i64* %va.ptr0, i64 2
  store i64 %arg4, i64* %va.ptr2, align 8
  %call.loc_140002710 = call i8* @loc_140002710(i32 1)
  %call.sub_140002650 = call i8** @sub_140002650()
  %loaded.ptr = load i8*, i8** %call.sub_140002650, align 8
  call void @sub_140002728(i8* %loaded.ptr, i8* %call.loc_140002710, i8* %arg1, i32 0, i64* %va.ptr0)
  ret void
}