; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global void (i8*)*

define void @sub_140002100(i32 %ecx_in, i8* %rdx_in, double %f0, double %f1, double %f2, double %f3, double %f_stack) {
entry:
  %fp = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (i8*)* %fp, null
  br i1 %cmp, label %ret, label %do_call

do_call:
  %s = alloca { i32, i32, i8*, <2 x double>, double }, align 8
  %s_i32 = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %s, i32 0, i32 0
  store i32 %ecx_in, i32* %s_i32, align 4
  %s_ptr = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %s, i32 0, i32 2
  store i8* %rdx_in, i8** %s_ptr, align 8
  %vec0 = insertelement <2 x double> undef, double %f2, i32 0
  %vec1 = insertelement <2 x double> %vec0, double %f3, i32 1
  %s_vec = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %s, i32 0, i32 3
  store <2 x double> %vec1, <2 x double>* %s_vec, align 8
  %s_d = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %s, i32 0, i32 4
  store double %f_stack, double* %s_d, align 8
  %s_as_i8 = bitcast { i32, i32, i8*, <2 x double>, double }* %s to i8*
  call void %fp(i8* %s_as_i8)
  br label %ret

ret:
  ret void
}