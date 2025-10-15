; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external global %struct.Node*, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %iszero = icmp eq i32 %flag, 0
  br i1 %iszero, label %ret0, label %crit_enter

ret0:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isempty = icmp eq %struct.Node* %head, null
  br i1 %isempty, label %leave, label %loop

loop:
  %cur = phi %struct.Node* [ %head, %crit_enter ], [ %new_cur, %loop_latch ]
  %prev = phi %struct.Node* [ null, %crit_enter ], [ %new_prev, %loop_latch ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %cmpne = icmp ne i32 %key, %arg0
  br i1 %cmpne, label %not_equal, label %found

not_equal:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %leave, label %loop_latch

loop_latch:
  %new_prev = phi %struct.Node* [ %cur, %not_equal ]
  %new_cur = phi %struct.Node* [ %next, %not_equal ]
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %update_head, label %update_link

update_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %do_free

update_link:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %do_free

do_free:
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* noundef %cur_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}