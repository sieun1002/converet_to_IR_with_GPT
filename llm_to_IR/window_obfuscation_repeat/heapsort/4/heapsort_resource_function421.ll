; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@.str = private unnamed_addr constant [18 x i8] c"runtime error %d\0A\00", align 1

declare i8* @__acrt_iob_func(i32)
declare void @_exit(i32)
declare i32 @fprintf(i8*, i8*, ...)

define dso_local i32 @sub_1400029C0(i8* %stream, i8* %fmt, i32 %val) {
entry:
  %call = call i32 (i8*, i8*, ...) @fprintf(i8* %stream, i8* %fmt, i32 %val)
  ret i32 %call
}

define dso_local void @sub_140002A30(i32 %arg) noreturn {
entry:
  %iob = call i8* @__acrt_iob_func(i32 2)
  %fmtptr = getelementptr inbounds [18 x i8], [18 x i8]* @.str, i64 0, i64 0
  %call = call i32 @sub_1400029C0(i8* %iob, i8* %fmtptr, i32 %arg)
  call void @_exit(i32 255)
  unreachable
}