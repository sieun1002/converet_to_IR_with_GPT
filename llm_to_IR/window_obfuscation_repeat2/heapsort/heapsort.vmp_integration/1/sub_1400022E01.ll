; ModuleID = 'm'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@qword_1400070E0 = external global %struct.Node*
@unk_140007100 = external global [1 x i8]

declare void @sub_14001E10E(i8*)
declare void @sub_140002B40(%struct.Node*)
declare void @sub_140032A48(i8*)

define dso_local i32 @sub_1400022E0(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tobool = icmp ne i32 %flag, 0
  br i1 %tobool, label %enter, label %ret

ret:
  ret i32 0

enter:
  %lockptr = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_14001E10E(i8* %lockptr)
  %head = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %release, label %loop

loop:
  %curr = phi %struct.Node* [ %head, %enter ], [ %next, %advance ]
  %prev = phi %struct.Node* [ null, %enter ], [ %curr, %advance ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %advance

advance:
  %end = icmp eq %struct.Node* %next, null
  br i1 %end, label %release, label %loop

found:
  %ishead = icmp eq %struct.Node* %prev, null
  br i1 %ishead, label %update_head, label %update_prev

update_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  br label %after_update

update_prev:
  %pnextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %pnextptr, align 8
  br label %after_update

after_update:
  call void @sub_140002B40(%struct.Node* %curr)
  br label %release

release:
  %lockptr2 = getelementptr inbounds [1 x i8], [1 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_140032A48(i8* %lockptr2)
  ret i32 0
}