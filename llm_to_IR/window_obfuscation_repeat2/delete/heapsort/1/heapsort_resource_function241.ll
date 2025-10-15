; ModuleID: 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external dso_local global i32
@Block = external dso_local global i8*
@CriticalSection = external dso_local global [40 x i8]

declare dllimport void @EnterCriticalSection(i8* noundef)
declare dllimport void @LeaveCriticalSection(i8* noundef)
declare dllimport void @free(i8* noundef)

define dso_local i32 @sub_140002340(i32 noundef %arg_0) {
entry:
  %0 = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %0, 0
  br i1 %cmp0, label %ret0, label %cs_enter

ret0:
  ret i32 0

cs_enter:
  %cs_ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs_ptr)
  %head = load i8*, i8** @Block, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %leave, label %loop

loop:
  %cur = phi i8* [ %head, %cs_enter ], [ %next, %loop_cont ]
  %prev = phi i8* [ null, %cs_enter ], [ %cur, %loop_cont ]
  %keyptr = bitcast i8* %cur to i32*
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %arg_0
  %next_i8 = getelementptr inbounds i8, i8* %cur, i64 16
  %next_ptr = bitcast i8* %next_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  br i1 %eq, label %found, label %not_equal

not_equal:
  %next_null = icmp eq i8* %next, null
  br i1 %next_null, label %leave, label %loop_cont

loop_cont:
  br label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %head_case, label %non_head

head_case:
  store i8* %next, i8** @Block, align 8
  br label %do_free

non_head:
  %prev_next_i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  br label %do_free

do_free:
  call void @free(i8* %cur)
  br label %leave

leave:
  %cs_ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @LeaveCriticalSection(i8* %cs_ptr2)
  ret i32 0
}