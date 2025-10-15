; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %fp0 = load void ()*, void ()** %p0, align 8
  %isnull = icmp eq void ()* %fp0, null
  br i1 %isnull, label %exit, label %loop

loop:
  %fp = phi void ()* [ %fp0, %entry ], [ %fpNext, %loop ]
  call void %fp()
  %p1 = load void ()**, void ()*** @off_140003000, align 8
  %nextp = getelementptr inbounds void ()*, void ()** %p1, i64 1
  %fpNext = load void ()*, void ()** %nextp, align 8
  store void ()** %nextp, void ()*** @off_140003000, align 8
  %cond = icmp ne void ()* %fpNext, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}