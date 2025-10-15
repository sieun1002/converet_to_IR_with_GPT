; ModuleID = 'sub_140002030.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i64, double, double, double }

@qword_1400070B0 = external dso_local global void (%struct.S*)*

define dso_local void @sub_140002030(i32 %a, i64 %b, double %c, double %d, double %e) local_unnamed_addr {
entry:
  %fp.ptr = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (%struct.S*)* %fp.ptr, null
  br i1 %isnull, label %ret, label %build

build:
  %s = alloca %struct.S, align 8
  %field0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %a, i32* %field0, align 4
  %field1 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 1
  store i64 %b, i64* %field1, align 8
  %field2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store double %c, double* %field2, align 8
  %field3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %d, double* %field3, align 8
  %field4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %e, double* %field4, align 8
  call void %fp.ptr(%struct.S* %s)
  br label %ret

ret:
  ret void
}