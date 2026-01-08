; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Node*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %flag, 0
  br i1 %cond, label %enter_cs, label %ret_zero_early

ret_zero_early:
  ret i32 0

enter_cs:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %leave_cs, label %loop_start

loop_start:
  br label %loop_check

loop_check:
  %prev = phi %struct.Node* [ null, %loop_start ], [ %cur, %advance ]
  %cur = phi %struct.Node* [ %head, %loop_start ], [ %next, %advance ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp, label %found, label %advance

advance:
  %next_null = icmp eq %struct.Node* %next, null
  br i1 %next_null, label %leave_cs, label %loop_check

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %delete_head, label %delete_middle

delete_middle:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %leave_cs

delete_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  %cur_i8_h = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8_h)
  br label %leave_cs

leave_cs:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}