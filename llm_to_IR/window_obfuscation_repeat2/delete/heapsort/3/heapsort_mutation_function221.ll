; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@CriticalSection = external global i8
@Block = external global i8*

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %t0 = load i32, i32* @dword_1400070E8, align 4
  %cond = icmp ne i32 %t0, 0
  br i1 %cond, label %enter, label %ret0

ret0:
  ret i32 0

enter:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %head_null = icmp eq i8* %head, null
  br i1 %head_null, label %leave, label %loop

loop:
  %prev = phi i8* [ null, %enter ], [ %curr, %cont ]
  %curr = phi i8* [ %head, %enter ], [ %next, %cont ]
  %curr_i32p = bitcast i8* %curr to i32*
  %node_val = load i32, i32* %curr_i32p, align 4
  %eq = icmp eq i32 %node_val, %arg
  %next_ptr_addr = getelementptr i8, i8* %curr, i64 16
  %next_pp = bitcast i8* %next_ptr_addr to i8**
  %next = load i8*, i8** %next_pp, align 8
  br i1 %eq, label %found, label %notfound

notfound:
  %next_isnull = icmp eq i8* %next, null
  br i1 %next_isnull, label %leave, label %cont

cont:
  br label %loop

found:
  %prev_isnull = icmp eq i8* %prev, null
  br i1 %prev_isnull, label %update_head, label %update_link

update_head:
  store i8* %next, i8** @Block, align 8
  br label %do_free

update_link:
  %prev_next_addr = getelementptr i8, i8* %prev, i64 16
  %prev_next_pp = bitcast i8* %prev_next_addr to i8**
  store i8* %next, i8** %prev_next_pp, align 8
  br label %do_free

do_free:
  call void @free(i8* %curr)
  br label %leave

leave:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret i32 0
}