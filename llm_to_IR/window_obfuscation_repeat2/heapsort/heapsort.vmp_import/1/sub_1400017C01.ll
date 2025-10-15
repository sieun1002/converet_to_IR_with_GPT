; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*, align 8

define void @sub_1400017C0() {
entry:
  %curptr = load i8*, i8** @off_140003000, align 8
  %curpp = bitcast i8* %curptr to i8**
  %fn0_i8 = load i8*, i8** %curpp, align 8
  %cmp0 = icmp eq i8* %fn0_i8, null
  br i1 %cmp0, label %done, label %loop

loop:                                             ; preds = %entry, %loop
  %curphi = phi i8* [ %curptr, %entry ], [ %nextptr, %loop ]
  %fnphi_i8 = phi i8* [ %fn0_i8, %entry ], [ %fn_next_i8, %loop ]
  %fnphi = bitcast i8* %fnphi_i8 to void ()*
  call void %fnphi()
  %nextptr = getelementptr i8, i8* %curphi, i64 8
  %nextpp = bitcast i8* %nextptr to i8**
  %fn_next_i8 = load i8*, i8** %nextpp, align 8
  store i8* %nextptr, i8** @off_140003000, align 8
  %cmp1 = icmp eq i8* %fn_next_i8, null
  br i1 %cmp1, label %done, label %loop

done:                                             ; preds = %loop, %entry
  ret void
}