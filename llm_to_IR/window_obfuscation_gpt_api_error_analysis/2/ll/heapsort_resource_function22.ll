; ModuleID = 'sub_140002240.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION, align 8
@Block = external global %struct.Block*, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %head_is_null = icmp eq %struct.Block* %head, null
  br i1 %head_is_null, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %head, %entry ], [ %next, %aftercall ]
  %tlsidx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %tlsidx = load i32, i32* %tlsidx.ptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %tlsidx)
  %err = call i32 @GetLastError()
  %has_val = icmp ne i8* %tlsval, null
  %no_err = icmp eq i32 %err, 0
  %do_call = and i1 %has_val, %no_err
  br i1 %do_call, label %callcb, label %aftercall

callcb:
  %func.ptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 1
  %func = load void (i8*)*, void (i8*)** %func.ptrptr, align 8
  call void %func(i8* %tlsval)
  br label %aftercall

aftercall:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  %has_next = icmp ne %struct.Block* %next, null
  br i1 %has_next, label %loop, label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}