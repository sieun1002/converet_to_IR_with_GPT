target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %base.ptr = load void ()**, void ()*** @off_140003000, align 8
  %first.fn = load void ()*, void ()** %base.ptr, align 8
  %cmp0 = icmp eq void ()* %first.fn, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %curr.fn = phi void ()* [ %first.fn, %entry ], [ %next.fn, %update ]
  call void %curr.fn()
  br label %update

update:
  %base.ptr2 = load void ()**, void ()*** @off_140003000, align 8
  %next.base = getelementptr inbounds void ()*, void ()** %base.ptr2, i64 1
  %next.fn = load void ()*, void ()** %next.base, align 8
  store void ()** %next.base, void ()*** @off_140003000, align 8
  %cmp1 = icmp ne void ()* %next.fn, null
  br i1 %cmp1, label %loop, label %exit

exit:
  ret void
}