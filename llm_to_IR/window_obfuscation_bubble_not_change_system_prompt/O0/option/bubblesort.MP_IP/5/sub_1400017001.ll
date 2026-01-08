; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798() noreturn

define void @sub_140001700(i8* %arg1, i8* %arg2, i8* %arg3, i8* %arg4) {
entry:
  %arr = alloca [3 x i8*], align 8
  %arr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %arg2, i8** %arr0, align 8
  %arr1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 1
  store i8* %arg3, i8** %arr1, align 8
  %arr2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 2
  store i8* %arg4, i8** %arr2, align 8
  %ctx1 = call i8* @sub_140002710(i32 2)
  %str = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %ctx1, i8* %str)
  %ctx2 = call i8* @sub_140002710(i32 2)
  %p = bitcast i8** %arr0 to i8*
  call void @sub_140002560(i8* %ctx2, i8* %arg1, i8* %p)
  call void @sub_140002798()
  unreachable
}