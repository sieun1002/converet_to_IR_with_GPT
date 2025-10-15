; ModuleID = 'fixed_module'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct.RTL_CRITICAL_SECTION, align 8
@Block = external global %struct.Block*, align 8

declare dllimport void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION* nocapture)
declare dllimport void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION* nocapture)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION* nonnull @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %headnull = icmp eq %struct.Block* %head, null
  br i1 %headnull, label %leave, label %loop.header

loop.header:
  %cur = phi %struct.Block* [ %head, %entry ], [ %nextblk, %aftercall ]
  %tlsidxptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %tlsidx = load i32, i32* %tlsidxptr, align 4
  %val = call i8* @TlsGetValue(i32 %tlsidx)
  %gle = call i32 @GetLastError()
  %valnotnull = icmp ne i8* %val, null
  %glezero = icmp eq i32 %gle, 0
  %docond = and i1 %valnotnull, %glezero
  br i1 %docond, label %docall, label %aftercall

docall:
  %cbptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbptr, align 8
  call void %cb(i8* %val)
  br label %aftercall

aftercall:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %nextblk = load %struct.Block*, %struct.Block** %nextptr, align 8
  %nnull = icmp ne %struct.Block* %nextblk, null
  br i1 %nnull, label %loop.header, label %leave

leave:
  call void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION* nonnull @CriticalSection)
  ret void
}