; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.S*)*

define dso_local void @sub_140002030(i32 %a, i64 %b, double %c, double %d, double %e) {
entry:
  %s = alloca %struct.S, align 8
  %cb.ptr = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %cb.null = icmp eq void (%struct.S*)* %cb.ptr, null
  br i1 %cb.null, label %ret, label %do

do:
  %s.a = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %a, i32* %s.a, align 4
  %s.b = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %b, i64* %s.b, align 8
  %s.c = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %c, double* %s.c, align 8
  %s.d = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %d, double* %s.d, align 8
  %s.e = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %e, double* %s.e, align 8
  call void %cb.ptr(%struct.S* nonnull %s)
  br label %ret

ret:
  ret void
}