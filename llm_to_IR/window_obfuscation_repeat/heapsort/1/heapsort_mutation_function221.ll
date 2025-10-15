; ModuleID = 'fixed'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, [12 x i8], %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*
@dword_1400070E8 = external global i32

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tobool = icmp ne i32 %flag, 0
  br i1 %tobool, label %cs_enter, label %ret_zero

ret_zero:
  ret i32 0

cs_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %head, null
  br i1 %isnull, label %leave, label %loop

loop:
  %curr = phi %struct.Block* [ %head, %cs_enter ], [ %next, %loop_next ]
  %prev = phi %struct.Block* [ null, %cs_enter ], [ %curr, %loop_next ]
  %keyptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i64 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i64 0, i32 2
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %mismatch

mismatch:
  %isnull2 = icmp eq %struct.Block* %next, null
  br i1 %isnull2, label %leave, label %loop_next

loop_next:
  br label %loop

found:
  %hasprev = icmp ne %struct.Block* %prev, null
  br i1 %hasprev, label %link_prev, label %link_head

link_head:
  store %struct.Block* %next, %struct.Block** @Block, align 8
  br label %do_free

link_prev:
  %prev_next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %prev, i64 0, i32 2
  store %struct.Block* %next, %struct.Block** %prev_next_ptr, align 8
  br label %do_free

do_free:
  %curr_i8 = bitcast %struct.Block* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}