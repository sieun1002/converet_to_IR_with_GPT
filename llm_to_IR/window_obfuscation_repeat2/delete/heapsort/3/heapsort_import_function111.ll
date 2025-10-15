; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_1400D766D(i8*)
declare void @sub_1400E1987(i8*)
declare void @sub_140002BB0()

define dso_local i32 @sub_140002340(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %locked_start, label %ret0

ret0:
  ret i32 0

locked_start:
  call void @loc_1400D766D(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0
  %head_isnull = icmp eq i8* %head, null
  br i1 %head_isnull, label %unlock, label %loop

loop:
  %curr = phi i8* [ %head, %locked_start ], [ %next2, %advance ]
  %prev = phi i8* [ null, %locked_start ], [ %curr_passthru, %advance ]
  %valptr = bitcast i8* %curr to i32*
  %val = load i32, i32* %valptr
  %nextaddr.i8 = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextaddr.i8 to i8**
  %next = load i8*, i8** %nextptr
  %cmpeq = icmp eq i32 %val, %arg0
  br i1 %cmpeq, label %found, label %notfound

notfound:
  %next_isnull = icmp eq i8* %next, null
  br i1 %next_isnull, label %unlock, label %advance

advance:
  %curr_passthru = bitcast i8* %curr to i8*
  %next2 = bitcast i8* %next to i8*
  br label %loop

found:
  %prev_isnull = icmp eq i8* %prev, null
  br i1 %prev_isnull, label %update_head, label %update_prev

update_prev:
  %prev_next_addr.i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_addr.i8 to i8**
  store i8* %next, i8** %prev_next_ptr
  br label %call_free

update_head:
  store i8* %next, i8** @qword_1400070E0
  br label %call_free

call_free:
  call void @sub_140002BB0()
  br label %unlock

unlock:
  call void @sub_1400E1987(i8* @unk_140007100)
  ret i32 0
}