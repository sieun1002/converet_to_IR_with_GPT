; ModuleID = 'sub_140001700'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare i32 @sub_140002600(i8*, i8*)
declare i32 @sub_140002560(i8*, i8*, i8*)
declare void @abort()

define void @sub_140001700(i8* %rcx, i64 %rdx, i64 %r8, i64 %r9) {
entry:
  %va.area = alloca [3 x i64], align 8
  %arglist.slot = alloca i8*, align 8
  %va.gep0 = getelementptr inbounds [3 x i64], [3 x i64]* %va.area, i64 0, i64 0
  store i64 %rdx, i64* %va.gep0, align 8
  %va.gep1 = getelementptr inbounds [3 x i64], [3 x i64]* %va.area, i64 0, i64 1
  store i64 %r8, i64* %va.gep1, align 8
  %va.gep2 = getelementptr inbounds [3 x i64], [3 x i64]* %va.area, i64 0, i64 2
  store i64 %r9, i64* %va.gep2, align 8
  %arglist.ptr = bitcast i64* %va.gep0 to i8*
  store i8* %arglist.ptr, i8** %arglist.slot, align 8
  %iob1 = call i8* @__acrt_iob_func(i32 2)
  %msg.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call1 = call i32 @sub_140002600(i8* %iob1, i8* %msg.ptr)
  %arglist.load = load i8*, i8** %arglist.slot, align 8
  %iob2 = call i8* @__acrt_iob_func(i32 2)
  %call2 = call i32 @sub_140002560(i8* %iob2, i8* %rcx, i8* %arglist.load)
  call void @abort()
  unreachable
}