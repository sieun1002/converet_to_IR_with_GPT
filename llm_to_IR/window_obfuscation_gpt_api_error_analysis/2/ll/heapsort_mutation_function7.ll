; ModuleID = 'sub_140001820.ll'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*, align 8

define void @sub_140001820() {
entry:
  %base0 = load i8*, i8** @off_140003000, align 8
  %slotptr0 = bitcast i8* %base0 to i8**
  %fp0 = load i8*, i8** %slotptr0, align 8
  %isnull0 = icmp eq i8* %fp0, null
  br i1 %isnull0, label %exit, label %loop

loop:
  %base.phi = phi i8* [ %base0, %entry ], [ %nextbase, %loop ]
  %fp.phi = phi i8* [ %fp0, %entry ], [ %nextfp, %loop ]
  %callee = bitcast i8* %fp.phi to void ()*
  call void %callee()
  %nextbase = getelementptr i8, i8* %base.phi, i64 8
  store i8* %nextbase, i8** @off_140003000, align 8
  %nextslotptr = bitcast i8* %nextbase to i8**
  %nextfp = load i8*, i8** %nextslotptr, align 8
  %isnull = icmp eq i8* %nextfp, null
  br i1 %isnull, label %exit, label %loop

exit:
  ret void
}