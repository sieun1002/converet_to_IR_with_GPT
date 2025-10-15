; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %p0 = load void ()**, void ()*** @off_140003000
  %fn0 = load void ()*, void ()** %p0
  %isnull0 = icmp eq void ()* %fn0, null
  br i1 %isnull0, label %done, label %loop_call

loop_call:
  %f = phi void ()* [ %fn0, %entry ], [ %fnNext, %loop_update ]
  call void %f()
  br label %loop_update

loop_update:
  %p1 = load void ()**, void ()*** @off_140003000
  %pnext = getelementptr void ()*, void ()** %p1, i64 1
  %fnNext = load void ()*, void ()** %pnext
  store void ()** %pnext, void ()*** @off_140003000
  %cont = icmp ne void ()* %fnNext, null
  br i1 %cont, label %loop_call, label %done

done:
  ret void
}