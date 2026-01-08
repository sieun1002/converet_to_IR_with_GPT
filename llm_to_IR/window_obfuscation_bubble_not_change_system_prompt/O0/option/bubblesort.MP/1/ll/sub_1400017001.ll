; ModuleID = 'sub_140001700_module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8**)
declare void @sub_140002798()

define void @sub_140001700(i8* %rcx_in, i8* %rdx_in, i8* %r8_in, i8* %r9_in) noreturn {
entry:
  %rbx.slot = alloca i8*, align 8
  store i8* %rcx_in, i8** %rbx.slot, align 8

  %args.array = alloca [3 x i8*], align 8
  %arg0.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.array, i64 0, i64 0
  store i8* %rdx_in, i8** %arg0.ptr, align 8
  %arg1.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.array, i64 0, i64 1
  store i8* %r8_in, i8** %arg1.ptr, align 8
  %arg2.ptr = getelementptr inbounds [3 x i8*], [3 x i8*]* %args.array, i64 0, i64 2
  store i8* %r9_in, i8** %arg2.ptr, align 8

  %call1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)

  %call2 = call i8* @sub_140002710(i32 2)
  %rbx.val = load i8*, i8** %rbx.slot, align 8
  call void @sub_140002560(i8* %call2, i8* %rbx.val, i8** %arg0.ptr)

  call void @sub_140002798()
  unreachable
}