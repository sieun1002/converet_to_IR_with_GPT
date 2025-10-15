; ModuleID = 'sub_140002030_module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (%struct.S*)*, align 8

define void @sub_140002030(i32 %arg_ecx, i64 %arg_rdx, double %arg_xmm2, double %arg_xmm3, double %arg_stack_dbl) {
entry:
  %fp = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %isnull = icmp eq void (%struct.S*)* %fp, null
  br i1 %isnull, label %ret, label %do_call

do_call:
  %s = alloca %struct.S, align 8
  %s_i32 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg_ecx, i32* %s_i32, align 4
  %s_i64 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i64 %arg_rdx, i64* %s_i64, align 8
  %s_d0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %arg_xmm2, double* %s_d0, align 8
  %s_d1 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg_xmm3, double* %s_d1, align 8
  %s_d2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %arg_stack_dbl, double* %s_d2, align 8
  call void %fp(%struct.S* %s)
  br label %ret

ret:
  ret void
}