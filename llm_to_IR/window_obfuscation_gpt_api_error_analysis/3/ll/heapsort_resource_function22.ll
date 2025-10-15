; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external dso_local global %struct._RTL_CRITICAL_SECTION
@Block = external dso_local global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define dso_local void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %head_null = icmp eq %struct.Block* %head, null
  br i1 %head_null, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %head, %entry ], [ %next, %cont ]
  %idx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %idx)
  %err = call i32 @GetLastError()
  %tls_nonnull = icmp ne i8* %tlsval, null
  %err_zero = icmp eq i32 %err, 0
  %do_call = and i1 %tls_nonnull, %err_zero
  br i1 %do_call, label %callcb, label %cont.pre

callcb:
  %cb.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cb.ptr, align 8
  call void %cb(i8* %tlsval)
  br label %cont

cont.pre:
  br label %cont

cont:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  %has_next = icmp ne %struct.Block* %next, null
  br i1 %has_next, label %loop, label %leave

leave:
  tail call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}