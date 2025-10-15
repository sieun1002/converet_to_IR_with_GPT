; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define dso_local void @sub_1400018F0() local_unnamed_addr {
entry:
  %slotptr0 = load void ()**, void ()*** @off_140003000, align 8
  %fn0 = load void ()*, void ()** %slotptr0, align 8
  %cmp0 = icmp eq void ()* %fn0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %fn.cur = phi void ()* [ %fn0, %entry ], [ %fn.next, %update ]
  %slotptr.cur = phi void ()** [ %slotptr0, %entry ], [ %slotptr.next, %update ]
  call void %fn.cur()
  br label %update

update:
  %slotptr.next = getelementptr inbounds void ()*, void ()** %slotptr.cur, i64 1
  %fn.next = load void ()*, void ()** %slotptr.next, align 8
  store void ()** %slotptr.next, void ()*** @off_140003000, align 8
  %cmp = icmp eq void ()* %fn.next, null
  br i1 %cmp, label %exit, label %loop

exit:
  ret void
}