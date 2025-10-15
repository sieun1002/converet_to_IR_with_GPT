; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@Block = external global %struct.Block*, align 8
@CriticalSection = external global [40 x i8], align 8

declare void @EnterCriticalSection(i8* nocapture) nounwind
declare void @LeaveCriticalSection(i8* nocapture) nounwind
declare i8* @TlsGetValue(i32) nounwind
declare i32 @GetLastError() nounwind

define void @sub_140002240() {
entry:
  %cs = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @EnterCriticalSection(i8* %cs)
  %block0 = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %block0, null
  br i1 %isnull, label %leave, label %loop

loop:
  %block = phi %struct.Block* [ %block0, %entry ], [ %next, %after_call ]
  %idxptr = getelementptr inbounds %struct.Block, %struct.Block* %block, i32 0, i32 0
  %idx = load i32, i32* %idxptr, align 4
  %val = call i8* @TlsGetValue(i32 %idx)
  %err = call i32 @GetLastError()
  %val_not_null = icmp ne i8* %val, null
  %err_zero = icmp eq i32 %err, 0
  %call_ok = and i1 %val_not_null, %err_zero
  br i1 %call_ok, label %do_call, label %after_call

do_call:
  %fpptr = getelementptr inbounds %struct.Block, %struct.Block* %block, i32 0, i32 2
  %fp = load void (i8*)*, void (i8*)** %fpptr, align 8
  call void %fp(i8* %val)
  br label %after_call

after_call:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %block, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %hasnext = icmp ne %struct.Block* %next, null
  br i1 %hasnext, label %loop, label %leave

leave:
  %cs2 = getelementptr inbounds [40 x i8], [40 x i8]* @CriticalSection, i64 0, i64 0
  call void @LeaveCriticalSection(i8* %cs2)
  ret void
}