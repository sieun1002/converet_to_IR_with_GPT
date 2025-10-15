; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external dso_local global void ()**, align 8

define dso_local void @sub_140001820() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %fn0 = load void ()*, void ()** %p0, align 8
  %cmp0 = icmp eq void ()* %fn0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %fn.cur = phi void ()* [ %fn0, %entry ], [ %fn.next, %update ]
  call void %fn.cur()
  %p1 = load void ()**, void ()*** @off_140003000, align 8
  %pnext = getelementptr inbounds void ()*, void ()** %p1, i64 1
  %fn.next = load void ()*, void ()** %pnext, align 8
  store void ()** %pnext, void ()*** @off_140003000, align 8
  br label %update

update:
  %cmp1 = icmp eq void ()* %fn.next, null
  br i1 %cmp1, label %exit, label %loop

exit:
  ret void
}