; ModuleID = 'sub_140002030.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i64, <2 x double>, double }

@qword_1400070B0 = external dso_local global void (%struct.S*)*, align 8

define dso_local void @sub_140002030(i32 %arg_ecx, i64 %arg_rdx, double %arg_xmm2, double %arg_xmm3, double %arg_stack_dbl) local_unnamed_addr {
entry:
  %fp.ptr = load void (%struct.S*)*, void (%struct.S*)** @qword_1400070B0, align 8
  %cmp.null = icmp eq void (%struct.S*)* %fp.ptr, null
  br i1 %cmp.null, label %ret, label %have

have:
  %s = alloca %struct.S, align 16
  %p.i32 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg_ecx, i32* %p.i32, align 4
  %p.i64 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 1
  store i64 %arg_rdx, i64* %p.i64, align 8
  %vec0 = insertelement <2 x double> undef, double %arg_xmm2, i32 0
  %vec1 = insertelement <2 x double> %vec0, double %arg_xmm3, i32 1
  %p.vec = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store <2 x double> %vec1, <2 x double>* %p.vec, align 16
  %p.dbl = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %arg_stack_dbl, double* %p.dbl, align 8
  call void %fp.ptr(%struct.S* nonnull %s)
  br label %ret

ret:
  ret void
}