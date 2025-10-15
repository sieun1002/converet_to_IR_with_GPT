; ModuleID = 'sub_140002030'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.ctx = type { i32, i32, i64, <2 x double>, double }

@qword_1400070B0 = external dso_local global ptr, align 8

define dso_local void @sub_140002030(i32 %ecx, i64 %rdx, double %f0, double %f1, double %f2, double %f3, double %f4) {
entry:
  %fpraw = load ptr, ptr @qword_1400070B0, align 8
  %isnull = icmp eq ptr %fpraw, null
  br i1 %isnull, label %exit, label %prepare

prepare:
  %ctx = alloca %struct.ctx, align 16
  %ctx_ecx = getelementptr inbounds %struct.ctx, ptr %ctx, i32 0, i32 0
  store i32 %ecx, ptr %ctx_ecx, align 4
  %ctx_rdx = getelementptr inbounds %struct.ctx, ptr %ctx, i32 0, i32 2
  store i64 %rdx, ptr %ctx_rdx, align 8
  %vec0 = insertelement <2 x double> undef, double %f2, i32 0
  %vec1 = insertelement <2 x double> %vec0, double %f3, i32 1
  %ctx_vec = getelementptr inbounds %struct.ctx, ptr %ctx, i32 0, i32 3
  store <2 x double> %vec1, ptr %ctx_vec, align 16
  %ctx_f4 = getelementptr inbounds %struct.ctx, ptr %ctx, i32 0, i32 4
  store double %f4, ptr %ctx_f4, align 8
  %fp = bitcast ptr %fpraw to void (ptr)*
  call void %fp(ptr %ctx)
  br label %exit

exit:
  ret void
}