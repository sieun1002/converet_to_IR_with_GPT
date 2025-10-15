; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = dso_local global i32 0, align 4
@CriticalSection = dso_local global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8
@Block = dso_local global %struct.Node* null, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef) #1
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef) #1
declare void @free(i8* noundef) #1

define dso_local i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %cs_enter, label %ret0

ret0:
  ret i32 0

cs_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %cs_leave, label %loop

loop:
  %cur = phi %struct.Node* [ %head, %cs_enter ], [ %next, %iter ]
  %prev = phi %struct.Node* [ null, %cs_enter ], [ %cur, %iter ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %cmp = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp, label %found, label %check_next

check_next:
  %nnull = icmp eq %struct.Node* %next, null
  br i1 %nnull, label %cs_leave, label %iter

iter:
  br label %loop

found:
  %is_head = icmp eq %struct.Node* %prev, null
  br i1 %is_head, label %head_remove, label %mid_remove

head_remove:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %free_and_leave

mid_remove:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  br label %free_and_leave

free_and_leave:
  %cur_i8 = bitcast %struct.Node* %cur to i8*
  call void @free(i8* noundef %cur_i8)
  br label %cs_leave

cs_leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}

attributes #1 = { nounwind }