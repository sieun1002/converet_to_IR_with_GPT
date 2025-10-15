; ModuleID = 'sub_140001820_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*, align 8

define void @sub_140001820() {
entry:
  %p0 = load i8*, i8** @off_140003000, align 8
  %p0_fnpp = bitcast i8* %p0 to void ()**
  %f0 = load void ()*, void ()** %p0_fnpp, align 8
  %isnull = icmp eq void ()* %f0, null
  br i1 %isnull, label %done, label %loop

loop:
  %curf = phi void ()* [ %f0, %entry ], [ %nextf, %loop ]
  call void %curf()
  %pcur = load i8*, i8** @off_140003000, align 8
  %nextptr = getelementptr inbounds i8, i8* %pcur, i64 8
  %next_fnpp = bitcast i8* %nextptr to void ()**
  %nextf = load void ()*, void ()** %next_fnpp, align 8
  store i8* %nextptr, i8** @off_140003000, align 8
  %cont = icmp ne void ()* %nextf, null
  br i1 %cont, label %loop, label %done

done:
  ret void
}