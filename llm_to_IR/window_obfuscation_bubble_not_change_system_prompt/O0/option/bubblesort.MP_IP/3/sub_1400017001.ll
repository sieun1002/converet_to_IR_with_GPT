; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@aMingwW64Runtim = external dso_local constant [29 x i8]

declare dso_local i8* @sub_140002710(i32)
declare dso_local void @sub_140002600(i8*, i8*)
declare dso_local void @sub_140002560(i8*, i8*, i8**)
declare dso_local void @sub_140002798() noreturn

define dso_local void @sub_140001700(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %rdx.slot = alloca i8*, align 8
  store i8* %rdx, i8** %rdx.slot, align 8

  %call1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [29 x i8], [29 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)

  %call2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %call2, i8* %rcx, i8** %rdx.slot)

  call void @sub_140002798()
  unreachable
}