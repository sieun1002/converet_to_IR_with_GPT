; ModuleID = 'sub_140001F80.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8
@qword_140008258 = external dso_local global i8*
@qword_140008270 = external dso_local global i8*

declare dso_local void @sub_1400027F0()

define dso_local i32 @sub_140001F80(i32 %param) local_unnamed_addr {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %2 = load i8*, i8** @qword_140008258, align 8
  %3 = bitcast i8* %2 to void (i8*)*
  %4 = getelementptr i8, i8* @unk_140007100, i64 0
  call void %3(i8* %4)
  %5 = load i8*, i8** @qword_1400070E0, align 8
  %6 = icmp eq i8* %5, null
  br i1 %6, label %unlock_ret, label %loop

loop:
  %cur = phi i8* [ %5, %cont ], [ %next2, %advance ]
  %prev = phi i8* [ null, %cont ], [ %cur2, %advance ]
  %7 = bitcast i8* %cur to i32*
  %8 = load i32, i32* %7, align 4
  %9 = icmp ne i32 %8, %param
  %10 = getelementptr i8, i8* %cur, i64 16
  %11 = bitcast i8* %10 to i8**
  %12 = load i8*, i8** %11, align 8
  br i1 %9, label %miss, label %found

miss:
  %13 = icmp eq i8* %12, null
  br i1 %13, label %unlock_ret, label %advance

advance:
  %cur2 = phi i8* [ %cur, %miss ]
  %next2 = phi i8* [ %12, %miss ]
  br label %loop

found:
  %14 = icmp eq i8* %prev, null
  br i1 %14, label %remove_head, label %remove_mid

remove_mid:
  %15 = getelementptr i8, i8* %prev, i64 16
  %16 = bitcast i8* %15 to i8**
  store i8* %12, i8** %16, align 8
  call void @sub_1400027F0()
  br label %unlock_ret

remove_head:
  store i8* %12, i8** @qword_1400070E0, align 8
  call void @sub_1400027F0()
  br label %unlock_ret

unlock_ret:
  %17 = load i8*, i8** @qword_140008270, align 8
  %18 = bitcast i8* %17 to void (i8*)*
  %19 = getelementptr i8, i8* @unk_140007100, i64 0
  call void %18(i8* %19)
  ret i32 0
}