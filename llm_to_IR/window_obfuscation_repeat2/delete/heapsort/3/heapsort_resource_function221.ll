; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.RTL_CRITICAL_SECTION = type opaque
%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@__imp_EnterCriticalSection = external dllimport global void (%struct.RTL_CRITICAL_SECTION*)*
@__imp_LeaveCriticalSection = external dllimport global void (%struct.RTL_CRITICAL_SECTION*)*
@__imp_TlsGetValue = external dllimport global i8* (i32)*
@__imp_GetLastError = external dllimport global i32 ()*

@CriticalSection = external global %struct.RTL_CRITICAL_SECTION
@Block = external global %struct.Node*

define void @sub_140002240() local_unnamed_addr {
entry:
  %impEnter = load void (%struct.RTL_CRITICAL_SECTION*)*, void (%struct.RTL_CRITICAL_SECTION*)** @__imp_EnterCriticalSection
  call void %impEnter(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block
  %isnull = icmp eq %struct.Node* %head, null
  br i1 %isnull, label %leave, label %loop.init

loop.init:
  %pTls = load i8* (i32)*, i8* (i32)** @__imp_TlsGetValue
  %pGetErr = load i32 (), i32 ()** @__imp_GetLastError
  br label %loop

loop:
  %curr = phi %struct.Node* [ %head, %loop.init ], [ %next, %cont ]
  %idxptr = getelementptr %struct.Node, %struct.Node* %curr, i32 0, i32 0
  %idx = load i32, i32* %idxptr
  %tlsval = call i8* %pTls(i32 %idx)
  %err = call i32 %pGetErr()
  %cond1 = icmp ne i8* %tlsval, null
  %errzero = icmp eq i32 %err, 0
  %both = and i1 %cond1, %errzero
  br i1 %both, label %do_cb, label %skip_cb

do_cb:
  %cbptrptr = getelementptr %struct.Node, %struct.Node* %curr, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbptrptr
  call void %cb(i8* %tlsval)
  br label %after_cb

skip_cb:
  br label %after_cb

after_cb:
  %nextptr = getelementptr %struct.Node, %struct.Node* %curr, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr
  %hasnext = icmp ne %struct.Node* %next, null
  br i1 %hasnext, label %cont, label %leave

cont:
  br label %loop

leave:
  %impLeave = load void (%struct.RTL_CRITICAL_SECTION*)*, void (%struct.RTL_CRITICAL_SECTION*)** @__imp_LeaveCriticalSection
  tail call void %impLeave(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}