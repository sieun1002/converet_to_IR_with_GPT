; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @sub_1400029C0(i8*, i8*)
declare void @sub_140002920(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001AD0(i8* %format, i8* %arg_8, i8* %arg_10, i8* %arg_18) {
entry:
  %arg8.slot = alloca i8*, align 8
  %arg10.slot = alloca i8*, align 8
  %arg18.slot = alloca i8*, align 8
  store i8* %arg_8, i8** %arg8.slot, align 8
  store i8* %arg_10, i8** %arg10.slot, align 8
  store i8* %arg_18, i8** %arg18.slot, align 8
  %arglist.ptr = bitcast i8** %arg8.slot to i8*
  %iob1 = call i8* @__acrt_iob_func(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_1400029C0(i8* %iob1, i8* %strptr)
  %iob2 = call i8* @__acrt_iob_func(i32 2)
  call void @sub_140002920(i8* %iob2, i8* %format, i8* %arglist.ptr)
  call void @abort()
  unreachable
}