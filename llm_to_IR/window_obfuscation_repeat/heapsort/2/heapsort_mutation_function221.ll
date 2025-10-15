; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { i32, [12 x i8], %struct.Node* }
%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }

@dword_1400070E8 = external global i32, align 4
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external global %struct.Node*, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) {
entry:
  %enabled = load i32, i32* @dword_1400070E8, align 4
  %tobool = icmp ne i32 %enabled, 0
  br i1 %tobool, label %cs_entry, label %ret0

ret0:
  ret i32 0

cs_entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %leave, label %loop.prep

loop.prep:
  br label %loop

loop:
  %curr = phi %struct.Node* [ %head, %loop.prep ], [ %next_nonnull, %loop.cont ]
  %prev = phi %struct.Node* [ null, %loop.prep ], [ %curr.prev, %loop.cont ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %node_key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %node_key, %arg
  br i1 %eq, label %found, label %notfound

notfound:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %next.isnull = icmp eq %struct.Node* %next, null
  br i1 %next.isnull, label %leave, label %loop.cont

loop.cont:
  %next_nonnull = phi %struct.Node* [ %next, %notfound ]
  %curr.prev = phi %struct.Node* [ %curr, %notfound ]
  br label %loop

found:
  %nextptr2 = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next2 = load %struct.Node*, %struct.Node** %nextptr2, align 8
  %prev.isnull = icmp eq %struct.Node* %prev, null
  br i1 %prev.isnull, label %update_head, label %update_link

update_head:
  store %struct.Node* %next2, %struct.Node** @Block, align 8
  br label %do_free

update_link:
  %prev_nextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next2, %struct.Node** %prev_nextptr, align 8
  br label %do_free

do_free:
  %curr.i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr.i8)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}