; ModuleID = 'sub_140001E80.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare i8* @TlsGetValue(i32 noundef)
declare i32 @GetLastError()

define void @sub_140001E80() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %blk0, null
  br i1 %isnull, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %blk0, %entry ], [ %next, %aftercall ]
  %idx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tls = call i8* @TlsGetValue(i32 noundef %idx)
  %err = call i32 @GetLastError()
  %tls.notnull = icmp ne i8* %tls, null
  %err.zero = icmp eq i32 %err, 0
  %do.call = and i1 %tls.notnull, %err.zero
  br i1 %do.call, label %callcb, label %aftercall

callcb:
  %cb.ptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 1
  %cb.ptr = load void (i8*)*, void (i8*)** %cb.ptrptr, align 8
  call void %cb.ptr(i8* noundef %tls)
  br label %aftercall

aftercall:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  %hasnext = icmp ne %struct.Block* %next, null
  br i1 %hasnext, label %loop, label %leave

leave:
  tail call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret void
}