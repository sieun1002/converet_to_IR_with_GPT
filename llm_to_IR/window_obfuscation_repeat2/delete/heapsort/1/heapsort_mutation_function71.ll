; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %S0 = load void ()**, void ()*** @off_140003000
  %F0 = load void ()*, void ()** %S0
  %cmp0 = icmp eq void ()* %F0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %Fcur = phi void ()* [ %F0, %entry ], [ %Fnext, %loop ]
  call void %Fcur()
  %S1 = load void ()**, void ()*** @off_140003000
  %Snext = getelementptr inbounds void ()*, void ()** %S1, i64 1
  %Fnext = load void ()*, void ()** %Snext
  store void ()** %Snext, void ()*** @off_140003000
  %cond = icmp ne void ()* %Fnext, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}