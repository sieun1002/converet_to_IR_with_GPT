; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arr = alloca [3 x i8*], align 8
  %var20 = alloca i8*, align 8
  %arr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %rdx, i8** %arr0, align 8
  %arr1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 1
  store i8* %r8, i8** %arr1, align 8
  %arr2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 2
  store i8* %r9, i8** %arr2, align 8
  %arr0_as_i8p = bitcast i8** %arr0 to i8*
  store i8* %arr0_as_i8p, i8** %var20, align 8
  %h1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %h1, i8* %strptr)
  %rsi = load i8*, i8** %var20, align 8
  %h2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %h2, i8* %rcx, i8* %rsi)
  call void @sub_140002798()
  ret void
}