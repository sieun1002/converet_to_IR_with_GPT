; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.S*)*

define void @sub_140002030(i32 %arg_ecx, i64 %arg_rdx, double %arg_xmm0, double %arg_xmm2, double %arg_xmm3) #0 {
entry:
  %fp = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (%struct.S*)* %fp, null
  br i1 %isnull, label %ret, label %call

call:
  %s = alloca %struct.S, align 8
  %s.a = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg_ecx, i32* %s.a, align 4
  %s.pad = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 1
  store i32 0, i32* %s.pad, align 4
  %s.b = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %arg_rdx, i64* %s.b, align 8
  %s.d1 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %arg_xmm2, double* %s.d1, align 8
  %s.d2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg_xmm3, double* %s.d2, align 8
  %s.d0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %arg_xmm0, double* %s.d0, align 8
  call void %fp(%struct.S* %s)
  br label %ret

ret:
  ret void
}

attributes #0 = { nounwind "target-cpu"="x86-64" }