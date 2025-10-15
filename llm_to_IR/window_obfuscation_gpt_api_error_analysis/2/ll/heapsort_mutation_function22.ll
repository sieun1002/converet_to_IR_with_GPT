; target: Windows x86-64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_nonzero = icmp ne i32 %flag, 0
  br i1 %flag_nonzero, label %enter, label %ret0

ret0:
  ret i32 0

enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %cur0 = load %struct.Node*, %struct.Node** @Block, align 8
  %hascur = icmp ne %struct.Node* %cur0, null
  br i1 %hascur, label %loop, label %leave

loop:
  %prev = phi %struct.Node* [ null, %enter ], [ %cur, %cont ]
  %cur = phi %struct.Node* [ %cur0, %enter ], [ %next, %cont ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %cont

cont:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %leave, label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %rm_head, label %rm_nothead

rm_nothead:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %free_and_leave

rm_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %free_and_leave

free_and_leave:
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* noundef %cur_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}