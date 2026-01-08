; ModuleID = 'sub_140001F80'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global i8*
@CriticalSection = external dso_local global i8

@__imp_EnterCriticalSection = external dllimport global void (i8*)*
@__imp_LeaveCriticalSection = external dllimport global void (i8*)*

declare dllimport void @free(i8*)

define dso_local i32 @sub_140001F80(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %flag_set = icmp ne i32 %flag, 0
  br i1 %flag_set, label %locked, label %ret_zero

ret_zero:
  ret i32 0

locked:
  %impEnter = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %impEnter(i8* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %is_empty = icmp eq i8* %head, null
  br i1 %is_empty, label %leave, label %loop_body

loop_body:
  %curr = phi i8* [ %head, %locked ], [ %next2, %loop_back ]
  %prev = phi i8* [ null, %locked ], [ %curr_back, %loop_back ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %arg0
  %next_gep = getelementptr i8, i8* %curr, i64 16
  %next_slot = bitcast i8* %next_gep to i8**
  %next = load i8*, i8** %next_slot, align 8
  br i1 %eq, label %found, label %cont_neq

cont_neq:
  %at_end = icmp eq i8* %next, null
  br i1 %at_end, label %leave, label %loop_back

loop_back:
  %curr_back = phi i8* [ %curr, %cont_neq ]
  %next2 = phi i8* [ %next, %cont_neq ]
  br label %loop_body

found:
  %no_prev = icmp eq i8* %prev, null
  br i1 %no_prev, label %update_head, label %update_link

update_head:
  store i8* %next, i8** @Block, align 8
  br label %call_free

update_link:
  %prev_next_gep = getelementptr i8, i8* %prev, i64 16
  %prev_next_slot = bitcast i8* %prev_next_gep to i8**
  store i8* %next, i8** %prev_next_slot, align 8
  br label %call_free

call_free:
  call void @free(i8* %curr)
  br label %leave

leave:
  %impLeave = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  call void %impLeave(i8* @CriticalSection)
  ret i32 0
}