; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, [12 x i8], %struct.Block* }

@dword_1400070E8 = dso_local global i32 0, align 4
@Block = dso_local global %struct.Block* null, align 8
@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8

declare dllimport void @EnterCriticalSection(i8* noundef)
declare dllimport void @LeaveCriticalSection(i8* noundef)
declare dllimport void @free(i8* noundef)

define dso_local i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %locked, label %ret0

ret0:
  ret i32 0

locked:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* noundef %cs_ptr)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %head, null
  br i1 %isnull, label %leave_and_ret, label %loop

loop:
  %curr = phi %struct.Block* [ %head, %locked ], [ %next, %loop_update ]
  %prev = phi %struct.Block* [ null, %locked ], [ %curr, %loop_update ]
  %keyptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %curr, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %cmp = icmp eq i32 %key, %arg
  br i1 %cmp, label %found, label %notfound

notfound:
  %next_isnull = icmp eq %struct.Block* %next, null
  br i1 %next_isnull, label %leave_and_ret, label %loop_update

loop_update:
  br label %loop

found:
  %prev_isnull = icmp eq %struct.Block* %prev, null
  br i1 %prev_isnull, label %remove_head, label %remove_nonhead

remove_head:
  store %struct.Block* %next, %struct.Block** @Block, align 8
  br label %free_node

remove_nonhead:
  %prev_next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %prev, i32 0, i32 2
  store %struct.Block* %next, %struct.Block** %prev_next_ptr, align 8
  br label %free_node

free_node:
  %curr_i8 = bitcast %struct.Block* %curr to i8*
  call void @free(i8* noundef %curr_i8)
  br label %leave_and_ret

leave_and_ret:
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @LeaveCriticalSection(i8* noundef %cs_ptr2)
  ret i32 0
}