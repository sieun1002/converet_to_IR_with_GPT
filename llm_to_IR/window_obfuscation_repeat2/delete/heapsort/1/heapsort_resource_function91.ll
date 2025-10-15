; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define dso_local void @sub_140001820() local_unnamed_addr {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %fp0 = load void ()*, void ()** %p0, align 8
  %cond0 = icmp eq void ()* %fp0, null
  br i1 %cond0, label %done, label %loop

loop:
  %p.cur = phi void ()** [ %p0, %entry ], [ %nextp, %loop ]
  %fp.cur = phi void ()* [ %fp0, %entry ], [ %nextfp, %loop ]
  call void %fp.cur()
  %nextp = getelementptr inbounds void ()*, void ()** %p.cur, i64 1
  %nextfp = load void ()*, void ()** %nextp, align 8
  store void ()** %nextp, void ()*** @off_140003000, align 8
  %cond1 = icmp eq void ()* %nextfp, null
  br i1 %cond1, label %done, label %loop

done:
  ret void
}