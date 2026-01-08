; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

declare i8* @sub_140002710(i32)
declare i8** @sub_140002650()
declare i8* @sub_140002728(i8*, i8*, i8*, i32)

define dso_local i8* @sub_1400025A0(i8* %rcx, i8* %rdx, i8* %r8, i8* %r9) {
entry:
  %arg_area = alloca [3 x i8*], align 8
  %var20 = alloca i8**, align 8
  %var38 = alloca i8**, align 8
  %p0 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arg_area, i64 0, i64 0
  store i8* %rdx, i8** %p0, align 8
  %p1 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arg_area, i64 0, i64 1
  store i8* %r8, i8** %p1, align 8
  %p2 = getelementptr inbounds [3 x i8*], [3 x i8*]* %arg_area, i64 0, i64 2
  store i8* %r9, i8** %p2, align 8
  store i8** %p0, i8*** %var20, align 8
  %call1 = call i8* @sub_140002710(i32 1)
  %call2 = call i8** @sub_140002650()
  %loaded = load i8*, i8** %call2, align 8
  store i8** %p0, i8*** %var38, align 8
  %call3 = call i8* @sub_140002728(i8* %loaded, i8* %call1, i8* %rcx, i32 0)
  ret i8* %call3
}