; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_1400EC4EB(i8*)
declare void @loc_1400027F0(i8*)
declare void @sub_1400F1710(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %v = load i32, i32* @dword_1400070E8, align 4
  %t = icmp eq i32 %v, 0
  br i1 %t, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  call void @loc_1400EC4EB(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %hn = icmp eq i8* %head, null
  br i1 %hn, label %after, label %loop

loop:
  %curr = phi i8* [ %head, %cont ], [ %next, %iterate ]
  %prev = phi i8* [ null, %cont ], [ %curr, %iterate ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %cmpeq = icmp eq i32 %key, %arg
  %nextptr_i8 = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %cmpeq, label %found, label %notmatch

notmatch:
  %isnull = icmp eq i8* %next, null
  br i1 %isnull, label %after, label %iterate

iterate:
  br label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %unlink_head, label %unlink_mid

unlink_head:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %delete

unlink_mid:
  %prev_next_ptr_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %delete

delete:
  call void @loc_1400027F0(i8* %curr)
  br label %after

after:
  call void @sub_1400F1710(i8* @unk_140007100)
  ret i32 0
}