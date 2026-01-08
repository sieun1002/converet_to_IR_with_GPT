; ModuleID = 'sub_140001700.ll'
target triple = "x86_64-pc-windows-msvc"

@.str.mingw = private unnamed_addr constant [28 x i8] c"Mingw-w64 runtime failure:\0A\00", align 1

declare i8* @sub_140002710(i32)
declare void @sub_140002600(i8*, i8*)
declare void @sub_140002560(i8*, i8*, i8*)
declare void @sub_140002798() noreturn

define dso_local void @sub_140001700(i8* %arg_rcx, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9) {
entry:
  %args = alloca [3 x i8*], align 8
  %args.gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %args, i64 0, i64 0
  store i8* %arg_rdx, i8** %args.gep0, align 8
  %args.gep1 = getelementptr inbounds i8*, i8** %args.gep0, i64 1
  store i8* %arg_r8, i8** %args.gep1, align 8
  %args.gep2 = getelementptr inbounds i8*, i8** %args.gep0, i64 2
  store i8* %arg_r9, i8** %args.gep2, align 8
  %call.ctx1 = call i8* @sub_140002710(i32 2)
  %str.ptr = getelementptr inbounds [28 x i8], [28 x i8]* @.str.mingw, i64 0, i64 0
  call void @sub_140002600(i8* %call.ctx1, i8* %str.ptr)
  %call.ctx2 = call i8* @sub_140002710(i32 2)
  %args.as.i8 = bitcast i8** %args.gep0 to i8*
  call void @sub_140002560(i8* %call.ctx2, i8* %arg_rcx, i8* %args.as.i8)
  call void @sub_140002798()
  unreachable
}