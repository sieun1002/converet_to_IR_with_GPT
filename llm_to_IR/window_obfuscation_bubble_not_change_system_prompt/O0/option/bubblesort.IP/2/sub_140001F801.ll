; ModuleID = 'sub_140001F80.ll'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global i8*, align 8
@unk_140007100 = external global i8, align 1

declare i8* @sub_1403E7BA3(i8* noundef)
declare void @sub_1400DC8D7(i8* noundef)
declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 noundef %arg0) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %1 = icmp ne i32 %0, 0
  br i1 %1, label %if.notzero, label %ret0

ret0:
  ret i32 0

if.notzero:
  %2 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  %3 = call i8* @sub_1403E7BA3(i8* noundef %2)
  %4 = icmp ne i8* %3, null
  br i1 %4, label %loop.preheader, label %after

loop.preheader:
  br label %loop

loop:
  %curr = phi i8* [ %3, %loop.preheader ], [ %nextval, %cont ]
  %prev = phi i8* [ null, %loop.preheader ], [ %curr, %cont ]
  %curr_i32ptr = bitcast i8* %curr to i32*
  %5 = load i32, i32* %curr_i32ptr, align 4
  %6 = icmp eq i32 %5, %arg0
  %nextptr = getelementptr inbounds i8, i8* %curr, i64 16
  %next = bitcast i8* %nextptr to i8**
  %nextval = load i8*, i8** %next, align 8
  br i1 %6, label %found, label %advance

advance:
  %7 = icmp ne i8* %nextval, null
  br i1 %7, label %cont, label %after

cont:
  br label %loop

found:
  %8 = icmp eq i8* %prev, null
  br i1 %8, label %sethead, label %linkprev

sethead:
  store i8* %nextval, i8** @qword_1400070E0, align 8
  call void @sub_1400027F0()
  br label %after

linkprev:
  %prev_nextptr = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_nextptr to i8**
  store i8* %nextval, i8** %prev_next, align 8
  call void @sub_1400027F0()
  br label %after

after:
  %9 = getelementptr inbounds i8, i8* @unk_140007100, i64 0
  call void @sub_1400DC8D7(i8* noundef %9)
  ret i32 0
}