; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

@__imp_EnterCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_TlsGetValue = external global i8* (i32)*
@__imp_GetLastError = external global i32 ()*

define void @sub_140002320() local_unnamed_addr {
entry:
  %0 = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_EnterCriticalSection
  call void %0(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %1 = load %struct.Block*, %struct.Block** @Block
  %2 = icmp eq %struct.Block* %1, null
  br i1 %2, label %after_loop, label %loop_entry

loop_entry:                                       ; preds = %entry
  %3 = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue
  %4 = load i32 ()*, i32 ()** @__imp_GetLastError
  br label %loop

loop:                                             ; preds = %loop_cont, %loop_entry
  %cur = phi %struct.Block* [ %1, %loop_entry ], [ %10, %loop_cont ]
  %5 = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %6 = load i32, i32* %5, align 4
  %7 = call i8* %3(i32 %6)
  %8 = call i32 %4()
  %9 = icmp ne i8* %7, null
  %cmpzero = icmp eq i32 %8, 0
  %cond = and i1 %9, %cmpzero
  br i1 %cond, label %do_call, label %skip_call

do_call:                                          ; preds = %loop
  %cbptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbptrptr, align 8
  call void %cb(i8* %7)
  br label %skip_call

skip_call:                                        ; preds = %do_call, %loop
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %10 = load %struct.Block*, %struct.Block** %nextptr, align 8
  %11 = icmp ne %struct.Block* %10, null
  br i1 %11, label %loop_cont, label %after_loop

loop_cont:                                        ; preds = %skip_call
  br label %loop

after_loop:                                       ; preds = %skip_call, %entry
  %12 = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_LeaveCriticalSection
  tail call void %12(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}