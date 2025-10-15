; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i8*, double, double, double }

@qword_1400070B0 = external global void (i8*)*

define void @sub_140002030(i32 %arg1, i8* %arg2, double %arg3, double %arg4, double %arg5) {
entry:
  %fnptr = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (i8*)* %fnptr, null
  br i1 %cmp, label %ret, label %have

have:
  %s = alloca %struct.S, align 8
  %p0 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 0
  store i32 %arg1, i32* %p0, align 4
  %p2 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 2
  store i8* %arg2, i8** %p2, align 8
  %p3 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 3
  store double %arg3, double* %p3, align 8
  %p4 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 4
  store double %arg4, double* %p4, align 8
  %p5 = getelementptr inbounds %struct.S, %struct.S* %s, i32 0, i32 5
  store double %arg5, double* %p5, align 8
  %bc = bitcast %struct.S* %s to i8*
  call void %fnptr(i8* %bc)
  br label %ret

ret:
  ret void
}