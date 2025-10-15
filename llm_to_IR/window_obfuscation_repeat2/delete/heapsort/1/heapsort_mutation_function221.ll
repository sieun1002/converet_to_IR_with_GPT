; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %cur0 = load %struct.Node*, %struct.Node** @Block, align 8
  %cur0_is_null = icmp eq %struct.Node* %cur0, null
  br i1 %cur0_is_null, label %leave, label %loop.entry

loop.entry:
  br label %loop

loop:
  %cur_phi = phi %struct.Node* [ %cur0, %loop.entry ], [ %cur_next, %update ]
  %prev_phi = phi %struct.Node* [ null, %loop.entry ], [ %prev_next, %update ]
  %valptr = getelementptr inbounds %struct.Node, %struct.Node* %cur_phi, i32 0, i32 0
  %val = load i32, i32* %valptr, align 4
  %cmp_eq = icmp eq i32 %val, %arg0
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur_phi, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp_eq, label %found, label %update

update:
  %prev_next = bitcast %struct.Node* %cur_phi to %struct.Node*
  %cur_next = bitcast %struct.Node* %next to %struct.Node*
  %next_is_null = icmp eq %struct.Node* %cur_next, null
  br i1 %next_is_null, label %leave, label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev_phi, null
  br i1 %prev_is_null, label %head_case, label %unlink_mid

unlink_mid:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev_phi, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %free_and_leave

head_case:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %free_and_leave

free_and_leave:
  %cur_as_i8 = bitcast %struct.Node* %cur_phi to i8*
  call void @free(i8* %cur_as_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}