; ModuleID = 'fixed'
target triple = "x86_64-pc-windows-msvc"

%struct.RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct.RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dllimport void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION*)
declare dllimport i8* @TlsGetValue(i32)
declare dllimport i32 @GetLastError()

define void @sub_140002240() {
entry:
  call void @EnterCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  %blk0 = load %struct.Block*, %struct.Block** @Block, align 8
  %cmp0 = icmp eq %struct.Block* %blk0, null
  br i1 %cmp0, label %after_loop, label %loop

loop:
  %blk = phi %struct.Block* [ %blk0, %entry ], [ %next, %advance ]
  %tls_index_ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 0
  %tls_index = load i32, i32* %tls_index_ptr, align 4
  %tls_value = call i8* @TlsGetValue(i32 %tls_index)
  %gle = call i32 @GetLastError()
  %nonnull = icmp ne i8* %tls_value, null
  br i1 %nonnull, label %check_err, label %advance

check_err:
  %err_zero = icmp eq i32 %gle, 0
  br i1 %err_zero, label %do_call, label %advance

do_call:
  %func_ptr_ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 2
  %func = load void (i8*)*, void (i8*)** %func_ptr_ptr, align 8
  call void %func(i8* %tls_value)
  br label %advance

advance:
  %next_ptr = getelementptr inbounds %struct.Block, %struct.Block* %blk, i32 0, i32 3
  %next = load %struct.Block*, %struct.Block** %next_ptr, align 8
  %has_next = icmp ne %struct.Block* %next, null
  br i1 %has_next, label %loop, label %after_loop

after_loop:
  call void @LeaveCriticalSection(%struct.RTL_CRITICAL_SECTION* @CriticalSection)
  ret void
}