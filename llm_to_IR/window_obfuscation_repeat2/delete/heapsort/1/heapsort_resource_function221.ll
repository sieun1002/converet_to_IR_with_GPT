; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.Node = type { i32, i32, void (i8*)*, %struct.Node* }

@CriticalSection = dso_local global [40 x i8] zeroinitializer, align 8
@Block = external dso_local global %struct.Node*, align 8

declare dso_local void @EnterCriticalSection(i8*)
declare dso_local void @LeaveCriticalSection(i8*)
declare dso_local i8* @TlsGetValue(i32)
declare dso_local i32 @GetLastError()

define dso_local void @sub_140002240() {
entry:
  %cs.ptr = bitcast [40 x i8]* @CriticalSection to i8*
  call void @EnterCriticalSection(i8* %cs.ptr)
  %blk0 = load %struct.Node*, %struct.Node** @Block, align 8
  %isnull = icmp eq %struct.Node* %blk0, null
  br i1 %isnull, label %leave, label %loop

loop:
  %blk = phi %struct.Node* [ %blk0, %entry ], [ %next, %loop_end ]
  %idx.ptr = getelementptr inbounds %struct.Node, %struct.Node* %blk, i32 0, i32 0
  %dw = load i32, i32* %idx.ptr, align 8
  %tlsval = call i8* @TlsGetValue(i32 %dw)
  %last = call i32 @GetLastError()
  %hasptr = icmp ne i8* %tlsval, null
  %lasteq0 = icmp eq i32 %last, 0
  %do = and i1 %hasptr, %lasteq0
  br i1 %do, label %callfun, label %loop_end

callfun:
  %fptr.ptr = getelementptr inbounds %struct.Node, %struct.Node* %blk, i32 0, i32 2
  %fptr = load void (i8*)*, void (i8*)** %fptr.ptr, align 8
  call void %fptr(i8* %tlsval)
  br label %loop_end

loop_end:
  %next.ptr = getelementptr inbounds %struct.Node, %struct.Node* %blk, i32 0, i32 3
  %next = load %struct.Node*, %struct.Node** %next.ptr, align 8
  %hasnext = icmp ne %struct.Node* %next, null
  br i1 %hasnext, label %loop, label %leave

leave:
  %cs.ptr2 = bitcast [40 x i8]* @CriticalSection to i8*
  call void @LeaveCriticalSection(i8* %cs.ptr2)
  ret void
}