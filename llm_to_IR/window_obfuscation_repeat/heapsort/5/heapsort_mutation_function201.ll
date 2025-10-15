; ModuleID = 'fixed'
source_filename = "fixed.ll"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
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
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  br label %loop

loop:
  %blk = phi %struct.Block* [ %head, %entry ], [ %next, %cont ]
  %isnull = icmp eq %struct.Block* %blk, null
  br i1 %isnull, label %leave, label %process

process:
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 0
  %idx = load i32, i32* %idxptr, align 4
  %val = call i8* @TlsGetValue(i32 %idx)
  %last = call i32 @GetLastError()
  %valnull = icmp eq i8* %val, null
  br i1 %valnull, label %cont, label %checkerr

checkerr:
  %zerolast = icmp eq i32 %last, 0
  br i1 %zerolast, label %callfn, label %cont

callfn:
  %fnptrptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 2
  %fn = load void (i8*)*, void (i8*)** %fnptrptr, align 8
  call void %fn(i8* %val)
  br label %cont

cont:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  br label %loop

leave:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}