; ModuleID: fixed
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@CriticalSection = global [40 x i8] zeroinitializer, align 8
@Block = external global %struct.Node*

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  %cs.ptr = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs.ptr)
  %blk0 = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %blk0, null
  br i1 %isnull, label %release, label %loop

loop:
  %cur = phi %struct.Node* [ %blk0, %entry ], [ %next, %loop.latch ]
  %idx.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %idx)
  %gle = call i32 @GetLastError()
  %hasval = icmp ne i8* %tlsval, null
  %noerr = icmp eq i32 %gle, 0
  %ok = and i1 %hasval, %noerr
  br i1 %ok, label %do_cb, label %loop.latch

do_cb:
  %fn.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %fn = load void (i8*)*, void (i8*)** %fn.ptr, align 8
  call void %fn(i8* %tlsval)
  br label %loop.latch

loop.latch:
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %cont = icmp ne %struct.Node* %next, null
  br i1 %cont, label %loop, label %release

release:
  %cs.ptr2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @LeaveCriticalSection(i8* %cs.ptr2)
  ret void
}