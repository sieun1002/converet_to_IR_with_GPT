; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

%struct.ARGPACK = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.ARGPACK*)*, align 8

define void @sub_140002030(i32 %a1, i64 %a2, double %a3, double %a4, double %a5) {
entry:
  %fp = load void (%struct.ARGPACK*)*, void (%struct.ARGPACK*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (%struct.ARGPACK*)* %fp, null
  br i1 %cmp, label %ret, label %cont

cont:
  %agg = alloca %struct.ARGPACK, align 8
  %field0 = getelementptr inbounds %struct.ARGPACK, %struct.ARGPACK* %agg, i32 0, i32 0
  store i32 %a1, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.ARGPACK, %struct.ARGPACK* %agg, i32 0, i32 2
  store i64 %a2, i64* %field2, align 8
  %field3 = getelementptr inbounds %struct.ARGPACK, %struct.ARGPACK* %agg, i32 0, i32 3
  store double %a3, double* %field3, align 8
  %field4 = getelementptr inbounds %struct.ARGPACK, %struct.ARGPACK* %agg, i32 0, i32 4
  store double %a4, double* %field4, align 8
  %field5 = getelementptr inbounds %struct.ARGPACK, %struct.ARGPACK* %agg, i32 0, i32 5
  store double %a5, double* %field5, align 8
  call void %fp(%struct.ARGPACK* %agg)
  br label %ret

ret:
  ret void
}