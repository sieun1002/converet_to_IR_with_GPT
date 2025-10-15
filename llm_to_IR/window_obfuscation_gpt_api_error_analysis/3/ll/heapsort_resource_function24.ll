; ModuleID = 'sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) {
entry:
  %init = load i32, i32* @dword_1400070E8, align 4
  %init_nonzero = icmp ne i32 %init, 0
  br i1 %init_nonzero, label %crit_enter, label %ret_zero

ret_zero:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %crit_leave, label %loop

loop:
  %curr = phi %struct.Node* [ %head, %crit_enter ], [ %next, %cont ]
  %prev = phi %struct.Node* [ null, %crit_enter ], [ %curr, %cont ]
  %val_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %val = load i32, i32* %val_ptr, align 4
  %cmp = icmp eq i32 %val, %arg
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next_ptr, align 8
  br i1 %cmp, label %found, label %check_next

check_next:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %crit_leave, label %cont

cont:
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %update_head, label %update_prev

update_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %do_free

update_prev:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  br label %do_free

do_free:
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* noundef %curr_i8)
  br label %crit_leave

crit_leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}