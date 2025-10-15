; ModuleID = 'sub_140002030.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, [4 x i8], i64, <2 x double>, double }

@qword_1400070B0 = external global void (%struct.S*)*

define void @sub_140002030(i32 %arg_ecx, i64 %arg_rdx, double %arg_fp3, double %arg_fp4, double %arg_fp5) {
entry:
  %frame = alloca %struct.S, align 16
  %pfn = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (%struct.S*)* %pfn, null
  br i1 %cmp, label %ret, label %do_call

do_call:
  %field0 = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 0
  store i32 %arg_ecx, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 2
  store i64 %arg_rdx, i64* %field2, align 8
  %vec.undef = undef <2 x double>
  %vec.ins0 = insertelement <2 x double> %vec.undef, double %arg_fp3, i32 0
  %vec.ins1 = insertelement <2 x double> %vec.ins0, double %arg_fp4, i32 1
  %field3 = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 3
  store <2 x double> %vec.ins1, <2 x double>* %field3, align 16
  %field4 = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 4
  store double %arg_fp5, double* %field4, align 8
  call void %pfn(%struct.S* %frame)
  br label %ret

ret:
  ret void
}