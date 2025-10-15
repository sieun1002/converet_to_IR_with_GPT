; ModuleID: 'module'
target triple = "x86_64-pc-windows-msvc"

@off_140003000 = external global i8*

define void @sub_140001820() {
entry:
  %p0 = load i8*, i8** @off_140003000, align 8
  %p0_pp = bitcast i8* %p0 to i8**
  %f0 = load i8*, i8** %p0_pp, align 8
  %cmp0 = icmp ne i8* %f0, null
  br i1 %cmp0, label %loop, label %exit

loop:
  %curr_f = phi i8* [ %f0, %entry ], [ %f_next, %loop ]
  %fptr = bitcast i8* %curr_f to void ()*
  call void %fptr()
  %p_reload = load i8*, i8** @off_140003000, align 8
  %p_next = getelementptr i8, i8* %p_reload, i64 8
  %p_next_pp = bitcast i8* %p_next to i8**
  %f_next = load i8*, i8** %p_next_pp, align 8
  store i8* %p_next, i8** @off_140003000, align 8
  %cmp1 = icmp ne i8* %f_next, null
  br i1 %cmp1, label %loop, label %exit

exit:
  ret void
}