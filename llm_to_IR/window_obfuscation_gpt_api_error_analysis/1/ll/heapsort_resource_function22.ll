; Target: Windows x64 (MSVC)
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, void (i8*)*, %struct.Node* }

@CriticalSection = external global i8
@Block = external global %struct.Node*

declare void @EnterCriticalSection(i8* nocapture)
declare void @LeaveCriticalSection(i8* nocapture)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() local_unnamed_addr {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %first = load %struct.Node*, %struct.Node** @Block, align 8
  %cmp.first.null = icmp eq %struct.Node* %first, null
  br i1 %cmp.first.null, label %after.loop, label %loop

loop:
  %node.cur = phi %struct.Node* [ %first, %entry ], [ %next, %cont ]
  %idx.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node.cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tls.val = call i8* @TlsGetValue(i32 %idx)
  %gle = call i32 @GetLastError()
  %tls.isnull = icmp eq i8* %tls.val, null
  %gle.iszero = icmp eq i32 %gle, 0
  %tls.notnull = xor i1 %tls.isnull, true
  %do.call = and i1 %tls.notnull, %gle.iszero
  br i1 %do.call, label %call.cb, label %cont

call.cb:
  %cb.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node.cur, i32 0, i32 1
  %cb = load void (i8*)*, void (i8*)** %cb.ptr, align 8
  call void %cb(i8* %tls.val)
  br label %cont

cont:
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %node.cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %cmp.next.null = icmp eq %struct.Node* %next, null
  br i1 %cmp.next.null, label %after.loop, label %loop

after.loop:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}