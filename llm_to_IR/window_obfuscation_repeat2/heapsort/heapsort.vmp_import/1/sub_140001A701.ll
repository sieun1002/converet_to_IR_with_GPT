; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002A70(i32)
declare i32 @sub_140002960(i8*, i8*)
declare i32 @sub_1400028C0(i8*, i8*, i8*)
declare void @sub_140002AE8() noreturn

define void @sub_140001A70(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) noreturn {
entry:
  %home = alloca [3 x i8*], align 8
  %home0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 0
  store i8* %rdx, i8** %home0, align 8
  %home1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 1
  store i8* %r8, i8** %home1, align 8
  %home2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 2
  store i8* %r9, i8** %home2, align 8
  %va_ptr = bitcast i8** %home0 to i8*

  %file1 = call i8* @sub_140002A70(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  %call1 = call i32 @sub_140002960(i8* %file1, i8* %strptr)

  %file2 = call i8* @sub_140002A70(i32 2)
  %call2 = call i32 @sub_1400028C0(i8* %file2, i8* %rcx, i8* %va_ptr)

  call void @sub_140002AE8()
  unreachable
}