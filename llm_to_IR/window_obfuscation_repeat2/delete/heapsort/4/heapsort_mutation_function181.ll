; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global i8*

define void @sub_140002030(i32 %arg1, i64 %arg2, double %arg3, double %arg4, double %arg5) {
entry:
  %fp = load i8*, i8** @qword_1400070B0
  %isnull = icmp eq i8* %fp, null
  br i1 %isnull, label %ret, label %callblk

callblk:
  %S = alloca { i32, i64, [2 x double], double }, align 8
  %S_i32_ptr = getelementptr inbounds { i32, i64, [2 x double], double }, { i32, i64, [2 x double], double }* %S, i32 0, i32 0
  store i32 %arg1, i32* %S_i32_ptr, align 4
  %S_i64_ptr = getelementptr inbounds { i32, i64, [2 x double], double }, { i32, i64, [2 x double], double }* %S, i32 0, i32 1
  store i64 %arg2, i64* %S_i64_ptr, align 8
  %S_arr_ptr = getelementptr inbounds { i32, i64, [2 x double], double }, { i32, i64, [2 x double], double }* %S, i32 0, i32 2
  %elem0 = getelementptr inbounds [2 x double], [2 x double]* %S_arr_ptr, i32 0, i32 0
  store double %arg3, double* %elem0, align 8
  %elem1 = getelementptr inbounds [2 x double], [2 x double]* %S_arr_ptr, i32 0, i32 1
  store double %arg4, double* %elem1, align 8
  %S_dbl_ptr = getelementptr inbounds { i32, i64, [2 x double], double }, { i32, i64, [2 x double], double }* %S, i32 0, i32 3
  store double %arg5, double* %S_dbl_ptr, align 8
  %S_cast = bitcast { i32, i64, [2 x double], double }* %S to i8*
  %fp_cast = bitcast i8* %fp to void (i8*)*
  call void %fp_cast(i8* %S_cast)
  br label %ret

ret:
  ret void
}