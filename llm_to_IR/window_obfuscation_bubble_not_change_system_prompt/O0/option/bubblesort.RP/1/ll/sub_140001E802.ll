; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define dso_local void @sub_140001E80() local_unnamed_addr {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %0 = load %struct.Block*, %struct.Block** @Block, align 8
  %1 = icmp eq %struct.Block* %0, null
  br i1 %1, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %0, %entry ], [ %11, %cont ]
  %2 = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %3 = load i32, i32* %2, align 4
  %4 = call i8* @TlsGetValue(i32 %3)
  %5 = call i32 @GetLastError()
  %6 = icmp ne i8* %4, null
  %7 = icmp eq i32 %5, 0
  %8 = and i1 %6, %7
  br i1 %8, label %invoke, label %cont

invoke:
  %9 = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 1
  %fp = load void (i8*)*, void (i8*)** %9, align 8
  call void %fp(i8* %4)
  br label %cont

cont:
  %10 = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %11 = load %struct.Block*, %struct.Block** %10, align 8
  %12 = icmp ne %struct.Block* %11, null
  br i1 %12, label %loop, label %leave

leave:
  tail call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}