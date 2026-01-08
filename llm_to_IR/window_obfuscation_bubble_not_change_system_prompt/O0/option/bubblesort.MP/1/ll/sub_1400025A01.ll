; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare void @sub_140002728(i8*, i8*, i8*, i8*, i8*)

define void @sub_1400025A0(i8* %rcx_arg, i8* %rdx_arg, i8* %r8_arg, i8* %r9_arg) {
entry:
  %argblock = alloca [3 x i8*], align 8
  %argblock_gep0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argblock, i64 0, i64 0
  store i8* %rdx_arg, i8** %argblock_gep0, align 8
  %argblock_gep1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argblock, i64 0, i64 1
  store i8* %r8_arg, i8** %argblock_gep1, align 8
  %argblock_gep2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %argblock, i64 0, i64 2
  store i8* %r9_arg, i8** %argblock_gep2, align 8
  %argptr = bitcast [3 x i8*]* %argblock to i8*
  %call1 = call i8* @sub_140002710(i32 1)
  %call2 = call i8** @sub_140002650()
  %loaded = load i8*, i8** %call2, align 8
  call void @sub_140002728(i8* %loaded, i8* %call1, i8* %rcx_arg, i8* null, i8* %argptr)
  ret void
}