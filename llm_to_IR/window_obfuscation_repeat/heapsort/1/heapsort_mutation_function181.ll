; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.S = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global void (i8*)*

define void @sub_140002030(i32 %a, i64 %b, double %c, double %d, double %e) {
entry:
  %frame = alloca %struct.S, align 8
  %fnptr.addr = load void (i8*)*, void (i8*)** @qword_1400070B0, align 8
  %cmp = icmp eq void (i8*)* %fnptr.addr, null
  br i1 %cmp, label %ret, label %prepare

prepare:
  %a.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 0
  store i32 %a, i32* %a.ptr, align 4
  %pad.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 1
  store i32 0, i32* %pad.ptr, align 4
  %b.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 2
  store i64 %b, i64* %b.ptr, align 8
  %c.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 3
  store double %c, double* %c.ptr, align 8
  %d.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 4
  store double %d, double* %d.ptr, align 8
  %e.ptr = getelementptr inbounds %struct.S, %struct.S* %frame, i32 0, i32 5
  store double %e, double* %e.ptr, align 8
  %call.arg = bitcast %struct.S* %frame to i8*
  call void %fnptr.addr(i8* %call.arg)
  br label %ret

ret:
  ret void
}