; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = internal unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) local_unnamed_addr {
entry:
  %rbx = alloca i8*, align 8
  %arg8 = alloca i8*, align 8
  %arg10 = alloca i8*, align 8
  %arg18 = alloca i8*, align 8
  %var20 = alloca i8**, align 8
  store i8* %rcx, i8** %rbx, align 8
  store i8* %r8, i8** %arg10, align 8
  store i8* %r9, i8** %arg18, align 8
  store i8* %rdx, i8** %arg8, align 8
  store i8** %arg8, i8*** %var20, align 8
  %call1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)
  %rsi_ptr = load i8**, i8*** %var20, align 8
  %call2 = call i8* @sub_140002710(i32 2)
  %rbx_val = load i8*, i8** %rbx, align 8
  %r8_arg = bitcast i8** %rsi_ptr to i8*
  call void @sub_140002560(i8* %call2, i8* %rbx_val, i8* %r8_arg)
  call void @sub_140002798()
  ret void
}