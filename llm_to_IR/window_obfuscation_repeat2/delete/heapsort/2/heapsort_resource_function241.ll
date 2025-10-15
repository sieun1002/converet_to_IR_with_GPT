; ModuleID = 'module'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32, align 4
@Block = external global %struct.Node*, align 8
@CriticalSection = external global [40 x i8], align 8

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %flag, 0
  br i1 %cmp0, label %ret0, label %cont

ret0:
  ret i32 0

cont:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs_ptr)
  %block = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %block, null
  br i1 %isnull, label %unlock, label %loop

loop:
  %cur = phi %struct.Node* [ %block, %cont ], [ %next, %continue ]
  %prev = phi %struct.Node* [ null, %cont ], [ %cur, %continue ]
  %keyptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %key = load i32, i32* %keyptr, align 4
  %cmp_key = icmp eq i32 %key, %arg
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br i1 %cmp_key, label %found, label %notfound

notfound:
  %next_isnull = icmp eq %struct.Node* %next, null
  br i1 %next_isnull, label %unlock, label %continue

continue:
  br label %loop

found:
  %prev_isnull = icmp eq %struct.Node* %prev, null
  br i1 %prev_isnull, label %sethead, label %linkprev

sethead:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %dofree

linkprev:
  %prevnextptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prevnextptr, align 8
  br label %dofree

dofree:
  %cur_cast = bitcast %struct.Node* %cur to i8*
  call void @free(i8* %cur_cast)
  br label %unlock

unlock:
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @LeaveCriticalSection(i8* %cs_ptr2)
  ret i32 0
}