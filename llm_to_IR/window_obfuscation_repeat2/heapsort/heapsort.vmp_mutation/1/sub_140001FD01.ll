; ModuleID = 'module'
source_filename = "module"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.anon = type { i32, i32, i64, double, double, double }

@qword_1400070B0 = external global i8*, align 8

define void @sub_140001FD0(i32 %a1, i64 %a2, double %a3, double %a4, double %a5) {
entry:
  %fp_ptr = load i8*, i8** @qword_1400070B0, align 8
  %cmp = icmp eq i8* %fp_ptr, null
  br i1 %cmp, label %ret, label %callblk

callblk:
  %s = alloca %struct.anon, align 8
  %field0 = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 0
  store i32 %a1, i32* %field0, align 4
  %field2 = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 2
  store i64 %a2, i64* %field2, align 8
  %field3 = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 3
  store double %a3, double* %field3, align 8
  %field4 = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 4
  store double %a4, double* %field4, align 8
  %field5 = getelementptr inbounds %struct.anon, %struct.anon* %s, i32 0, i32 5
  store double %a5, double* %field5, align 8
  %fp = bitcast i8* %fp_ptr to void (%struct.anon*)*
  call void %fp(%struct.anon* %s)
  br label %ret

ret:
  ret void
}