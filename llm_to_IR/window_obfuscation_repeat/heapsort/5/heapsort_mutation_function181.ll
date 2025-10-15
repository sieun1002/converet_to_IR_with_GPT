; ModuleID = 'fixed_module'
source_filename = "sub_140002030.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global void (i8*)*

define dso_local void @sub_140002030(i32 %ecx, i8* %rdx, double %a0, double %a1, double %a2, double %a3, double %a4) local_unnamed_addr {
entry:
  %fp = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %fp_is_null = icmp eq void (i8*)* %fp, null
  br i1 %fp_is_null, label %ret, label %do_call

do_call:
  %s = alloca { i32, i8*, double, double, double }, align 8
  %s_ecx_ptr = getelementptr inbounds { i32, i8*, double, double, double }, { i32, i8*, double, double, double }* %s, i32 0, i32 0
  store i32 %ecx, i32* %s_ecx_ptr, align 4
  %s_rdx_ptr = getelementptr inbounds { i32, i8*, double, double, double }, { i32, i8*, double, double, double }* %s, i32 0, i32 1
  store i8* %rdx, i8** %s_rdx_ptr, align 8
  %s_d2_ptr = getelementptr inbounds { i32, i8*, double, double, double }, { i32, i8*, double, double, double }* %s, i32 0, i32 2
  store double %a2, double* %s_d2_ptr, align 8
  %s_d3_ptr = getelementptr inbounds { i32, i8*, double, double, double }, { i32, i8*, double, double, double }* %s, i32 0, i32 3
  store double %a3, double* %s_d3_ptr, align 8
  %s_d4_ptr = getelementptr inbounds { i32, i8*, double, double, double }, { i32, i8*, double, double, double }* %s, i32 0, i32 4
  store double %a4, double* %s_d4_ptr, align 8
  %s_i8 = bitcast { i32, i8*, double, double, double }* %s to i8*
  call void %fp(i8* %s_i8)
  br label %ret

ret:
  ret void
}