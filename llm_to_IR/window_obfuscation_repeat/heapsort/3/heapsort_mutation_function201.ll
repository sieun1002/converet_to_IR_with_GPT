; ModuleID = 'fixed_module'
target datalayout = "e-m:w-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION_DEBUG = type opaque
%struct._RTL_CRITICAL_SECTION = type { %struct._RTL_CRITICAL_SECTION_DEBUG*, i32, i32, i8*, i8*, i64 }
%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Node*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare i8* @TlsGetValue(i32 noundef)
declare i32 @GetLastError()

define void @sub_140002240() local_unnamed_addr {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head = load %struct.Node*, %struct.Node** @Block, align 8
  br label %loop

loop:
  %cur = phi %struct.Node* [ %head, %entry ], [ %next, %aftercall ]
  %cmpnull = icmp eq %struct.Node* %cur, null
  br i1 %cmpnull, label %leave, label %process

process:
  %tlsIndexPtr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 0
  %tlsIndex = load i32, i32* %tlsIndexPtr, align 4
  %tls = call i8* @TlsGetValue(i32 noundef %tlsIndex)
  %gle = call i32 @GetLastError()
  %nonnull = icmp ne i8* %tls, null
  %isZero = icmp eq i32 %gle, 0
  %doCall = and i1 %nonnull, %isZero
  br i1 %doCall, label %call, label %aftercall

call:
  %cbPtrPtr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbPtrPtr, align 8
  call void %cb(i8* noundef %tls)
  br label %aftercall

aftercall:
  %nextPtr = getelementptr inbounds %struct.Node, %struct.Node* %cur, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %nextPtr, align 8
  br label %loop

leave:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret void
}