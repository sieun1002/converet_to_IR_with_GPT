; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global i8*
@unk_140007100 = external global i8

declare void @sub_1403E7BA3(i8*)
declare void @sub_1400027F0(i8*)
declare void @sub_1400DC8D7(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret_zero, label %cont

ret_zero:
  ret i32 0

cont:
  call void @sub_1403E7BA3(i8* @unk_140007100)
  %head = load i8*, i8** @qword_1400070E0, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %cleanup, label %loop

loop:
  %curr = phi i8* [ %head, %cont ], [ %next, %advance ]
  %prev = phi i8* [ null, %cont ], [ %curr, %advance ]
  %valptr = bitcast i8* %curr to i32*
  %val = load i32, i32* %valptr, align 4
  %eq = icmp eq i32 %val, %arg
  %nextptr.byte = getelementptr i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr.byte to i8**
  %next = load i8*, i8** %nextptr, align 8
  br i1 %eq, label %found, label %advance

advance:
  %next_is_null = icmp eq i8* %next, null
  br i1 %next_is_null, label %cleanup, label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %set_head, label %link_prev

set_head:
  store i8* %next, i8** @qword_1400070E0, align 8
  br label %free_node

link_prev:
  %prev_nextptr.byte = getelementptr i8, i8* %prev, i64 16
  %prev_nextptr = bitcast i8* %prev_nextptr.byte to i8**
  store i8* %next, i8** %prev_nextptr, align 8
  br label %free_node

free_node:
  call void @sub_1400027F0(i8* %curr)
  br label %cleanup

cleanup:
  call void @sub_1400DC8D7(i8* @unk_140007100)
  ret i32 0
}