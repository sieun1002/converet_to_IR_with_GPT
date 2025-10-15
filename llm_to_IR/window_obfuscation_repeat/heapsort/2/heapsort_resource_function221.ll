; ModuleID = 'fixed_module'
source_filename = "fixed_module.ll"
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = global %struct._RTL_CRITICAL_SECTION zeroinitializer, align 8
@Block = global %struct.Block* null, align 8

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull0 = icmp eq %struct.Block* %blk0, null
  br i1 %isnull0, label %leave, label %loop

loop:
  %blk = phi %struct.Block* [ %blk0, %entry ], [ %next, %cont ]
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 0
  %tlsIndex = load i32, i32* %idxptr, align 4
  %val = call i8* @TlsGetValue(i32 %tlsIndex)
  %gle = call i32 @GetLastError()
  %valnz = icmp ne i8* %val, null
  %glezero = icmp eq i32 %gle, 0
  %cond1 = and i1 %valnz, %glezero
  br i1 %cond1, label %do_call, label %cont

do_call:
  %fpptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 2
  %fp = load void (i8*)*, void (i8*)** %fpptr, align 8
  call void %fp(i8* %val)
  br label %cont

cont:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %more = icmp ne %struct.Block* %next, null
  br i1 %more, label %loop, label %leave

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}