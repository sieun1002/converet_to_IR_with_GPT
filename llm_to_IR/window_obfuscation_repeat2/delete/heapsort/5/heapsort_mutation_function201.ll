; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global i8
@Block = external global %struct.Block*

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  %cmp0 = icmp eq %struct.Block* %blk0, null
  br i1 %cmp0, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %blk0, %entry ], [ %nextblk, %next ]
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idxptr, align 4
  %tls = call i8* @TlsGetValue(i32 %idx)
  %err = call i32 @GetLastError()
  %tlsnull = icmp eq i8* %tls, null
  br i1 %tlsnull, label %next, label %check

check:
  %errnz = icmp ne i32 %err, 0
  br i1 %errnz, label %next, label %callfn

callfn:
  %fnptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %fnptr = load void (i8*)*, void (i8*)** %fnptrptr, align 8
  call void %fnptr(i8* %tls)
  br label %next

next:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %nextblk = load %struct.Block*, %struct.Block** %nextptr, align 8
  %has = icmp ne %struct.Block* %nextblk, null
  br i1 %has, label %loop, label %leave

leave:
  tail call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}