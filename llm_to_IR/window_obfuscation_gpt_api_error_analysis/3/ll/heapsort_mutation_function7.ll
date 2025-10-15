; ModuleID = 'sub_140001820_module'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**, align 8

define void @sub_140001820() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  %f0 = load void ()*, void ()** %p0, align 8
  %isnull0 = icmp eq void ()* %f0, null
  br i1 %isnull0, label %end, label %loop

loop:
  %f.cur = phi void ()* [ %f0, %entry ], [ %next_fun, %loop ]
  call void %f.cur()
  %p.after = load void ()**, void ()*** @off_140003000, align 8
  %next_ptr = getelementptr inbounds void ()*, void ()** %p.after, i64 1
  %next_fun = load void ()*, void ()** %next_ptr, align 8
  store void ()** %next_ptr, void ()*** @off_140003000, align 8
  %isnull1 = icmp eq void ()* %next_fun, null
  br i1 %isnull1, label %end, label %loop

end:
  ret void
}