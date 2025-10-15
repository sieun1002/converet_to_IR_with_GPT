; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002BB0(i32, i8*, i8*, i8*, i8**)
declare void @sub_140002AA0(i8*, i8*)

define void @sub_140001BA0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arg8.addr = alloca i8*, align 8
  %arg10.addr = alloca i8*, align 8
  %arg18.addr = alloca i8*, align 8
  store i8* %rdx, i8** %arg8.addr, align 8
  store i8* %r8, i8** %arg10.addr, align 8
  store i8* %r9, i8** %arg18.addr, align 8
  %call = call i8* @sub_140002BB0(i32 2, i8* %rdx, i8* %r8, i8* %r9, i8** %arg8.addr)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002AA0(i8* %call, i8* %strptr)
  ret void
}