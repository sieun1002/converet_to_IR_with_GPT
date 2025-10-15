; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@qword_1400070B0 = external global void (i8*)*

define dso_local void @sub_140002100(i32 %arg0, i8* %arg1, double %fp0, double %fp1, double %fp2, double %fp3, double %fp4) {
entry:
  %fnptr = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (i8*)* %fnptr, null
  br i1 %cmp, label %ret, label %callprep

callprep:
  %s = alloca { i32, i32, i8*, double, double, double }, align 8
  %s_a = getelementptr inbounds { i32, i32, i8*, double, double, double }, { i32, i32, i8*, double, double, double }* %s, i32 0, i32 0
  store i32 %arg0, i32* %s_a, align 4
  %s_p = getelementptr inbounds { i32, i32, i8*, double, double, double }, { i32, i32, i8*, double, double, double }* %s, i32 0, i32 2
  store i8* %arg1, i8** %s_p, align 8
  %s_d2 = getelementptr inbounds { i32, i32, i8*, double, double, double }, { i32, i32, i8*, double, double, double }* %s, i32 0, i32 3
  store double %fp2, double* %s_d2, align 8
  %s_d3 = getelementptr inbounds { i32, i32, i8*, double, double, double }, { i32, i32, i8*, double, double, double }* %s, i32 0, i32 4
  store double %fp3, double* %s_d3, align 8
  %s_d5 = getelementptr inbounds { i32, i32, i8*, double, double, double }, { i32, i32, i8*, double, double, double }* %s, i32 0, i32 5
  store double %fp4, double* %s_d5, align 8
  %s_cast = bitcast { i32, i32, i8*, double, double, double }* %s to i8*
  call void %fnptr(i8* %s_cast)
  br label %ret

ret:
  ret void
}