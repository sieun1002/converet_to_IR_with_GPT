; ModuleID = 'sub_140002340.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external dso_local global i32, align 4
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external dso_local global %struct.Node*, align 8

declare dso_local void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dso_local void @free(i8* noundef)

define dso_local i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %flag, 0
  br i1 %cond, label %crit_entry, label %ret_zero

ret_zero:
  ret i32 0

crit_entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head0 = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull0 = icmp eq %struct.Node* %head0, null
  br i1 %isnull0, label %leave_and_ret, label %loop

loop:
  %curr = phi %struct.Node* [ %head0, %crit_entry ], [ %next1, %loop_latch ]
  %prev = phi %struct.Node* [ null, %crit_entry ], [ %curr, %loop_latch ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next1 = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp, label %found, label %loop_latch

loop_latch:
  %nnull = icmp eq %struct.Node* %next1, null
  br i1 %nnull, label %leave_and_ret, label %loop

found:
  %ishead = icmp eq %struct.Node* %prev, null
  br i1 %ishead, label %head_case, label %unlink

unlink:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next1, %struct.Node** %prev_next_ptr, align 8
  br label %do_free

head_case:
  store %struct.Node* %next1, %struct.Node** @Block, align 8
  br label %do_free

do_free:
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %leave_and_ret

leave_and_ret:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}