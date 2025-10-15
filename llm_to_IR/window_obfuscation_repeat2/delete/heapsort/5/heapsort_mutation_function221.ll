; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct.Node = type { i32, [12 x i8], %struct.Node* }

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global %struct.Node*

declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)
declare dllimport void @free(i8*)

define dso_local i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %crit, label %ret0

ret0:
  ret i32 0

crit:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %leave_ret0, label %loop

loop:
  %curr = phi %struct.Node* [ %head, %crit ], [ %next, %loc_380_done ]
  %prev = phi %struct.Node* [ null, %crit ], [ %curr, %loc_380_done ]
  %val_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %val = load i32, i32* %val_ptr, align 4
  %next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next_ptr, align 8
  %cmp = icmp eq i32 %val, %arg
  br i1 %cmp, label %found, label %loc_380

loc_380:
  %next_isnull = icmp eq %struct.Node* %next, null
  br i1 %next_isnull, label %leave_ret0, label %loc_380_done

loc_380_done:
  br label %loop

found:
  %prev_isnull = icmp eq %struct.Node* %prev, null
  br i1 %prev_isnull, label %set_head, label %set_link

set_link:
  %prev_next_ptr = getelementptr inbounds %struct.Node, %struct.Node* %prev, i32 0, i32 2
  store %struct.Node* %next, %struct.Node** %prev_next_ptr, align 8
  br label %call_free

set_head:
  store %struct.Node* %next, %struct.Node** @Block, align 8
  br label %call_free

call_free:
  %curr_as_i8 = bitcast %struct.Node* %curr to i8*
  call void @free(i8* %curr_as_i8)
  br label %leave_ret0

leave_ret0:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}