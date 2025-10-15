; ModuleID = 'sub_140001820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = extern_weak global void ()**

define void @sub_140001820() local_unnamed_addr {
entry:
  %base0 = load void ()**, void ()*** @off_140003000, align 8
  %fn0 = load void ()*, void ()** %base0, align 8
  %cmp0 = icmp eq void ()* %fn0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %base = phi void ()** [ %base0, %entry ], [ %next_base, %loop ]
  %fn = phi void ()* [ %fn0, %entry ], [ %next_fn, %loop ]
  call void %fn()
  %next_base = getelementptr inbounds void ()*, void ()** %base, i64 1
  %next_fn = load void ()*, void ()** %next_base, align 8
  store void ()** %next_base, void ()*** @off_140003000, align 8
  %cond = icmp ne void ()* %next_fn, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}