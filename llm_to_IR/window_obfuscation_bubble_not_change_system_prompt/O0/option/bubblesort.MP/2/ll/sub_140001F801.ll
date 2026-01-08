; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, i64, %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global %struct.Node*, align 8
@unk_140007100 = external global [1 x i8], align 1
@qword_140008258 = external global void (i8*)*, align 8
@qword_140008270 = external global void (i8*)*, align 8

declare void @sub_1400027F0(%struct.Node*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %gval = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp ne i32 %gval, 0
  br i1 %cmp0, label %acquire, label %ret0

ret0:
  ret i32 0

acquire:
  %lock_fn_ptr = load void (i8*)*, void (i8*)** @qword_140008258, align 8
  %lock_obj = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void %lock_fn_ptr(i8* %lock_obj)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %release, label %loop.head

loop.head:
  br label %loop.cond

loop.cond:
  %cur = phi %struct.Node* [ %head, %loop.head ], [ %next, %loop.advance ]
  %prev = phi %struct.Node* [ null, %loop.head ], [ %cur, %loop.advance ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i64 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %neq = icmp ne i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i64 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %neq, label %check_next, label %match

check_next:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %release, label %loop.advance

loop.advance:
  br label %loop.cond

match:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %del_head, label %del_link

del_link:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i64 0, i32 3
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %do_free

del_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %do_free

do_free:
  call void @sub_1400027F0(%struct.Node* %cur)
  br label %release

release:
  %unlock_fn_ptr = load void (i8*)*, void (i8*)** @qword_140008270, align 8
  %unlock_obj = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void %unlock_fn_ptr(i8* %unlock_obj)
  ret i32 0
}