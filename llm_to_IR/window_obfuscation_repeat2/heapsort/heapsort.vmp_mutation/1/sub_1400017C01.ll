; ModuleID: 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_1400017C0() local_unnamed_addr {
entry:
  %p0 = load void ()**, void ()*** @off_140003000, align 8
  br label %check

check:
  %p = phi void ()** [ %p0, %entry ], [ %nextp, %body ]
  %fn = load void ()*, void ()** %p, align 8
  %isnull = icmp eq void ()* %fn, null
  br i1 %isnull, label %ret, label %body

body:
  call void %fn()
  %nextp = getelementptr inbounds void ()*, void ()** %p, i64 1
  store void ()** %nextp, void ()*** @off_140003000, align 8
  br label %check

ret:
  ret void
}