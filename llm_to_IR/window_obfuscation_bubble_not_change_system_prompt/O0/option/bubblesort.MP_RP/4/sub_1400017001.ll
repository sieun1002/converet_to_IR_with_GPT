; ModuleID = 'sub_140001700_module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = dso_local constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare dso_local i8* @sub_140002710(i32)
declare dso_local void @sub_140002600(i8*, i8*)
declare dso_local void @sub_140002560(i8*, i8*, i8*)
declare dso_local void @sub_140002798()

define dso_local void @sub_140001700(i8* %arg_rcx, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9) {
entry:
  %saved_arg8 = alloca i8*, align 8
  %saved_arg10 = alloca i8*, align 8
  %saved_arg18 = alloca i8*, align 8
  %var20 = alloca i8**, align 8

  store i8* %arg_r8, i8** %saved_arg10, align 8
  store i8* %arg_r9, i8** %saved_arg18, align 8
  store i8* %arg_rdx, i8** %saved_arg8, align 8

  store i8** %saved_arg8, i8*** %var20, align 8

  %call_ctx1 = call i8* @sub_140002710(i32 2)

  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call_ctx1, i8* %strptr)

  %rsi_ptr_load = load i8**, i8*** %var20, align 8

  %call_ctx2 = call i8* @sub_140002710(i32 2)

  %rsi_as_i8ptr = bitcast i8** %rsi_ptr_load to i8*
  call void @sub_140002560(i8* %call_ctx2, i8* %arg_rcx, i8* %rsi_as_i8ptr)

  call void @sub_140002798()
  unreachable
}