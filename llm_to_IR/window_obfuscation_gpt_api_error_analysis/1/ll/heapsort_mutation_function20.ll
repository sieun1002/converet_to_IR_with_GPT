; ModuleID = 'sub_140002240.ll'
target triple = "x86_64-pc-windows-msvc"

%struct._RTL_CRITICAL_SECTION = type opaque
%struct.Block = type { i32, i32, void (i8*)*, %struct.Block* }

@CriticalSection = external global %struct._RTL_CRITICAL_SECTION
@Block = external global %struct.Block*

declare dllimport void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef)
declare dllimport i8* @TlsGetValue(i32 noundef)
declare dllimport i32 @GetLastError()

define dso_local void @sub_140002240() local_unnamed_addr {
entry:
  call void @EnterCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  %head0 = load %struct.Block*, %struct.Block** @Block, align 8
  %cmp0 = icmp eq %struct.Block* %head0, null
  br i1 %cmp0, label %exit, label %loop

loop:                                             ; preds = %entry, %cont
  %node1 = phi %struct.Block* [ %head0, %entry ], [ %next6, %cont ]
  %idxptr2 = getelementptr inbounds %struct.Block, %struct.Block* %node1, i32 0, i32 0
  %tls_index3 = load i32, i32* %idxptr2, align 4
  %tlsval4 = call i8* @TlsGetValue(i32 noundef %tls_index3)
  %err5 = call i32 @GetLastError()
  %nonnull6 = icmp ne i8* %tlsval4, null
  %zererr7 = icmp eq i32 %err5, 0
  %call_ok8 = and i1 %nonnull6, %zererr7
  br i1 %call_ok8, label %do_call, label %cont

do_call:                                          ; preds = %loop
  %cbptr9 = getelementptr inbounds %struct.Block, %struct.Block* %node1, i32 0, i32 2
  %cb10 = load void (i8*)*, void (i8*)** %cbptr9, align 8
  call void %cb10(i8* noundef %tlsval4)
  br label %cont

cont:                                             ; preds = %do_call, %loop
  %nextptr11 = getelementptr inbounds %struct.Block, %struct.Block* %node1, i32 0, i32 3
  %next6 = load %struct.Block*, %struct.Block** %nextptr11, align 8
  %has_next12 = icmp ne %struct.Block* %next6, null
  br i1 %has_next12, label %loop, label %exit

exit:                                             ; preds = %cont, %entry
  call void @LeaveCriticalSection(%struct._RTL_CRITICAL_SECTION* noundef @CriticalSection)
  ret void
}