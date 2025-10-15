; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@qword_1400070E0 = external dso_local global i8*
@unk_140007100 = external dso_local global i8

declare dso_local void @loc_1400D766D(i8*)
declare dso_local void @sub_140002BB0() noreturn
declare dso_local i8* @sub_1400E1987(i8*)

define dso_local i32 @sub_140002340(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %ret0, label %proceed

ret0:
  ret i32 0

proceed:
  call void @loc_1400D766D(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_is_null = icmp eq i8* %head, null
  br i1 %head_is_null, label %L3A3, label %search

L3A3:
  %call_unlock = call i8* @sub_1400E1987(i8* @unk_140007100)
  store i8* %call_unlock, i8** @qword_1400070E0, align 8
  br label %L39E

L39E:
  call void @sub_140002BB0()
  unreachable

search:
  br label %loop_check

loop_check:
  %curr = phi i8* [ %head, %search ], [ %curr2, %notfound_cont ]
  %prev = phi i8* [ null, %search ], [ %prev2, %notfound_cont ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %next_i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %next_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %cmp = icmp eq i32 %key, %arg0
  br i1 %cmp, label %found, label %notfound

notfound:
  %prev2 = bitcast i8* %curr to i8*
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %L3A3, label %notfound_cont

notfound_cont:
  %curr2 = bitcast i8* %next to i8*
  br label %loop_check

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %headcase, label %unlink

headcase:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %L39E

unlink:
  %prev_next_i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %L39E
}