; ModuleID = 'module'
source_filename = "module.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global void (i8*)*

%struct.S = type { i32, i32, i8*, <2 x double>, double }

define void @sub_140002100(i32 %arg_ecx, i8* %arg_rdx, double %arg_xmm2, double %arg_xmm3, double %arg5) {
entry:
  %fp = load void (i8*)*, void (i8*)** @qword_1400070B0
  %isnull = icmp eq void (i8*)* %fp, null
  br i1 %isnull, label %ret, label %call

call:
  %s = alloca %struct.S
  %p0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg_ecx, i32* %p0
  %p2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i8* %arg_rdx, i8** %p2
  %vecinit = insertelement <2 x double> undef, double %arg_xmm2, i32 0
  %vec = insertelement <2 x double> %vecinit, double %arg_xmm3, i32 1
  %p3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store <2 x double> %vec, <2 x double>* %p3
  %p4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg5, double* %p4
  %s_i8 = bitcast %struct.S* %s to i8*
  call void %fp(i8* %s_i8)
  br label %ret

ret:
  ret void
}