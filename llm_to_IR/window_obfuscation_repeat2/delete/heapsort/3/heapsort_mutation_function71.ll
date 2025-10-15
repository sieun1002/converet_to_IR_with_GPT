; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void (...)* *

define void @sub_140001820() {
entry:
  %slotptr0 = load void (...)* *, void (...)* * * @off_140003000
  %fp0 = load void (...)*, void (...)* * %slotptr0
  %cmp0 = icmp eq void (...)* %fp0, null
  br i1 %cmp0, label %ret, label %loop

loop:
  %slotphi = phi void (...)* * [ %slotptr0, %entry ], [ %next, %loop ]
  %fpphi = phi void (...)* [ %fp0, %entry ], [ %fpnext, %loop ]
  %fpcast = bitcast void (...)* %fpphi to void ()*
  call void %fpcast()
  %next = getelementptr void (...)*, void (...)* * %slotphi, i64 1
  store void (...)* * %next, void (...)* * * @off_140003000
  %fpnext = load void (...)*, void (...)* * %next
  %cmp1 = icmp eq void (...)* %fpnext, null
  br i1 %cmp1, label %ret, label %loop

ret:
  ret void
}