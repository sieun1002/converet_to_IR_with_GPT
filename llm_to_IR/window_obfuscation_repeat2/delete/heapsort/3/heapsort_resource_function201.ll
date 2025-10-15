; ModuleID = 'module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.sub_140002030_args = type { i32, i32, i64, [2 x double], double }

@qword_1400070B0 = external global i8*, align 8

define dso_local void @sub_140002030(i32 %arg0, i64 %arg1, double %arg2, double %arg3, double %arg4) {
entry:
  %0 = load i8*, i8** @qword_1400070B0, align 8
  %cmp = icmp eq i8* %0, null
  br i1 %cmp, label %ret, label %prepare

prepare:
  %s = alloca %struct.sub_140002030_args, align 8
  %s.field0 = getelementptr inbounds %struct.sub_140002030_args, %struct.sub_140002030_args* %s, i32 0, i32 0
  store i32 %arg0, i32* %s.field0, align 4
  %s.field2 = getelementptr inbounds %struct.sub_140002030_args, %struct.sub_140002030_args* %s, i32 0, i32 2
  store i64 %arg1, i64* %s.field2, align 8
  %s.field3 = getelementptr inbounds %struct.sub_140002030_args, %struct.sub_140002030_args* %s, i32 0, i32 3
  %s.field3.elem0 = getelementptr inbounds [2 x double], [2 x double]* %s.field3, i32 0, i32 0
  store double %arg2, double* %s.field3.elem0, align 8
  %s.field3.elem1 = getelementptr inbounds [2 x double], [2 x double]* %s.field3, i32 0, i32 1
  store double %arg3, double* %s.field3.elem1, align 8
  %s.field4 = getelementptr inbounds %struct.sub_140002030_args, %struct.sub_140002030_args* %s, i32 0, i32 4
  store double %arg4, double* %s.field4, align 8
  %1 = bitcast i8* %0 to void (%struct.sub_140002030_args*)*
  call void %1(%struct.sub_140002030_args* %s)
  br label %ret

ret:
  ret void
}