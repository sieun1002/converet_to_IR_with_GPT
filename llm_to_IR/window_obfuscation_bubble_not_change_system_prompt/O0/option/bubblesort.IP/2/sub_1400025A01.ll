; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @loc_140002710(i32, i8*, i8*, i8*, i8*)
declare i8** @sub_140002650()
declare void @sub_140002728(i8*, i8*, i8*, i32, i8*)

define void @sub_1400025A0(i8* %arg_rcx, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9) {
entry:
  %home = alloca [3 x i8*], align 8
  %home.gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 0
  store i8* %arg_rdx, i8** %home.gep0, align 8
  %home.gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 1
  store i8* %arg_r8, i8** %home.gep1, align 8
  %home.gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %home, i64 0, i64 2
  store i8* %arg_r9, i8** %home.gep2, align 8
  %home.as.i8 = bitcast i8** %home.gep0 to i8*
  %call1 = call i8* @loc_140002710(i32 1, i8* %arg_rdx, i8* %arg_r8, i8* %arg_r9, i8* %home.as.i8)
  %p = call i8** @sub_140002650()
  %rcx.load = load i8*, i8** %p, align 8
  call void @sub_140002728(i8* %rcx.load, i8* %call1, i8* %arg_rcx, i32 0, i8* %home.as.i8)
  ret void
}