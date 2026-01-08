; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global %struct.Node*, align 8
@unk_140007100 = external global i8, align 1
@qword_140008258 = external global void (i8*)*, align 8
@qword_140008270 = external global void (i8*)*, align 8

declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 %arg_0) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %0, 0
  br i1 %cmp0, label %ret0, label %locked

ret0:
  ret i32 0

locked:
  %fp_lock = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  call void %fp_lock(i8* @unk_140007100)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %unlock_ret, label %loop_entry

loop_entry:
  br label %loop

loop:
  %cur = phi %struct.Node* [ %head, %loop_entry ], [ %cur_next, %loop_continue ]
  %prev = phi %struct.Node* [ null, %loop_entry ], [ %cur, %loop_continue ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %cur_next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg_0
  br i1 %eq, label %found, label %loc_update

loc_update:
  %next_is_null = icmp eq %struct.Node* %cur_next, null
  br i1 %next_is_null, label %unlock_ret, label %loop_continue

loop_continue:
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %delete_head, label %unlink_mid

delete_head:
  store %struct.Node* %cur_next, %struct.Node** @qword_1400070E0, align 8
  br label %after_unlink

unlink_mid:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %cur_next, %struct.Node** %prev_nextptr, align 8
  br label %after_unlink

after_unlink:
  call void @sub_1400027F0()
  br label %unlock_ret

unlock_ret:
  %fp_unlock = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  call void %fp_unlock(i8* @unk_140007100)
  ret i32 0
}