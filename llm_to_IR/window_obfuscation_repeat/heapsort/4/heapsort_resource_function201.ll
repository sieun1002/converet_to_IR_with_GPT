; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global void (i8*)*

define dso_local void @sub_140002030(i32 %ecx, i8* %rdx, double %xmm2_val, double %xmm3_val, double %stack_double) local_unnamed_addr {
entry:
  %fnptr = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (i8*)* %fnptr, null
  br i1 %isnull, label %ret, label %callpath

callpath:
  %frame = alloca { i32, i32, i8*, [2 x double], double }, align 8
  %ecx_ptr = getelementptr inbounds { i32, i32, i8*, [2 x double], double }, { i32, i32, i8*, [2 x double], double }* %frame, i32 0, i32 0
  store i32 %ecx, i32* %ecx_ptr, align 4
  %pad_ptr = getelementptr inbounds { i32, i32, i8*, [2 x double], double }, { i32, i32, i8*, [2 x double], double }* %frame, i32 0, i32 1
  store i32 0, i32* %pad_ptr, align 4
  %rdx_ptr = getelementptr inbounds { i32, i32, i8*, [2 x double], double }, { i32, i32, i8*, [2 x double], double }* %frame, i32 0, i32 2
  store i8* %rdx, i8** %rdx_ptr, align 8
  %vec_ptr = getelementptr inbounds { i32, i32, i8*, [2 x double], double }, { i32, i32, i8*, [2 x double], double }* %frame, i32 0, i32 3
  %vec_elt0 = getelementptr inbounds [2 x double], [2 x double]* %vec_ptr, i32 0, i32 0
  store double %xmm2_val, double* %vec_elt0, align 8
  %vec_elt1 = getelementptr inbounds [2 x double], [2 x double]* %vec_ptr, i32 0, i32 1
  store double %xmm3_val, double* %vec_elt1, align 8
  %d5_ptr = getelementptr inbounds { i32, i32, i8*, [2 x double], double }, { i32, i32, i8*, [2 x double], double }* %frame, i32 0, i32 4
  store double %stack_double, double* %d5_ptr, align 8
  %arg_ptr = bitcast { i32, i32, i8*, [2 x double], double }* %frame to i8*
  call void %fnptr(i8* %arg_ptr)
  br label %ret

ret:
  ret void
}