; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798() noreturn

define void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %rbx.slot = alloca i8*, align 8
  %arg8.slot = alloca i8*, align 8
  %arg10.slot = alloca i8*, align 8
  %arg18.slot = alloca i8*, align 8

  store i8* %rcx, i8** %rbx.slot, align 8
  store i8* %rdx, i8** %arg8.slot, align 8
  store i8* %r8, i8** %arg10.slot, align 8
  store i8* %r9, i8** %arg18.slot, align 8

  %call1 = call i8* @sub_140002710(i32 2)
  %msgptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %msgptr)

  %call2 = call i8* @sub_140002710(i32 2)
  %rbx.val = load i8*, i8** %rbx.slot, align 8
  %va.ptr = bitcast i8** %arg8.slot to i8*
  call void @sub_140002560(i8* %call2, i8* %rbx.val, i8* %va.ptr)

  call void @sub_140002798()
  unreachable
}