; ModuleID = 'sub_140001FD0_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i8*, [2 x double], double }

@qword_1400070B0 = external global i8*

define void @sub_140001FD0(i32 %arg1, i8* %arg2, double %arg3, double %arg4, double %arg5) {
entry:
  %s = alloca %struct.S, align 8
  %fpaddr_ptr = load i8*, i8** @qword_1400070B0
  %isnull = icmp eq i8* %fpaddr_ptr, null
  br i1 %isnull, label %ret, label %call

call:
  %s_i32 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg1, i32* %s_i32, align 4
  %s_ptr = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i8* %arg2, i8** %s_ptr, align 8
  %s_darr0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3, i32 0
  store double %arg3, double* %s_darr0, align 8
  %s_darr1 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3, i32 1
  store double %arg4, double* %s_darr1, align 8
  %s_d5 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg5, double* %s_d5, align 8
  %s_i8 = bitcast %struct.S* %s to i8*
  %fp = bitcast i8* %fpaddr_ptr to void (i8*)*
  call void %fp(i8* %s_i8)
  br label %ret

ret:
  ret void
}