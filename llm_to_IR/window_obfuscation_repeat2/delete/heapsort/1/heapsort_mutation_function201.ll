; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@CriticalSection = external global i8
@Block = external global %struct.Node*

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %first = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop

loop:
  %cur = phi %struct.Node* [ %first, %entry ], [ %next, %after_cb ]
  %isnull = icmp eq %struct.Node* %cur, null
  br i1 %isnull, label %leave, label %process

process:
  %tlsIndexPtr = getelementptr %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %tlsIndex = load i32, i32* %tlsIndexPtr, align 4
  %tls = call i8* @TlsGetValue(i32 %tlsIndex)
  %gle = call i32 @GetLastError()
  %has_tls = icmp ne i8* %tls, null
  %gle_zero = icmp eq i32 %gle, 0
  %do_cb = and i1 %has_tls, %gle_zero
  br i1 %do_cb, label %call_cb, label %after_cb

call_cb:
  %cbptrptr = getelementptr %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %cbptr = load void (i8*)*, void (i8*)** %cbptrptr, align 8
  call void %cbptr(i8* %tls)
  br label %after_cb

after_cb:
  %nextptr = getelementptr %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  br label %loop

leave:
  tail call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}