; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_1400017C0() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %f0 = load void ()*, void ()** %p0, align 8
  %cmp0 = icmp eq void ()* %f0, null
  br i1 %cmp0, label %exit, label %call

call:
  call void %f0()
  %p1 = getelementptr inbounds void ()*, void ()** %p0, i64 1
  %f1 = load void ()*, void ()** %p1, align 8
  store void ()** %p1, void ()*** @off_140003000, align 8
  %cmp1 = icmp eq void ()* %f1, null
  br i1 %cmp1, label %exit, label %loop

loop:
  %p_cur = phi void ()** [ %p1, %call ], [ %p_next, %loop ]
  %f_cur = phi void ()*  [ %f1, %call ], [ %f_next, %loop ]
  call void %f_cur()
  %p_next = getelementptr inbounds void ()*, void ()** %p_cur, i64 1
  %f_next = load void ()*, void ()** %p_next, align 8
  store void ()** %p_next, void ()*** @off_140003000, align 8
  %cmp_next = icmp eq void ()* %f_next, null
  br i1 %cmp_next, label %exit, label %loop

exit:
  ret void
}