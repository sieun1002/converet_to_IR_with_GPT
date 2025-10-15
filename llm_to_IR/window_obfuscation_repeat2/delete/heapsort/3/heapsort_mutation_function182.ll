; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global i8*, align 8

define void @sub_140002030(i32 %ecx_in, i64 %rdx_in, double %xmm2_low, double %xmm3_low, double %stack_double) {
entry:
  %buf = alloca %struct.S, align 8
  %fp_ptr = load i8*, i8** @qword_1400070B0, align 8
  %isnull = icmp eq i8* %fp_ptr, null
  br i1 %isnull, label %ret, label %cont

cont:
  %f0 = getelementptr inbounds %struct.S, %struct.S* %buf, i32 0, i32 0
  store i32 %ecx_in, i32* %f0, align 4
  %f2 = getelementptr inbounds %struct.S, %struct.S* %buf, i32 0, i32 2
  store i64 %rdx_in, i64* %f2, align 8
  %f3_0 = getelementptr inbounds %struct.S, %struct.S* %buf, i32 0, i32 3, i32 0
  store double %xmm2_low, double* %f3_0, align 8
  %f3_1 = getelementptr inbounds %struct.S, %struct.S* %buf, i32 0, i32 3, i32 1
  store double %xmm3_low, double* %f3_1, align 8
  %f4 = getelementptr inbounds %struct.S, %struct.S* %buf, i32 0, i32 4
  store double %stack_double, double* %f4, align 8
  %callee = bitcast i8* %fp_ptr to void (%struct.S*)*
  call void %callee(%struct.S* %buf)
  br label %ret

ret:
  ret void
}