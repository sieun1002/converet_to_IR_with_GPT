; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

@off_140003000 = external global void ()** align 8

define dso_local void @sub_140001820() local_unnamed_addr {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %f0 = load void ()*, void ()** %p0, align 8
  %c0 = icmp eq void ()* %f0, null
  br i1 %c0, label %ret, label %loop

loop:
  %curpos = phi void ()** [ %p0, %entry ], [ %nextpos, %loop ]
  %curfn = phi void ()* [ %f0, %entry ], [ %nextfn, %loop ]
  call void %curfn()
  %nextpos = getelementptr inbounds void ()*, void ()** %curpos, i64 1
  store void ()** %nextpos, void ()*** @off_140003000, align 8
  %nextfn = load void ()*, void ()** %nextpos, align 8
  %isnull = icmp eq void ()* %nextfn, null
  br i1 %isnull, label %ret, label %loop

ret:
  ret void
}