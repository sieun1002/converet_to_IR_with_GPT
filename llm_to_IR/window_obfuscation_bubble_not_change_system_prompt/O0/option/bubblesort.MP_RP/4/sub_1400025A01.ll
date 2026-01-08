target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare void @sub_140002728(i8*, i8*, i8*, i32, i8**)

define void @sub_1400025A0(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %argsarr = alloca [3 x i8*], align 8
  %arr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsarr, i64 0, i64 0
  store i8* %arg2, i8** %arr0, align 8
  %arr1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsarr, i64 0, i64 1
  store i8* %arg3, i8** %arr1, align 8
  %arr2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argsarr, i64 0, i64 2
  store i8* %arg4, i8** %arr2, align 8
  %call1 = call i8* @sub_140002710(i32 1)
  %call2 = call i8** @sub_140002650()
  %load = load i8*, i8** %call2, align 8
  call void @sub_140002728(i8* %load, i8* %call1, i8* %arg1, i32 0, i8** %arr0)
  ret void
}