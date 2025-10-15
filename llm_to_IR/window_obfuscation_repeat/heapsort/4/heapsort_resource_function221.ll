; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global i8
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(i8*)
declare dllimport void @LeaveCriticalSection(i8*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define dso_local void @sub_140002240() {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %cond = icmp ne %struct.Block* %head, null
  br i1 %cond, label %loop, label %done

loop:
  %cur = phi %struct.Block* [ %head, %entry ], [ %next, %cont ]
  %idx_ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx_ptr, align 4
  %tls = call i8* @TlsGetValue(i32 %idx)
  %last = call i32 @GetLastError()
  %has = icmp ne i8* %tls, null
  %ok = icmp eq i32 %last, 0
  %both = and i1 %has, %ok
  br i1 %both, label %do_call, label %cont

do_call:
  %cbp = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbp, align 8
  call void %cb(i8* %tls)
  br label %cont

cont:
  %nextp = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextp, align 8
  %more = icmp ne %struct.Block* %next, null
  br i1 %more, label %loop, label %done

done:
  call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}