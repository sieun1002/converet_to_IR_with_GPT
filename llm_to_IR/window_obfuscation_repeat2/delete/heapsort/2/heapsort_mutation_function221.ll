; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@__imp_EnterCriticalSection = external dllimport global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external dllimport global void (%struct._RTL_CRITICAL_SECTION*)*

declare dllimport void @free(i8* noundef)

define i32 @sub_140002340(i32 noundef %arg) local_unnamed_addr {
entry:
  %flag = load i32, i32* @dword_1400070E8, align 4
  %tst = icmp ne i32 %flag, 0
  br i1 %tst, label %enter_cs, label %ret_zero

ret_zero:
  ret i32 0

enter_cs:
  %fn_enter_ptr = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_EnterCriticalSection
  call void %fn_enter_ptr(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %leave_cs, label %loop

loop:
  %prev = phi i8* [ null, %enter_cs ], [ %curr, %advance ]
  %curr = phi i8* [ %head, %enter_cs ], [ %next, %advance ]
  %keyptr = bitcast i8* %curr to i32*
  %key = load i32, i32* %keyptr, align 4
  %nextptr_i8 = getelementptr inbounds i8, i8* %curr, i64 16
  %nextptr = bitcast i8* %nextptr_i8 to i8**
  %next = load i8*, i8** %nextptr, align 8
  %cmp_eq = icmp eq i32 %key, %arg
  br i1 %cmp_eq, label %found, label %check_next

check_next:
  %isnull2 = icmp eq i8* %next, null
  br i1 %isnull2, label %leave_cs, label %advance

advance:
  br label %loop

found:
  %hasprev = icmp ne i8* %prev, null
  br i1 %hasprev, label %link_prev, label %update_head

link_prev:
  %prev_next_i8 = getelementptr inbounds i8, i8* %prev, i64 16
  %prev_next = bitcast i8* %prev_next_i8 to i8**
  store i8* %next, i8** %prev_next, align 8
  call void @free(i8* noundef %curr)
  br label %leave_cs

update_head:
  store i8* %next, i8** @Block, align 8
  call void @free(i8* noundef %curr)
  br label %leave_cs

leave_cs:
  %fn_leave_ptr = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_LeaveCriticalSection
  call void %fn_leave_ptr(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret i32 0
}