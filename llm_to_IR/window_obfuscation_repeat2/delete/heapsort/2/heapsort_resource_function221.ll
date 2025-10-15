; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"
target datalayout = "e-m:w-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head = load %struct.Block*, %struct.Block** @Block, align 8
  %cmp.head.null = icmp eq %struct.Block* %head, null
  br i1 %cmp.head.null, label %exit, label %loop

loop:
  %cur = phi %struct.Block* [ %head, %entry ], [ %next, %loopcont ]
  %idx.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %idx = load i32, i32* %idx.ptr, align 4
  %tlsval = call i8* @TlsGetValue(i32 %idx)
  %lasterr = call i32 @GetLastError()
  %isnull = icmp eq i8* %tlsval, null
  br i1 %isnull, label %loopcont, label %checkerr

checkerr:
  %errnz = icmp ne i32 %lasterr, 0
  br i1 %errnz, label %loopcont, label %docall

docall:
  %cb.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cb.ptr, align 8
  call void %cb(i8* %tlsval)
  br label %loopcont

loopcont:
  %next.ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %next.ptr, align 8
  %hasnext = icmp ne %struct.Block* %next, null
  br i1 %hasnext, label %loop, label %exit

exit:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}