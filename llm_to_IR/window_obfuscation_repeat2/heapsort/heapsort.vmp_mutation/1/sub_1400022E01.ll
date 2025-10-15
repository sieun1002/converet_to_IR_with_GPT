; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32, align 4
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external global i8*, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define dso_local i32 @sub_1400022E0(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %flag, 0
  br i1 %cond, label %crit_enter, label %ret0

ret0:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %empty = icmp eq i8* %head, null
  br i1 %empty, label %leave, label %loop

loop:
  %cur = phi i8* [ %head, %crit_enter ], [ %next, %mismatch ]
  %prev = phi i8* [ null, %crit_enter ], [ %cur, %mismatch ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr_i8 = getelementptr i8, i8* %cur, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %eq = icmp eq i32 %key, %arg
  br i1 %eq, label %found, label %mismatch

mismatch:
  %hasnext = icmp ne i8* %next, null
  br i1 %hasnext, label %loop, label %leave

found:
  %ishead = icmp eq i8* %prev, null
  br i1 %ishead, label %found_head, label %found_not_head

found_not_head:
  %prev_next_i8 = getelementptr i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next, align 8
  call void @free(i8* %cur)
  br label %leave

found_head:
  store i8* %next, i8** @Block, align 8
  call void @free(i8* %cur)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}