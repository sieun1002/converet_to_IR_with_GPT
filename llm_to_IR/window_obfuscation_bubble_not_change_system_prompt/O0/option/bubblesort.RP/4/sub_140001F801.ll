; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i32 }
%struct.Block = type { i32, [12 x i8], %struct.Block* }

@dword_1400070E8 = external global i32, align 4
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external global %struct.Block*, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define dso_local i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %locked, label %ret0

ret0:
  ret i32 0

locked:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %head, null
  br i1 %isnull, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %head, %locked ], [ %next, %cont ]
  %prev = phi %struct.Block* [ null, %locked ], [ %cur, %cont ]
  %keyptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %advance

advance:
  %nextnull = icmp eq %struct.Block* %next, null
  br i1 %nextnull, label %leave, label %cont

cont:
  br label %loop

found:
  %hasprev = icmp ne %struct.Block* %prev, null
  br i1 %hasprev, label %unlink_mid, label %unlink_head

unlink_mid:
  %prev_next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %prev, i32 0, i32 2
  store %struct.Block* %next, %struct.Block** %prev_next_ptr, align 8
  %cur_as_i8 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* %cur_as_i8)
  br label %leave

unlink_head:
  store %struct.Block* %next, %struct.Block** @Block, align 8
  %cur_as_i8_2 = bitcast %struct.Block* %cur to i8*
  call void @free(i8* %cur_as_i8_2)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}