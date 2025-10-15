; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global void (%struct.S*)*

define void @sub_140002030(i32 %ecx, i64 %rdx, double %d2, double %d3, double %d5) {
entry:
  %fp = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (%struct.S*)* %fp, null
  br i1 %cmp, label %ret, label %callblk

callblk:
  %s = alloca %struct.S, align 8
  %s_f0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %ecx, i32* %s_f0, align 4
  %s_f2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %rdx, i64* %s_f2, align 8
  %s_arr = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  %s_arr0 = getelementptr inbounds [2 x double], [2 x double]* %s_arr, i32 0, i32 0
  store double %d2, double* %s_arr0, align 8
  %s_arr1 = getelementptr inbounds [2 x double], [2 x double]* %s_arr, i32 0, i32 1
  store double %d3, double* %s_arr1, align 8
  %s_f4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %d5, double* %s_f4, align 8
  call void %fp(%struct.S* %s)
  br label %ret

ret:
  ret void
}