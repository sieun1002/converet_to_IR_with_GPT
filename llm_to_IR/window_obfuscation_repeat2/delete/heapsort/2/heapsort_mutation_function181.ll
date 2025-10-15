; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, <2 x double>, double }

@qword_1400070B0 = external global void (i8*)*

define void @sub_140002030(i32 %ecx, i64 %rdx, double %f2, double %f3, double %f5) {
entry:
  %fp.ptr = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (i8*)* %fp.ptr, null
  br i1 %isnull, label %ret, label %call

call:
  %s = alloca %struct.S, align 8
  %field0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %ecx, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %rdx, i64* %field2, align 8
  %vec0 = insertelement <2 x double> undef, double %f2, i32 0
  %vec1 = insertelement <2 x double> %vec0, double %f3, i32 1
  %field3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store <2 x double> %vec1, <2 x double>* %field3, align 8
  %field4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %f5, double* %field4, align 8
  %s.i8 = bitcast %struct.S* %s to i8*
  call void %fp.ptr(i8* %s.i8)
  br label %ret

ret:
  ret void
}