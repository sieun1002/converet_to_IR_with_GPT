; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = internal global i32 0, align 4
@qword_1400070E0 = internal global %struct.Node* null, align 8
@unk_140007100 = internal global [64 x i8] zeroinitializer, align 8

declare void @loc_1400D766D(i8*)
declare void @sub_1400E1987(i8*)
declare void @sub_140002BB0()

define i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %g, 0
  br i1 %cond, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  %lockptr0 = getelementptr inbounds [64 x i8], [64 x i8]* @unk_140007100, i64 0, i64 0
  call void @loc_1400D766D(i8* %lockptr0)
  %head0 = load %struct.Node*, %struct.Node** @qword_1400070E0, align 8
  %empty = icmp eq %struct.Node* %head0, null
  br i1 %empty, label %unlock_and_ret, label %loop

loop:
  %rcx.cur = phi %struct.Node* [ %head0, %cont ], [ %next2, %loop_cont ]
  %prev.cur = phi %struct.Node* [ null, %cont ], [ %rcx.cur.phi, %loop_cont ]
  %valptr = getelementptr inbounds %struct.Node, %struct.Node* %rcx.cur, i32 0, i32 0
  %val = load i32, i32* %valptr, align 4
  %cmp = icmp eq i32 %val, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %rcx.cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp, label %found, label %cmp_not

cmp_not:
  %isnull = icmp eq %struct.Node* %next, null
  br i1 %isnull, label %unlock_and_ret, label %loop_cont

loop_cont:
  %rcx.cur.phi = phi %struct.Node* [ %rcx.cur, %cmp_not ]
  %next2 = phi %struct.Node* [ %next, %cmp_not ]
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev.cur, null
  br i1 %prev_is_null, label %remove_head, label %remove_middle

remove_middle:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev.cur, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  call void @sub_140002BB0()
  br label %unlock_and_ret

remove_head:
  store %struct.Node* %next, %struct.Node** @qword_1400070E0, align 8
  call void @sub_140002BB0()
  br label %unlock_and_ret

unlock_and_ret:
  %lockptr1 = getelementptr inbounds [64 x i8], [64 x i8]* @unk_140007100, i64 0, i64 0
  call void @sub_1400E1987(i8* %lockptr1)
  ret i32 0
}