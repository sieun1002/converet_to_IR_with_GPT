; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@Block = external global %struct.Node*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @free(i8* noundef)

define dso_local i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_is_zero = icmp eq i32 %flag, 0
  br i1 %flag_is_zero, label %ret0, label %enter

ret0:
  ret i32 0

enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef nonnull @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %leave_and_ret0, label %loop_init

loop_init:
  br label %loop

loop:
  %prev = phi %struct.Node* [ null, %loop_init ], [ %curr, %not_equal ]
  %curr = phi %struct.Node* [ %head, %loop_init ], [ %next, %not_equal ]
  %key_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 0
  %key = load i32, i32* %key_ptr, align 4
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i64 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next_ptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %not_equal

not_equal:
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %leave_and_ret0, label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %update_head, label %link_prev

link_prev:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i64 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  br label %free_and_leave

update_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %free_and_leave

free_and_leave:
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* noundef %curr_i8)
  br label %leave_and_ret0

leave_and_ret0:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef nonnull @CriticalSection)
  ret i32 0
}