; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@aRuntimeErrorD = internal constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @sub_140002BB0(i32)
declare void @sub_140002AA0(i8*, i8*, i32)

define void @sub_140002B10(i32 %arg) {
entry:
  %call = call i8* @sub_140002BB0(i32 2)
  %strptr = getelementptr inbounds [18 x i8], [18 x i8]* @aRuntimeErrorD, i64 0, i64 0
  call void @sub_140002AA0(i8* %call, i8* %strptr, i32 %arg)
  ret void
}