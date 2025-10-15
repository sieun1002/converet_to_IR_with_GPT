; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = global i32 0, align 4
@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8
@Block = global %struct.Node* null, align 8

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* nocapture)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* nocapture)
declare dllimport void @free(i8* nocapture)

define dso_local i32 @sub_140002340(i32 %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_set = icmp ne i32 %flag, 0
  br i1 %flag_set, label %lock, label %ret0

ret0:
  ret i32 0

lock:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %head_is_null = icmp eq %struct.Node* %head, null
  br i1 %head_is_null, label %leave, label %loop

loop:
  %curr = phi %struct.Node* [ %head, %lock ], [ %next, %check_next ]
  %prev = phi %struct.Node* [ null, %lock ], [ %curr, %check_next ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %check_next

check_next:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %next_is_null = icmp eq %struct.Node* %next, null
  br i1 %next_is_null, label %leave, label %loop

found:
  %next2ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next2 = load %struct.Node*, %struct.Node** %next2ptr, align 8
  %prev_is_null = icmp eq %struct.Node* %prev, null
  br i1 %prev_is_null, label %update_head, label %update_link

update_head:
  store %struct.Node* %next2, %struct.Node** @Block, align 8
  br label %do_free

update_link:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next2, %struct.Node** %prev_next_ptr, align 8
  br label %do_free

do_free:
  %curr_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}