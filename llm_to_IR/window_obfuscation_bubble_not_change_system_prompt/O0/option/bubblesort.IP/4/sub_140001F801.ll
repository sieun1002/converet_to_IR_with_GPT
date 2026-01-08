; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global %struct.Node*
@unk_140007100 = external global [1 x i8]

declare void @sub_1403E7BA3(i8*)
declare void @sub_1400DC8D7(i8*)
declare void @sub_1400027F0()

define i32 @sub_140001F80(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %g, 0
  br i1 %tst, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %lock.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1403E7BA3(i8* %lock.ptr)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head.null = icmp eq %struct.Node* %head, null
  br i1 %head.null, label %unlock, label %loop

loop:
  %prev = phi %struct.Node* [ null, %cont ], [ %curr, %not_eq ]
  %curr = phi %struct.Node* [ %head, %cont ], [ %next, %not_eq ]
  %key.ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %key.ptr, align 4
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %not_eq

not_eq:
  %next.null = icmp eq %struct.Node* %next, null
  br i1 %next.null, label %unlock, label %loop

found:
  %prev.null = icmp eq %struct.Node* %prev, null
  br i1 %prev.null, label %store_head, label %store_prev

store_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %do_call

store_prev:
  %prev.next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev.next.ptr, align 8
  br label %do_call

do_call:
  call void @sub_1400027F0()
  br label %unlock

unlock:
  %unlock.ptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1400DC8D7(i8* %unlock.ptr)
  ret i32 0
}