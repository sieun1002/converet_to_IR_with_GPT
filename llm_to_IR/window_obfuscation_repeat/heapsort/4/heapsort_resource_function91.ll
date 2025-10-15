; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() local_unnamed_addr {
entry:
  %0 = load void ()**, void ()*** @off_140003000, align 8
  %1 = load void ()*, void ()** %0, align 8
  %2 = icmp eq void ()* %1, null
  br i1 %2, label %exit, label %loop

loop:
  %f.cur = phi void ()* [ %1, %entry ], [ %5, %loop ]
  call void %f.cur()
  %3 = load void ()**, void ()*** @off_140003000, align 8
  %4 = getelementptr inbounds void ()*, void ()** %3, i64 1
  %5 = load void ()*, void ()** %4, align 8
  store void ()** %4, void ()*** @off_140003000, align 8
  %6 = icmp ne void ()* %5, null
  br i1 %6, label %loop, label %exit

exit:
  ret void
}