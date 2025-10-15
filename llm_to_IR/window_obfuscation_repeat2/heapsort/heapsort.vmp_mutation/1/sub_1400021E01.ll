; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, [4 x i8], void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

@__imp_EnterCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_TlsGetValue = external global i8* (i32)*
@__imp_GetLastError = external global i32 ()*

define void @sub_1400021E0() {
entry:
  %pEnterPtr = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_EnterCriticalSection, align 8
  call void %pEnterPtr(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %blkptr = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %blkptr, null
  br i1 %isnull, label %exit, label %loop.prep

loop.prep:
  %pTlsPtr = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue, align 8
  %pGetLastErrPtr = load i32 ()*, i32 ()** @__imp_GetLastError, align 8
  br label %loop

loop:
  %cur = phi %struct.Block* [ %blkptr, %loop.prep ], [ %next, %after_iter ]
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %dw = load i32, i32* %idxptr, align 4
  %val = call i8* %pTlsPtr(i32 %dw)
  %gle = call i32 %pGetLastErrPtr()
  %isnz = icmp ne i8* %val, null
  %gle_zero = icmp eq i32 %gle, 0
  %cond = and i1 %isnz, %gle_zero
  br i1 %cond, label %do_call, label %skip_call

do_call:
  %fp_field_ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %fp = load void (i8*)*, void (i8*)** %fp_field_ptr, align 8
  call void %fp(i8* %val)
  br label %after_iter

skip_call:
  br label %after_iter

after_iter:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %more = icmp ne %struct.Block* %next, null
  br i1 %more, label %loop, label %exit

exit:
  %pLeavePtr = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_LeaveCriticalSection, align 8
  tail call void %pLeavePtr(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}