; ModuleID = 'sub_140001700_mod'
target triple = "x86_64-pc-windows-msvc"

@aMingwW64Runtim = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798()

define void @sub_140001700(i8* %arg_rcx, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9) {
entry:
  %args = alloca [3 x i8*], align 8
  %args.gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 0
  store i8* %arg_rdx, i8** %args.gep0, align 8
  %args.gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 1
  store i8* %arg_r8, i8** %args.gep1, align 8
  %args.gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 2
  store i8* %arg_r9, i8** %args.gep2, align 8
  %call1 = call i8* @sub_140002710(i32 2)
  %strptr = getelementptr inbounds [28 x i8], [28 x i8]* @aMingwW64Runtim, i64 0, i64 0
  call void @sub_140002600(i8* %call1, i8* %strptr)
  %args.i8 = bitcast [3 x i8*]* %args to i8*
  %call2 = call i8* @sub_140002710(i32 2)
  call void @sub_140002560(i8* %call2, i8* %arg_rcx, i8* %args.i8)
  call void @sub_140002798()
  ret void
}