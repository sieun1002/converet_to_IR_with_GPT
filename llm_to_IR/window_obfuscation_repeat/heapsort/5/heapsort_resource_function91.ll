; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**, align 8

define void @sub_140001820() {
entry:
  %p0.ptrptr = load void ()**, void ()*** @off_140003000, align 8
  %fn0.ptr = load void ()*, void ()** %p0.ptrptr, align 8
  %isnull0 = icmp eq void ()* %fn0.ptr, null
  br i1 %isnull0, label %exit, label %loop

loop:
  %p.cur = phi void ()** [ %p0.ptrptr, %entry ], [ %p.next, %update ]
  %fn.cur = phi void ()* [ %fn0.ptr, %entry ], [ %fn.next, %update ]
  call void %fn.cur()
  %p.next = getelementptr inbounds void ()*, void ()** %p.cur, i64 1
  %fn.next = load void ()*, void ()** %p.next, align 8
  store void ()** %p.next, void ()*** @off_140003000, align 8
  %cond = icmp ne void ()* %fn.next, null
  br i1 %cond, label %update, label %exit

update:
  br label %loop

exit:
  ret void
}