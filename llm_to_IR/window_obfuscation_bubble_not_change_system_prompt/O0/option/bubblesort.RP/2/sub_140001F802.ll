; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global i8

@__imp_EnterCriticalSection = external dllimport global void (i8*)*
@__imp_LeaveCriticalSection = external dllimport global void (i8*)*

declare dllimport void @free(i8*)

define dso_local i32 @sub_140001F80(i32 %arg) {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %cmp0 = icmp eq i32 %flag, 0
  br i1 %cmp0, label %ret0, label %need_cs

ret0:
  ret i32 0

need_cs:
  %ecs_fp = load void (i8*)*, void (i8*)** @__imp_EnterCriticalSection, align 8
  call void %ecs_fp(i8* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %empty = icmp eq i8* %head, null
  br i1 %empty, label %leave, label %loop

loop:
  %curr = phi i8* [ %head, %need_cs ], [ %next, %cont ]
  %prev = phi i8* [ null, %need_cs ], [ %curr, %cont ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %eq = icmp eq i32 %key, %arg
  %next_addr_i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %next_ptr = bitcast i8* %next_addr_i8 to i8**
  %next = load i8*, i8** %next_ptr, align 8
  br i1 %eq, label %found, label %notfound

notfound:
  %no_next = icmp eq i8* %next, null
  br i1 %no_next, label %leave, label %cont

cont:
  br label %loop

found:
  %prev_is_null = icmp eq i8* %prev, null
  br i1 %prev_is_null, label %remove_head, label %remove_mid

remove_mid:
  %prev_next_addr_i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next_ptr = bitcast i8* %prev_next_addr_i8 to i8**
  store i8* %next, i8** %prev_next_ptr, align 8
  call void @free(i8* %curr)
  br label %leave

remove_head:
  store i8* %next, i8** @Block, align 8
  call void @free(i8* %curr)
  br label %leave

leave:
  %lcs_fp = load void (i8*)*, void (i8*)** @__imp_LeaveCriticalSection, align 8
  call void %lcs_fp(i8* @CriticalSection)
  ret i32 0
}