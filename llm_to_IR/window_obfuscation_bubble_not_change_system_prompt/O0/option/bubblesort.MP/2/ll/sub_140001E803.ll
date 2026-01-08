; ModuleID = 'sub_140001E80.ll'
target triple = "x86_64-pc-windows-msvc"

@qword_140008258 = external global i8*
@qword_1400070E0 = external global i8*
@qword_140008288 = external global i8*
@qword_140008260 = external global i8*
@qword_140008270 = external global i8*
@unk_140007100 = external global i8

define dso_local void @sub_140001E80() local_unnamed_addr {
entry:
  %0 = load i8*, i8** @qword_140008258, align 8
  %1 = bitcast i8* %0 to void (i8*)*
  call void %1(i8* @unk_140007100)
  %2 = load i8*, i8** @qword_1400070E0, align 8
  %3 = icmp eq i8* %2, null
  br i1 %3, label %end, label %preloop

preloop:                                          ; preds = %entry
  %4 = load i8*, i8** @qword_140008288, align 8
  %5 = bitcast i8* %4 to i8* (i32)*
  %6 = load i8*, i8** @qword_140008260, align 8
  %7 = bitcast i8* %6 to i32 ()*
  br label %loop

loop:                                             ; preds = %aftercall, %preloop
  %8 = phi i8* [ %2, %preloop ], [ %21, %aftercall ]
  %9 = bitcast i8* %8 to i32*
  %10 = load i32, i32* %9, align 4
  %11 = call i8* %5(i32 %10)
  %12 = call i32 %7()
  %13 = icmp ne i8* %11, null
  %14 = icmp eq i32 %12, 0
  %15 = and i1 %13, %14
  br i1 %15, label %callnode, label %aftercall

callnode:                                         ; preds = %loop
  %16 = getelementptr i8, i8* %8, i64 8
  %ptr17 = bitcast i8* %16 to i8**
  %17 = load i8*, i8** %ptr17, align 8
  %18 = bitcast i8* %17 to void (i8*)*
  call void %18(i8* %11)
  br label %aftercall

aftercall:                                        ; preds = %callnode, %loop
  %19 = getelementptr i8, i8* %8, i64 16
  %20 = bitcast i8* %19 to i8**
  %21 = load i8*, i8** %20, align 8
  %22 = icmp ne i8* %21, null
  br i1 %22, label %loop, label %end

end:                                              ; preds = %aftercall, %entry
  %23 = load i8*, i8** @qword_140008270, align 8
  %24 = bitcast i8* %23 to void (i8*)*
  tail call void %24(i8* @unk_140007100)
  ret void
}