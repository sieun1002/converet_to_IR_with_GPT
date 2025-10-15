; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external dso_local global void ()**, align 8

define dso_local void @sub_140001820() local_unnamed_addr {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %f0 = load void ()*, void ()** %p0, align 8
  %cmp0 = icmp eq void ()* %f0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %p.cur = phi void ()** [ %p0, %entry ], [ %p.next, %loop ]
  %f.cur = phi void ()* [ %f0, %entry ], [ %f.next, %loop ]
  call void %f.cur()
  %p.next = getelementptr inbounds void ()*, void ()** %p.cur, i64 1
  %f.next = load void ()*, void ()** %p.next, align 8
  store void ()** %p.next, void ()*** @off_140003000, align 8
  %cont = icmp ne void ()* %f.next, null
  br i1 %cont, label %loop, label %exit

exit:
  ret void
}