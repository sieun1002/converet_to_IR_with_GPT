; ModuleID = 'fixed'
source_filename = "fixed.ll"
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, void (i8*)*, %struct.Block* }

@Block = external global %struct.Block*
@CriticalSection = external global i8

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %blk.head = load %struct.Block*, %struct.Block** @Block, align 8
  br label %loop

loop:
  %blk = phi %struct.Block* [ %blk.head, %entry ], [ %blk.next, %after_if ]
  %cond.null = icmp eq %struct.Block* %blk, null
  br i1 %cond.null, label %done, label %body

body:
  %tls.idx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 0
  %tls.idx = load i32, i32* %tls.idx.ptr, align 4
  %tls.val = call i8* @TlsGetValue(i32 %tls.idx)
  %gle = call i32 @GetLastError()
  %notnull = icmp ne i8* %tls.val, null
  %glezero = icmp eq i32 %gle, 0
  %do.call = and i1 %notnull, %glezero
  br i1 %do.call, label %do_cb, label %after_if

do_cb:
  %cb.ptr.ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 1
  %cb.ptr = load void (i8*)*, void (i8*)** %cb.ptr.ptr, align 8
  call void %cb.ptr(i8* %tls.val)
  br label %after_if

after_if:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 2
  %blk.next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  br label %loop

done:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}