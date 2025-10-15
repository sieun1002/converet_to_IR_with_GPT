; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@Block = external global %struct.Node*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)

define i32 @sub_140002420(i32 %arg0) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tobool = icmp ne i32 %flag, 0
  br i1 %tobool, label %crit, label %ret0

ret0:                                             ; preds = %entry
  ret i32 0

crit:                                             ; preds = %entry
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %cur0 = load %struct.Node*, %struct.Node** @Block, align 8
  %empt = icmp eq %struct.Node* %cur0, null
  br i1 %empt, label %unlock_ret, label %loop

loop:                                             ; preds = %crit, %cont
  %cur = phi %struct.Node* [ %cur0, %crit ], [ %next1, %cont ]
  %prev = phi %struct.Node* [ null, %crit ], [ %cur, %cont ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next1 = load %struct.Node*, %struct.Node** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg0
  br i1 %eq, label %found, label %cont

cont:                                             ; preds = %loop
  %nextnull = icmp eq %struct.Node* %next1, null
  br i1 %nextnull, label %unlock_ret, label %loop

found:                                            ; preds = %loop
  %prevnull = icmp eq %struct.Node* %prev, null
  br i1 %prevnull, label %sethead, label %linkprev

sethead:                                          ; preds = %found
  store %struct.Node* %next1, %struct.Node** @Block, align 8
  br label %dofree

linkprev:                                         ; preds = %found
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next1, %struct.Node** %prev_nextptr, align 8
  br label %dofree

dofree:                                           ; preds = %linkprev, %sethead
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_i8)
  br label %unlock_ret

unlock_ret:                                       ; preds = %cont, %crit, %dofree
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}