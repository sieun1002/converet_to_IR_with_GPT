; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@.str.runtime_error = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @loc_140002A6D(i32)
declare i32 @sub_140002960(i8*, i8*, ...)
declare void @sub_140002AB8(i32)

define dso_local void @sub_1400029D0(i32 %arg) {
entry:
  %fptr.raw = bitcast i8* (i32)* @loc_140002A6D to i8*
  %fptr.int = ptrtoint i8* %fptr.raw to i64
  %fptr.plus3 = add i64 %fptr.int, 3
  %fptr.call = inttoptr i64 %fptr.plus3 to i8* (i32)*
  %handle = call i8* %fptr.call(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str.runtime_error, i64 0, i64 0
  %call.print = call i32 (i8*, i8*, ...) @sub_140002960(i8* %handle, i8* %fmtptr, i32 %arg)
  call void @sub_140002AB8(i32 255)
  unreachable
}