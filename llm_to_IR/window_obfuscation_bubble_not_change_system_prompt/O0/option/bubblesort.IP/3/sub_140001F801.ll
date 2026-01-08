; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@qword_1400070E0 = external global %struct.Node*, align 8
@unk_140007100 = external global i8, align 1

declare void @sub_1403E7BA3(i8* noundef)
declare void @sub_1400DC8D7(i8* noundef)
declare void @sub_1400027F0()

define dso_local i32 @sub_140001F80(i32 noundef %arg0) local_unnamed_addr {
entry:
  %t0 = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %t0, 0
  br i1 %cond, label %init, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

init:                                             ; preds = %entry
  call void @sub_1403E7BA3(i8* noundef @unk_140007100)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %head_nz = icmp ne %struct.Node* %head, null
  br i1 %head_nz, label %loop, label %final

loop:                                             ; preds = %cont, %init
  %cur = phi %struct.Node* [ %head, %init ], [ %next, %cont ]
  %prev = phi %struct.Node* [ null, %init ], [ %cur, %cont ]
  %valptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %val = load i32, i32* %valptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %eq = icmp eq i32 %val, %arg0
  br i1 %eq, label %found, label %check_next

check_next:                                       ; preds = %loop
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %final, label %cont

cont:                                             ; preds = %check_next
  br label %loop

found:                                            ; preds = %loop
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %store_head, label %store_prev

store_head:                                       ; preds = %found
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %post_store

store_prev:                                       ; preds = %found
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %post_store

post_store:                                       ; preds = %store_prev, %store_head
  call void @sub_1400027F0()
  br label %final

final:                                            ; preds = %post_store, %check_next, %init
  call void @sub_1400DC8D7(i8* noundef @unk_140007100)
  ret i32 0
}