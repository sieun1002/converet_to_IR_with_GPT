; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

declare i8* @__acrt_iob_func(i32)
declare i64* @sub_140002A10()
declare i32 @__stdio_common_vfprintf(i64, i8*, i8*, i8*, i8*)

define i32 @sub_140002960(i8* %format, i64 %arg1, i64 %arg2, i64 %arg3) {
entry:
  %va = alloca [3 x i64], align 16
  %p0 = getelementptr inbounds [3 x i64], [3 x i64]* %va, i64 0, i64 0
  store i64 %arg1, i64* %p0, align 8
  %p1 = getelementptr inbounds [3 x i64], [3 x i64]* %va, i64 0, i64 1
  store i64 %arg2, i64* %p1, align 8
  %p2 = getelementptr inbounds [3 x i64], [3 x i64]* %va, i64 0, i64 2
  store i64 %arg3, i64* %p2, align 8
  %arglist = bitcast [3 x i64]* %va to i8*
  %stream = call i8* @__acrt_iob_func(i32 1)
  %opts_ptr = call i64* @sub_140002A10()
  %opts = load i64, i64* %opts_ptr, align 8
  %res = call i32 @__stdio_common_vfprintf(i64 %opts, i8* %stream, i8* %format, i8* null, i8* %arglist)
  ret i32 %res
}