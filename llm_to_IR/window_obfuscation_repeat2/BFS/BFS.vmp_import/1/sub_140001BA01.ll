; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @loc_140002BAD(i32)
declare void @sub_140002AA0(i8*, i8*)
declare void @sub_140002A00(i8*, i8*, i8*)
declare void @sub_140002C38()

define void @sub_140001BA0(i8* %rcx_param, i8* %rdx_param, i8* %r8_param, i8* %r9_param) local_unnamed_addr {
entry:
  %arr = alloca [3 x i8*], align 8
  %arr0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 0
  store i8* %rdx_param, i8** %arr0, align 8
  %arr1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 1
  store i8* %r8_param, i8** %arr1, align 8
  %arr2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arr, i64 0, i64 2
  store i8* %r9_param, i8** %arr2, align 8
  %stream1 = call i8* @loc_140002BAD(i32 2)
  %msg = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002AA0(i8* %stream1, i8* %msg)
  %stream2 = call i8* @loc_140002BAD(i32 2)
  %arrcast = bitcast [3 x i8*]* %arr to i8*
  call void @sub_140002A00(i8* %stream2, i8* %rcx_param, i8* %arrcast)
  call void @sub_140002C38()
  ret void
}