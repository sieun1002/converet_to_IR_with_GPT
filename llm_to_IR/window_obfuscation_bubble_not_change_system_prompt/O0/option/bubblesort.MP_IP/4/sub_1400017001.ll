; ModuleID = 'sub_140001700_module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %0, i8* %1, i8* %2, i8* %3) {
entry:
  %argarr = alloca [3 x i8*], align 8
  %var20 = alloca i8*, align 8
  %idx0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argarr, i64 0, i64 0
  store i8* %1, i8** %idx0, align 8
  %idx1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argarr, i64 0, i64 1
  store i8* %2, i8** %idx1, align 8
  %idx2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argarr, i64 0, i64 2
  store i8* %3, i8** %idx2, align 8
  %argarr_i8 = bitcast [3 x i8*]* %argarr to i8*
  store i8* %argarr_i8, i8** %var20, align 8
  %h1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %h1, i8* %strptr)
  %rsi_val = load i8*, i8** %var20, align 8
  %h2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %h2, i8* %0, i8* %rsi_val)
  call void @sub_140002798()
  ret void
}