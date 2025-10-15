; ModuleID = 'sub_140002240.ll'
target triple = "x86_64-pc-windows-msvc"

%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@Block = external global %struct.Block*, align 8
@CriticalSection = external global i8, align 8

declare void @EnterCriticalSection(i8*)
declare void @LeaveCriticalSection(i8*)
declare i8* @TlsGetValue(i32)
declare i32 @GetLastError()

define void @sub_140002240() local_unnamed_addr {
entry:
  call void @EnterCriticalSection(i8* @CriticalSection)
  %headptr = load %struct.Block*, %struct.Block** @Block, align 8
  %isnull = icmp eq %struct.Block* %headptr, null
  br i1 %isnull, label %leave, label %loop

loop:
  %cur = phi %struct.Block* [ %headptr, %entry ], [ %next, %advance ]
  %dw_ptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 0
  %dw = load i32, i32* %dw_ptr, align 4
  %val = call i8* @TlsGetValue(i32 %dw)
  %err = call i32 @GetLastError()
  %val_isnull = icmp eq i8* %val, null
  %err_is_zero = icmp eq i32 %err, 0
  %not_null = xor i1 %val_isnull, true
  %do_call = and i1 %not_null, %err_is_zero
  br i1 %do_call, label %callfn, label %advance

callfn:
  %fnptrptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 2
  %fnptr = load void (i8*)*, void (i8*)** %fnptrptr, align 8
  call void %fnptr(i8* %val)
  br label %advance

advance:
  %nextptr = getelementptr inbounds %struct.Block, %struct.Block* %cur, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %nextptr, align 8
  %next_isnull = icmp eq %struct.Block* %next, null
  br i1 %next_isnull, label %leave, label %loop

leave:
  tail call void @LeaveCriticalSection(i8* @CriticalSection)
  ret void
}