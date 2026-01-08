; ModuleID = 'recovered'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i64, i64, i64, i64, i32, i32 }
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

@__imp_EnterCriticalSection = external dllimport global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external dllimport global void (%struct._RTL_CRITICAL_SECTION*)*
@__imp_TlsGetValue = external dllimport global i8* (i32)*
@__imp_GetLastError = external dllimport global i32 ()*

define void @sub_140001E80() local_unnamed_addr {
entry:
  %imp_enter.p = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_EnterCriticalSection
  call void %imp_enter.p(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block
  %cmp.head.null = icmp eq %struct.Block* %head, null
  br i1 %cmp.head.null, label %exit, label %preloop

preloop:
  %imp_tlsget.p = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue
  %imp_getlasterror.p = load i32 ()*, i32 ()** @__imp_GetLastError
  br label %loop

loop:
  %cur = phi %struct.Block* [ %head, %preloop ], [ %next, %after_cb ]
  %idx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tlsval = call i8* %imp_tlsget.p(i32 %idx)
  %last = call i32 %imp_getlasterror.p()
  %has.tls = icmp ne i8* %tlsval, null
  %no.err = icmp eq i32 %last, 0
  %do.cb = and i1 %has.tls, %no.err
  br i1 %do.cb, label %call_cb, label %after_cb

call_cb:
  %cb.ptr.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cb.ptr.ptr, align 8
  call void %cb(i8* %tlsval)
  br label %after_cb

after_cb:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  %has.next = icmp ne %struct.Block* %next, null
  br i1 %has.next, label %loop, label %exit

exit:
  %imp_leave.p = load void (%struct._RTL_CRITICAL_SECTION*)*, void (%struct._RTL_CRITICAL_SECTION*)** @__imp_LeaveCriticalSection
  tail call void %imp_leave.p(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}