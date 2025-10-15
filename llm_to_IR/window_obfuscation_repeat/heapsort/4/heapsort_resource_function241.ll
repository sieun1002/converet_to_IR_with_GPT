; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, i32, i32, %struct.Node* }

@dword_1400070E8 = dso_local global i32 1, align 4
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8
@Block = dso_local global %struct.Node* null, align 8

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @free(i8*)

define dso_local i32 @sub_140002340(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_zero = icmp eq i32 %flag, 0
  br i1 %flag_zero, label %early_ret, label %enter_cs

early_ret:
  ret i32 0

enter_cs:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %leave, label %loop_pre

loop_pre:
  br label %loop

loop:
  %curr = phi %struct.Node* [ %head, %loop_pre ], [ %curr_next, %cont ]
  %prev = phi %struct.Node* [ null, %loop_pre ], [ %prev_next, %cont ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nxtptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 3
  %nxt = load %struct.Node*, %struct.Node** %nxtptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %check_next

check_next:
  %n_is_null = icmp eq %struct.Node* %nxt, null
  br i1 %n_is_null, label %leave, label %cont

cont:
  %curr_next = phi %struct.Node* [ %nxt, %check_next ]
  %prev_next = phi %struct.Node* [ %curr, %check_next ]
  br label %loop

found:
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %update_head, label %update_prev

update_prev:
  %prev_nxtptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 3
  store %struct.Node* %nxt, %struct.Node** %prev_nxtptr, align 8
  br label %free_node

update_head:
  store %struct.Node* %nxt, %struct.Node** @Block, align 8
  br label %free_node

free_node:
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}