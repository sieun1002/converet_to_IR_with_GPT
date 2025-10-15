; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@qword_1400070B0 = external global i8*

define void @sub_140002030(i32 %ecx_arg, i8* %rdx_arg, double %xmm2_arg, double %xmm3_arg, double %stack_double_arg) {
entry:
  %fp = alloca [40 x i8], align 8
  %funcptr.addr = load i8*, i8** @qword_1400070B0, align 8
  %isnull = icmp eq i8* %funcptr.addr, null
  br i1 %isnull, label %ret, label %prepare

prepare:
  %p0 = getelementptr inbounds [40 x i8], [40 x i8]* %fp, i64 0, i64 0
  %p0_i32 = bitcast i8* %p0 to i32*
  store i32 %ecx_arg, i32* %p0_i32, align 4
  %p8 = getelementptr inbounds [40 x i8], [40 x i8]* %fp, i64 0, i64 8
  %p8_ptr = bitcast i8* %p8 to i8**
  store i8* %rdx_arg, i8** %p8_ptr, align 8
  %p16 = getelementptr inbounds [40 x i8], [40 x i8]* %fp, i64 0, i64 16
  %p16_d = bitcast i8* %p16 to double*
  store double %xmm2_arg, double* %p16_d, align 8
  %p24 = getelementptr inbounds [40 x i8], [40 x i8]* %fp, i64 0, i64 24
  %p24_d = bitcast i8* %p24 to double*
  store double %xmm3_arg, double* %p24_d, align 8
  %p32 = getelementptr inbounds [40 x i8], [40 x i8]* %fp, i64 0, i64 32
  %p32_d = bitcast i8* %p32 to double*
  store double %stack_double_arg, double* %p32_d, align 8
  %argptr = bitcast [40 x i8]* %fp to i8*
  %callee = bitcast i8* %funcptr.addr to void (i8*)*
  call void %callee(i8* %argptr)
  br label %ret

ret:
  ret void
}