; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global void ()**

define dso_local void @sub_140001820() {
entry:
  %curPtr0 = load void ()**, void ()*** @off_140003000
  %curFn0 = load void ()*, void ()** %curPtr0
  %cond0 = icmp ne void ()* %curFn0, null
  br i1 %cond0, label %loop, label %end

loop:
  %curFn = phi void ()* [ %curFn0, %entry ], [ %nextFn, %loop ]
  %curPtr = phi void ()** [ %curPtr0, %entry ], [ %nextPtr, %loop ]
  call void %curFn()
  %nextPtr = getelementptr void ()*, void ()** %curPtr, i64 1
  %nextFn = load void ()*, void ()** %nextPtr
  store void ()** %nextPtr, void ()*** @off_140003000
  %hasNext = icmp ne void ()* %nextFn, null
  br i1 %hasNext, label %loop, label %end

end:
  ret void
}