; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*, align 8
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %t = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %t, 0
  br i1 %cond, label %cont, label %ret0

ret0:
  ret i32 0

cont:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %leave, label %loop

loop:
  %cur = phi %struct.Node* [ %head, %cont ], [ %next, %loop_iter ]
  %prev = phi %struct.Node* [ null, %cont ], [ %cur, %loop_iter ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %eq, label %found, label %loop_mismatch

loop_mismatch:
  %next_isnull = icmp eq %struct.Node* %next, null
  br i1 %next_isnull, label %leave, label %loop_iter

loop_iter:
  br label %loop

found:
  %isHead = icmp eq %struct.Node* %prev, null
  br i1 %isHead, label %headdel, label %nonheaddel

nonheaddel:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %freedel

headdel:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %freedel

freedel:
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}