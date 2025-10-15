; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*

define void @sub_140001820() local_unnamed_addr {
entry:
  %G0 = load i8*, i8** @off_140003000, align 8
  %F0ptr = bitcast i8* %G0 to void ()**
  %F0 = load void ()*, void ()** %F0ptr, align 8
  %isnull0 = icmp eq void ()* %F0, null
  br i1 %isnull0, label %exit, label %loop

loop:
  %Gcur = phi i8* [ %G0, %entry ], [ %Gnext, %loop ]
  %Fcur = phi void ()* [ %F0, %entry ], [ %Fnext, %loop ]
  call void %Fcur()
  %Gnext = getelementptr i8, i8* %Gcur, i64 8
  store i8* %Gnext, i8** @off_140003000, align 8
  %Fnextptr = bitcast i8* %Gnext to void ()**
  %Fnext = load void ()*, void ()** %Fnextptr, align 8
  %isnullN = icmp eq void ()* %Fnext, null
  br i1 %isnullN, label %exit, label %loop

exit:
  ret void
}