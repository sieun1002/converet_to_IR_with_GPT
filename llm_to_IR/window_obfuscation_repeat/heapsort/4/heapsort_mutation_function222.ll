; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, [12 x i8], %struct.Block* }

@dword_1400070E8 = external global i32
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)

define dso_local i32 @sub_140002340(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_set = icmp ne i32 %flag, 0
  br i1 %flag_set, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %head, null
  br i1 %isnull, label %unlock, label %iter

iter:
  %curr = phi %struct.Block* [ %head, %cont ], [ %next, %advance ]
  %prev = phi %struct.Block* [ null, %cont ], [ %curr, %advance ]
  %key_ptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i32 0, i32 0
  %key = load i32, i32* %key_ptr, align 4
  %next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %next_ptr, align 8
  %match = icmp eq i32 %key, %arg
  br i1 %match, label %found, label %check_end

check_end:
  %at_end = icmp eq %struct.Block* %next, null
  br i1 %at_end, label %unlock, label %advance

advance:
  br label %iter

found:
  %has_prev = icmp ne %struct.Block* %prev, null
  br i1 %has_prev, label %link_prev, label %update_head

update_head:
  store %struct.Block* %next, %struct.Block** @Block, align 8
  br label %do_free

link_prev:
  %prev_next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %prev, i32 0, i32 2
  store %struct.Block* %next, %struct.Block** %prev_next_ptr, align 8
  br label %do_free

do_free:
  %curr_i8 = bitcast %struct.Block* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %unlock

unlock:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}