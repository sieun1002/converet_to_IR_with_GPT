; ModuleID = 'fixed'
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque

@dword_1400070E8 = external global i32
@Block = external global i8*
@CriticalSection = external global %struct._RTL_CRITICAL_SECTION

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @free(i8*)

define i32 @sub_140002340(i32 %arg) {
entry:
  %g = load i32, i32* @dword_1400070E8, align 4
  %t = icmp ne i32 %g, 0
  br i1 %t, label %crit_enter, label %ret0

ret0:
  ret i32 0

crit_enter:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load i8*, i8** @Block, align 8
  %isnull = icmp eq i8* %head, null
  br i1 %isnull, label %leave, label %loop

loop:
  %cur = phi i8* [ %head, %crit_enter ], [ %next1, %loop_update ]
  %prev = phi i8* [ null, %crit_enter ], [ %cur, %loop_update ]
  %keyptr = bitcast i8* %cur to i32*
  %cur_key = load i32, i32* %keyptr, align 4
  %next_off = getelementptr inbounds i8, i8* %cur, i64 16
  %nextpp = bitcast i8* %next_off to i8**
  %next1 = load i8*, i8** %nextpp, align 8
  %eq = icmp eq i32 %cur_key, %arg
  br i1 %eq, label %found, label %chk_next

chk_next:
  %nnull = icmp ne i8* %next1, null
  br i1 %nnull, label %loop_update, label %leave

loop_update:
  br label %loop

found:
  %prev_isnull = icmp eq i8* %prev, null
  br i1 %prev_isnull, label %set_head, label %link_prev

set_head:
  store i8* %next1, i8** @Block, align 8
  br label %do_free

link_prev:
  %pnext_off = getelementptr inbounds i8, i8* %prev, i64 16
  %pnextpp = bitcast i8* %pnext_off to i8**
  store i8* %next1, i8** %pnextpp, align 8
  br label %do_free

do_free:
  call void @free(i8* %cur)
  br label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret i32 0
}