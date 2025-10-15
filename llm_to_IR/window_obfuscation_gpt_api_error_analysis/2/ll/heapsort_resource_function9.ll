; ModuleID = 'sub_140001820.ll'
source_filename = "sub_140001820"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() local_unnamed_addr {
entry:
  %g0 = load void ()**, void ()*** @off_140003000, align 8
  %fp0 = load void ()*, void ()** %g0, align 8
  %cond0 = icmp ne void ()* %fp0, null
  br i1 %cond0, label %loop, label %exit

loop:
  %g.phi = phi void ()** [ %g0, %entry ], [ %g.next, %loop ]
  %fp.phi = phi void ()* [ %fp0, %entry ], [ %fp.next, %loop ]
  call void %fp.phi()
  %g.next = getelementptr inbounds void ()*, void ()** %g.phi, i64 1
  store void ()** %g.next, void ()*** @off_140003000, align 8
  %fp.next = load void ()*, void ()** %g.next, align 8
  %cond = icmp ne void ()* %fp.next, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}