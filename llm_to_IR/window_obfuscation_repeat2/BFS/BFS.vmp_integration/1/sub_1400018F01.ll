; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_1400018F0() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  br label %loop

loop:
  %eptr = phi void ()** [ %p0, %entry ], [ %next_eptr, %call ]
  %func = load void ()*, void ()** %eptr, align 8
  %isnull = icmp eq void ()* %func, null
  br i1 %isnull, label %done, label %call

call:
  call void %func()
  %next_eptr = getelementptr inbounds void ()*, void ()** %eptr, i64 1
  store void ()** %next_eptr, void ()*** @off_140003000, align 8
  br label %loop

done:
  ret void
}