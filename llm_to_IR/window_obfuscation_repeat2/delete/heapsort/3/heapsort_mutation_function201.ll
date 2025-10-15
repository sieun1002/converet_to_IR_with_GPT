; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, void (i8*)*, %struct.Node* }

@CriticalSection = external global i8
@Block = external global %struct.Node*

declare void @EnterCriticalSection(i8* noundef)
declare void @LeaveCriticalSection(i8* noundef)
declare i8* @TlsGetValue(i32 noundef)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %blk0 = load %struct.Node*, %struct.Node** @Block, align 8
  %cmp0 = icmp eq %struct.Node* %blk0, null
  br i1 %cmp0, label %exit, label %loop

loop:
  %cur = phi %struct.Node* [ %blk0, %entry ], [ %next, %cont ]
  %tlsidxptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %tlsidx = load i32, i32* %tlsidxptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %tlsidx)
  %lasterr = call i32 @GetLastError()
  %cond1 = icmp ne i8* %tlsval, null
  %cond2 = icmp eq i32 %lasterr, 0
  %do_call = and i1 %cond1, %cond2
  br i1 %do_call, label %callit, label %cont

callit:
  %fnptrptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 1
  %fnptr = load void (i8*)*, void (i8*)** %fnptrptr, align 8
  call void %fnptr(i8* %tlsval)
  br label %cont

cont:
  %nextptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %next = load %struct.Node*, %struct.Node** %nextptr, align 8
  %has = icmp ne %struct.Node* %next, null
  br i1 %has, label %loop, label %exit

exit:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}