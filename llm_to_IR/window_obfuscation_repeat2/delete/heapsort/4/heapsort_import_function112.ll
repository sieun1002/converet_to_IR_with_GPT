; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @loc_1400D766D(i8*)
declare void @sub_140002BB0()
declare i8* @sub_1400E1987(i8*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %v = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %v, 0
  br i1 %t, label %enabled, label %ret0

ret0:
  ret i32 0

enabled:
  call void @loc_1400D766D(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %A3, label %loopinit

loopinit:
  br label %loopHeader

loopHeader:
  %curr = phi i8* [ %head, %loopinit ], [ %next, %advance ]
  %prev = phi i8* [ null, %loopinit ], [ %curr, %advance ]
  %curr_i32ptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %curr_i32ptr, align 4
  %next_ptr_i8 = getelementptr i8, i8* %curr, i64 16
  %next_ptr = bitcast i8* %next_ptr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %notfound

notfound:
  %isnullnext = icmp eq i8* %next, null
  br i1 %isnullnext, label %A3, label %advance

advance:
  br label %loopHeader

found:
  %prevIsNull = icmp eq i8* %prev, null
  br i1 %prevIsNull, label %firstmatch, label %unlink

firstmatch:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %L39E

unlink:
  %prev_next_ptr_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %L39E

L39E:
  call void @sub_140002BB0()
  br label %A3

A3:
  %retHead = call i8* @sub_1400E1987(i8* @unk_140007100)
  store i8* %retHead, i8** @qword_1400070E0, align 8
  br label %L39E
}