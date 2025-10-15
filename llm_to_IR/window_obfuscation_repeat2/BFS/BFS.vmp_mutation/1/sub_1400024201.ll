; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8

declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)
declare dllimport void @free(i8*)

define i32 @sub_140002420(i32 %arg0) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %t0 = icmp eq i32 %flag, 0
  br i1 %t0, label %ret0, label %crit_enter

ret0:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %leave_and_ret0, label %loop_header

loop_header:
  %cur = phi i8* [ %head, %crit_enter ], [ %next, %notfound ]
  %prev = phi i8* [ null, %crit_enter ], [ %cur, %notfound ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr_i8 = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %cmp = icmp eq i32 %key, %arg0
  br i1 %cmp, label %found, label %notfound

notfound:
  %end = icmp eq i8* %next, null
  br i1 %end, label %leave_and_ret0, label %loop_header

found:
  %hasprev = icmp ne i8* %prev, null
  br i1 %hasprev, label %unlink_nonhead, label %unlink_head

unlink_nonhead:
  %prev_next_ptr_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_ptr_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %free_and_leave

unlink_head:
  store i8* %next, i8** @Block, align 8
  br label %free_and_leave

free_and_leave:
  call void @free(i8* %cur)
  br label %leave_and_ret0

leave_and_ret0:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}