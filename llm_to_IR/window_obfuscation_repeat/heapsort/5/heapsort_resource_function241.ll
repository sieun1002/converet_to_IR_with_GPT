; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, i32, %struct.Node* }

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global %struct.Node*
@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)

define dso_local i32 @sub_140002340(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmpflag = icmp ne i32 %flag, 0
  br i1 %cmpflag, label %crit, label %ret0

ret0:
  ret i32 0

crit:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull.head = icmp eq %struct.Node* %head, null
  br i1 %isnull.head, label %leave, label %loop

loop:
  %curr = phi %struct.Node* [ %head, %crit ], [ %next, %loop.cont ]
  %prev = phi %struct.Node* [ null, %crit ], [ %curr, %loop.cont ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %iter

iter:
  %isnull.next = icmp eq %struct.Node* %next, null
  br i1 %isnull.next, label %leave, label %loop.cont

loop.cont:
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %sethead, label %linkprev

sethead:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %dofree

linkprev:
  %prevnextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prevnextptr, align 8
  br label %dofree

dofree:
  %curr.i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr.i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}