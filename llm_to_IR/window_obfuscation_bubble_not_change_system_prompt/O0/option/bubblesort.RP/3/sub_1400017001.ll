target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001700(i8* %0, i8* %1, i8* %2, i8* %3) {
entry:
  %4 = alloca [3 x i8*], align 8
  %5 = getelementptr inbounds [3 x i8*], [3 x i8*]* %4, i64 0, i64 0
  store i8* %1, i8** %5, align 8
  %6 = getelementptr inbounds i8*, i8** %5, i64 1
  store i8* %2, i8** %6, align 8
  %7 = getelementptr inbounds i8*, i8** %5, i64 2
  store i8* %3, i8** %7, align 8
  %8 = call i8* @__acrt_iob_func(i32 2)
  %9 = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %8, i8* %9)
  %10 = call i8* @__acrt_iob_func(i32 2)
  %11 = bitcast i8** %5 to i8*
  call void @sub_140002560(i8* %10, i8* %0, i8* %11)
  call void @abort()
  unreachable
}