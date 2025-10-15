; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global i8*

define void @sub_140001FD0(i32 %arg0, i8* %arg1, double %arg2, double %arg3, double %arg4) {
entry:
  %fp = load i8*, i8** @qword_1400070B0
  %isnull = icmp eq i8* %fp, null
  br i1 %isnull, label %ret, label %call

call:
  %tmp = alloca { i32, i32, i8*, <2 x double>, double }, align 8
  %field0 = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %tmp, i32 0, i32 0
  store i32 %arg0, i32* %field0, align 4
  %field2 = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %tmp, i32 0, i32 2
  store i8* %arg1, i8** %field2, align 8
  %vec0 = insertelement <2 x double> undef, double %arg2, i32 0
  %vec1 = insertelement <2 x double> %vec0, double %arg3, i32 1
  %field3 = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %tmp, i32 0, i32 3
  store <2 x double> %vec1, <2 x double>* %field3, align 8
  %field4 = getelementptr inbounds { i32, i32, i8*, <2 x double>, double }, { i32, i32, i8*, <2 x double>, double }* %tmp, i32 0, i32 4
  store double %arg4, double* %field4, align 8
  %tmp_cast = bitcast { i32, i32, i8*, <2 x double>, double }* %tmp to i8*
  %callee = bitcast i8* %fp to void (i8*)*
  call void %callee(i8* %tmp_cast)
  br label %ret

ret:
  ret void
}