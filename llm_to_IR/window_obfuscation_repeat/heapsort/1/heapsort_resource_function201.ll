; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.S*)*, align 8

define void @sub_140002030(i32 %a1, i64 %a2, double %a3, double %a4, double %a5) {
entry:
  %fp_ptr = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (%struct.S*)* %fp_ptr, null
  br i1 %cmp, label %ret, label %nonnull

nonnull:
  %s = alloca %struct.S, align 8
  %s_f0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %a1, i32* %s_f0, align 4
  %s_pad = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 1
  store i32 0, i32* %s_pad, align 4
  %s_f2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %a2, i64* %s_f2, align 8
  %s_f3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %a3, double* %s_f3, align 8
  %s_f4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %a4, double* %s_f4, align 8
  %s_f5 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %a5, double* %s_f5, align 8
  call void %fp_ptr(%struct.S* nonnull %s)
  br label %ret

ret:
  ret void
}