; ModuleID = 'sub_140002030_module'
target triple = "x86_64-pc-windows-msvc"

%struct.anon = type { i32, i32, i64, <2 x double>, double }

@qword_1400070B0 = external global void (%struct.anon*)*, align 8

define void @sub_140002030(i32 %ecx, i64 %rdx, double %a, double %b, double %c) {
entry:
  %fp = load void (%struct.anon*)*, void (%struct.anon*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (%struct.anon*)* %fp, null
  br i1 %cmp, label %ret, label %callpath

callpath:
  %blk = alloca %struct.anon, align 8
  %f0 = getelementptr inbounds %struct.anon, %struct.anon* %blk, i32 0, i32 0
  store i32 %ecx, i32* %f0, align 4
  %f2 = getelementptr inbounds %struct.anon, %struct.anon* %blk, i32 0, i32 2
  store i64 %rdx, i64* %f2, align 8
  %v0 = insertelement <2 x double> undef, double %b, i32 0
  %v1 = insertelement <2 x double> %v0, double %c, i32 1
  %f3 = getelementptr inbounds %struct.anon, %struct.anon* %blk, i32 0, i32 3
  store <2 x double> %v1, <2 x double>* %f3, align 8
  %f4 = getelementptr inbounds %struct.anon, %struct.anon* %blk, i32 0, i32 4
  store double %a, double* %f4, align 8
  call void %fp(%struct.anon* %blk)
  br label %ret

ret:
  ret void
}