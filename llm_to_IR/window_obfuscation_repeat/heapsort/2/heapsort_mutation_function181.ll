; ModuleID = 'sub_140002030_module'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.S*)*

define void @sub_140002030(i32 %a, i64 %b, double %c, double %d, double %e) {
entry:
  %fnptr = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (%struct.S*)* %fnptr, null
  br i1 %isnull, label %ret, label %build

build:
  %s = alloca %struct.S, align 8
  %field0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %a, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %b, i64* %field2, align 8
  %field3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %c, double* %field3, align 8
  %field4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %d, double* %field4, align 8
  %field5 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %e, double* %field5, align 8
  call void %fnptr(%struct.S* %s)
  br label %ret

ret:
  ret void
}