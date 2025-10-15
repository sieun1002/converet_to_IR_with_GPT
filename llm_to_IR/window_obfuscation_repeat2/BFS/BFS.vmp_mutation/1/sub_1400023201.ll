; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type { i8*, i32, i32, i8*, i8*, i64 }
%struct.BlockNode = type { i32, i32, void (i8*)*, %struct.BlockNode* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.BlockNode*

declare void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002320() {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  %head1 = load %struct.BlockNode*, %struct.BlockNode** @Block
  %cmp0 = icmp eq %struct.BlockNode* %head1, null
  br i1 %cmp0, label %release, label %loop.header

loop.header:
  %cur = phi %struct.BlockNode* [ %head1, %entry ], [ %next, %loop.latch ]
  %tlsIndexPtr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 0
  %tlsIndex = load i32, i32* %tlsIndexPtr
  %val = call i8* @TlsGetValue(i32 %tlsIndex)
  %gle = call i32 @GetLastError()
  %valIsNull = icmp eq i8* %val, null
  br i1 %valIsNull, label %loop.aftercall, label %checkerr

checkerr:
  %gleZero = icmp eq i32 %gle, 0
  br i1 %gleZero, label %docall, label %loop.aftercall

docall:
  %cbptrptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 2
  %cb = load void (i8*)*, void (i8*)** %cbptrptr
  call void %cb(i8* %val)
  br label %loop.aftercall

loop.aftercall:
  %nextptr = getelementptr inbounds %struct.BlockNode, %struct.BlockNode* %cur, i32 0, i32 3
  %next = load %struct.BlockNode*, %struct.BlockNode** %nextptr
  %hasnext = icmp ne %struct.BlockNode* %next, null
  br i1 %hasnext, label %loop.latch, label %release

loop.latch:
  br label %loop.header

release:
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}