; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global i8*, align 8

define void @sub_140002030(i32 %a, i64 %b, double %c, double %d, double %e) {
entry:
  %fp_raw = load i8*, i8** @qword_1400070B0, align 8
  %isnull = icmp eq i8* %fp_raw, null
  br i1 %isnull, label %ret, label %do_call

do_call:
  %s = alloca %struct.S, align 8
  %s_f0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %a, i32* %s_f0, align 4
  %s_f2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %b, i64* %s_f2, align 8
  %s_arr = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  %s_arr0 = getelementptr inbounds [2 x double], [2 x double]* %s_arr, i32 0, i32 0
  store double %c, double* %s_arr0, align 8
  %s_arr1 = getelementptr inbounds [2 x double], [2 x double]* %s_arr, i32 0, i32 1
  store double %d, double* %s_arr1, align 8
  %s_f4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %e, double* %s_f4, align 8
  %fp = bitcast i8* %fp_raw to void (i8*)*
  %s_i8 = bitcast %struct.S* %s to i8*
  call void %fp(i8* %s_i8)
  br label %ret

ret:
  ret void
}