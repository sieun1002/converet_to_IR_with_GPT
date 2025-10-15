; ModuleID: win64_module
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %head_is_null = icmp eq %struct.Block* %head, null
  br i1 %head_is_null, label %exit, label %loop

loop:
  %cur = phi %struct.Block* [ %head, %entry ], [ %next, %after_call ]
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %dwIdx = load i32, i32* %idxptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %dwIdx)
  %gle = call i32 @GetLastError()
  %hasval = icmp ne i8* %tlsval, null
  %noerr = icmp eq i32 %gle, 0
  %should_call = and i1 %hasval, %noerr
  br i1 %should_call, label %do_call, label %after_call

do_call:
  %fptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %fptr = load void (i8*)*, void (i8*)** %fptrptr, align 8
  call void %fptr(i8* %tlsval)
  br label %after_call

after_call:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %has_next = icmp ne %struct.Block* %next, null
  br i1 %has_next, label %loop, label %exit

exit:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}