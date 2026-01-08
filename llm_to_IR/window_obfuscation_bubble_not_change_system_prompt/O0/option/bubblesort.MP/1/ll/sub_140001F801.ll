; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8
@qword_140008258 = external global void (i8*)*
@qword_140008270 = external global void (i8*)*

declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 %arg) {
entry:
  %v0 = load i32, i32* @dword_1400070E8
  %v1 = icmp ne i32 %v0, 0
  br i1 %v1, label %locked, label %ret0

ret0:
  ret i32 0

locked:
  %v2 = load void (i8*)*, void (i8*)** @qword_140008258
  call void %v2(i8* @unk_140007100)
  %v3 = load i8*, i8** @qword_1400070E0
  %v4 = icmp eq i8* %v3, null
  br i1 %v4, label %unlock, label %loop

loop:
  %curr = phi i8* [ %v3, %locked ], [ %v10, %next_iter ]
  %prev = phi i8* [ null, %locked ], [ %curr, %next_iter ]
  %v5 = bitcast i8* %curr to i32*
  %v6 = load i32, i32* %v5
  %v7 = getelementptr i8, i8* %curr, i64 16
  %v8 = bitcast i8* %v7 to i8**
  %v10 = load i8*, i8** %v8
  %v9 = icmp eq i32 %v6, %arg
  br i1 %v9, label %found, label %check_next

check_next:
  %v11 = icmp eq i8* %v10, null
  br i1 %v11, label %unlock, label %next_iter

next_iter:
  br label %loop

found:
  %v12 = icmp eq i8* %prev, null
  br i1 %v12, label %update_head, label %update_link

update_head:
  store i8* %v10, i8** @qword_1400070E0
  br label %after_update

update_link:
  %v13 = getelementptr i8, i8* %prev, i64 16
  %v14 = bitcast i8* %v13 to i8**
  store i8* %v10, i8** %v14
  br label %after_update

after_update:
  call void @sub_1400027F0()
  br label %unlock

unlock:
  %v15 = load void (i8*)*, void (i8*)** @qword_140008270
  call void %v15(i8* @unk_140007100)
  ret i32 0
}