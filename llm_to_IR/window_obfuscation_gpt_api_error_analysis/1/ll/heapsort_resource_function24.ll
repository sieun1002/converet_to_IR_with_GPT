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

define dso_local i32 @sub_140002340(i32 noundef %arg0) {
entry:
  %guard = load i32, i32* @dword_1400070E8, align 4
  %guard.nonzero = icmp ne i32 %guard, 0
  br i1 %guard.nonzero, label %crit_enter, label %ret0

crit_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head.isnull = icmp eq %struct.Node* %head, null
  br i1 %head.isnull, label %leave, label %loop.pre

loop.pre:
  br label %loop

loop:
  %cur = phi %struct.Node* [ %head, %loop.pre ], [ %next, %loop.inc ]
  %prev = phi %struct.Node* [ null, %loop.pre ], [ %cur, %loop.inc ]
  %valptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %val = load i32, i32* %valptr, align 4
  %eq = icmp eq i32 %val, %arg0
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %eq, label %found, label %advance

advance:
  %next.isnull = icmp eq %struct.Node* %next, null
  br i1 %next.isnull, label %leave, label %loop.inc

loop.inc:
  br label %loop

found:
  %prev.isnull = icmp eq %struct.Node* %prev, null
  br i1 %prev.isnull, label %update_head, label %link_prev

update_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %do_free

link_prev:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_nextptr, align 8
  br label %do_free

do_free:
  %cur.i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* noundef %cur.i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  br label %ret0

ret0:
  ret i32 0
}