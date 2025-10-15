; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global ptr, align 8

define void @sub_140002030(i32 %ecx_in, i64 %rdx_in, double %xmm2_low, double %xmm3_low, double %stack_double) {
entry:
  %buf = alloca %struct.S, align 8
  %fp = load ptr, ptr @qword_1400070B0, align 8
  %isnull = icmp eq ptr %fp, null
  br i1 %isnull, label %ret, label %cont

cont:
  %f0 = getelementptr inbounds %struct.S, ptr %buf, i32 0, i32 0
  store i32 %ecx_in, ptr %f0, align 4
  %f2 = getelementptr inbounds %struct.S, ptr %buf, i32 0, i32 2
  store i64 %rdx_in, ptr %f2, align 8
  %f3_0 = getelementptr inbounds %struct.S, ptr %buf, i32 0, i32 3, i32 0
  store double %xmm2_low, ptr %f3_0, align 8
  %f3_1 = getelementptr inbounds %struct.S, ptr %buf, i32 0, i32 3, i32 1
  store double %xmm3_low, ptr %f3_1, align 8
  %f4 = getelementptr inbounds %struct.S, ptr %buf, i32 0, i32 4
  store double %stack_double, ptr %f4, align 8
  %callee = bitcast ptr %fp to ptr (ptr)*
  call void %callee(ptr %buf)
  br label %ret

ret:
  ret void
}