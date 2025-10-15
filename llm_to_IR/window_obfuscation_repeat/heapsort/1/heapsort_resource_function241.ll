; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@Block = global %struct.Node* null, align 8
@CriticalSection = global [1 x i8] zeroinitializer, align 8

declare void @EnterCriticalSection(i8* noundef)
declare void @LeaveCriticalSection(i8* noundef)
declare void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %isZero = icmp eq i32 %flag, 0
  br i1 %isZero, label %ret0, label %enter

ret0:
  ret i32 0

enter:
  %cs_ptr = getelementptr inbounds [1 x i8], [1 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs_ptr)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %leave, label %loop.header

loop.header:
  br label %loop

loop:
  %cur = phi %struct.Node* [ %head, %loop.header ], [ %next, %not_equal ]
  %prev = phi %struct.Node* [ null, %loop.header ], [ %cur, %not_equal ]
  %valptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %val = load i32, i32* %valptr, align 4
  %eq = icmp eq i32 %val, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %eq, label %found, label %not_equal

not_equal:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %leave, label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %set_head, label %link_prev

link_prev:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %do_free

set_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %do_free

do_free:
  %cur_as_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_as_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(i8* %cs_ptr)
  ret i32 0
}