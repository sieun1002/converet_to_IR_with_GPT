; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global void (%struct.S*)*

define void @sub_140002030(i32 %arg0, i64 %arg1, double %arg2, double %arg3, double %arg4) {
entry:
  %fp = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0
  %cmp = icmp eq void (%struct.S*)* %fp, null
  br i1 %cmp, label %ret, label %do_call

do_call:
  %s = alloca %struct.S, align 8
  %f0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg0, i32* %f0, align 4
  %f2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %arg1, i64* %f2, align 8
  %f3_0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3, i32 0
  store double %arg2, double* %f3_0, align 8
  %f3_1 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3, i32 1
  store double %arg3, double* %f3_1, align 8
  %f4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg4, double* %f4, align 8
  call void %fp(%struct.S* %s)
  br label %ret

ret:
  ret void
}