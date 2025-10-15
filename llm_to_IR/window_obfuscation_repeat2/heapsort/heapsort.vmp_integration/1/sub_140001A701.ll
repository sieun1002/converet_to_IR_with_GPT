; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002A70(i32)
declare void @sub_140002960(i8*, i8*)
declare void @sub_1400028C0(i8*, i8*, i8**)
declare void @loc_140002AE5() noreturn

define void @sub_140001A70(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %argbuf = alloca [3 x i8*], align 8
  %buf0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argbuf, i64 0, i64 0
  %buf1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argbuf, i64 0, i64 1
  %buf2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argbuf, i64 0, i64 2
  store i8* %rdx, i8** %buf0, align 8
  store i8* %r8, i8** %buf1, align 8
  store i8* %r9, i8** %buf2, align 8
  %call1 = call i8* @sub_140002A70(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002960(i8* %call1, i8* %strptr)
  %call2 = call i8* @sub_140002A70(i32 2)
  call void @sub_1400028C0(i8* %call2, i8* %rcx, i8** %buf0)
  call void @loc_140002AE5()
  unreachable
}