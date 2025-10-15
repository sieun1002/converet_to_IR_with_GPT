; ModuleID = 'sub_140001820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %f0 = load void ()*, void ()** %p0, align 8
  %notnull0 = icmp ne void ()* %f0, null
  br i1 %notnull0, label %loop, label %exit

loop:
  %f.cur = phi void ()* [ %f0, %entry ], [ %f.next, %loop ]
  call void %f.cur()
  %pcur = load void ()**, void ()*** @off_140003000, align 8
  %pnext = getelementptr inbounds void ()*, void ()** %pcur, i64 1
  %f.next = load void ()*, void ()** %pnext, align 8
  store void ()** %pnext, void ()*** @off_140003000, align 8
  %hasnext = icmp ne void ()* %f.next, null
  br i1 %hasnext, label %loop, label %exit

exit:
  ret void
}