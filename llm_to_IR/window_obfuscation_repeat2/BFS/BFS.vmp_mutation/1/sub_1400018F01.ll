; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

@off_140003000 = external global void ()**

define void @sub_1400018F0() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %fp0 = load void ()*, void ()** %p0, align 8
  %cmp0 = icmp eq void ()* %fp0, null
  br i1 %cmp0, label %ret, label %loop

loop:
  %curfp = phi void ()* [ %fp0, %entry ], [ %nextfp, %loop ]
  call void %curfp()
  %p = load void ()**, void ()*** @off_140003000, align 8
  %nextptr = getelementptr inbounds void ()*, void ()** %p, i64 1
  %nextfp = load void ()*, void ()** %nextptr, align 8
  store void ()** %nextptr, void ()*** @off_140003000, align 8
  %cond = icmp ne void ()* %nextfp, null
  br i1 %cond, label %loop, label %ret

ret:
  ret void
}