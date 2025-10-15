target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define void @sub_140001820() {
entry:
  %slotptr0 = load void ()**, void ()*** @off_140003000
  %fptr0 = load void ()*, void ()** %slotptr0
  %cmp0 = icmp ne void ()* %fptr0, null
  br i1 %cmp0, label %loop, label %exit

loop:
  %fptr = phi void ()* [ %fptr0, %entry ], [ %nextf, %loop ]
  call void %fptr()
  %slotcur = load void ()**, void ()*** @off_140003000
  %nextslot = getelementptr inbounds void ()*, void ()** %slotcur, i64 1
  %nextf = load void ()*, void ()** %nextslot
  store void ()** %nextslot, void ()*** @off_140003000
  %cond = icmp ne void ()* %nextf, null
  br i1 %cond, label %loop, label %exit

exit:
  ret void
}