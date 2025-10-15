; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() local_unnamed_addr {
entry:
  %p.init = load void ()**, void ()*** @off_140003000, align 8
  %fn.init = load void ()*, void ()** %p.init, align 8
  br label %check

check:
  %fn.cur = phi void ()* [ %fn.init, %entry ], [ %fn.next, %body ]
  %p.cur = phi void ()** [ %p.init, %entry ], [ %p.next, %body ]
  %cmp = icmp eq void ()* %fn.cur, null
  br i1 %cmp, label %exit, label %body

body:
  call void %fn.cur()
  %p.next = getelementptr void ()*, void ()** %p.cur, i64 1
  %fn.next = load void ()*, void ()** %p.next, align 8
  store void ()** %p.next, void ()*** @off_140003000, align 8
  br label %check

exit:
  ret void
}